# BXC22 RPi4 Software Stack [![Hackathon Image Build](https://github.com/benmordaunt/sdv-hackathon-cfg3/actions/workflows/image.yml/badge.svg)](https://github.com/benmordaunt/sdv-hackathon-cfg3/actions/workflows/image.yml)
Configuration (column) 3 implemented for the SDV hackathon - EWAOL (Yocto) additions

# Installation

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
U-Boot (RPi4 platform) {
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

