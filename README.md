# jitsi-for-music-lessons
A shell script automating the configuration of Jitsi Meet hosts with password protection and high audio quality

This script automates the steps as described in https://nicechord.com/post/jitsi-meet/

You need to first create a preconfigured Jitsi host using Linode's Marketplace.  Then, copy and paste the following line into the terminal of your Jitsi Linode host:
```
URL=https://raw.githubusercontent.com/pigpag/jitsi-for-music-lessons/main/linode-jitsi.sh; CONTENT=$(curl -sL $URL); [ $(md5sum<<<"$CONTENT" | head -c 32) = "68b329da9893e34099c7d8ad5cb9c940" ] && sudo bash -c "$CONTENT"
```

Follow the prompts to finish the additional configuration.

You should run this script immediately after creating the Jitsi instance, and run only once.
