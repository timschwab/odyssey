##### BASIC SETUP #####

# Base image
FROM openjdk:17-buster

# Set working directory
WORKDIR /odyssey

# Install software
RUN apt-get update && apt-get --yes install cron sudo
RUN wget "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -O "awscliv2.zip" && \
	unzip awscliv2.zip -d /tmp && \
	/tmp/aws/install && \
	rm -rf /tmp/aws

# Make plugins folder
RUN mkdir plugins

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

# Open ports
EXPOSE 8123 25565

##### DOWNLOADS #####

# Paper
ARG PAPER_VERSION=1.18.1
ARG PAPER_BUILD=215
ARG PAPER_ENDPOINT=${PAPER_VERSION}/builds/${PAPER_BUILD}/downloads/paper-${PAPER_VERSION}-${PAPER_BUILD}.jar
RUN wget https://papermc.io/api/v2/projects/paper/versions/${PAPER_ENDPOINT} -O paper.jar

# Multiverse Core 4.3.1
ARG MV_CORE_URL=https://media.forgecdn.net/files/3462/546/Multiverse-Core-4.3.1.jar
RUN wget ${MV_CORE_URL} -O plugins/Multiverse-Core.jar

# Multiverse Portals 4.2.1
ARG MV_PORTALS_URL=https://media.forgecdn.net/files/3113/114/Multiverse-Portals-4.2.1.jar
RUN wget ${MV_PORTALS_URL} -O plugins/Multiverse-Portals.jar

# Multiverse NetherPortals 4.2.1
ARG MV_NETHER_PORTALS_URL=https://media.forgecdn.net/files/3074/616/Multiverse-NetherPortals-4.2.1.jar
RUN wget ${MV_NETHER_PORTALS_URL} -O plugins/Multiverse-NetherPortals.jar

# Multiverse Inventories 4.2.2
ARG MV_INVENTORIES_URL=https://media.forgecdn.net/files/3222/929/Multiverse-Inventories-4.2.2.jar
RUN wget ${MV_INVENTORIES_URL} -O plugins/Multiverse-Inventories.jar

# Dynmap
ARG DYNMAP_URL=https://media.forgecdn.net/files/3637/280/Dynmap-3.3.2-spigot.jar
RUN wget ${DYNMAP_URL} -O plugins/dynmap.jar

# World Edit
# TODO

# VoidGen 2.2. It is hosted on spigotmc.org rather than forgecdn.net, and I can't get around Cloudflare there.
COPY plugin-configs/VoidGen-2.2.1.jar plugins/VoidGen.jar

##### FILES/FINISHING #####

# Install cron then set up crontab
COPY crontab /etc/crontab

# Copy in startup script and cron script
COPY run.sh ./
COPY cron-script.sh ./
RUN chmod +x run.sh && chmod +x cron-script.sh

# Record S3 bucket name for the cron-script
ARG s3_bucket=odyssey-minecraft-prod
RUN echo ${s3_bucket} > s3_bucket

# Create the user
ARG username=worker
RUN useradd -m ${username} && \
	chown -R ${username}:${username} . && \
	usermod -aG sudo ${username} && \
	echo "${username} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Run as the user
USER ${username}

# Initial command
CMD ["./run.sh"]
