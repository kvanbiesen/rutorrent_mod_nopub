FROM jrottenberg/ffmpeg:3.3-ubuntu2004
USER root

RUN apt-get update && apt-get install -y git && \
    git clone https://github.com/kvanbiesen/rtorrent-rutorrent-shared.git a && \
    cp ./a/extra.list /etc/apt/sources.list.d/extra.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y rtorrent tar gzip unzip unrar mediainfo curl php-fpm php-cli nginx wget supervisor php-xml libarchive-zip-perl libjson-perl libxml-libxml-perl irssi sox python3 python-is-python3 python3-pip && \
    apt autoremove -y && \
    apt clean -y && \
    python --version && \
    pip3 install cloudscraper cfscrape pyrosimple && \
    rm -rf /var/lib/apt/lists/* && \
    cp ./a/rutorrent-*.nginx /root/ && \
    mkdir -p /var/www && \
    wget --no-check-certificate https://github.com/Novik/ruTorrent/archive/v3.9.tar.gz && \
    tar xzf v3.9.tar.gz && \
    mv ruTorrent-3.9 /var/www/rutorrent && \
    rm v3.9.tar.gz && \
    cp ./a/config.php /var/www/rutorrent/conf/ && \
    cp ./a/startup-rtorrent.sh ./a/startup-nginx.sh ./a/startup-php.sh ./a/startup-irssi.sh ./a/.rtorrent.rc /root/ && \
    cp ./a/supervisord.conf /etc/supervisor/conf.d/ && \
    sed -i 's/\/var\/log/\/downloads\/\.log/g' /etc/nginx/nginx.conf


EXPOSE 80 443 49160 49161
VOLUME /downloads

ENTRYPOINT ["/usr/bin/env"]
CMD ["supervisord"]
