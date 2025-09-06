#!/bin/sh
# args from BR2_ROOTFS_POST_SCRIPT_ARGS
# $2    board name
INSTALL=install
TARGET=arm-buildroot-linux-gnueabihf

BOARD_DIR="$(dirname $0)"
BOARD_NAME="$(basename ${BOARD_DIR})"
BUILD=`grep device-fw ${BOARD_DIR}/VERSIONS | cut -d ' ' -f 2`

${INSTALL} -D -m 0644 ${BOARD_DIR}/input-event-daemon.conf ${TARGET_DIR}/etc/
${INSTALL} -D -m 0644 ${BOARD_DIR}/interfaces ${TARGET_DIR}/etc/network/
${INSTALL} -D -m 0644 ${BOARD_DIR}/libiio.ini ${TARGET_DIR}/etc/

${INSTALL} -D -m 0755 ${BOARD_DIR}/S15watchdog ${TARGET_DIR}/etc/init.d/
${INSTALL} -D -m 0755 ${BOARD_DIR}/S21misc ${TARGET_DIR}/etc/init.d/
${INSTALL} -D -m 0755 ${BOARD_DIR}/S99iiod ${TARGET_DIR}/etc/init.d/

${INSTALL} -D -m 0755 ${BOARD_DIR}/hdmi_test.py ${TARGET_DIR}/root
${INSTALL} -D -m 0755 ${BOARD_DIR}/hdmi_test_2.py ${TARGET_DIR}/root

${INSTALL} -D -m 0755 ${BOARD_DIR}/fb_test.py ${TARGET_DIR}/root
