FROM debian:bullseye

# Install necessary packages (minimal install without recommendations)
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    cups \
    lsb-release \
    gdebi \
    tar \
    libcups2 \
    libdbus-1-3 \
    libcupsimage2 \
    curl \
    nano \
    whois \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Add the Canon TS200 driver tar.gz file to the container
COPY drivers/cnijfilter2-5.50-1-deb.tar.gz /tmp/

# Extract the tar.gz file and install the .deb packages
RUN tar -xvzf /tmp/cnijfilter2-5.50-1-deb.tar.gz -C /tmp/ \
    && dpkg -i /tmp/cnijfilter2-5.50-1-deb/packages/cnijfilter2_5.50-1_amd64.deb \
    || apt-get install -f -y \
    && rm -rf /tmp/*

# Enable the CUPS web interface and allow all connections
RUN sed -i 's|Listen localhost:631|Listen 0.0.0.0:631|' /etc/cups/cupsd.conf 
RUN sed -i 's|Order allow,deny|Order allow,deny\n  Allow all\n|' /etc/cups/cupsd.conf
# Add WebInterface Yes, DefaultAuthType Basic, DefaultEncryption IfRequested, and ServerAlias *
RUN echo "WebInterface Yes" | tee -a /etc/cups/cupsd.conf
RUN echo "DefaultAuthType Basic" | tee -a /etc/cups/cupsd.conf
RUN echo "DefaultEncryption IfRequested" | tee -a /etc/cups/cupsd.conf
RUN echo "ServerAlias *" | tee -a /etc/cups/cupsd.conf


# Expose the CUPS port
EXPOSE 631

# Copy the start.sh script into the container and make it executable
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Clean up apt cache and unnecessary files
RUN rm -rf /var/lib/apt/lists/* /tmp/*

# Ensure CUPS service starts up when the container runs
CMD ["/start.sh"]
