#!/bin/bash
exec java -Xms$JAVA_MEMORY_MIN -Xmx$JAVA_MEMORY_MAX -jar -Dcom.mojang.eula.agree=true paper.jar
