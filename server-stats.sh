#!/bin/bash

# Total CPU usage
total_cpu=$(top -bn1 | grep "Cpu(s)" | \
           sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | \
           awk '{print 100 - $1"%"}')

# Total memory usage
total_mem=$(free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }')

# Total disk usage
total_disk=$(df -h | awk '$NF=="/"{printf "Disk Usage: %d/%dGB (%s)\n", $3,$2,$5}')

# Top 5 processes by CPU usage
top_cpu=$(ps aux --sort=-%cpu | head -n 6 | awk 'NR>1{printf "%-20s %-8s %-8s %-8s\n", $1, $2, $3, $11}')

# Top 5 processes by memory usage
top_mem=$(ps aux --sort=-%mem | head -n 6 | awk 'NR>1{printf "%-20s %-8s %-8s %-8s\n", $1, $2, $4, $11}')

echo "------------------------"
echo "       Server Stats      "
echo "------------------------"
echo "Total CPU Usage: $total_cpu"
echo "$total_mem"
echo "$total_disk"
echo
echo "Top 5 processes by CPU usage:"
echo "$top_cpu"
echo
echo "Top 5 processes by memory usage:"
echo "$top_mem"

# Stretch goals
echo "OS Version: $(lsb_release -a 2>/dev/null | grep 'Description' | awk '{print $2,$3,$4,$5}')"
echo "Uptime: $(uptime -p)"
echo "Load Average: $(uptime | awk -F 'load average: ' '{print $2}')"
echo "Logged in users: $(who | wc -l)"
echo "Failed login attempts: $(grep 'Failed password' /var/log/auth.log | wc -l)"
