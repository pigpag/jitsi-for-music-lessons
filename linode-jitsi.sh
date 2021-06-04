#!/bin/bash

# This script sets up a Jitsi Meet server for high audio quality sessions suitable for online music lessons.
# It automates the configuration process as described in https://nicechord.com/post/jitsi-meet/
# Special thanks to Wiwi Kuan for sharing his setup
#
# This script is tested based on the Jitsi server provided in Linode Marketplace.
# You may need a Linode account with Jitsi preinstalled.
# Please consider supporting the script's author by signing up at Linode via referral url https://www.linode.com/?r=a1bd5a1e26970d45a722cb8fe7b7480c1393bca0

# Ensure script is run with sudo
if [ "$EUID" -ne 0 ]; then
    echo "error: this script must be run with sudo privilege"
    exit -1
fi

# Read user account and password first
read -p "Enter your Jitsi admin user name (default 'admin'): " JITSI_USER
if [ -z "$JITSI_USER" ]; then
    JITSI_USER="admin"
fi

if [[ ! "$JITSI_USER" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
    echo "error: invalid user name '$JITSI_USER'"
    exit -1
fi

read -s -p "Enter password for '$JITSI_USER': " JITSI_PASSWD
echo
read -s -p "Re-enter password to confirm: " JITSI_PASSWD_RE
echo

if [ "$JITSI_PASSWD" != "$JITSI_PASSWD_RE" ]; then
    echo "error: password do not match"
    exit -1
fi
if [ -z "$JITSI_PASSWD" ]; then
    echo "error: password must not be empty"
    exit -1
fi

HOST=$(hostname --fqdn)
GUEST_HOST=guest.$HOST

# Change config files
HOST_CONFIG_FILE="/etc/prosody/conf.avail/$HOST.cfg.lua"
if [ ! -f "$HOST_CONFIG_FILE" ]; then
    echo "error: $HOST_CONFIG_FILE not found."
    exit -1
fi

/usr/bin/sed -i s/anonymous/internal_hashed/ "$HOST_CONFIG_FILE"
/usr/bin/sed -i '/muc_lobby_whitelist.*$/a\\n\nVirtualHost "guest.$HOST"\n    authentication = "anonymous"\n    c2s_require_encryption = false' "$HOST_CONFIG_FILE"

JS_CONFIG_FILE="/etc/jitsi/meet/$HOST-config.js"
if [ ! -f "$JS_CONFIG_FILE" ]; then
    echo "error: $JS_CONFIG_FILE not found."
    exit -1
fi

/usr/bin/sed -i "s|// anonymousdomain:.*$|anonymousdomain: '$GUEST_HOST',|" "$JS_CONFIG_FILE"
/usr/bin/sed -i "s/enableNoisyMicDetection: true,/enableNoisyMicDetection: false,/" "$JS_CONFIG_FILE"
/usr/bin/sed -i "s|// audioQuality|audioQuality|" "$JS_CONFIG_FILE"
/usr/bin/sed -i "s|//     stereo:|    stereo:|" "$JS_CONFIG_FILE"
/usr/bin/sed -i "s|//     opusMaxAverageBitrate: null|    opusMaxAverageBitrate: 128000|" "$JS_CONFIG_FILE"
/usr/bin/sed -i '/opusMaxAverageBitrate:.*$/!b;n;c\    },' "$JS_CONFIG_FILE"

SIP_CONFIG_FILE="/etc/jitsi/jicofo/sip-communicator.properties"
if [ ! -f "$SIP_CONFIG_FILE" ]; then
    echo "error: $SIP_CONFIG_FILE not found."
    exit -1
fi

echo "org.jitsi.jicofo.auth.URL=XMPP:$HOST" >> "$SIP_CONFIG_FILE"

# Setup jitsi account
/usr/bin/prosodyctl register "$JITSI_USER" "$HOST" "$JITSI_PASSWD"

# Restart services
/usr/bin/systemctl restart prosody
/usr/bin/systemctl restart jicofo
/usr/bin/systemctl restart jitsi-videobridge2

echo "Congratulations!  Your Jitsi Meet host has been configured."
echo "Your Jitsi Meet address is https://$HOST/"
