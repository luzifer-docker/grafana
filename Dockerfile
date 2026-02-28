FROM debian:13.3@sha256:3615a749858a1cba49b408fb49c37093db813321355a9ab7c1f9f4836341e9db

ENV GRAFANA_VERSION=12.4.0

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
