#!/bin/bash
check_active_port(){
	port=$1
	grep -wq $port /var/lib/jenkins/portlookup/portlookup.txt
	while :
	do
		if [ $? -ne 0 ]
          	then
              		port=$(($port + 1))
          	else
              		break
          	fi
          	grep -wq $port /var/lib/jenkins/portlookup/portlookup.txt
	done
	echo ${port}	
}

assign_ports(){
	serv_name=$1
	grep -wq $serv_name /var/lib/jenkins/portlookup/server_mapping
	if [ $? -eq 0 ]; then
		echo "This server name already exists."
		exit 1
	else
		lastsshport=$(tail -1 /var/lib/jenkins/portlookup/ssh_port)
		lastvncport=$(tail -1 /var/lib/jenkins/portlookup/vnc_port)
		lastnginxport=$(tail -1 /var/lib/jenkins/portlookup/nginx_port)
		addsshport=$((${lastsshport} + 1))
		addvncport=$((${lastvncport} + 1))
		addnginxport=$((${lastnginxport} + 1))
		netstat -ant | awk '{ print $4}' | rev |cut -d ":" -f1|rev|uniq -u | grep -o '[0-9]*'>/var/lib/jenkins/portlookup/portlookup.txt
		[ -s /var/lib/jenkins/portlookup/portlookup.txt ]
		if [ $? -eq 1 ]; then
			echo "10">>/var/lib/jenkins/portlookup/portlookup.txt
		fi
       
		addsshport=`check_active_port $addsshport`
		addvncport=`check_active_port $addvncport`
		addnginxport=`check_active_port $addnginxport`

		echo "$serv_name $addsshport $addvncport $addnginxport">>/var/lib/jenkins/portlookup/server_mapping
		echo "$addsshport">/var/lib/jenkins/portlookup/ssh_port
		echo "$addvncport">/var/lib/jenkins/portlookup/vnc_port
		echo "$addnginxport">/var/lib/jenkins/portlookup/nginx_port
	fi
}

deleteServer() {
	server_name=$1
	grep -wq $server_name /var/lib/jenkins/portlookup/server_mapping
	if [ $? -eq 0 ]
	then
    		linenum=$(grep -nw $server_name /var/lib/jenkins/portlookup/server_mapping|sed 's/^\([0-9]\+\):.*$/\1/')
    		sed -i "${linenum}d" /var/lib/jenkins/portlookup/server_mapping
	else
    		echo "No server with this name"
		exit 1
	fi
}

getPort(){
	servername=$1
	find_port=$2
	port_value=$(grep -w $servername /var/lib/jenkins/portlookup/server_mapping | cut -d " " -f${find_port})
	echo $port_value
}

getSSHPort(){
	name=$1
	grep -wq $name /var/lib/jenkins/portlookup/server_mapping
	if [ $? -eq 0 ]
	then
		sshport=`getPort ${name} 2`
		echo $sshport
	else
		echo "This server does not exist"
		exit 1
	fi
}

getVNCPort(){
	name=$1
        grep -wq $name /var/lib/jenkins/portlookup/server_mapping
        if [ $? -eq 0 ]
        then
                vncport=`getPort ${name} 3`
		echo $vncport
        else
                echo "This server does not exist"
                exit 1
        fi
}

getNginxPort(){
        name=$1
        grep -wq $name /var/lib/jenkins/portlookup/server_mapping
        if [ $? -eq 0 ]
        then
                nginxport=`getPort ${name} 4`
                echo $nginxport
        else
                echo "This server does not exist"
                exit 1
        fi
}
