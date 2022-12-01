FROM jrottenberg/ffmpeg:3.3-ubuntu2004
USER root

RUN apt-get update && apt-get install -y git && \
    git clone https://github.com/kvanbiesen/rtorrent-rutorrent-shared.git a && \
    cp ./a/extra.list /etc/apt/sources.list.d/extra.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y rtorrent tar gzip unzip nano cron unrar mkvtoolnix mediainfo curl php-fpm php-cli python2-minimal nginx wget supervisor php-xml libarchive-zip-perl libjson-perl libxml-libxml-perl irssi sox python3 python-is-python3 python3-pip && \
    apt autoremove -y && \
    apt clean -y && \
    pip3 install cloudscraper cfscrape pyrosimple && \
    rm -rf /var/lib/apt/lists/* && \
    cp ./a/rutorrent-*.nginx /root/ && \
    mkdir -p /var/www && \
    mkdir -p /root/.config/pyrosimple && \
    wget --no-check-certificate https://github.com/Novik/ruTorrent/archive/refs/tags/v4.0-beta3.zip && \
    unzip v4.0-beta3.zip && \
    mv ruTorrent-4.0-beta3 /var/www/rutorrent && \
    rm v4.0-beta3.zip && \
    cp ./a/config.php /var/www/rutorrent/conf/ && \
    cp ./a/startup-rtorrent.sh ./a/startup-nginx.sh ./a/startup-php.sh ./a/startup-irssi.sh ./a/.rtorrent.rc /root/ && \
    cp ./a/config.toml /root/.config/pyrosimple/ && \
    cp ./a/rpc-rtcheck.py /usr/bin/rpc-rtcheck.py && \
    cp ./a/rtcheck /usr/bin/rtcheck && \
    cp ./a/startup.sh /root/ && \
    cp ./a/cleanru.sh /downloads/ && \
    chmod +x /usr/bin/rtcheck && \
    chmod +x /usr/bin/rpc-rtcheck.py && \
    chmod +x /downloads/cleanru.sh && \
    chmod +x /root/startup.sh && \
    cp ./a/supervisord.conf /etc/supervisor/conf.d/ && \
    sed -i 's/\/var\/log/\/downloads\/\.log/g' /etc/nginx/nginx.conf


EXPOSE 80 443 49160 49161
VOLUME /downloads

ENTRYPOINT ["/usr/bin/env"]
CMD ["supervisord"]
