FROM openjdk:jre-slim

ENV USER_ID 1000
ENV GROUP_ID 1000
ENV BUILD 1480

RUN addgroup --system --gid $GROUP_ID freenet && adduser --system --uid=$USER_ID --gid=$GROUP_ID --home /freenet --shell /bin/bash --gecos "Freenet" freenet

WORKDIR /freenet

RUN apt-get update && apt-get install --no-install-recommends -y \
  gnupg2 \
  wget \
  nginx \
  htop \
  curl \
  nano \
  net-tools \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p data && chown -R freenet:freenet /freenet \
  && chown -R freenet:freenet /var/log/nginx \
  && chown -R freenet:freenet /etc/nginx \
  && chown -R freenet:freenet /run \
  && chown -R freenet:freenet /var/lib/nginx \
  && rm /etc/nginx/sites-enabled/default

USER freenet

ADD release-managers.asc /release-managers.asc
ADD ./run /freenet/run
ADD ./domain.conf /etc/nginx/conf.d/domain.conf

EXPOSE 80 8888 9481
STOPSIGNAL SIGTERM

VOLUME ["/freenet/data"]
CMD ["/freenet/run"]
