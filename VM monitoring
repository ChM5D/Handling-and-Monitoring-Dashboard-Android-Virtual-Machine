#!/bin/bash

# Define color variables
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

while true; do
  devices=$(adb devices | awk 'NR>1 {print $1}' | grep -v "offline")
  
  # Clear the screen
  clear

  # Device counter to manage cursor positioning
  device_count=0
    lines_per_device=17 # Number of lines per device information block


  for device in $devices; do
    
    
    
    # Print the captured information
  printf "${BLUE}Device: %s${RED}\n CPU Information: \n${NC}Processor: %s\nCPU Cores: %s\nMicrocode: %s\nModel Number: %s\nCPU Family: %s\nCPU MHz: %s\nCPU Used: %.2f${NC}\n${RED} RAM Information:${NC}\nTotal RAM: %.2f MO\nUsed RAM: %.2f MO\nFree RAM: %.2f MO\n${RED} Storage Information:\n${NC}Total Storage: %s MO\nUsed Storage: %s MO\nFree Storage: %s MO\n" "$device" "$proc" "$core" "$mic" "$mod" "$fam" "$mhz" "$cpu_used" "$total_ram" "$used_ram" "$free_ram" "$total_storage" "$used_storage" "$free_storage"

# Capture CPU information  
    cpuinfo=$(adb -s $device shell cat /proc/cpuinfo)
    proc=$(echo "$cpuinfo" | awk '/^processor/ {print $3; exit}')
    core=$(echo "$cpuinfo" | awk '/^cpu cores/ {print $4; exit}')
    mic=$(echo "$cpuinfo" | awk '/^microcode/ {print $3; exit}')
    mod=$(echo "$cpuinfo" | awk '/^model name/ {print $4; exit}')
    fam=$(echo "$cpuinfo" | awk '/^cpu family/ {print $4; exit}')
    mhz=$(echo "$cpuinfo" | awk '/^cpu MHz/ {print $4; exit}')
    
# Capture CPU USED value 
   cpu_used=$(adb -s $device shell top -n 1 -b | awk 'NR>6 {sum += $9} END {printf "%.2f", sum}')
   
# Capture RAM information 
   raminfo=$(adb -s $device shell dumpsys meminfo )
    total_ram=$(echo "$raminfo" | awk '/Total RAM/ {print $3*1024}')
    used_ram=$(echo "$raminfo" | awk '/Used RAM/ {print $3*1024}')
    free_ram=$(echo "$raminfo" | awk '/Free RAM/ {print $3*1024}')
    
    
# Capture storage information 
    storage_info=$(adb -s $device shell df | awk '/\/data$|\/storage$|\/mnt\/								 	 sdcard$/ {
      total=$2; used=$3; free=$4;
      # Convert values to MB
      total_mb=(total ~ /G/ ? total*1024 : (total ~ /M/ ? total : total/1024));
      used_mb=(used ~ /G/ ? used*1024 : (used ~ /M/ ? used : used/1024));
      free_mb=(free ~ /G/ ? free*1024 : (free ~ /M/ ? free : free/1024));
      printf "%.2f %.2f %.2f", total_mb, used_mb, free_mb
    }')

    total_storage=$(echo $storage_info | awk '{print $1}')
    used_storage=$(echo $storage_info | awk '{print $2}')
    free_storage=$(echo $storage_info | awk '{print $3}')


    
    
    # Increment device counter
    device_count=$((device_count + 1))
  done
  
  sleep 0.1
done
