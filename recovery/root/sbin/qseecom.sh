#!/sbin/sh

if [ -z "`mount | grep -w /system`" ]; then
    mount -o ro /system
fi

if [ -n "`blkid /dev/block/bootdevice/by-name/vendor | grep ext4`" ]; then
    if [ -L /vendor ]; then
        rm /vendor
    fi
    if [ ! -d /vendor ]; then
        mkdir /vendor
    fi
    mount -t ext4 -o ro /dev/block/bootdevice/by-name/vendor /vendor
fi

if [ -z "`ls -A /vendor`" ]; then
    if [ -n "`mount | grep -w /vendor`" ]; then
        umount /vendor
    fi
    if [ -d /vendor ]; then
        rmdir /vendor
    fi
    ln -sf /system/vendor /vendor
fi

if [ -z "`pidof qseecomd`" ]; then
    if [ -f /system/bin/qseecomd ]; then
        LD_LIBRARY_PATH='/system/lib64:/system/lib' PATH='/system/bin' /system/bin/qseecomd &
    else
        LD_LIBRARY_PATH='/vendor/lib64:/vendor/lib:/system/lib64:/system/lib' PATH='/vendor/bin:/system/bin' /vendor/bin/qseecomd &
    fi
fi

retry=0
while [ "$retry" -le 60 ]; do
    case `getprop ro.crypto.fs_crypto_blkdev` in
        /dev/block/dm-*) cryptodone=1 ;;
    esac
    if [ -n "$cryptodone" ] || [ "$retry" -eq 60 ]; then
        break
    fi
    retry=`expr "$retry" + 1`
    sleep 1
done

killall qseecomd

if [ -n "`mount | grep -w /system`" ]; then
    umount /system
fi

if [ -n "`mount | grep -w /vendor`" ]; then
    umount /vendor
fi
