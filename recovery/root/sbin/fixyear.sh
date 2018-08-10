#!/sbin/sh

setdate() {
    date `date +%m%d%H%M`${year}.`date +%S`
    echo "I:Corrected year to $year from $curyear" >> /tmp/recovery.log
}

retry=0
while [ "$retry" -le 60 ]; do
    if [ -d /data/data ]; then
        break
    elif [ "$retry" -eq 60 ]; then
        exit 1
    fi
    retry=`expr "$retry" + 1`
    sleep 1
done

## Delay method
#cryptostate=`getprop ro.crypto.state`
#cryptodone=`getprop ro.crypto.fs_crypto_blkdev`
#if [ -z "$cryptostate" ]; then
#    sleep 5
#elif [ -n "$cryptodone" ]; then
#    sleep 7
#else
#    sleep 10
#fi

until [ -n "$fixedup" ]; do
    sleep 2
    fixedup=`grep -m 1 "Fixup_Time" /tmp/recovery.log`
done

curyear=`date +%Y`
if [ "$curyear" -ge 2018 ]; then
    exit 0
fi

year1=`date -r /data/data +%Y`
year2=`date -r /data/media/0 +%Y`
if [ "$year1" -ge "$year2" ]; then
    year=$year1
else
    year=$year2
fi

setdate
