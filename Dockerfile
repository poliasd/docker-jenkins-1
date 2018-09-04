FROM jenkins:1.651.3
MAINTAINER zsx <thinkernel@gmail.com>

# Install docker binary
USER root

#ENV DOCKER_BUCKET download.docker.com
#ENV DOCKER_VERSION 17.09.0-ce

#RUN curl -fSL "https://${DOCKER_BUCKET}/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz" -o /tmp/docker-ce.tgz \
#        && tar -xvzf /tmp/docker-ce.tgz --directory="/usr/local/bin" --strip-components=1 docker/docker \
#	&& rm /tmp/docker-ce.tgz

# Patch scripts about plugins from 2.x
COPY install-plugins.sh /usr/local/bin/install-plugins.sh
COPY jenkins-support /usr/local/bin/jenkins-support

USER jenkins

# Install plugins
RUN /usr/local/bin/install-plugins.sh \
  audit-trail:2.2 \
  email-ext:2.39.3 \
  envinject:1.92.1 \
  git:2.4.0 \
  jobcopy-builder:1.3.0 \
  log-parser:2.0 \
  multi-branch-project-plugin:0.3 \
  template-project:1.4.2 \
  ws-cleanup:0.29 \
  maven-plugin:2.10 \
  swarm

# Add groovy setup config
COPY init.groovy.d/ /usr/share/jenkins/ref/init.groovy.d/

# Generate jenkins ssh key.
COPY generate_key.sh /usr/local/bin/generate_key.sh

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
