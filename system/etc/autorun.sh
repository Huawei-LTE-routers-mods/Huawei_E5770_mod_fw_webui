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
insmod /system/bin/kmod/crc16.ko
insmod /system/bin/kmod/mbcache.ko
insmod /system/bin/kmod/jbd2.ko
insmod /system/bin/kmod/ext4.ko

# Set more or less real date for DNSCrypt
date -u -s '2018-10-01 00:00:00'

busybox echo 0 > /proc/sys/net/netfilter/nf_conntrack_checksum

mkdir /var
busybox sysctl -p /system/etc/sysctl.conf
/etc/patchblocked.sh boot
/etc/patch_usbmac.sh
/etc/fix_ttl.sh 0
# Enable global IPv6 functionality. Does not enable IPv6 per se,
# just allows to enable it in the configuration files.
echo -e 'AT^NVWREX=8514,0,4,01,04,00,00\r' > /dev/appvcom

/etc/huawei_process_start

# Remove /online/mobilelog/mlogcfg.cfg if /app/config/mlog/mlogcfg.cfg does NOT exist
# Disables mobile logger and saves flash rewrite cycles
[ ! -f /app/config/mlog/mlogcfg.cfg ] && rm /online/mobilelog/mlogcfg.cfg

[ ! -f /data/userdata/passwd ] && cp /usr/default_files/passwd_def /data/userdata/passwd
[ ! -f /data/userdata/dnscrypt-public-resolvers.md ] && cp /usr/default_files/dnscrypt-public-resolvers.md_def /data/userdata/dnscrypt-public-resolvers.md
[ ! -f /data/userdata/telnet_disable ] && busybox telnetd -l login -b 0.0.0.0
[ ! -f /data/userdata/adb_disable ] && adb

/app/bin/oled_hijack/autorun.sh
# Entware autorun
[ -f /data/userdata/entware_autorun ] && /opt/etc/init.d/rc.unslung start

# fix_ttl.sh 2, dnscrypt.sh and anticenshorship.sh are called
# from /system/bin/iptables-fixttl-wrapper.sh by /app/bin/npdaemon.
