#!/system/bin/busybox sh

mkdir bin
ln -s /system/bin/sh /bin/sh
ln -s /system/bin/busybox /bin/ash
ln -s /app/bin/oled_hijack/atc /sbin/atc

mkdir /opt /tmp /online/opt
# For Entware
mount --bind /online/opt /opt
# For TUN/TAP
mkdir /dev/net
mknod /dev/net/tun c 10 200
insmod /system/bin/kmod/tun.ko

busybox echo 0 > /proc/sys/net/netfilter/nf_conntrack_checksum

mkdir /var
busybox sysctl -p /system/etc/sysctl.conf
/etc/patchblocked.sh boot
/etc/fix_ttl.sh 0
# Enable IPv6
echo -e 'AT^NVWREX=8514,0,4,01,04,00,00\r' > /dev/appvcom

/etc/huawei_process_start

[ ! -f /data/userdata/passwd ] && cp /etc/passwd_def /data/userdata/passwd
[ ! -f /data/userdata/telnet_disable ] && busybox telnetd -l login -b 0.0.0.0
[ ! -f /data/userdata/adb_disable ] && adb

/app/bin/oled_hijack/autorun.sh
# Entware autorun
[ -f /data/userdata/entware_autorun ] && /opt/etc/init.d/rc.unslung start

# fix_ttl.sh 2, adblock.sh and anticenshorship.sh are called
# from /system/bin/iptables-fixttl-wrapper.sh by /app/bin/npdaemon.
