#!/bin/bash
exec java -Xms$JAVA_MEMORY -Xmx$JAVA_MEMORY -jar -Dcom.mojang.eula.agree=true paper.jar
