# 115 Browser
## Start now
**PASSWORD**
VNC密码

***CID、SEID、UID***
115 cookie对应值，可选，为空则需要手动扫码登录

***/opt/115***
115浏览器的数据目录，可选

***/root/Downloads***
115浏览器默认下载目录

有时候115下载文件夹会直接下载到Downloads外面，并且名字是Downloads，似乎是115浏览器的BUG,可挂载上一层目录来解决这个问题

host模式下会占用1152、1150两个端口，端口映射只需要映射1150即可

***点击进入网盘页面一直刷新的，那就是Cookie过期了***
建议抓取APP的Cookie

```shell
docker run --name=115 \
-v /opt/podman/115:/opt/115 \
-v /download:/root/Downloads \
--env PASSWORD=123456 \
--env CID=xxxx \
--env SEID=xxxx \
--env UID=xxxx \
--rm --network=host -d --tmpfs /tmp \
--label io.containers.autoupdate=registry \
--env TZ=Asia/Shanghai \
docker.io/xiuxiu10201/115:latest
```
## Web
[http://localhost:1150/vnc.html](http://localhost:1150/vnc.html)
