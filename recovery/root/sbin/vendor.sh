#!/sbin/sh

if [ "`blkid /dev/block/bootdevice/by-name/vendor`" ]; then
    if [ -L /vendor ]; then
        rm /vendor
    fi
    sed -i '5i\/vendor		ext4	/dev/block/bootdevice/by-name/vendor	flags=backup=1;wipeingui' /etc/twrp.fstab
    sed -i '6i\/vendor_image	emmc	/dev/block/bootdevice/by-name/vendor	flags=backup=0;flashimg=1' /etc/twrp.fstab
fi
