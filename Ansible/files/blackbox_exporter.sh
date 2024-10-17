#!/bin/bash
useradd --no-create-home --shell /bin/false blackbox_exporter
wget https://github.com/prometheus/blackbox_exporter/releases/download/v0.24.0/blackbox_exporter-0.24.0.linux-amd64.tar.gz
tar -xvf blackbox_exporter-0.24.0.linux-amd64.tar.gz
mv blackbox_exporter-0.24.0.linux-amd64/blackbox_exporter /usr/local/bin/
chown blackbox_exporter:blackbox_exporter /usr/local/bin/blackbox_exporter
mkdir /etc/blackbox_exporter
tee /etc/blackbox_exporter/blackbox.yml <<EOF
modules:
  http_2xx:
    prober: http
    timeout: 5s
    http:
      valid_http_versions: ["HTTP/1.1", "HTTP/2"]
      valid_status_codes: []  # Accept all status codes
      method: GET
EOF
tee /etc/systemd/system/blackbox_exporter.service <<EOF
[Unit]
Description=Blackbox Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=blackbox_exporter
Group=blackbox_exporter
Type=simple
ExecStart=/usr/local/bin/blackbox_exporter --config.file=/etc/blackbox_exporter/blackbox.yml --web.listen-address=:9102

[Install]
WantedBy=multi-user.target
EOF
