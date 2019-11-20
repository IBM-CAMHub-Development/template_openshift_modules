#!/bin/bash

PRIVATE_IP=$1
PUBLIC_IP=$2

## Check if a command exists
function command_exists() {
    type "$1" &> /dev/null;
}

## Use Python installation to identify the platform and version
function identifyPlatform() {
    if command_exists python; then
        PLATFORM=`python -c "import platform;print(platform.platform())" | rev | cut -d '-' -f3 | rev | tr -d '".' | tr '[:upper:]' '[:lower:]'`
        PLATFORM_VERSION=`python -c "import platform;print(platform.platform())" | rev | cut -d '-' -f2 | rev`
    else
        if command_exists python3; then
            PLATFORM=`python3 -c "import platform;print(platform.platform())" | rev | cut -d '-' -f3 | rev | tr -d '".' | tr '[:upper:]' '[:lower:]'`
            PLATFORM_VERSION=`python3 -c "import platform;print(platform.platform())" | rev | cut -d '-' -f2 | rev`
        fi
    fi
    if [[ ${PLATFORM} == *"redhat"* ]]; then
        PLATFORM="rhel"
    fi
}

## Configure the firewall to allow external servers to access the DNS
function configureFirewall() {
    echo "Configuring ports to allow access to DNS, DHCP, API, APIINT, APPS and NAT..."
    if [[ ${PLATFORM} == *"ubuntu"* ]]; then
        sudo systemctl disable systemd-resolved
        sudo systemctl stop systemd-resolved        
        echo "y" | sudo ufw enable
		for ports in 22 53 67 68 80 443 2380 8080 6443 22623; do        	
	        sudo ufw allow out ${ports}/tcp
	        sudo ufw allow out ${ports}/udp
		done
		sudo ufw allow out 2379:2380/tcp
		sudo ufw allow out 9000:9999/tcp
		sudo ufw allow out 10256/tcp		
		sudo ufw allow out 10249:10259/tcp
		sudo ufw allow out 9000:9999/udp			
		sudo ufw allow out 4789/udp
		sudo ufw allow out 6081/udp		
		sudo ufw allow out 30000:32767/udp							
		echo "net/ipv4/ip_forward=1" | sudo tee -a /etc/ufw/sysctl.conf
		sudo sed -i -e 's/DEFAULT_FORWARD_POLICY=.*/DEFAULT_FORWARD_POLICY="ACCEPT"/g' /etc/default/ufw
		sudo sed -i -e "1s|^|/*nat :POSTROUTING ACCEPT [0:0] -A POSTROUTING -o $INT -j MASQUERADE COMMIT \n|" /etc/ufw/before.rules
        echo "y" | sudo ufw disable
        echo "y" | sudo ufw enable
        echo "y" | sudo ufw reset
    elif [[ ${PLATFORM} == *"rhel"* ]]; then
        sudo systemctl start firewalld
    	sudo sysctl -w net.ipv4.ip_forward=1
		echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.d/ip_forward.conf    		
    	sudo sysctl -p        	
        for ports in 22 53 67 68 80 443 2380 6443 8080 22623; do
        	sudo firewall-cmd --zone=public --add-port=${ports}/tcp --permanent
        	sudo firewall-cmd --zone=public --add-port=${ports}/udp --permanent
    	done
    	sudo firewall-cmd --zone=public --add-port=4789/udp --permanent
		sudo firewall-cmd --zone=public --add-port=6081/udp --permanent    		
		sudo firewall-cmd --zone=public --add-port=9000-9999/udp --permanent
		sudo firewall-cmd --zone=public --add-port=30000-32767/udp --permanent
		sudo firewall-cmd --zone=public --add-port=9000-9999/tcp --permanent
		sudo firewall-cmd --zone=public --add-port=10249-10259/tcp --permanent
		sudo firewall-cmd --zone=public --add-port=10256/tcp --permanent
		sudo firewall-cmd --zone=public --add-port=2379-2380/tcp --permanent					
    	#sudo firewall-cmd --zone=public --permanent --direct --passthrough ipv4 -A FORWARD -i $PUBLIC_INT -o $PRIVATE_INT -m state --state ESTABLISHED,RELATED -j ACCEPT
    	#sudo firewall-cmd --zone=public --permanent --direct --passthrough ipv4 -A FORWARD -i $PRIVATE_INT -j ACCEPT
    	#sudo firewall-cmd --zone=public --permanent --direct --passthrough ipv4 -A nat -I POSTROUTING -o ${INT} -j MASQUERADE
		sudo firewall-cmd --permanent --direct --add-rule ipv4 nat POSTROUTING 0 -o $PUBLIC_INT -j MASQUERADE
		sudo firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 0 -i $PRIVATE_INT -o $PUBLIC_INT -j ACCEPT
		sudo firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 0 -i $PUBLIC_INT -o $PRIVATE_INT -m state --state RELATED,ESTABLISHED -j ACCEPT    		
        sudo firewall-cmd --reload
    fi
}
echo ${PRIVATE_IP}
echo ${PUBLIC_IP}
PRIVATE_INT=$(ifconfig | grep -B1 "${PRIVATE_IP}" | awk '$1!="inet" && $1!="--" {print $1}'| cut -d':' -f1)
PUBLIC_INT=$(ifconfig | grep -B1 "${PUBLIC_IP}" | awk '$1!="inet" && $1!="--" {print $1}'| cut -d':' -f1)
echo ${PRIVATE_INT}
echo ${PUBLIC_INT}
identifyPlatform
configureFirewall