# sdv-hackathon-cfg3 [![Hackathon Image Build](https://github.com/benmordaunt/sdv-hackathon-cfg3/actions/workflows/image.yml/badge.svg)](https://github.com/benmordaunt/sdv-hackathon-cfg3/actions/workflows/image.yml)
Configuration (column) 3 implemented for the SDV hackathon - EWAOL (Yocto) additions

# Installation

## UEFI Firmware

As of the v0.2 tag, the boot process depends on use of the RPi4 UEFI firmware available [here](https://github.com/pftf/RPi4).
First, follow the instructions in "Readme.md" of that repository to prepare your Pi.

As EWAOL, as well as all configured guests are using Linux kernels more recent than 5.8, ensure you disable the 3 GB RAM limit
(if your Pi is a 4 GB or 8 GB variant) by navigating to `Device Manager` → `Raspberry Pi Configuration` → `Advanced Configuration` 
in the UEFI settings.

## Configuring the Yocto Build

`meta-ewaol-hackathon/kas/machine/rpi4-hkt.yml` contains several variables that should be configured to better suit your use case
and variant of Pi used. As of v0.2, these are:

- `EWAOL_CONTROL_VM_MEMORY_SIZE` - Memory attributed to Dom0. (Recommended values: "1024" - 4 GB Pi, "2048" - 8 GB Pi)
- `HKT_GUEST_UBUNTU_MEMORY_SIZE` - Memory attributed to Ubuntu 20.04 LTS (focal) Cloud
- `HKT_GUEST_LEDA_MEMORY_SIZE`   - Memory attributed to Eclipse Leda

The default EWAOL guest, (`EWAOL_GUEST_VM1`) is disabled.


## Notes

### Boot Flow

```
EDK2 UEFI Firmware (RPi4 platform) {
    Xen {
        EWAOL Dom0;
	EDK2 UEFI Firmware (ArmVirtXen platform) {
            GRUB2 bootloader {
	        Ubuntu 20.04 Cloud DomU;
            }
	}
	EDK2 UEFI Firmware (ArmVirtXen platform) {
	    GRUB2 bootloader {
	        Eclipse Leda DomU;
	    }
        }
    }
}
```

### RAUC

Eclipse Leda makes use of the RAUC update framework, which interacts with the bootloader to facilitate fault-tolerant image updates.
While interaction between RAUC and Xen has not been verified as of yet, I do not foresee issues with integration. `xen,uefi-binary`
will be pointed to a grub2-efi which should then operate as if Xen does not exist. However, we will need to make sure multiple
xvda block devices are made available for the A/B rootfs switching feature.

### Leda under EFI

By default, Eclipse Leda depends on the U-Boot bootloader from `meta-raspberrypi`, which we are not using as the Raspberry Pi 4 has
been configured with SystemReady SR UEFI firmware. We therefore expect to boot Leda using ArmVirtXen EFI. This maintains the ability
to use GRUB2, and therefore the RAUC tooling. A new Kickstart file for building a grub2-efi-based `/boot` partition will therefore
need to be created under `meta-leda`'s BSP layer. I imagine this will be closely related to the [existing configuration for x86 QEMU](https://github.com/eclipse-leda/meta-leda/blob/b738899c3e9b9f8b34e3b528266b9b97d13a739a/meta-leda-distro/wic/qemux86-grub-efi.wks).
