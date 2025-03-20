# syntax=docker/dockerfile:1

FROM golang:1.24.1

# Set destination for COPY
WORKDIR /app

# Download Go modules
COPY go.mod go.sum ./
RUN go mod download

# Copy the source code. Note the slash at the end, as explained in
# https://docs.docker.com/reference/dockerfile/#copy
COPY . .

# Build
RUN go build -o /air-controller-webservice cmd/main.go

EXPOSE 8080

# Run
CMD ["/air-controller-webservice"]