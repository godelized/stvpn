#!/usr/bin/env bash

openvpn_conf=./openvpn.conf
sockd_conf=./sockd.conf
port=1080

show_usage() {
	cat <<EOF
$0 [opt ...] build
$0 [opt ...] run
$0 [opt ...] gc

OPTIONS:
    -h: show usage.
    -o: openvpn configuration (default: $openvpn_conf).
    -s: sockd configuration (default: $sockd_conf).
    -p: port (default: $port).
EOF
}

while getopts ':ho:s:p:' arg; do
	case "$arg" in
	h)
		show_usage
		exit
		;;
	:)
		show_usage
		exit 1
		;;
	o)
		openvpn_conf="$OPTARG"
		;;
	s)
		sockd_conf="$OPTARG"
		;;
	p)
		port="$OPTARG"
		;;
	?)
		echo "Invalid option: -${OPTARG}."
		exit 1
		;;
	esac

done
shift $((OPTIND - 1))

case "$1" in
build)
	DOCKER_BUILDKIT=1 docker build -t stvpn docker
	;;
run)
	if [ ! -f "$openvpn_conf" ]; then
		file "$openvpn_conf"
		exit 1
	fi

	if [ ! -f "$sockd_conf" ]; then
		file "$sockd_conf"
		exit 1
	fi
	docker run \
		--rm \
		-ti \
		-v "$(realpath "$openvpn_conf")":/etc/openvpn.conf \
		-v "$(realpath "$sockd_conf")":/etc/sockd.conf \
		--device /dev/net/tun \
		--cap-add NET_ADMIN \
		-p "$port:1080" \
		stvpn
	;;
gc)
	docker rmi stvpn
	;;

*)
	show_usage
	;;
esac
