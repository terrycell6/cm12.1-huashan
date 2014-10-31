#!/system/bin/sh

insmod /system/lib/modules/zsmalloc.ko
insmod /system/lib/modules/lzo.ko
insmod /system/lib/modules/zram.ko num_devices=1
