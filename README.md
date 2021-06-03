# jitsi-for-music-lessons
A shell script automating the configuration process of setting up a Jitsi Meet host with high audio quality

To run this script, copy and paste the following line into your terminal:
```
URL=https://raw.githubusercontent.com/Pigpag/jitsi-for-music-lessons/7283626befe9164566d790d967c3caa410dcb849/linode-jitsi.sh; [ $(curl -sL "$URL" | md5sum | head -c 32) = "62f333346b4c691e29d1410131ce99ac" ] && sudo bash -c "$(curl -sL $URL)"
```
