FROM golang:1.20.5

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY *.go ./
RUN go build -o api .

EXPOSE 80
CMD ["./main"]