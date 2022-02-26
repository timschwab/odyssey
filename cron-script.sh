#!/bin/bash

# Flush everything and make sure the filesystem is ready for copying
echo "save-off" >> /odyssey/mc.pipe
echo "save-all" >> /odyssey/mc.pipe
sleep 60

# Do backup
new_file=backups/snapshot-$(date -I).tar.gz
tar -czvf /odyssey/$new_file /odyssey/worlds

# Turn saving back on
echo "save-on" >> /odyssey/mc.pipe

# Remove snapshot from 7 days ago
old_file=/odyssey/backups/snapshot-$(date -d "-7 days" -I).tar.gz
if [ -e "$old_file" ]; then
	rm "$old_file"
fi

# Send backup to AWS once a week
aws_bucket="odyssey-minecraft-dev"
if [[ $(date +%u) -eq 1 ]]
then
	aws s3 cp /odyssey/$new_file s3://$aws_bucket/$new_file
fi
