# Base image
FROM openjdk:11

# Set working directory
WORKDIR /odyssey

##### DOWNLOADS #####

# Paper
ARG PAPER_VERSION=1.16.5
ARG PAPER_BUILD=483
ARG PAPER_ENDPOINT=${PAPER_VERSION}/builds/${PAPER_BUILD}/downloads/paper-${PAPER_VERSION}-${PAPER_BUILD}.jar
RUN wget https://papermc.io/api/v2/projects/paper/versions/${PAPER_ENDPOINT} -O paper.jar

# Make plugins folder
RUN mkdir plugins

# Multiverse Core 4.2.2
ARG MV_CORE_URL=https://media.forgecdn.net/files/3074/594/Multiverse-Core-4.2.2.jar
RUN wget ${MV_CORE_URL} -O plugins/Multiverse-Core.jar

# Multiverse Portals 4.2.1
ARG MV_PORTALS_URL=https://media.forgecdn.net/files/3113/114/Multiverse-Portals-4.2.1.jar
RUN wget ${MV_PORTALS_URL} -O plugins/Multiverse-Portals.jar

# Multiverse NetherPortals 4.2.1
ARG MV_NETHER_PORTALS_URL=https://media.forgecdn.net/files/3074/616/Multiverse-NetherPortals-4.2.1.jar
RUN wget ${MV_NETHER_PORTALS_URL} -O plugins/Multiverse-NetherPortals.jar

# Multiverse Inventories 4.2.1
ARG MV_INVENTORIES_URL=https://media.forgecdn.net/files/3074/607/Multiverse-Inventories-4.2.1.jar
RUN wget ${MV_INVENTORIES_URL} -O plugins/Multiverse-Inventories.jar

# Dynmap
ARG DYNMAP_URL=https://dev.bukkit.org/projects/dynmap/files/3197686/download
RUN  wget ${DYNMAP_URL} -O plugins/dynmap.jar

# World Edit

# Set up symlinks for the paper config files. Lame but necessary.
RUN ln -s configs/server.properties server.properties && \
	ln -s configs/ops.json ops.json && \
	ln -s configs/whitelist.json whitelist.json && \
	ln -s configs/banned-players.json banned-players.json && \
	ln -s configs/banned-ips.json banned-ips.json && \
	ln -s configs/permissions.yml permissions.yml && \
	ln -s configs/bukkit.yml bukkit.yml && \
	ln -s configs/spigot.hml spigot.hml && \
	ln -s configs/paper.yml paper.yml

# Copy in startup script
COPY run.sh ./
RUN chmod +x run.sh

# Open ports
EXPOSE 80 433 25565

# Run as me for convenience
RUN useradd pyzaist && chown -R pyzaist .
USER pyzaist

# Initial command
CMD ["./run.sh"]
