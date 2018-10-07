#!/system/bin/busybox sh
sdpath=/dev/block/platform/hi_mci.0
gadget=/sys/devices/platform/dwc3/gadget
mntpath=/mnt/sd
for i in  $(ls $gadget|grep lun)
do 
	if [ "$(cat $gadget/$i/ro)" = "0" ] && [ "$(cat $gadget/$i/mode)" = "1" ];then
		sdlun=$gadget/$i/file
		break
	fi
done
if ! ls $sdpath|grep mmcblk
then
		echo "" > $sdlun
        umount $mntpath 
fi

if [ $(ls $sdpath|grep mmcblk)[0-9] ];then
    echo $sdpath/$(ls $sdpath|grep mmcblk[0-9]$) > $sdlun
    mount -t vfat $sdpath/$(ls $sdpath|grep mmcblk[0-9]p1$) $mntpath
elif 
    [ $(ls $sdpath|grep mmcblk[0-9]p1$) ];then
   echo $sdpath/$(ls $sdpath|grep mmcblk[0-9]p1$) > $sdlun 
   mount -t vfat $sdpath/$(ls $sdpath|grep mmcblk[0-9]$) $mntpath
fi
