# -----------------------------------------------------------------------------
# Base step
# -----------------------------------------------------------------------------
FROM kalilinux/kali-rolling AS base

RUN mkdir -p /opt/app

ENV RUNTIME_DIR="/opt/app"

# Disable interactive prompts and policy-rc.d execution
ENV DEBIAN_FRONTEND=noninteractive
RUN echo '#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && chmod +x /usr/sbin/policy-rc.d


WORKDIR $RUNTIME_DIR

RUN apt update && apt install -y \
    python3 \
    g++ \
    libpython3-dev \
    smbclient \
    gcc \
    apache2 \
    qt6-base-dev-tools \
    php-mysql \
    kali-linux-headless

RUN wget https://go.dev/dl/go1.22.5.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.22.5.linux-amd64.tar.gz
RUN rm -f go1.22.5.linux-amd64.tar.gz
RUN echo "PATH=$PATH:/usr/local/go/bin" >> /root/.profile

RUN apt update && apt install -y \
    slowhttptest \
    thc-ssl-dos \
    siege \
    tor \
    supervisor

RUN cp /etc/tor/torrc /etc/tor/torrc.bak
RUN sed -i 's/^# *\(SocksPort 9050\)/\1/' /etc/tor/torrc

RUN mkdir -p /etc/supervisor/conf.d

# Add the tor.conf for
RUN cat <<EOF > /etc/supervisor/conf.d/tor.conf
[program:tor]
command=/usr/bin/tor
autostart=false
autorestart=false
stdout_logfile=/var/log/tor.out
stderr_logfile=/var/log/tor.err
EOF

# Add the main supervisord configuration file
RUN cat <<EOF > /etc/supervisor/supervisord.conf
[supervisord]
logfile=/var/log/supervisord.log
pidfile=/var/run/supervisord.pid
childlogdir=/var/log/supervisord

[unix_http_server]
file=/var/run/supervisord.sock   ; the path to the socket file
chmod=0700

[supervisorctl]
serverurl=unix:///var/run/supervisord.sock ; use a local Unix socket

[include]
files = /etc/supervisor/conf.d/*.conf
EOF

#Create supervisord log directory
RUN mkdir -p /var/log/supervisord

# Expose the default Tor port
EXPOSE 9050

COPY docker-entrypoint.sh /opt/docker-entrypoint.sh
RUN chmod +x /opt/docker-entrypoint.sh

# Reset DEBIAN_FRONTEND and remove policy-rc.d script
RUN unset DEBIAN_FRONTEND && rm -f /usr/sbin/policy-rc.d

# -----------------------------------------------------------------------------
# Production step
# -----------------------------------------------------------------------------
FROM base AS production

COPY ./scripts $RUNTIME_DIR/scripts

# # Use JSON array syntax for ENTRYPOINT
ENTRYPOINT ["/opt/docker-entrypoint.sh"]

# CMD ["$0", "$@"]

# Set supervisord as the entrypoint
# ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]

# Start supervisord as the main process
CMD ["supervisorctl", "status"]
# CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]