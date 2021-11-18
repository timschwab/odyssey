#!/bin/bash

# Start up cron
sudo service cron start

# Set defaults if environment variables are not set
JAVA_MEMORY_MIN=${JAVA_MEMORY_MIN:-1G}
JAVA_MEMORY_MAX=${JAVA_MEMORY_MAX:-4G}

# Start up Minecraft
tail -f mc.pipe | exec java -Xms$JAVA_MEMORY_MIN -Xmx$JAVA_MEMORY_MAX -jar -Dcom.mojang.eula.agree=true paper.jar
