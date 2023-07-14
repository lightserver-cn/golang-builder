golang-docker
===

平滑构建golang项目的二进制包及容器

step 1 编辑 .env 文件，后缀表示对应的环境（可选值：local, dev, test, prod）

```shell
# 系统环境变量标识
ENV=dev
# 容器对外端口号
PORT=9012
# 时区
TIMEZONE=Asia/Shanghai
# golang 构建成功的二进制包名
BINARY=test-server
```

step 2 开始构建基础镜像（仅首次执行）

```shell
# 构建基础镜像
dockerfiles/golang-alpine/build.sh
```

step 3 开始构建项目

```shell
# 构建项目
./run.sh dev build
```
