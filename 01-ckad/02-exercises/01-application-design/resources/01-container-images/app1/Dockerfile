# Build stage
FROM golang:1.21 AS builder

WORKDIR /app
COPY main.go ./
RUN go build -o webserver main.go

# Final stage
FROM gcr.io/distroless/static

COPY --from=builder /app/webserver /webserver
EXPOSE 8080
ENTRYPOINT ["/webserver"]
