#!/system/bin/busybox sh

WIFI_FLAGS_FILE=/system/bin/wifi_rtl/exe/wifi_flags.sh
if [ -e ${WIFI_FLAGS_FILE} ];then
	. ${WIFI_FLAGS_FILE}
fi
if [ -z "${CONFIG_WLAN_MODULE_NAME}" ];then
	CONFIG_WLAN_MODULE_NAME=rtl8192es
fi
CONFIG_WLAN_MODULE_TYPE=${CONFIG_WLAN_MODULE_NAME:3:4}
if [ -z "${CONFIG_WLAN_MODULE_TYPE}" ];then
	CONFIG_WLAN_MODULE_TYPE=8192
fi

echo "hi_mci.0" > /sys/bus/platform/drivers/hi_mci/unbind
WIFI_RESULT=$?
echo "[wi-fi]: sdio unbind ret = ${WIFI_RESULT}"

echo "10 shutdown ${CONFIG_WLAN_MODULE_TYPE}:wifi_rtl" > /sys/devices/platform/wifi_at_dev/wifi_at_dev
echo "[wi-fi]: wifi chip power off = $?"









exit ${WIFI_RESULT}
