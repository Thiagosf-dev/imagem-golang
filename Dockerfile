# Pegando imagem do GoLang
FROM golang:1.14.4-alpine AS builder

# Instalando utilitários
RUN \
    apk add --no-cache \
    build-base \ 
    upx

# Definindo diretório inicial no container
WORKDIR /go/src/api/

COPY . .

# Realizando build e compressão para binário do arquivo .go
RUN \
    CGO_ENABLED=0 GOOS=linux \
    go build -a -installsuffix cgo -ldflags="-s -w" -o web_api ./main.go && \
    upx web_api

# Realizando o Multi Stage Build
FROM scratch
WORKDIR /root/
COPY --from=builder /go/src/api/web_api .
CMD ["./web_api"]