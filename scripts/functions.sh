log(){
        local  level="$1"
        local message="$2"
        if [[ "$level" == "ERROR" ]];then
                echo "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] $message" | tee -a "$LOG_FILE" >&2
        else 
                echo "$(date '+%Y-%m-%d %H:%M:%S') [$level] $message" | tee -a "$LOG_FILE"
        fi
}


