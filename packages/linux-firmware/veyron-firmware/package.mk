# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2026-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="veyron-firmware"
PKG_VERSION="1"
PKG_LICENSE="Free-to-use"
PKG_SITE="https://archlinuxarm.org/builder/src/veyron/"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="veyron-firmware: firmwares for Veyron series of Chrome OS devices"
PKG_TOOLCHAIN="manual"

pre_unpack() {
  local file sha256 source sum url
  source=(https://github.com/Infineon/ifx-linux-firmware/raw/dc38e700612b334080e0b6df69070a88c4c2a12b/firmware/cyfmac4354-sdio.bin::a7427f1e75cfc82ab153d7fe7c8a7e9ba7613280bce095f83d7d75836c822875
          https://github.com/Infineon/ifx-linux-firmware/raw/dc38e700612b334080e0b6df69070a88c4c2a12b/firmware/cyfmac4354-sdio.clm_blob::edcea4a3d7d0a45f01c54aa825e825327ea251134b3c2f0fb99860f6307a9567
          https://archlinuxarm.org/builder/src/veyron/brcmfmac4354-sdio.txt::aa2df1b411097b9fa6d7149f0a25f87db6e8a80f2b5aeb9eacd859f71884259a
          https://archlinuxarm.org/builder/src/veyron/BCM4354_003.001.012.0306.0659.hcd::45c04797a769bae3b6c73a88a2a2d5b812581f9e0b11e9f030aef8513b305995)

  mkdir -p "${SOURCES}/${PKG_NAME}"
  cd "${SOURCES}/${PKG_NAME}"

  for s in ${source[@]}; do
    url="${s%%::*}"
    file="${url##*/}"
    sum="${s##*::}"

    if [ ! -f "${file}" ]; then
      curl -L -O "${url}"
      sha256="$(sha256sum ${file} | cut -d" " -f1)"
      if [ "${sha256}" != "${sum}" ]; then
        echo "Incorrect checksum calculated on downloaded file: got ${sha256} wanted ${sum}"
        exit 1
      else
        printf "%s\n" "${url}" >> "${PKG_NAME}-${PKG_VERSION}.url"
        printf "%s\n" "${sha256}" >> "${PKG_NAME}-${PKG_VERSION}.sha256"
      fi
    else
      sha256="$(sha256sum ${file} | cut -d" " -f1)"
      if [ "${sha256}" != "${sum}" ]; then
        echo "Incorrect checksum calculated on downloaded file: got ${sha256} wanted ${sum}"
        exit 1
      fi
    fi
  done
}

unpack() {
  mkdir -p ${PKG_BUILD}
  cp ${SOURCES}/${PKG_NAME}/* ${PKG_BUILD}/.
}

make_target() {
  :
}

makeinstall_target() {
  mkdir -p ${INSTALL}/$(get_full_firmware_dir)/brcm
  cd ${PKG_BUILD}
  cp -a \
    brcmfmac4354-sdio.txt \
    BCM4354_003.001.012.0306.0659.hcd \
    cyfmac4354-sdio.bin \
    cyfmac4354-sdio.clm_blob \
    ${INSTALL}/$(get_full_firmware_dir)/brcm

  cd  ${INSTALL}/$(get_full_firmware_dir)/brcm
  ln -s BCM4354_003.001.012.0306.0659.hcd BCM4354.hcd
  ln -s cyfmac4354-sdio.bin brcmfmac4354-sdio.bin
  ln -s cyfmac4354-sdio.clm_blob brcmfmac4354-sdio.clm_blob
}
