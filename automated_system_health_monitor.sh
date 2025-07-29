#!/bin/bash
# Automated System Health Check Script
LOG_FILE="/var/log/system_health_check_$(date '+%Y%m%d_%H%M%S').log"

# Functions to Log OutPut
log(){
	echo "$(date '+%Y-%m-%d %H:%M:%S') -$1" >> "$LOG_FILE"
}

# CPU Check
check_cpu(){
	CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')	
	log "CPU USAGE: $CPU_USAGE%"
}

#Memory Usage
check_memory(){
	MEM_USAGE=$(free | grep MEM | awk '{printf "%.2f",$3/$2 * 100.00 }')
	log "Memory Usage: $MEM_USAGE%"
}

#Disk Usage
check_disk_usage(){
	DISK_USAGE=$(df -h | tail -1 | awk '{print $5}')
	log "Disk Usage: $DISK_USAGE%"
}

#System Uptime
check_uptime(){
	UPTIME=$(uptime -p)
	log "System Uptime: $UPTIME"
}

#ACtive Services samidha nitin wani
check_services(){
	SERVICES=("nginx" "mysql")
	for SERVICE in "${SERVICES[@]}"; do
		systemctl is-active quite "$SERVICE" && STATUS="Running" || STATUS="Stopped"
		log "Service: $SERVICE - Status: $STATUS"
	done
}

#Log Analysis
check_log(){
	ERROR_COUNT=$(grep -i "error" /var/log/messages | wc -l)
	FAILED_LOGINS=$(grep "Failed Password" /var/log/secure | wc -l)
	log "Errors in logs: $ERROR_COUNT"
	log "Failed Login Attemps: $FAILED_LOGINS"
}


#Main Function
main(){	
	echo "Starting System Health Check...."
	echo "===================System Health Check Started==================="
	log "Run Date: $(date '+%Y-%m-%d %H:%M:%S')"  
	
	check_cpu
	check_memory
	check_disk_usage
	check_uptime
	check_services
	check_log
    
	echo "===================System Health Check Completed==================="
	echo "System Health Check Completed.Logs saved to $LOG_FILE"
}

#Execute the main function
main