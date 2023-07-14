# 第一个阶段：指定基础镜像
FROM golang:1.20.4-alpine3.18

# Permission denied
RUN sed -i 's/https/http/' /etc/apk/repositories

# 安装 tzdata 包
RUN apk add --no-cache tzdata

# --build-arg TZ=Asia/Shanghai
ARG TIMEZONE=Asia/Shanghai

# 设置环境信息：时区，环境变量，GO111MODULE 和 GOPROXY
ENV TZ=${TIMEZONE} \
    GO111MODULE=on \
    GOPROXY=https://goproxy.cn,direct

# 设置时区
RUN ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && date
