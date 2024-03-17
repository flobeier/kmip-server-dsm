FROM python:3.11-alpine3.19

RUN apk add --no-cache \
    openssl-dev libffi-dev musl-dev gcc rust cargo && \
    pip wheel --no-deps --wheel-dir=/wheel pykmip cffi cryptography && \

FROM python:3.11-alpine3.19

COPY --from=0 /wheel /wheel

RUN apk add --no-cache openssl && \
    pip install --no-cache-dir /wheel/*

RUN mkdir -p /etc/pykmip \
    mkdir -p /etc/pykmip/policy \
    mkdir -p /var/lib/certs \
    mkdir -p /var/lib/state

COPY assets/server.conf /etc/pykmip

COPY assets/policy.json /etc/pykmip/policy

COPY config.sh /etc/pykmip

COPY --chmod=755 assets/init.sh /bin/init.sh

EXPOSE 5696

ENTRYPOINT /bin/init.sh
