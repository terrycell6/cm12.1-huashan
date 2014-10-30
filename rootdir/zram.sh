#!/system/bin/sh

insmod /system/lib/modules/zsmalloc.ko
insmod /system/lib/modules/lzo.ko
insmod /system/lib/modules/zram.ko

mknod /dev/block/zram0 b 253 0

mkswap /dev/block/zram0
