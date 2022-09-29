# Ensure Xen is deployed into the wic
do_image_wic[depends] += "xen:do_deploy"
