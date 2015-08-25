#!/system/xbin/sh
#
# Original author: Bagyusz
#
# 2015.08.25
#
###############################################

GLOVEMODENODE="\/sys\/devices\/i2c-3\/3-0024\/main_ttsp_core.cyttsp4_i2c_adapter\/signal_disparity"
ACTUAL=`cat /sys/devices/i2c-3/3-0024/main_ttsp_core.cyttsp4_i2c_adapter/signal_disparity`;

mount_needed=false;

if [ "$ACTUAL" = "136" ];then
  mount -o remount,rw /system
  sed -i 's/^.*echo.*$/echo '$ACTUAL' > '$GLOVEMODENODE'/' /system/bin/glove_mode_set.sh
  mount_needed=true;
fi

if [ "$ACTUAL" = "0" ];then
  mount -o remount,rw /system
  sed -i 's/^.*echo.*$/echo '$ACTUAL' > '$GLOVEMODENODE'/' /system/bin/glove_mode_set.sh
  mount_needed=true;
fi

if $mount_needed ;then
  mount -o remount,ro /system
fi
