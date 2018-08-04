#!/sbin/ash
if [ -e /dev/block/bootdevice/by-name/vendor ]; then
echo '/dev/block/bootdevice/by-name/vendor	/vendor	ext4	ro	wait'>>/fstab.h1
if [ ! -d /vendor ]; then
	if [ -e /vendor ]; then
	rm /vendor
	fi
mkdir /vendor
fi
