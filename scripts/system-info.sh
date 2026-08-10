#!/bin/bash

HOSTNAME=$(hostname)
CURRENT_USER=$(whoami)
KERNEL=$(uname -r)
UPTIME=$(uptime -p)

echo "===== System Information ====="
echo "Hostname: $HOSTNAME"
echo "User: $CURRENT_USER"
echo "Kernel: $KERNEL"
echo "Uptime: $UPTIME"

echo ""
echo "===== Disk Usage ====="
df -h /

echo ""
echo "===== Memory Usage ====="
free -h