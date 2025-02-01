# Auth Service

## Setup

```sh
$ go mod init aad-b2c-auth-service
$ go mod tidy
$ go get github.com/denisenkom/go-mssqldb
$ go get gorm.io/driver/sqlserver
$ go get github.com/gin-gonic/gin
$ go get gorm.io/gorm
$ go get github.com/sirupsen/logrus

$ go run main.go

$ cd ../../docker/local
$ docker compose -f restapi.air.docker-compose.yml up --build
```
