#!/bin/bash

# Start up cron
sudo service cron start

# Start up Minecraft
tail -f mc.pipe | exec java -Xms$JAVA_MEMORY_MIN -Xmx$JAVA_MEMORY_MAX -jar -Dcom.mojang.eula.agree=true paper.jar
