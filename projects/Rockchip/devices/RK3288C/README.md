# RK3288C

This is a target for RK3288-C based Chrome OS systems.

**Build**

Execute: `PROJECT=Rockchip DEVICE=RK3288C ARCH=arm make image`

**Installation**

The created image and tar archive are universal, they should run on any
RK3288-C based Chromebook, Chromebase or Chromebit system. Consult
[LibreELEC wiki][1] on how to create boot medium (USB memory stick or
micro SD card).

**Booting**

The Chrome OS needs to be switched to developer mode for it to allow
booting from external medium. The following procedure was performed
on ASUS CS10 (Chromebit), it might slightly differ from other systems,
consult [Chromium OS developer site][2] for details. To follow the
instructions You'll need USB hub, USB keyboard and USB memory stick
with LibreELEC.

 1. Power down Chromebit.
 2. Press and hold reset button hidden in hole near label, then apply
    power.
 3. After few seconds (5-10) the button can be released.
 4. Recovery screen should apear, press Ctrl+D on keyboard and press
    reset button to confirm switching to Developer Mode.
 5. System will reboot, again press Ctrl+D and wait few minutes
    until system will finish switching to Developer Mode.
 6. System will reboot, wait until setup screen apears, then press
    Ctrl+Alt+F2 to enter console and login as root.
 7. Execute `crossystem dev_boot_usb=1 dev_boot_signed_only=0` to
    allow booting from external media and kernel signed with
    developer keys.
 8. (Optional) It is advised to also change GBB flags to 0x11 or 0x19
    with `/usr/share/vboot/bin/set_gbb_flags.sh`. For elaborate
    explanation what these do consult the [source][3]. The most
    interesting flag is VB2_GBB_FLAG_DEV_SCREEN_SHORT_DELAY, which
    shortens the wait on bootloader screen to few seconds.
 9. Now reboot the system and press Ctrl+U on bootloader screen
    to boot from external media. Unfortunately pressing Ctrl+U is
    necessary on each boot/reboot, so consider installing LibreELEC
    on eMMC. That way booting proper system won't need any interaction.
10. (Optional) To install LibreELEC on eMMC use emmc_install script
    with LibreELEC tar archive as an argument. The script doesn't touch
    bootloader, so if anything went wrong, pressing Ctrl+U on
    bootloader screen will boot system from external media, it being
    LibreELEC or Chrome OS recovery.

[1]: https://wiki.libreelec.tv/installation/create-media
[2]: https://www.chromium.org/chromium-os/developer-library/guides/device/developer-mode
[3]: https://github.com/coreboot/vboot/raw/refs/heads/release-R84-13099.B/scripts/image_signing/gbb_flags_common.sh
