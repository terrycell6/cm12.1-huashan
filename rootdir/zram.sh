#!/system/bin/sh

insmod /system/lib/modules/zsmalloc.ko
sync
insmod /system/lib/modules/lzo.ko
sync
insmod /system/lib/modules/zram.ko num_devices=1
sync
