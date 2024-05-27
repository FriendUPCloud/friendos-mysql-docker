# Use the official latest Ubuntu base image
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install required packages
RUN apt-get update && \
    apt-get install -y software-properties-common \
        curl \
        wget \
        nano \
        bash \
        mysql-client \
    apt-get clean

WORKDIR /opt/

# Copy init script
COPY ./assets/init-system.sh /usr/local/bin/

# Make the initialization script executable
RUN chmod +x /usr/local/bin/init-system.sh

# Expose port 3306
EXPOSE 3306

# Set the entry point to the initialization script
ENTRYPOINT ["/usr/local/bin/init-system.sh"]

