# Use the official Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Update the package lists and install required tools
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl gnupg2 && \
    rm -rf /var/lib/apt/lists/*

# Add the Tor Project repository to sources.list.d
RUN echo "deb [signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org jammy main" > /etc/apt/sources.list.d/tor.list && \
    echo "deb-src [signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org jammy main" >> /etc/apt/sources.list.d/tor.list

# Add the Tor Project GPG key
RUN curl -s https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --dearmor -o /usr/share/keyrings/tor-archive-keyring.gpg

# Update the package lists again and install Tor
RUN apt-get update && \
    apt-get install -y tor deb.torproject.org-keyring && \
    rm -rf /var/lib/apt/lists/*

# Expose the Tor SOCKS proxy port (optional)
EXPOSE 9050

# Add the SocksPort configuration directly to /etc/tor/torrc
RUN echo "SocksPort 0.0.0.0:9050" >> /etc/tor/torrc

# Start Tor when the container runs
CMD ["tor"]
