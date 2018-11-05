FROM alpine:3.8

LABEL maintainer="Mark <mark.binlab@gmail.com>"

RUN addgroup -S socat \
    && adduser -S -D -H -s /bin/false -g "Socat Service" -G socat socat \
    && set -x \
    && apk add --no-cache socat

USER socat
EXPOSE 2375

ENTRYPOINT ["socat"]
CMD ["TCP-LISTEN:2375,reuseaddr,fork", "UNIX-CLIENT:/var/run/docker.sock"]

