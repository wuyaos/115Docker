FROM debian:latest
EXPOSE 1150
COPY run.sh /run.sh
WORKDIR /usr/local/115Browser
RUN apt update && \
    apt install -y wget curl unzip && \
    # 中文字体
    apt install -y locales fonts-noto-cjk fonts-wqy-microhei && \ 
    # 115 依赖
    apt install -y libnss3 libasound2 libgbm1 && \
    # 文件管理和状态栏
    apt install -y pcmanfm tint2 && \
    # VNC
    apt install -y xvfb x11vnc openbox novnc websockify && \
    apt install -y ibus ibus-pinyin && \
    # libatk1.0-0 libnss3 libatk-bridge2.0-0 libgbm1 libxkbcommon0 libasound2 locales fonts-noto-cjk fonts-wqy-microhei unzip pcmanfm tint2&& \
    wget -q --no-check-certificate -c https://github.com/dream10201/115Cookie/archive/refs/heads/master.zip && \
    unzip -j master.zip -d /usr/local/115Cookie/ && \
    rm master.zip && \
    wget -q --no-check-certificate -c https://down.115.com/client/115pc/lin/115br_v27.0.6.9.deb && \
    apt install ./115br_v27.0.6.9.deb && \
    rm 115br_v27.0.6.9.deb && \
    apt clean -y && \
    apt autoclean -y && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /opt/115 && \
    echo "zh_CN.UTF-8 UTF-8" >/etc/locale.gen && \
    echo "LANG=zh_CN.UTF-8">> /etc/default/locale && \
    echo "LC_ALL=zh_CN.UTF-8">> /etc/default/locale && \
    echo "export LANG=zh_CN.UTF-8" >>/etc/profile && \
    echo "export LC_ALL=zh_CN.UTF-8" >>/etc/profile && \
    echo "export DISPLAY=:115" >>/etc/profile && \
    echo "export LANG=zh_CN.UTF-8" >>/root/.bashrc && \
    echo "export LC_ALL=zh_CN.UTF-8" >>/root/.bashrc && \
    echo "export DISPLAY=:115" >>/root/.bashrc && \
    locale-gen zh_CN.UTF-8 && \
    mkdir -p ~/Desktop && \
    cp /usr/share/applications/115Browser.desktop ~/Desktop && \
    cp /usr/share/applications/pcmanfm.desktop ~/Desktop && \
    update-locale LANG=zh_CN.UTF-8 && \
    chmod +x /run.sh && \
    echo "export LD_LIBRARY_PATH=/usr/local/115Browser:\$LD_LIBRARY_PATH" > /usr/local/115Browser/115.sh && \
    echo "cd /usr/local/115Browser" >> /usr/local/115Browser/115.sh && \
    echo "export LANG=zh_CN.UTF-8" >>/usr/local/115Browser/115.sh && \
    echo "export LC_ALL=zh_CN.UTF-8" >>/usr/local/115Browser/115.sh && \
    echo "export DISPLAY=:115" >>/usr/local/115Browser/115.sh && \
    echo "/usr/local/115Browser/115Browser \
    --disable-backgrounding-occluded-windows \
    --user-data-dir=/opt/115 \
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
    >/dev/null 2>&1 &" >> /usr/local/115Browser/115.sh
CMD ["/run.sh"]