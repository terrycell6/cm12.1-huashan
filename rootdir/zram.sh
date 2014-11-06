#!/system/bin/sh

insmod /system/lib/modules/zsmalloc.ko
sync
insmod /system/lib/modules/lzo.ko
sync
insmod /system/lib/modules/zram.ko num_devices=2
sync
echo "268435456" > /sys/block/zram0/disksize
sync
echo "268435456" > /sys/block/zram1/disksize
sync
mkswap /dev/block/zram0
sync
mkswap /dev/block/zram1
sync
swapon -p 10 /dev/block/zram0
swapon -p 10 /dev/block/zram1
