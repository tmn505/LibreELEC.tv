# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2026-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="vboot-utils"
# There are no tags. Release is taken from latest release branch. Run
# git describe --all --match 'origin/release-R*.B' | awk -F- '{sub(/R/,"",$2); print $2}'
# in $PKG_SITE source tree to get release number. GitHub mirror might not have
# all branches pulled in.
PKG_VERSION="145"
# To get PKG_GIT_SHA of latest release in $PKG_SITE source tree run
# git rev-parse $(git describe --all --match 'origin/release-R*.B' | awk -F- '{print $1 "-" $2 "-" $3}')
PKG_GIT_SHA="0ee734db27fe06a92b92e0bdc58c8b7f35dfaf16"
PKG_SHA256="978deb658d2590a89de70f3339939b7c5873ff40bf6696655673bd4a51317560"
PKG_LICENSE="BSD-3-Clause"
PKG_SITE="https://chromium.googlesource.com/chromiumos/platform/vboot_reference"
PKG_URL="https://github.com/coreboot/vboot/archive/${PKG_GIT_SHA}.tar.gz"
PKG_DEPENDS_HOST="gcc:host make:host openssl:host util-linux:host"
PKG_DEPENDS_TARGET="u-boot-tools:host openssl util-linux"
PKG_LONGDESC="${PKG_NAME}: Chromium OS vboot utilities"

PKG_MAKE_OPTS_HOST="CC=${HOSTCC}
                    ARCH=$(uname -m)
                    USE_FLASHROM=0
                    USE_AVB=0
                    WERROR=
                    BUILD=build-host
                    cgpt
                    futil"

PKG_MAKEINSTALL_OPTS_HOST="CC=${HOSTCC}
                           ARCH=$(uname -m)
                           USE_FLASHROM=0
                           USE_AVB=0
                           WERROR=
                           BUILD=build-host
                           DF_DIR=${TOOLCHAIN}/etc/default
                           UB_DIR=${TOOLCHAIN}/bin
                           UL_DIR=${TOOLCHAIN}/lib
                           US_DIR=${TOOLCHAIN}/share/vboot
                           cgpt_install
                           futil_install"

PKG_MAKE_OPTS_TARGET="ARCH=${TARGET_ARCH}
                      USE_FLASHROM=0
                      USE_AVB=0
                      WERROR=
                      BUILD=build-target
                      cgpt
                      futil"

PKG_MAKEINSTALL_OPTS_TARGET="ARCH=${TARGET_ARCH}
                             USE_FLASHROM=0
                             USE_AVB=0
                             WERROR=
                             BUILD=build-target
                             cgpt_install
                             futil_install"

post_makeinstall_target() {
  mkdir -p ${INSTALL}/usr/share/vboot
  cp -R -a ${TOOLCHAIN}/share/u-boot/devkeys \
           ${INSTALL}/usr/share/vboot
  ${STRIP} ${INSTALL}/usr/bin/cgpt ${INSTALL}/usr/bin/futility
}
