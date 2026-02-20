# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2026-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="flashrom-chromiumos"
PKG_VERSION="1c70ca25cdb62f9448e7e650be1faf32ab8f7f0c"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://chromium.googlesource.com/chromiumos/third_party/flashrom"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain libusb-compat"
PKG_LONGDESC="flashrom is a utility for identifying, reading, writing, verifying and erasing flash chips. It is designed to flash BIOS/EFI/coreboot/firmware/optionROM images on mainboards, network/graphics/storage controller cards, and various other programmer devices."

PKG_MESON_OPTS_TARGET="--wrap-mode=nodownload"
