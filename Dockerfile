# Configuration
ARG JAVA_VERSION=11

# Base image
FROM openjdk:${JAVA_VERSION} AS build
