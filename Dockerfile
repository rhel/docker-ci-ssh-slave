FROM docker:18
LABEL MAINTAINER="Artyom Nosov <chip@unixstyle.ru>"

ARG USER=ci
ARG GROUP=ci
ARG UID=3000
ARG GID=3000
ARG CI_AGENT_HOME=/home/$USER
ARG DOCKER_COMPOSE_VERSION=1.22.0

ENV CI_AGENT_HOME $CI_AGENT_HOME

RUN addgroup -g $GID $GROUP \
 && adduser -D -h "$CI_AGENT_HOME" -u "$UID" -G "$GROUP" -s /bin/bash "$USER" \
 && passwd -u $USER

RUN apk add --no-cache \
      bash \
      ca-certificates \
      curl \
      git \
      groff \
      ncurses \
      nss \
      openssh \
      openjdk8 \
      py-pip \
      rsync \
      subversion \
      wget
RUN sed -i /etc/ssh/sshd_config \
        -e 's/#PermitRootLogin.*/PermitRootLogin no/' \
        -e 's/#RSAAuthentication.*/RSAAuthentication yes/'  \
        -e 's/#PasswordAuthentication.*/PasswordAuthentication no/' \
        -e 's/#SyslogFacility.*/SyslogFacility AUTH/' \
        -e 's/#LogLevel.*/LogLevel INFO/' \
    && mkdir /var/run/sshd

RUN pip install --no-cache-dir \
      awscli \
      docker-compose==$DOCKER_COMPOSE_VERSION \
      python-magic \
      s3cmd \
      urllib3==1.22

RUN curl -o /usr/local/bin/ecs-cli https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-linux-amd64-latest \
 && chmod +x /usr/local/bin/ecs-cli

RUN delgroup ping \
    && addgroup -g 999 docker \
    && addgroup $USER docker \
    && ln -s /usr/local/bin/docker /usr/bin/docker 

VOLUME "$CI_AGENT_HOME"
WORKDIR "$CI_AGENT_HOME"

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

EXPOSE 22

ENTRYPOINT [ "docker-entrypoint.sh" ]
