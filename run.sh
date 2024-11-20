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

mkdir -p "${HOME}/.vnc"
export PASSWD_PATH="${HOME}/.vnc/passwd"
echo ${PASSWORD} | vncpasswd -f > "${PASSWD_PATH}"
chmod 0600 .vnc/passwd
"${NO_VNC_HOME}"/utils/novnc_proxy --vnc localhost:6015 --listen 1150 &
echo "geometry=${DISPLAY_WIDTH}x${DISPLAY_HEIGHT}" > ~/.vnc/config
/usr/libexec/vncserver :115 &
openbox &
pcmanfm --desktop &
tint2 &
/usr/local/115Browser/115.sh