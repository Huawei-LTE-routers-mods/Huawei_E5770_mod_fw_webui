Huawei E5770 LTE router custom firmware
=======================================

Huawei E5770 firmware and web interface repository. Check available branches.

Current version: FW 21.290.23.00.00, WEBUI: 17.100.19.01.00

---------------------------------------

The firmware is based on the original global firmware version 21.290.23.00.00. It could be installed on any technological firmware, or updated from a modified firmware.

Flash using balongflash ([Windows](https://github.com/forth32/balongflash/tree/master/winbuild/Release), [Linux](https://github.com/forth32/balongflash/)).

#### Warning!
This firmware can render your device unbootable! Use it only if you are aware of all the risks and consequences. In case of any problems, do not wait for help, you're on your own. Do not install firmware by non-tech-savvy people request, and do not sell routers with this firmware preinstalled.

### Changes:

Changes:
* Firmware digital signature verification in the firmware server is disabled*
* Added support for IPv6 on mobile networks (disabled by default, could be activated "ipv6" script)**
* ADB installed and Telnet activated (disabled by default, controlled from the OLED menu)
* The stock versions of busybox, iptables and ip6tables programs are replaced with full-fledged ones ***
* The "atc" utility is installed to send AT commands from the console
* Installed "ttl" script for modifying (fixing) TTL (for IPv4) and HL (for IPv6)
* Installed "imei" script to change IMEI
* A local transparent proxy server "tpws" and a script "anticensorship" are installed to circumvent censorship to sites from the registry of prohibited sites in Russian Federation (IPv4 only)
* Added DNS over TLS resolver stubby (version 1.5.1, compiled with OpenSSL 1.0.2p) and DNS-level adblock (IPv4 only)
* Added [extended menu on OLED screen](https://github.com/ValdikSS/huawei_oled_hijack)
* Added RNDIS and ECM Ethernet switching functionality without a switch program on a computer
* All NVRAM items are unlocked
* AT^DATALOCK code is disabled
* Added kernel module TUN/TAP (for OpenVPN and other programs)
* Added OpenVPN (version 2.4.6, compiled with OpenSSL 1.0.2p) and scripts for DNS redirection
* Added curl (version 7.63.0, compiled with OpenSSL 1.0.2p)
* Added EXT4 kernel module and swap support
* Added script for installing Entware application repository
* Added script "adblock_update", for updating the list of advertising domains
* Added script to change MAC address of Wi-Fi in Extender mode (script "wifiext_mac") and USB MAC addresses (script "usb_mac")
* Removed mobile connection logging (mobile logger) to extend flash memory lifetime
* Multilingual web interface with GSM/UMTS/LTE band selection menu
