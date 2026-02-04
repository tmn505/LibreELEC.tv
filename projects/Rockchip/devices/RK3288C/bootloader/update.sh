# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2026-present Team LibreELEC (https://libreelec.tv)

[ -z "${BOOT_ROOT}" ] && BOOT_ROOT="/flash"
[ -z "${BOOT_PART}" ] && BOOT_PART=$(df "${BOOT_ROOT}" | tail -1 | awk '{print $1}')
if [ -z "${BOOT_DISK}" ]; then
  case ${BOOT_PART} in
    /dev/sd[a-z][0-9]*)
      BOOT_DISK=$(echo ${BOOT_PART} | sed -e "s,[0-9]*,,g")
      ;;
    /dev/mmcblk*)
      BOOT_DISK=$(echo ${BOOT_PART} | sed -e "s,p[0-9]*,,g")
      MMC_P=p
      ;;
  esac
fi

[ -z "${SYSTEM_ROOT}" ] && SYSTEM_ROOT="/update"
[ -z "${UPDATE_DIR}" ] && UPDATE_DIR="/storage/.update"
UUID_SYSTEM="$(sed 's, ,\n,g' /proc/cmdline | grep 'boot=')"
UUID_STORAGE="$(sed 's, ,\n,g' /proc/cmdline | grep 'disk=')"

if [ -f "${UPDATE_DIR}/KERNEL" ]; then
  echo -n "Flashing kernel... "
  awk '/rtc_/ {print $3}' /proc/driver/rtc > /tmp/date.txt
  sed -e "1s,$, ${UUID_SYSTEM} ${UUID_STORAGE}," \
    ${SYSTEM_ROOT}/usr/share/bootloader/cmdline.txt > /tmp/cmdline.txt
  LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${SYSTEM_ROOT}/usr/lib" \
  ${SYSTEM_ROOT}/usr/bin/vbutil_kernel \
    --arch arm \
    --version 1 \
    --bootloader /tmp/date.txt \
    --config /tmp/cmdline.txt \
    --keyblock ${SYSTEM_ROOT}/usr/share/vboot/devkeys/kernel.keyblock \
    --signprivate ${SYSTEM_ROOT}/usr/share/vboot/devkeys/kernel_data_key.vbprivk \
    --vmlinuz "${UPDATE_DIR}/KERNEL" \
    --pack /tmp/kernel.kpart

  dd if=/tmp/kernel.kpart of="${BOOT_DISK}${MMC_P}"3 conv=fsync,notrunc &>/dev/null
  echo "done"
else
  echo "Kernel was not found, update failed!"
fi

sync
