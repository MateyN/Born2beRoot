#!/bin/bash

arcs=$(uname -a)
pcpu=$(awk '/^processor/{n+=1}END{print n}' /proc/cpuinfo)
vcpu=$(cat /proc/cpuinfo | grep processor | wc -l)
uram=$(free -m | awk '$1 == "Mem:" {print $3}')
fram=$(free -m | awk '$1 == "Mem:" {print $2}')
pram=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')
udisk=$(df -Bm | grep -v '^/dev/' | grep -v '/boot$' | awk '{usage += $2} END {print usage}')
fdisk=$(df -Bg | grep -v '^/dev/' | grep -v '/boot$' | awk '{free += $3} END {print free}')
pdisk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{usage += $3} {free+= $2} END {printf("%d"), usage/free*100}')
cpul=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')
lb=$(who -b | awk '$1 == "system" {print $3 " " $4}')
lvm=$(lsblk | grep "lvm" | wc -l)
lvmu=$(if [ $lvm -eq 0 ]; then echo no; else echo yes; fi)

# Here we need to install net tools for the next step [$ sudo apt install net-tools]

ctcp=$(cat /proc/net/sockstat{,6} | awk '$1 == "TCP:" {print $3}')
ul=$(users | wc -w)
net=$(hostname -I | cut -f1 -d' ')
mac=$(ip link show | awk '$1 == "link/ether" {print $2}')
sudo=$(sudo journalctl | grep "COMMAND" | wc -l)

wall "	#Architecture: $arcs
       	#CPU physical : $pcpu
       	#vCPU : $vcpu
       	#Memory Usage: $uram/${fram}MB ($pram%)
		#Disk Usage: $udisk/${fdisk}GB ($pdisk%)
		#CPU load: $cpul
       	#Last boot: $lb
       	#LVM use: $lvmu
       	#Connections TCP : $ctcp ESTABLISHED
       	#User log: $ul
		#Network: IP $net ($mac)
       	#Sudo : $sudo cmd "
