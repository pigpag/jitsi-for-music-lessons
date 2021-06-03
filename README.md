# jitsi-for-music-lessons
A shell script automating the configuration process of setting up a Jitsi Meet host with high audio quality

This script automates the steps as described in https://nicechord.com/post/jitsi-meet/

You need to first create a preconfigured Jitsi host using Linode's Marketplace.  Then, copy and paste the following line into the terminal of your Jitsi Linode host:
```
URL=https://raw.githubusercontent.com/Pigpag/jitsi-for-music-lessons/main/linode-jitsi.sh; CONTENT=$(curl -sL $URL); [ $(md5sum<<<"$CONTENT" | head -c 32) = "62f333346b4c691e29d1410131ce99ac" ] && sudo bash -c "$CONTENT"
```

Follow the prompts to finish the additional configuration.

You should run this script immediately after creating the Jitsi instance, and run only once.
