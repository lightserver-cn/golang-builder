# 第一个阶段：指定基础镜像
FROM golang1.20-alpine3.18:latest AS build

# 设置环境信息：GOPROXY 和 GO111MODULE
ENV GOPROXY=https://goproxy.cn,direct
ENV GO111MODULE=on

# 设置go包缓存（防止出现 $GOPATH/go.mod exists but should not）
WORKDIR /go/cache

# 将 go.mod 和 go.sum 文件复制到容器的工作目录
# 下载 Go 模块依赖
COPY go.mod .
COPY go.sum .

RUN go mod download

FROM build as release

# 设置工作目录为 /go/release
WORKDIR /go/release

# 将当前目录下的所有文件复制到容器的工作目录
ADD . .

# 编译 Go 项目，并将可执行文件命名为 app，并将其复制到 /usr/local/bin 目录
# -s: 省略符号表和调试信息
# -w: 省略DWARF符号表
RUN GOOS=linux CGO_ENABLED=0 go build -ldflags="-s -w" -installsuffix cgo -v -o app main.go

RUN ls
