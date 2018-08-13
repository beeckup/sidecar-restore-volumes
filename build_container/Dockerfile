FROM golang:alpine
WORKDIR /go/src/app
# install curl
RUN apk update \
    && apk add --no-cache openssl curl \
    && apk add bash
COPY . .
CMD ["./restore.sh"]