#!/sbin/sh

while [ -z "`getprop ro.crypto.fs_crypto_blkdev`" ]; do # if not yet decrypted
    if [ ! -d /system/etc ]; then # mount system if not already mounted
        mount -o ro /system
    fi

    if [ -n "`blkid /dev/block/bootdevice/by-name/vendor | grep ext4`" ] && [ -z "`mount | grep /vendor`" ]; then
        if [ -L /vendor ]; then # if a symlink, remove it
            rm /vendor
        fi
        if [ ! -d /vendor ]; then # if not a directory, create it
            mkdir /vendor
        fi
        mount -t ext4 -o ro /dev/block/bootdevice/by-name/vendor /vendor
    fi

    if [ -z "`ls -A /vendor`" ]; then # if empty or nonexistent, symlink it
        if [ -n "`mount | grep /vendor`" ]; then
            umount /vendor
        fi
        if [ -d /vendor ]; then
            rmdir /vendor
        fi
        ln -sf /system/vendor /vendor
    fi

    if [ -z "`pidof qseecomd`" ]; then # make sure it isn't already running
        if [ -f /system/bin/qseecomd ]; then
            LD_LIBRARY_PATH='/system/lib64:/system/lib' PATH='/system/bin' /system/bin/qseecomd &
        else
            LD_LIBRARY_PATH='/vendor/lib64:/system/lib64:/vendor/lib:/system/lib' PATH='/vendor/bin:/system/bin' /vendor/bin/qseecomd &
        fi
    fi
done

if [ -n "`getprop ro.crypto.fs_crypto_blkdev`" ]; then
    killall qseecomd
fi

if [ -n "`mount | grep /system`" ]; then
    umount /system
fi

if [ -n "`mount | grep /vendor`" ]; then
    umount /vendor
fi
