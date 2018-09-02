#!/sbin/sh

setdate() {
    date `date +%m%d%H%M`${year}.`date +%S`
    echo "I:Corrected year from $curyear to $year" >> /tmp/recovery.log
}

for retry in `seq 0 60`; do
    if [ -d /data/data ]; then
        break
    elif [ "$retry" -eq 60 ]; then
        exit 1
    fi
    sleep 1
done

until [ -n "`grep -m 1 "Fixup_Time" /tmp/recovery.log`" ]; do
    sleep 2
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
