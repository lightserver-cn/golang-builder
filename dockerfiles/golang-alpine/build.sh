#!/bin/sh

image_name=golang1.20-alpine3.18:latest
# 这里的 tag 是镜像仓库的地址，如果是本地就不需要考虑
# tag_name=registryUrl:golang1.20-alpine3.18

# 构建镜像
docker build -f dockerfiles/golang-alpine/Dockerfile --build-arg TIMEZONE=Asia/Shanghai -t "$image_name" ./

# 给镜像打上 tag
# docker tag "$image_name" "$tag_name"

# 将镜像推送到远程仓库 Registry
# docker push "$tag_name"

# 删除构成成功的镜像（步骤镜像）
# docker rmi "$image_name"
