log(){
        local  level="$1"
        local message="$2"
        if [[ "$level" == "ERROR" ]];then
                echo "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] $message" | tee -a "$LOG_FILE" >&2
        else 
                echo "$(date '+%Y-%m-%d %H:%M:%S') [$level] $message" | tee -a "$LOG_FILE"
        fi
}

check_disk_usage(){
	local threshold=80
	local disk_usage
	
	disk_usage=$(df -P / | awk 'NR>1 {print $5}' | sed 's/%//')

	if [[ "$disk_usage" -ge "$threshold" ]]; then
		log "WARNING" "Disk usage is high: ${disk_usage}%"
	else
		log "INFO" "Disk usage is healthy: ${disk_usage}%"
	fi
	
}

backup_applications() {
    local timestamp
    local archive_name
    local archive_path

    timestamp=$(date '+%Y-%m-%d_%H-%M-%S')
    archive_name="applications-${timestamp}.tar.gz"
    archive_path="${BACKUP_DIR}/${archive_name}"

	if tar -czf "$archive_path" -C "$SOURCE_DIR" .; then
    		log "INFO" "Backup created successfully: $archive_path"
	else
    		log "ERROR" "Backup failed: $archive_path"
		rm -f -- "$archive_path"
    		return 1
	fi	
}
