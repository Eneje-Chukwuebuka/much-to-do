# ─── Build Stage ───────────────────────────────────────────────────
FROM golang:1.25-alpine AS builder

WORKDIR /app

# Install swag for generating docs
RUN go install github.com/swaggo/swag/cmd/swag@latest

# Copy go mod files and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY . .

# Generate swagger docs
RUN swag init -g ./cmd/api/main.go -o ./docs

# Build the binary
RUN go build -o bin/much-to-do ./cmd/api/main.go

# ─── Runtime Stage ─────────────────────────────────────────────────
FROM alpine:3.19

WORKDIR /app

RUN apk --no-cache add ca-certificates

COPY --from=builder /app/bin/much-to-do .
COPY --from=builder /app/docs ./docs

EXPOSE 8080

CMD ["./much-to-do"]
