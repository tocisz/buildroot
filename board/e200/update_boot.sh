#!/bin/sh

#set -x

source /etc/device_config

FRM_FILE="$1"

flash_indication_on() {
    echo timer > /sys/class/leds/led0:green/trigger
    echo 40 > /sys/class/leds/led0:green/delay_off
    echo 40 > /sys/class/leds/led0:green/delay_on
}

flash_indication_off() {
    echo heartbeat > /sys/class/leds/led0:green/trigger
}

handle_boot_frm () {
	FILE="$1"
	md5=`tail -c 33 ${FILE}`
	head -c -33 ${FILE} > /opt/boot.frm
	frm=`md5sum /opt/boot.frm | cut -d ' ' -f 1`
	if [ "$frm" = "$md5" ]
	then
		flash_indication_on
	        dd if=/opt/boot.frm of=/dev/mtdblock0 bs=64k && do_reset=1 && echo "Done" || echo "Failed"
	        flash_indication_off
		rm -f /opt/boot.frm
		sync
		exit 0
	else
		rm -f /opt/boot.frm
        echo Failed Checksum error: $frm $md5
        exit 1
    fi
}

if [[ -f ${FRM_FILE} ]] && [[ ${FRM_FILE: -4} == ".frm" ]] && [[ -s ${FRM_FILE} ]]
then
    handle_boot_frm "${FRM_FILE}" "${FRM_MAGIC}"
else
    echo "Failed"
    exit 1
fi
