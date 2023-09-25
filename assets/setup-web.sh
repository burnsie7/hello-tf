#!/usr/bin/env sh
chmod +x /tmp/hello-tf/main.py
cp /tmp/hello-tf/assets/hello.service /etc/systemd/system/hello.service
sudo systemctl daemon-reload
sudo systemctl enable hello.service
sudo systemctl start hello.service
sudo systemctl status hello.service
