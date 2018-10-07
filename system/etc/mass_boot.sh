#!/system/bin/busybox sh
cdrom=$(cat /proc/mtd|busybox grep cdromiso|busybox cut -d: -f1|busybox sed 's/mtd/mtdblock/')
sdpath=/dev/block/mmcblk0
#gadget=/sys/devices/platform/dwc3/gadget
echo $cdrom
mount -t yaffs2 /dev/block/$cdrom /root/
echo "+++++++++++++++++++++++++mass_boot.sh begin++++++++++++++++++++++++"

sdlun=/sys/devices/platform/dwc3/gadget/mass/lun0_SD/file
echo $sdpath > $sdlun
sdlun=/sys/devices/platform/dwc3/gadget/mass/lun1_SD/file
echo $sdpath > $sdlun
sdlun=/sys/devices/platform/dwc3/gadget/mass_two/lun0_SD/file
echo $sdpath > $sdlun
sdlun=/sys/devices/platform/dwc3/gadget/mass_two/lun1_SD/file
echo $sdpath > $sdlun

if busybox [ -f "/root/ISO" ]
then
mount -t iso9660 -o loop /root/ISO /app/webroot/WebApp/common/autorun
fi

cdromlun=/sys/devices/platform/dwc3/gadget/mass/lun0_CD/file
echo /root/ISO > $cdromlun
cdromlun=/sys/devices/platform/dwc3/gadget/mass/lun1_CD/file
echo /root/ISO > $cdromlun
cdromlun=/sys/devices/platform/dwc3/gadget/mass_two/lun0_CD/file
echo /root/ISO > $cdromlun
cdromlun=/sys/devices/platform/dwc3/gadget/mass_two/lun1_CD/file
echo /root/ISO > $cdromlun

echo "+++++++++++++++++++++++++mass_boot.sh end++++++++++++++++++++++++"

#for i in  $(ls $gadget|grep lun)
#do 
#	if [ "$(cat $gadget/$i/ro)" = "1" ];then
#        cdromlun=$gadget/$i/file
#	echo /root/ISO > $cdromlun
#    elif 
#        [ "$(cat $gadget/$i/mode)" = "1" ];then
#		sdlun=$gadget/$i/file
#	if [ $(ls $sdpath|grep mmcblk[0-9]) ];then
#		echo $sdpath/$(ls $sdpath|grep mmcblk[0-9]$) > $sdlun
#	elif 
#	[ $(ls $sdpath|grep mmcblk[0-9]p1$) ];then
#		echo $sdpath/$(ls $sdpath|grep mmcblk[0-9]p1$) > $sdlun 
#	fi
#    fi

#done
