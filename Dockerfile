FROM golang:1.25-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o much-to-do ./cmd/api

# Run Stage
FROM alpine:3.18 AS runner

RUN apk --no-cache add ca-certificates

WORKDIR /app

RUN addgroup -g 1000 appuser && \
    adduser -u 1000 -G appuser -D appuser

COPY --from=builder /app/much-to-do /app/much-to-do
COPY --from=builder /app/.env .env

USER appuser

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget -q -O /dev/null http://localhost:8080/health || exit 1

CMD ["/app/much-to-do"]