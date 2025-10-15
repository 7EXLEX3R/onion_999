#!/bin/bash
set -e
echo "🧅 starting Tor..."
su debian-tor -s /bin/bash -c "tor -f /etc/tor/torrc > /var/lib/tor/tor.log 2>&1 &"
echo "⌛ waiting for Tor to create onion hostname..."
while [ ! -f /var/lib/tor/hidden_service/hostname ]; do
    sleep 1
done
ONION=$(cat /var/lib/tor/hidden_service/hostname)
echo "👁️ your Tor hidden service is live!"
echo "🌐 onion URL: http://$ONION"
echo "⚡ starting Node.js app..."
exec npm start