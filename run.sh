#!/bin/bash
sed -i "s/const CID=\"\"/const CID=\"${CID}\"/" /usr/local/115Cookie/worker.js
sed -i "s/const SEID=\"\"/const SEID=\"${SEID}\"/" /usr/local/115Cookie/worker.js
sed -i "s/const UID=\"\"/const UID=\"${UID}\"/" /usr/local/115Cookie/worker.js
if [ -z "${DISPLAY_WIDTH}" ]; then
    DISPLAY_WIDTH=1366
fi
if [ -z "${DISPLAY_HEIGHT}" ]; then
    DISPLAY_HEIGHT=768
fi
Xvfb :115 -screen 0 ${DISPLAY_WIDTH}x${DISPLAY_HEIGHT}x16 &
export DISPLAY=:115
/usr/libexec/dconf-service &
openbox &
pcmanfm --desktop &
tint2 &
x11vnc -display :115 -passwd ${PASSWORD} -listen 127.0.0.1 -nopw -forever -rfbport 1152 &
sleep 3
/usr/local/115Browser/115.sh
websockify --web /usr/share/novnc 1150 localhost:1152