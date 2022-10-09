# Ensure Xen is deployed into the wic
do_image_wic[depends] += "xen:do_deploy"

# Install Xen EDKII UEFI firmware
MACHINE_ESSENTIAL_EXTRA_RDEPENDS += "edk2-firmware"
