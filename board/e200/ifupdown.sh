#!/bin/sh

case "${ACTION}" in
add|"")
	ifconfig ${MDEV} up
	ifup ${MDEV}
	;;
remove)
	ifdown ${MDEV}
	;;
esac
