#!/bin/bash
echo "Content-type: text/html; charset=utf-8"
logdir=/var/log/odoo/$(date +%s)
LOG_FILE=$logdir/run.log
LOCK_FILE="/tmp/odoo_check"
TIME_FILE="/tmp/odoo_check_time"


if [ -e "$LOCK_FILE" ]; then
    #echo "Script is already running. Exiting."
    sleep 2
    echo "<meta http-equiv="refresh" content='0; url=/web'>"
    exit 1
else
   if [ -e "$TIME_FILE" ]; then
           last_run_timestamp=$(cat "$TIME_FILE")
           time_difference=$(($(date +%s) - last_run_timestamp))
           if [ "$time_difference" -lt 60 ]; then
                #echo "Script was run less than 1 minute ago. Exiting."
                    sleep 1
                    echo "<meta http-equiv="refresh" content='0; url=/web'>"
                exit 1
           fi
    fi
    echo "<script>console.log('Issue with Odoo service. Trying to recover')</script>"
    # Create the lock file
    mkdir $logdir
    touch "$LOCK_FILE"
    touch "$TIME_FILE"
    date +%s > "$TIME_FILE"
    touch "$LOG_FILE"
    echo "Logs captured while Odoo not responding" > $LOG_FILE
fi

    make_logs() {

        ps -aux > $logdir/ps-aux-$(date +%s)
        echo "=========== Memory Usage ===========" >> $LOG_FILE
        free -m >> $LOG_FILE
        top -bn1 | awk '/Cpu/ { print "\nCPU Usage: " $2 "%" }' >> $LOG_FILE
        echo "=========== CPU Speed ===========" >> $LOG_FILE
        lscpu | grep MHz >> $LOG_FILE
        echo "=========== I/O Statistics ===========" >> $LOG_FILE
        iostat -xtc >> $LOG_FILE
        systemctl status odoo >> $LOG_FILE
        systemctl status postgresql >> $LOG_FILE
        echo "==============================================================================" >> $LOG_FILE
        }

        echo "=========================== Before Service Restart ============================" >> $LOG_FILE
        make_logs
        systemctl stop odoo >> $LOG_FILE
        systemctl restart postgresql >> $LOG_FILE
        systemctl start odoo >> $LOG_FILE
        sleep 2
        echo "" >> $LOG_FILE
        echo "" >> $LOG_FILE
        echo "=========================== After Service Restart ============================" >> $LOG_FILE
        make_logs

rm -f "$LOCK_FILE"
    echo "<meta http-equiv="refresh" content='0; url=/web'>"
