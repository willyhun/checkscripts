#!/bin/bash
echo "unload the module first"
modprobe -r rxrpc || echo "REBOOT_REQUIRED"
cat > /etc/modprobe.d/10-rxrpc-bug-workaround.conf <<EOF
blacklist rxrpc
install rxrpc /bin/false
EOF
