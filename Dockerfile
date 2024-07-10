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

COPY docker-entrypoint.sh /opt/docker-entrypoint.sh
RUN chmod +x /opt/docker-entrypoint.sh

# Reset DEBIAN_FRONTEND and remove policy-rc.d script
RUN unset DEBIAN_FRONTEND && rm -f /usr/sbin/policy-rc.d

# -----------------------------------------------------------------------------
# Production step
# -----------------------------------------------------------------------------
FROM base AS production

# Disable interactive prompts and policy-rc.d execution
ENV DEBIAN_FRONTEND=noninteractive
RUN echo '#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && chmod +x /usr/sbin/policy-rc.d

RUN apt update && apt install -y \
    slowhttptest

# Reset DEBIAN_FRONTEND and remove policy-rc.d script
RUN unset DEBIAN_FRONTEND && rm -f /usr/sbin/policy-rc.d

COPY ./scripts $RUNTIME_DIR/scripts

# Use JSON array syntax for ENTRYPOINT
ENTRYPOINT ["/opt/docker-entrypoint.sh"]

CMD ["$0", "$@"]
