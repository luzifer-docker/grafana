FROM debian:13.5@sha256:7c83da81e123fa99f00cbffbe5c7c2e1c1bd0f1d458cab6ffc4239bd80ad73da

ENV GRAFANA_VERSION=13.0.1

RUN set -ex \
 && apt-get update \
 && apt-get install --no-install-recommends -y \
      adduser \
      ca-certificates \
      curl \
      libfontconfig \
      musl \
      openssl \
      unzip \
 && curl -sSfLo /tmp/grafana.deb "https://dl.grafana.com/oss/release/grafana_${GRAFANA_VERSION}_amd64.deb" \
 && dpkg -i /tmp/grafana.deb \
 && rm /tmp/grafana.deb \
 && rm -rf /var/lib/apt/lists/*

EXPOSE 3000

VOLUME ["/var/lib/grafana", "/var/log/grafana", "/etc/grafana"]

WORKDIR /usr/share/grafana

ENTRYPOINT ["/usr/sbin/grafana-server"]
CMD [ \
  "--config", \
  "/etc/grafana/grafana.ini", \
  "cfg:default.paths.data=/var/lib/grafana", \
  "cfg:default.paths.logs=/var/log/grafana", \
  "cfg:default.paths.plugins=/var/lib/grafana/plugins" \
]
