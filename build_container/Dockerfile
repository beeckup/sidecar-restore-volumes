FROM golang:alpine
WORKDIR /go/src/app
# install curl
RUN apk update \
    && apk add --no-cache openssl curl \
    && apk add bash \
    && apk --update add tar rsync
RUN apk add python
RUN apk add py-pip
RUN pip install awscli
COPY . .
CMD ["./restore.sh"]