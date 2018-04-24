#!/sbin/ash
if [ `blkid /dev/block/bootdevice/by-name/vendor | grep -c ext4` -ge 1 ] ; then
	echo '/dev/block/bootdevice/by-name/vendor	/vendor	ext4	ro	wait'>>/fstab.h1
	if [ ! -d /vendor ]; then # if not a directory, it either doesnt exist or is a symlink
		if [ -L /vendor ]; then
			rm /vendor
		fi
	fi
mkdir /vendor
fi
