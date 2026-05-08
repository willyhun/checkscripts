#!/bin/bash
dpkg -l charon-cmd 2>/dev/null 1>/dev/null && echo "IPSec (charon-cmd) found exit" && exit -1
dpkg -l charon-systemd 2>/dev/null 1>/dev/null && echo "IPSec (charon-systemd) found exit" && exit -1
dpkg -l strongswan 2>/dev/null 1>/dev/null && echo "IPSec (strongswan) found exit" && exit -1
dpkg -l libreswan 2>/dev/null 1>/dev/null && echo "IPSec (libreswan) found exit" && exit -1
dpkg -l softether-vpnclient 2>/dev/null 1>/dev/null && echo "IPSec (softether-vpnclient) found exit" && exit -1
dpkg -l softether-vpnbridge 2>/dev/null 1>/dev/null && echo "IPSec (softether-vpnbridge) found exit" && exit -1
dpkg -l softether-vpnserver 2>/dev/null 1>/dev/null && echo "IPSec (softether-vpnserver) found exit" && exit -1
echo "No IPSec software detected"
echo "unload the modules first"
modprobe -r esp4 || echo "REBOOT_REQUIRED"
modprobe -r esp6 || echo "REBOOT_REQUIRED"
cat > /etc/modprobe.d/10-esp_xfrm-bug-workaround.conf <<EOF
blacklist esp4
blacklist esp6
install esp4 /bin/false
install esp6 /bin/false
EOF
# if you need to
# chattr +i /etc/modprobe.d/10-esp_xfrm-bug-workaround.conf
echo "Module load disabled (if it is a module)"
