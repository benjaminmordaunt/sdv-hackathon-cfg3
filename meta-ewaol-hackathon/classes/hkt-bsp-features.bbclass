require ${@bb.utils.contains('DISTRO_FEATURES', \
                             'ewaol-virtualization', \
                             'conf/distro/include/hkt-bsp.inc', '', d)}
