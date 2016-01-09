#!/system/bin/sh

insmod /system/lib/modules/zsmalloc.ko
sync
insmod /system/lib/modules/lzo.ko
sync
insmod /system/lib/modules/zram.ko num_devices=1
sync
echo "268435456" > /sys/block/zram0/disksize
sync
mkswap /dev/block/zram0
sync
swapon -p 10 /dev/block/zram0
