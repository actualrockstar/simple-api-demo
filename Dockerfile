FROM golang:1.19 AS build
WORKDIR /go/src
COPY go ./go
COPY main.go .
COPY go.sum .
COPY go.mod .

ENV CGO_ENABLED=0

RUN go build -o simple_api .

FROM scratch AS runtime
COPY --from=build /go/src/simple_api ./
EXPOSE 80/tcp
USER 1001
ENTRYPOINT ["./simple_api"]
