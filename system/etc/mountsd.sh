#!/system/bin/busybox sh
path=/dev/block/platform/hi_mci.0
lun=/sys/devices/platform/dwc3/gadget
##/* BEGIN PN: DTS2013071704632, Modified by h00122846, 2012/07/17 */ 
isPartion=0

if [ "$1" = "mount_web" ]
then
	for i in  $(ls $gadget|grep lun)
	do 
		if [ "$(cat $gadget/$i/ro)" = "0" ];then
			echo 0 > $gadget/$i/mode
			break
		fi
	done
	
	for j in $(ls $path|grep mmcblk[0-9]p)
	do
		mount -t vfat -o codepage=437,iocharset=utf8,dirsync -o shortname=mixed $path/$j  /mnt/sdcard
		isPartion=1
		break
	done
        if [ $isPartion = 0 ]
        then
		for j in $(ls $path|grep mmcblk)
		do
			mount -t vfat -o codepage=437,iocharset=utf8,dirsync -o shortname=mixed $path/$j  /mnt/sdcard
			break
		done
        fi

elif [ "$1" = "umount_web" ]
then
	umount -l /mnt/sdcard
	unlink /var/sdcard

elif [ "$1" = "mount_usb" ]
then
	for i in  $(ls $gadget|grep lun)
	do 
		if [ "$(cat $gadget/$i/ro)" = "0" ];then
			echo 1 > $gadget/$i/mode
			break
		fi
	done
	
	for i in  $(ls $lun|grep lun)
	do 
		if [ "$(cat $lun/$i/ro)" = "0" ];then
			filepath=$lun/$i/file
			break
		fi
	done

	if ! ls $path|grep mmcblk
	then
		echo "" > $filepath
	fi	
	for j in $(ls $path|grep mmcblk)
	do
		if [ "$filepath" = "$lun/$i/file" ];then
			echo $path/$j > $filepath
			isPartion=1
			break
	    	fi
	done
	if [ $isPartion = 0 ]
        then
		for j in $(ls $path|grep mmcblk[0-9]p)
		do
			if [ "$filepath" = "$lun/$i/file" ];then
				echo $path/$j > $filepath
				break
		    	fi
		done
	fi

elif [ "$1" = "umount_usb" ]
then
	for i in  $(ls $lun|grep lun)
	do 
		if [ "$(cat $lun/$i/ro)" = "0" ];then
			filepath=$lun/$i/file
			break
		fi
	done

	echo "" > $filepath

fi
##/* END PN: DTS2013071704632, Modified by h00122846, 2012/07/17 */ 
