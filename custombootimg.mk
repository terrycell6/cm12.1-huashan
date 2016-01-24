LOCAL_PATH := $(call my-dir)

uncompressed_ramdisk := $(PRODUCT_OUT)/ramdisk.cpio
$(uncompressed_ramdisk): $(INSTALLED_RAMDISK_TARGET)
	zcat $< > $@

MKELF := device/sony/lbhuashan/tools/mkelf.py
INITSH := device/sony/lbhuashan/combinedroot/init.sh
BOOTREC_DEVICE := $(LOCAL_PATH)/recovery/root/etc/bootrec-device

INSTALLED_BOOTIMAGE_TARGET := $(PRODUCT_OUT)/boot.img
$(INSTALLED_BOOTIMAGE_TARGET): $(PRODUCT_OUT)/kernel $(uncompressed_ramdisk) $(recovery_uncompressed_ramdisk) $(INSTALLED_RAMDISK_TARGET) $(INITSH) $(BOOTREC_DEVICE) $(PRODUCT_OUT)/utilities/busybox $(PRODUCT_OUT)/utilities/extract_elf_ramdisk $(MKBOOTIMG) $(MINIGZIP) $(INTERNAL_BOOTIMAGE_FILES)
	$(call pretty,"Boot image: $@")

	$(hide) rm -fr $(PRODUCT_OUT)/combinedroot
	$(hide) mkdir -p $(PRODUCT_OUT)/combinedroot/sbin

	$(hide) mv $(PRODUCT_OUT)/root/logo.rle $(PRODUCT_OUT)/combinedroot/logo.rle
	$(hide) cp $(uncompressed_ramdisk) $(PRODUCT_OUT)/combinedroot/sbin/
	$(hide) cp $(recovery_uncompressed_ramdisk) $(PRODUCT_OUT)/combinedroot/sbin/
	$(hide) cp $(PRODUCT_OUT)/utilities/busybox $(PRODUCT_OUT)/combinedroot/sbin/
	$(hide) cp $(PRODUCT_OUT)/utilities/extract_elf_ramdisk $(PRODUCT_OUT)/combinedroot/sbin/

	$(hide) cp $(INITSH) $(PRODUCT_OUT)/combinedroot/sbin/init.sh
	$(hide) chmod 755 $(PRODUCT_OUT)/combinedroot/sbin/init.sh
	$(hide) ln -s sbin/init.sh $(PRODUCT_OUT)/combinedroot/init
	$(hide) cp $(BOOTREC_DEVICE) $(PRODUCT_OUT)/combinedroot/sbin/

	$(hide) $(MKBOOTFS) $(PRODUCT_OUT)/combinedroot/ > $(PRODUCT_OUT)/combinedroot.cpio
	$(hide) cat $(PRODUCT_OUT)/combinedroot.cpio | gzip > $(PRODUCT_OUT)/combinedroot.fs
	$(hide) python $(MKELF) -o $@ $(PRODUCT_OUT)/kernel@0x80208000 $(PRODUCT_OUT)/combinedroot.fs@0x81900000,ramdisk vendor/lbsony/huashan/proprietary/boot/RPM.bin@0x00020000,rpm device/sony/lbhuashan/rootdir/cmdline.txt@cmdline

	$(hide) ln -f $(INSTALLED_BOOTIMAGE_TARGET) $(PRODUCT_OUT)/boot.elf

	$(hide) cp $(PRODUCT_OUT)/system/lib/modules/zsmalloc.ko vendor/lbsony/huashan/proprietary/lib/modules/
	$(hide) cp $(PRODUCT_OUT)/system/lib/modules/lzo.ko vendor/lbsony/huashan/proprietary/lib/modules/
	$(hide) cp $(PRODUCT_OUT)/system/lib/modules/zram.ko vendor/lbsony/huashan/proprietary/lib/modules/

	$(hide) rm -fr $(PRODUCT_OUT)/system/lib/modules
	$(hide) cp -r vendor/lbsony/huashan/proprietary/lib/modules $(PRODUCT_OUT)/system/lib

	$(hide) rm vendor/lbsony/huashan/proprietary/lib/modules/zsmalloc.ko
	$(hide) rm vendor/lbsony/huashan/proprietary/lib/modules/lzo.ko
	$(hide) rm vendor/lbsony/huashan/proprietary/lib/modules/zram.ko

	$(hide) cd $(PRODUCT_OUT)/root/sbin && chmod 777 `ls`

	$(hide) chmod 644 $(PRODUCT_OUT)/root/default.prop
	$(hide) chmod 777 $(PRODUCT_OUT)/root/file_contexts
	$(hide) chmod 755 $(PRODUCT_OUT)/root/fstab.qcom
	$(hide) chmod 777 $(PRODUCT_OUT)/root/init
	$(hide) chmod 644 $(PRODUCT_OUT)/root/init.cm.rc
	$(hide) chmod 644 $(PRODUCT_OUT)/root/init.environ.rc
	$(hide) chmod 644 $(PRODUCT_OUT)/root/init.qcom.rc
	$(hide) chmod 644 $(PRODUCT_OUT)/root/init.rc
	$(hide) chmod 644 $(PRODUCT_OUT)/root/init.recovery.qcom.rc
	$(hide) chmod 644 $(PRODUCT_OUT)/root/init.sony.usb.rc
	$(hide) chmod 644 $(PRODUCT_OUT)/root/init.superuser.rc
	$(hide) chmod 644 $(PRODUCT_OUT)/root/init.target.rc
	$(hide) chmod 644 $(PRODUCT_OUT)/root/init.trace.rc
	$(hide) chmod 644 $(PRODUCT_OUT)/root/init.usb.rc
	$(hide) chmod 644 $(PRODUCT_OUT)/root/init.zygote32.rc
	$(hide) chmod 777 $(PRODUCT_OUT)/root/property_contexts
	$(hide) chmod 777 $(PRODUCT_OUT)/root/seapp_contexts
	$(hide) chmod 777 $(PRODUCT_OUT)/root/selinux_version
	$(hide) chmod 777 $(PRODUCT_OUT)/root/sepolicy
	$(hide) chmod 777 $(PRODUCT_OUT)/root/service_contexts
	$(hide) chmod 644 $(PRODUCT_OUT)/root/ueventd.qcom.rc
	$(hide) chmod 644 $(PRODUCT_OUT)/root/ueventd.rc
	$(hide) chmod 775 $(PRODUCT_OUT)/root/zram.sh

	$(hide) cd $(PRODUCT_OUT)/root && tar -cvf ramdisk.tar `ls $(PRODUCT_OUT)/root`
	$(hide) mv $(PRODUCT_OUT)/root/ramdisk.tar $(PRODUCT_OUT)/system/bin/ramdisk.tar
	$(hide) chmod 777 $(PRODUCT_OUT)/system/bin/wipedata
	$(hide) chmod 777 $(PRODUCT_OUT)/system/bin/philz.tar
	$(hide) chmod 777 $(PRODUCT_OUT)/system/bin/cwm.tar
	$(hide) chmod 777 $(PRODUCT_OUT)/system/bin/ramdisk.tar
	$(hide) chmod 777 $(PRODUCT_OUT)/system/bin/hijack.tar

	$(hide) ln -s /data/etc/wlan_macaddr0 $(PRODUCT_OUT)/system/etc/firmware/wlan/macaddr0
	$(hide) ln -s /data/etc/wlan_macaddr1 $(PRODUCT_OUT)/system/etc/firmware/wlan/macaddr1
	$(hide) ln -s /data/etc/wlan_macaddr2 $(PRODUCT_OUT)/system/etc/firmware/wlan/macaddr2
	$(hide) ln -s /data/etc/wlan_macaddr3 $(PRODUCT_OUT)/system/etc/firmware/wlan/macaddr3

	$(hide) rm $(PRODUCT_OUT)/boot.img
	$(hide) cp -r vendor/lbsony/huashan/proprietary/kernel/boot.img $(PRODUCT_OUT)

INSTALLED_RECOVERYIMAGE_TARGET := $(PRODUCT_OUT)/recovery.img
$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG) \
	$(recovery_ramdisk) \
	$(recovery_kernel)
	@echo ----- Making recovery image ------
	$(hide) python $(MKELF) -o $@ $(PRODUCT_OUT)/kernel@0x80208000 $(PRODUCT_OUT)/ramdisk-recovery.img@0x81900000,ramdisk vendor/lbsony/huashan/proprietary/boot/RPM.bin@0x00020000,rpm device/sony/lbhuashan/rootdir/cmdline.txt@cmdline
	@echo ----- Made recovery image -------- $@
