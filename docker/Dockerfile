# syntax=docker/dockerfile:1.4

FROM alpine:3.16

ADD init.sh /opt/

RUN <<EOF
set -e
apk add --no-cache sudo openvpn dante-server

adduser --system stvpn
echo 'stvpn ALL = (ALL) NOPASSWD: /usr/sbin/openvpn' >/etc/sudoers.d/stvpn

chown -R stvpn /opt/init.sh
chmod 0500 /opt/init.sh
EOF

USER stvpn

CMD ["/opt/init.sh"]
