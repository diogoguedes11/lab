#!/bin/bash
set -euo pipefail

# This script collects system performance statistics and writes them to a file.


TOTAL_CPU_USAGE=$(top -bn2 | grep "Cpu(s)" | tail -n1 | awk '{print 100 - $8 "%"}')
TOTAL_MEMORY_USAGE=$(free -mh | awk 'NR==2 {print $3}')
TOTAL_DISK_USAGE=$(df -h | awk '$NF=="/"{print $5}')
TOP_5_CPU_PROCESSES=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 7)
TOP_5_MEM_PROCESSES=$(ps -eo pid,comm,%mem --sort=-%mem | head -n 7)
OS=$(uname -a)
UPTIME=$(uptime -p)
USERS=$(who | wc -l)


echo "===== SERVER STATS ====="
echo "OS Version: $OS"
echo "Uptime: $UPTIME"
echo "Logged-in users: $USERS"

echo -e "\nCPU Usage: $TOTAL_CPU_USAGE%"
echo "Memory Usage: $TOTAL_MEMORY_USAGE"
echo "Disk Usage: $TOTAL_DISK_USAGE"
 
echo -e "\nTop 5 CPU-consuming processes:"
echo "$TOP_5_CPU_PROCESSES"

echo -e "\nTop 5 Memory-consuming processes:"
echo "$TOP_5_MEM_PROCESSES"
