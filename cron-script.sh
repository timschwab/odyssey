#!/bin/bash

# Flush everything and make sure the filesystem is ready for copying
echo "save-off" >> /odyssey/mc.pipe
echo "save-all" >> /odyssey/mc.pipe
sleep 10

# Do backup
tar -czvf /odyssey/backups/snapshot-$(date -I).tar.gz /odyssey/worlds

# Turn saving back on
echo "save-on" >> /odyssey/mc.pipe

# Remove snapshot from 7 days ago
old_file=/odyssey/backups/snapshot-$(date -d "-7 days" -I).tar.gz
if [ -e "$old_file" ]; then
	rm "$old_file"
fi
