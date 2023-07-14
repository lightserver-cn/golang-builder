#!/bin/sh

# 检查是否传递了参数
if [ $# -eq 0 ]; then
  echo "必须输入环境参数（可选值：local, dev, test, prod）"
  exit 1
fi

# 获取传递的环境参数
env_param=$1

# 检查环境参数是否为有效值
# shellcheck disable=SC2039
valid_env=("local" "dev" "test" "prod")
# shellcheck disable=SC2076
# shellcheck disable=SC2199
# shellcheck disable=SC2039
if [[ ! " ${valid_env[@]} " =~ " ${env_param} " ]]; then
  echo "无效的环境参数（可选值：local, dev, test, prod）"
  exit 1
fi

# 根据环境参数选择对应的 env-file 文件
# shellcheck disable=SC2034
env_file=".env.${env_param}"
yaml_file="docker-compose.${env_param}.yaml"

cp docker-compose.yaml "$yaml_file"

# 创建关联数组
# shellcheck disable=SC2039
declare -A env_map

# 读取环境变量文件并进行替换
# 替换后不在使用 docker-compose -f "$yaml_file" --env-file "$env_file" up --build -d 进行环境配置
while IFS= read -r line; do
  # 检查行是否包含等号，如果是，则解析环境变量名和值
  # shellcheck disable=SC2039
  if [[ $line == *=* ]]; then
    key="${line%%=*}"
    value="${line#*=}"
    # 使用 sed 命令替换环境变量
    sed -i "s|\${$key}|$value|g" "$yaml_file"
    # 去除空格并存储到关联数组中
    env_map["$key"]="${value// /}"
  fi
done < "$env_file"

# 使用传递的参数
# shellcheck disable=SC2028
echo "输入的 env 值为: $env_param; 将使用：$yaml_file 构建系统;"

die

# 根据参数决定是否重新构建镜像和容器
if [ "$2" = "build" ]; then

  # shellcheck disable=SC2039
  echo "开始构建二进制包: ${env_map["BINARY"]}"

  # 构建 golang 项目的二进制包文件 (sh file.sh 传参数)
  # shellcheck disable=SC2039
  sh ./dockerfiles/build-server/build.sh "${env_map["BINARY"]}"

  echo "停止并删除容器: docker-compose down"
  # 停止并删除容器
  docker-compose -f "$yaml_file" down

  # echo "删除镜像: docker-compose --rmi all"
  # 删除镜像
  # docker-compose -f "$yaml_file" down --rmi all

  echo "重建镜像及容器: docker-compose up -d"
  # 执行 Docker Compose 命令
  docker-compose -f "$yaml_file" up --build -d

elif [ "$2" = "restart" ]; then

  echo "重启容器: docker-compose up -d"
  # 启动容器
  docker-compose -f "$yaml_file" restart

else

  echo "启动容器: docker-compose up -d"
  # 启动容器
  docker-compose -f "$yaml_file" up -d

fi
