#  Note that this use of the edk2-firmware recipe is constructing a blob
#  for use under Xen as opposed to building it for the native machine.
#  Therefore, fill out what we need to make this build for the configured
#  machine, but really configure it for ArmVirtXen. This means that UEFI
#  cannot _also_ be built for the native platform - but that's OK as we're
#  already using ptft/RPi4 for that.

COMPATIBLE_MACHINE:raspberrypi4-64 = "raspberrypi4-64"
EDK2_PLATFORM:raspberrypi4-64      = "ArmVirtXen-AARCH64"
EDK2_PLATFORM_DSC:raspberrypi4-64  = "ArmVirtPkg/ArmVirtXen.dsc"
EDK2_BIN_NAME:raspberrypi4-64      = "XEN_EFI.fd"

#  Firmware will appear at /firmware/XEN_EFI.fd
