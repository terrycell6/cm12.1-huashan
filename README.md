Sony Xperia SP
==============

The Sony Xperia SP (codenamed _"HuaShan"_) is a mid-range smartphone from Sony Mobile.

It was announced on 18 March 2013. It is supported in CyanogenMod 10.2 and CyanogenMod 11.

Basic   | Spec Sheet
-------:|:-------------------------
CPU     | 1.7GHz Dual-Core MSM8960T
GPU     | Adreno 320
Memory  | 1GB RAM
Shipped Android Version | 4.1.2
Storage | 8GB
Battery | 2370 mAh
Display | 4.6" 1280 x 720 px
Camera  | 8MPx, LED Flash

![Sony Xperia SP](http://wiki.cyanogenmod.org/images/e/e5/Huashan2.png "Sony Xperia SP in white")

This branch is for building CyanogenMod 11 (or Android KitKat 4.4 AOSP based roms) ROMS.



How to build Slimkat 4.4.4:

repo init -u git://github.com/SlimRoms/platform_manifest.git -b kk4.4-caf

repo sync


Compile:

. build/envsetup.sh

make clean

lunch slim_lbhuashan-userdebug

make -j8 bacon
