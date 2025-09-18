#!/bin/sh
# args from BR2_ROOTFS_POST_SCRIPT_ARGS
# $2    board name
. ${BR2_CONFIG}

INSTALL=install
TARGET=arm-buildroot-linux-gnueabihf

grep -qE '^::sysinit:/bin/mount -t debugfs' ${TARGET_DIR}/etc/inittab || \
sed -i '/hostname/a\
::sysinit:/bin/mount -t debugfs none /sys/kernel/debug/' ${TARGET_DIR}/etc/inittab

sed -i -e '/::sysinit:\/bin\/hostname -F \/etc\/hostname/d' ${TARGET_DIR}/etc/inittab

grep -q mtd2 ${TARGET_DIR}/etc/fstab || echo "mtd2 /mnt/jffs2 jffs2 rw,noatime 0 0" >> ${TARGET_DIR}/etc/fstab
grep -q mmcblk0p3 ${TARGET_DIR}/etc/fstab || echo "/dev/mmcblk0p3 /app ext4 rw,noatime 0 0" >> ${TARGET_DIR}/etc/fstab

BOARD_DIR="$(dirname $0)"
BOARD_NAME="$(basename ${BOARD_DIR})"
BUILD=`grep device-fw ${BOARD_DIR}/VERSIONS | cut -d ' ' -f 2`

GCC_VERSION=$(${TARGET}-gcc --version | head -1 | sed 's/.*(\(.*\))/\1/')
BIN_VERSION=$(${TARGET}-as --version | head -1 | sed 's/.*(\(.*\))/\1/')
GCC_TRIPLE=$(${BR2_TOOLCHAIN_REFIX}-gcc -v -c  2>&1 | sed 's/ /\n/g' | grep -e "--target" | awk -F= '{print $2}')

if [ "$BR2_TARGET_GENERIC_ROOT_PASSWD" = "analog" ] ; then
	ROOTPASSWD=$BR2_TARGET_GENERIC_ROOT_PASSWD;
else
	ROOTPASSWD="********"
fi

rm -Rf ${TARGET_DIR}/etc/dropbear
mkdir -p ${TARGET_DIR}/etc/dropbear

mkdir -p ${TARGET_DIR}/mnt/jffs2
mkdir -p ${TARGET_DIR}/app

${INSTALL} -D -m 0755 ${BOARD_DIR}/update_frm.sh ${TARGET_DIR}/sbin/
${INSTALL} -D -m 0755 ${BOARD_DIR}/S15watchdog ${TARGET_DIR}/etc/init.d/
${INSTALL} -D -m 0755 ${BOARD_DIR}/S20urandom ${TARGET_DIR}/etc/init.d/
${INSTALL} -D -m 0755 ${BOARD_DIR}/S21misc ${TARGET_DIR}/etc/init.d/
${INSTALL} -D -m 0755 ${BOARD_DIR}/S23config ${TARGET_DIR}/etc/init.d/
${INSTALL} -D -m 0755 ${BOARD_DIR}/S40network ${TARGET_DIR}/etc/init.d/
${INSTALL} -D -m 0755 ${BOARD_DIR}/S99iiod ${TARGET_DIR}/etc/init.d/
${INSTALL} -D -m 0644 ${BOARD_DIR}/fw_env.config ${TARGET_DIR}/etc/
${INSTALL} -D -m 0644 ${BOARD_DIR}/VERSIONS ${TARGET_DIR}/opt/
${INSTALL} -D -m 0755 ${BOARD_DIR}/device_reboot ${TARGET_DIR}/usr/sbin/
${INSTALL} -D -m 0755 ${BOARD_DIR}/device_passwd ${TARGET_DIR}/usr/sbin/
${INSTALL} -D -m 0755 ${BOARD_DIR}/device_persistent_keys ${TARGET_DIR}/usr/sbin/
${INSTALL} -D -m 0755 ${BOARD_DIR}/device_format_jffs2 ${TARGET_DIR}/usr/sbin/
${INSTALL} -D -m 0644 ${BOARD_DIR}/motd ${TARGET_DIR}/etc/
${INSTALL} -D -m 0644 ${BOARD_DIR}/device_config ${TARGET_DIR}/etc/
${INSTALL} -D -m 0644 ${BOARD_DIR}/mdev.conf ${TARGET_DIR}/etc/
${INSTALL} -D -m 0755 ${BOARD_DIR}/automounter.sh ${TARGET_DIR}/lib/mdev/automounter.sh
${INSTALL} -D -m 0755 ${BOARD_DIR}/ifupdown.sh ${TARGET_DIR}/lib/mdev/ifupdown.sh

ln -sf device_reboot ${TARGET_DIR}/usr/sbin/pluto_reboot
sed -e "s/#BUILD#/$BUILD/g" -i ${TARGET_DIR}/etc/motd
