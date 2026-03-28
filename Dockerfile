FROM alpine:3.22

ENV TZ=Europe/Berlin

RUN apk add --no-cache \
    ca-certificates \
    curl \
    tzdata \
    bash \
    busybox-suid \
    su-exec \
    ffmpeg \
    vlc \
    wget \
    unzip \
 && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
 && echo $TZ > /etc/timezone \
 && sed -i 's/geteuid/getppid/' /usr/bin/vlc

RUN if [ "$TARGETARCH" = "arm64" ]; then \
      ARCH="arm64"; \
    else \
      ARCH="amd64"; \
    fi \
 && wget -O /tmp/xteve.zip https://github.com/xteve-project/xTeVe-Downloads/raw/master/xteve_linux_${ARCH}.zip \
 && unzip /tmp/xteve.zip -d /usr/bin/ \
 && rm /tmp/xteve.zip \
 && chmod +x /usr/bin/xteve

COPY cronjob.sh /cronjob.sh
COPY entrypoint.sh /entrypoint.sh
COPY sample_cron.txt /sample_cron.txt
COPY sample_xteve.txt /sample_xteve.txt

RUN chmod +x /entrypoint.sh /cronjob.sh

VOLUME ["/config"]

EXPOSE 34400

ENTRYPOINT ["/entrypoint.sh"]
