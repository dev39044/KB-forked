FROM alpine:latest
RUN apk update && apk --no-cache add dnsmasq
USER guest
ENTRYPOINT ["dnsmasq", "-k"]
