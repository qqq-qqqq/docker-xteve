FROM alpine:3.16

RUN apk update \
 && apk add --no-cache \
    ca-certificates \
    bash \
    busybox-suid \
    su-exec \
    ffmpeg4 \
    vlc \
    wget \
    unzip \
 && sed -i 's/geteuid/getppid/' /usr/bin/vlc \
 && case "$TARGETARCH" in \
    "amd64") ARCH="amd64" ;; \
    "arm64") ARCH="arm64" ;; \
    *) echo "unsupported arch $TARGETARCH" && exit 1 ;; \
    esac \
 && wget -O /tmp/xteve.zip https://github.com/xteve-project/xTeVe-Downloads/raw/master/xteve_linux_${ARCH}.zip \
 && unzip /tmp/xteve.zip -d /usr/bin/ \
 && rm /tmp/xteve.zip \
 && chmod +x /usr/bin/xteve \
 && apk del unzip \
 && rm -rf /var/cache/apk

COPY cronjob.sh /cronjob.sh
COPY entrypoint.sh /entrypoint.sh
COPY sample_cron.txt /sample_cron.txt
COPY sample_xteve.txt /sample_xteve.txt

RUN chmod +x /entrypoint.sh /cronjob.sh

VOLUME ["/config"]

EXPOSE 34400

ENTRYPOINT ["/entrypoint.sh"]
