# -----------------------------------------------------------------------------
# Base step
# -----------------------------------------------------------------------------
FROM kalilinux/kali-rolling AS base

ENV $RUNTIME_DIR="/opt/app" 

WORKDIR $RUNTIME_DIR

RUN apt update
RUN apt install -y kali-linux-headless

COPY docker-entrypoint.sh /opt/docker-entrypoint.sh
RUN chmod +x /opt/docker-entrypoint.sh


# -----------------------------------------------------------------------------
# Production step
# -----------------------------------------------------------------------------
FROM base AS production

COPY ./scripts $RUNTIME_DIR/scripts

ENTRYPOINT /opt/docker-entrypoint.sh $0 $@
