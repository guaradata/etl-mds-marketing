FROM alpine:latest

EXPOSE 8080

WORKDIR /app

RUN apk update && \
    apk add bash openrc nginx && \
    mkdir -p /run/openrc && \
    touch /run/openrc/softlevel && \
    rc-status && \
    rc-update add nginx && \
    rm -rf /var/cache/apk/*

CMD ["nginx", "-g", "daemon off;"]
