#!/bin/bash

echo "Entering script..."

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

# Capture TERM signals and pass them to java and tail
receive_trap () {
	echo "Received TERM signal"

	java_pid=$(pgrep java)
	tail_pid=$(pgrep tail)

	echo "Killing java"
	kill $java_pid

	echo "Killing tail"
	kill $tail_pid

	wait $java_pid
	echo "java killed"

	wait $tail_pid
	echo "tail killed"
}
trap receive_trap TERM

# Start up Minecraft, listening to the named pipe
tail -f "$pipeFile" | java -Xms$JAVA_MEMORY_MIN -Xmx$JAVA_MEMORY_MAX -jar -Dcom.mojang.eula.agree=true paper.jar &
wait

echo "Exiting script..."
