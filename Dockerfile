FROM debian:bookworm-slim
RUN apt update && apt upgrade -y && \
    apt install -y curl gnupg && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt install -y nodejs tor && \
    apt clean && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /var/lib/tor/hidden_service && \
    chown -R debian-tor:debian-tor /var/lib/tor/hidden_service && \
    chmod 700 /var/lib/tor/hidden_service && \
    echo "HiddenServiceDir /var/lib/tor/hidden_service/\nHiddenServicePort 80 127.0.0.1:80\n" >> /etc/tor/torrc
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY index.js start.sh ./
RUN chmod +x start.sh
EXPOSE 80
CMD ["./start.sh"]