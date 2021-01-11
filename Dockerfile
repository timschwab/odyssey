# Base image
FROM openjdk:11

# Set working directory
WORKDIR /odyssey

##### DOWNLOADS #####

# Paper
ARG PAPER_VERSION=1.16.4
RUN wget https://papermc.io/api/v1/paper/${PAPER_VERSION}/latest/download -O paper.jar

# Make plugins folder
RUN mkdir plugins

# Multiverse Core
ARG MV_CORE_URL=https://media.forgecdn.net/files/3074/594/Multiverse-Core-4.2.2.jar
RUN wget ${MV_CORE_URL} -O plugins/Multiverse-Core

# Multiverse Portals
# Multiverse NetherPortals
# Multiverse Inventories
# World Edit
# Dynmap

# Copy in paper configs
COPY paper-configs/* ./

# Copy in plugin configs
COPY plugin-configs/**/* plugins/

# Link world data
VOLUME ["/odyssey/worlds"]

# Open ports
EXPOSE 80 433 25565

# Set startup script
COPY run.sh ./
ENTRYPOINT ["./run.sh"]
