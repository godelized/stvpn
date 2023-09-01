#!/usr/bin/env sh

set -e

echo 'Starting openvpn...'
sudo openvpn --daemon --config /etc/openvpn.conf

while ! ifconfig tun0 1>/dev/null 2>/dev/null; do
    echo 'Waiting for tun0 to be ready...'
    sleep 2
done

echo 'Starting sockd...'
sockd &

echo 'Ready.'

sleep infinity
