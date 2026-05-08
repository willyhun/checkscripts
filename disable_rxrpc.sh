#!/bin/bash
cat > /etc/modprobe.d/10-rxrpc-bug-workaround.conf <<EOF
blacklist rxrpc
install rxrpc /bin/false
EOF
