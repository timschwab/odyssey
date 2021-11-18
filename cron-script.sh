#!/bin/bash

echo "save-off" >> /odyssey/mc.pipe
echo "save-all" >> /odyssey/mc.pipe
sleep 10

tar -czvf /odyssey/backups/snapshot-$(date +%F).tar.gz /odyssey/worlds

echo "save-on" >> /odyssey/mc.pipe

