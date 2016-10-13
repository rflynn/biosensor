#!/bin/sh

IFACE=${IFACE:-wlan0}
BCAST=$(/sbin/ifconfig $IFACE | awk '/Bcast:/{print $3}' | cut -c 7-)

if ! ping -c 2 -W 5 -w 10 -b $BCAST >/dev/null 2>/dev/null; then
	echo "No network connection, restarting wlan0..."
	sudo /sbin/ifdown $IFACE
	sleep 1
	sudo /sbin/ifup --force $IFACE
fi
