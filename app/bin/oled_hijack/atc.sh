#!/system/bin/busybox sh
# suspend ats daemon to prevent intervention
killall -STOP ats
timeout -t 3 /app/bin/oled_hijack/atc "$@"
killall -CONT ats
