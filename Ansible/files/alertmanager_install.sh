#!/bin/bash
wget https://github.com/prometheus/alertmanager/releases/download/v0.26.0/alertmanager-0.26.0.linux-amd64.tar.gz
tar -xvf alertmanager-0.26.0.linux-amd64.tar.gz
cd alertmanager-0.26.0.linux-amd64
mv alertmanager /usr/local/bin/
mv amtool /usr/local/bin/
useradd --no-create-home --shell /bin/false alertmanager
mkdir /etc/alertmanager
mkdir /var/lib/alertmanager
chown alertmanager:alertmanager /var/lib/alertmanager
chown -R alertmanager:alertmanager /etc/alertmanager
chown alertmanager:alertmanager /usr/local/bin/alertmanager
chown alertmanager:alertmanager /usr/local/bin/amtool
tee /etc/systemd/system/alertmanager.service <<EOF
[Unit]
Description=Prometheus Alertmanager
Wants=network-online.target
After=network-online.target

[Service]
User=alertmanager
Group=alertmanager
Type=simple
ExecStart=/usr/local/bin/alertmanager --config.file=/etc/alertmanager/alertmanager.yml --storage.path=/var/lib/alertmanager --web.listen-address=":9091"

[Install]
WantedBy=multi-user.target
EOF
