#!/bin/bash
echo "unload the modules first"
modprobe -r esp4 || echo "REBOOT_REQUIRED"
modprobe -r esp6 || echo "REBOOT_REQUIRED"
cat > /etc/modprobe.d/10-esp_xfrm-bug-workaround.conf <<EOF
blacklist esp4
blacklist esp6
install esp4 /bin/false
install esp6 /bin/false
EOF
echo "Module load disabled (if it is a module)"
