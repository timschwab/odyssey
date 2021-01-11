# Configuration
ARG JAVA_VERSION=11
ARG PAPER_VERSION=1.16.4

# Base image
FROM openjdk:${JAVA_VERSION} AS build

# Set working directory
WORKDIR /odyssey

# Pull down Paper
ADD https://papermc.io/api/v1/paper/${PAPER_VERSION}/latest/download paper.jar

# Copy in paper configs
COPY paper-configs/* .

# Pull down each plugin
ADD https://dev.bukkit.org/projects/multiverse-core/files/latest plugins/Multiverse-Core
ADD https://dev.bukkit.org/projects/multiverse-portals/files/latest plugins/Multiverse-Portals
ADD https://dev.bukkit.org/projects/multiverse-netherportals/files/latest plugins/Multiverse-NetherPortals
#ADD https://dev.bukkit.org/projects/multiverse-inventories/files/latest plugins/Multiverse-Inventories

#ADD world edit
#ADD Vanilla Tweaks
#ADD Dynmap

# Copy in plugin configs
COPY plugin-configs/**/* plugins

# Link world data

# Open ports
EXPOSE 25565

# Set startup script
COPY run.sh .
ENTRYPOINT ["./run.sh"]
