#!/bin/bash

# Start up cron
sudo service cron start

# Create the named pipe and get it going
pipeFile=mc.pipe
if [ ! -p "$pipeFile" ]; then
    mkfifo "$pipeFile"
fi

# Set defaults if environment variables are not set
JAVA_MEMORY_MIN=${JAVA_MEMORY_MIN:-1G}
JAVA_MEMORY_MAX=${JAVA_MEMORY_MAX:-4G}

# Capture all signals and pass them to java and tail
pass_trap() {
	pkill "-$sig" java
	pkill "-$sig" tail
}

for sig in {1..64} ; do
	trap "pass_trap $sig" $sig
done

# Start up Minecraft, listening to the named pipe
tail -f "$pipeFile" | java -Xms$JAVA_MEMORY_MIN -Xmx$JAVA_MEMORY_MAX -jar -Dcom.mojang.eula.agree=true paper.jar
