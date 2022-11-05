FROM golang:stretch as builder

RUN set -x \
	&& go get golang.org/x/tools/cmd/goimports

FROM alpine:3.16
LABEL \
	maintainer="cytopia <cytopia@everythingcli.org>" \
	repo="https://github.com/cytopia/docker-goimports"

COPY --from=builder /go/bin/goimports /usr/local/bin/goimports
COPY data/docker-entrypoint.sh /docker-entrypoint.sh

ENV WORKDIR /data
WORKDIR /data

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["--help"]
