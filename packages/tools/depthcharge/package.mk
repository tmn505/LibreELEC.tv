# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2026-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="depthcharge"
PKG_VERSION="1"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://chromium.googlesource.com/chromiumos/platform/depthcharge"
PKG_URL=""
PKG_DEPENDS_TARGET="u-boot-tools:host vboot-utils:host vboot-utils"
PKG_LONGDESC="${PKG_NAME}: bootloader package."
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/share/bootloader

  # Always install the update script
  find_file_path bootloader/update.sh && cp -av ${FOUND_PATH} ${INSTALL}/usr/share/bootloader

  # Always install the canupdate script
  if find_file_path bootloader/canupdate.sh; then
    cp -av ${FOUND_PATH} ${INSTALL}/usr/share/bootloader
    sed -e "s/@PROJECT@/${DEVICE:-${PROJECT}}/g" \
        -i ${INSTALL}/usr/share/bootloader/canupdate.sh
  fi

  echo "${EXTRA_CMDLINE}" > ${INSTALL}/usr/share/bootloader/cmdline.txt
}
