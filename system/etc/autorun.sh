#!/system/bin/busybox sh

mkdir bin
ln -s /system/bin/sh /bin/sh
ln -s /system/bin/busybox /bin/ash
ln -s /app/bin/oled_hijack/atc.sh /sbin/atc
mkdir /var /opt /tmp /online/opt
# For Entware
mount --bind /online/opt /opt
# For TUN/TAP
mkdir /dev/net
mknod /dev/net/tun c 10 200

busybox echo 0 > /proc/sys/net/netfilter/nf_conntrack_checksum

# NV restore flag, load patches only when normal boot.
if [[ "$(cat /proc/dload_nark)" == "nv_restore_start" ]];
then
    /etc/huawei_process_start
    exit 0
fi

/etc/fix_ttl.sh 0
/etc/huawei_process_start

# TUN/TAP support
insmod /system/bin/kmod/tun.ko
# EXT2/3/4
insmod /system/bin/kmod/crc16.ko
insmod /system/bin/kmod/mbcache.ko
insmod /system/bin/kmod/jbd2.ko
insmod /system/bin/kmod/ext4.ko

# Set time closer to a real time for time-sensitive software.
# Needed for everything TLS/HTTPS-related, like DNS over TLS stubby,
# to work before the time is synced over the internet.
date -u -s '2018-12-01 00:00:00'

busybox sysctl -p /system/etc/sysctl.conf
# Unlock DATALOCK and blocked (sensitive) NVRAM items
# to be readable/writable using AT^NVRD/AT^NVWR.
/etc/patchblocked.sh boot
/etc/patch_usbmac.sh

# Remove /online/mobilelog/mlogcfg.cfg if /app/config/mlog/mlogcfg.cfg does NOT exist
# Disables mobile logger and saves flash rewrite cycles
[ ! -f /app/config/mlog/mlogcfg.cfg ] && rm /online/mobilelog/mlogcfg.cfg

[ ! -f /data/userdata/passwd ] && cp /system/usr/default_files/passwd_def /data/userdata/passwd
[ ! -f /data/userdata/telnet_disable ] && telnetd -l login -b 0.0.0.0
[ ! -f /data/userdata/adb_disable ] && adb

/app/bin/oled_hijack/autorun.sh
# Entware autorun
[ -f /data/userdata/entware_autorun ] && /opt/etc/init.d/rc.unslung start

# fix_ttl.sh 2, dns_over_tls.sh and anticenshorship.sh are called
# from /system/bin/iptables-fixttl-wrapper.sh by /app/bin/npdaemon.
