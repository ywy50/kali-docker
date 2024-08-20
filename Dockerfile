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


COPY docker-entrypoint.sh /opt/docker-entrypoint.sh
RUN chmod +x /opt/docker-entrypoint.sh

# Reset DEBIAN_FRONTEND and remove policy-rc.d script
RUN unset DEBIAN_FRONTEND && rm -f /usr/sbin/policy-rc.d

# -----------------------------------------------------------------------------
# Production step
# -----------------------------------------------------------------------------
FROM base AS production

COPY ./scripts $RUNTIME_DIR/scripts

# Use JSON array syntax for ENTRYPOINT
ENTRYPOINT ["/opt/docker-entrypoint.sh"]

CMD ["$0", "$@"]
