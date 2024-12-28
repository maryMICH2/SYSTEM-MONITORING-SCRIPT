#!/bin/bash

# This is a system monitoring script that checks Disk, CPU, Memory usage, and Running processes
{
echo -e "\e[32mSystem Monitoring Report - $(date)\e[0m"   # print the date of the day in green color.
#variables
Disk_threshold=20

# Display the filesystem and its disk usage
echo "Filesystem and Disk Usage:"
df -h --output=source,pcent

echo -e "\e[31mChecking filesystems for usage greater than ${Disk_threshold}%:\e[0m"
df -h --output=source,pcent | tail -n +2 | while read -r line; do
usage_percent=$(echo "$line" | awk '{print $2}' | tr -d '%')
if (( usage_percent > Disk_threshold )); 
then
        echo "$line"
fi
done

echo
# Check CPU Usage:
echo "CPU usage:"
top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4 "%"}'

echo
# Check Memory Usage:
echo "Memory usage:"
free -h | awk 'NR==2{printf "Total Memory: %s\nUsed Memory: %s\nFree Memory: %s\n", $2, $3, $4}'
echo
# Check Running Processes:
echo "Top 5 Memory-Consuming Processes:"
ps aux --sort=-%mem | head -n 6 | awk '{print $1, $2, $4, $11}'
} | tee system_monitor.log



