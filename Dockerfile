FROM debian:stable-slim AS base
ENV LANG=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8 \
    DEBIAN_FRONTEND=noninteractive
RUN apt update \
    && apt install --no-install-recommends -y ca-certificates x11-xkb-utils xkbset wget curl unzip locales fonts-noto-cjk \
    && locale-gen zh_CN.UTF-8 \
    && echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

FROM base AS desktop
ENV G_SLICE=always-malloc
RUN apt install --no-install-recommends -y pcmanfm tint2 openbox xauth xinit

FROM desktop AS tigervnc
RUN wget --no-check-certificate -qO- https://sourceforge.net/projects/tigervnc/files/stable/1.15.0/tigervnc-1.15.0.x86_64.tar.gz | tar xz --strip 1 -C /


FROM tigervnc AS novnc
ENV NO_VNC_HOME=/usr/share/usr/local/share/noVNCdim
RUN apt install --no-install-recommends -y python3-numpy libxshmfence1 libasound2 libxcvt0 libgbm1 \
    && mkdir -p "${NO_VNC_HOME}/utils/websockify" \
    && wget --no-check-certificate -qO- "https://github.com/novnc/noVNC/archive/v1.6.0.tar.gz" | tar xz --strip 1 -C "${NO_VNC_HOME}" \
    && wget --no-check-certificate -qO- "https://github.com/novnc/websockify/archive/v0.13.0.tar.gz" | tar xz --strip 1 -C "${NO_VNC_HOME}/utils/websockify" \
    && chmod +x -v "${NO_VNC_HOME}/utils/novnc_proxy" \
    && sed -i '1s/^/if(localStorage.getItem("resize") == null){localStorage.setItem("resize","remote");}\n/' "${NO_VNC_HOME}/app/ui.js" \
    && rm -rf /usr/share/doc /usr/share/man

FROM novnc AS oneonefive
ENV \
    XDG_CONFIG_HOME=/tmp \
    XDG_CACHE_HOME=/tmp \
    HOME=/opt \
    DISPLAY=:115 \
    LD_LIBRARY_PATH=/usr/local/115Browser:\$LD_LIBRARY_PATH
RUN apt install -y --no-install-recommends libnss3 libgbm1 \
    && wget -q --no-check-certificate https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-linux-amd64 -O /usr/bin/jq \
    && chmod +x /usr/bin/jq \
    && export VERSION=`curl -k -s https://appversion.115.com/1/web/1.0/api/getMultiVer | jq '.data["Linux-115chrome"].version_code'  | tr -d '"'` \
    && wget -q --no-check-certificate "https://down.115.com/client/115pc/lin/115br_v${VERSION}.deb" -O /tmp/tmp.deb \
    && apt install /tmp/tmp.deb  \
    && rm /tmp/tmp.deb \
    && wget --no-check-certificate -q https://github.com/dream10201/115Cookie/archive/refs/heads/master.zip -O /tmp/tmp.zip \
    && unzip -j /tmp/tmp.zip -d /usr/local/115Cookie/ \
    && rm /tmp/tmp.zip \
    && mkdir -p /opt/Desktop \
    && ln -s /usr/share/applications/115Browser.desktop /opt/Desktop \
    && ln -s /usr/share/applications/pcmanfm.desktop /opt/Desktop \
    && chmod 777 -R /opt \
    && mkdir -p /etc/115 \
    && chmod 777 -R /etc/115 \
    && echo "cd /usr/local/115Browser" > /usr/local/115Browser/115.sh \
    && echo "/usr/local/115Browser/115Browser \
    --test-type \
    --disable-backgrounding-occluded-windows \
    --user-data-dir=/etc/115 \
    --disable-cache \
    --load-extension=/usr/local/115Cookie \
    --disable-wav-audio \
    --disable-logging \
    --disable-notifications \
    --no-default-browser-check \
    --disable-background-networking \
    --enable-features=ParallelDownloading \
    --start-maximized \
    --no-sandbox \
    --disable-vulkan \
    --disable-gpu \
    --ignore-certificate-errors \
    --disable-bundled-plugins \
    --disable-dev-shm-usage \
    --reduce-user-agent-sniffing \
    --no-first-run \
    --disable-breakpad \
    --disable-gpu-process-crash-limit \
    --enable-low-res-tiling \
    --disable-heap-profiling \
    --disable-features=IsolateOrigins,site-per-process \
    --disable-smooth-scrolling \
    --lang=zh-CN \
    --disable-software-rasterizer \
    >/tmp/115Browser.log 2>&1 &" >> /usr/local/115Browser/115.sh \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

FROM oneonefive
EXPOSE 1150
COPY run.sh /opt/run.sh
CMD ["bash","/opt/run.sh"]
