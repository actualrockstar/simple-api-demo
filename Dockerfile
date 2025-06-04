FROM golang:1.23 AS base

RUN go install github.com/go-delve/delve/cmd/dlv@latest

WORKDIR /go/src
COPY go ./go
COPY main.go .
COPY go.sum .
COPY go.mod .

ENV CGO_ENABLED=0

FROM base AS debug

RUN go build -gcflags="all=-N -l" -o simple_api .
ENV DEBUG_PORT=2345
EXPOSE $DEBUG_PORT
ENTRYPOINT /go/bin/dlv --listen=:$DEBUG_PORT --headless=true --api-version=2 --accept-multiclient exec simple_api

FROM base AS run

RUN go build -o simple_api .
EXPOSE 80/tcp
USER 1001
ENTRYPOINT ["./simple_api"]
