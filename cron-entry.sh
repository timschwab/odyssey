# Capture the output of the cron script

backup_filename=/odyssey/logs/cron-$(date -I).log
/odyssey/cron-script.sh > $backup_filename 2>&1
