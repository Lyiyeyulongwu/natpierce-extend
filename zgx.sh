#!/bin/sh
#请保留各版本注释
#项目版本于1.03版本构建，建立日期: 25/1/19 脚本编辑: xiyu505
#
#




# 定义基础URL
base_url="https://natpierce.oss-cn-beijing.aliyuncs.com/linux"

# 获取系统架构
arch=$(uname -m)

# 根据架构获取文件名
case "$arch" in
  x86_64)
    file="natpierce-amd64-v${VERSION}.tar.gz"
    ;;
  aarch64)
    file="natpierce-arm64-v${VERSION}.tar.gz"
    ;;
  arm*)
    file="natpierce-arm32-v${VERSION}.tar.gz"
    ;;
  *)
    echo "不支持的架构: $arch"
    exit 1
    ;;
esac

# 检查版本环境变量是否设置
if [ -z "$VERSION" ]; then
    echo "版本号变量VERSION 未设置"
    exit 1
fi

# 构建完整的下载URL
url="${base_url}/${file}"

# 下载 natpierce 包

curl -sSL "$url" -o natpierce.tar.gz

# 检查文件是否存在且不为空且大小大于1KB
if [ -s natpierce.tar.gz ] && [ $(stat -c%s natpierce.tar.gz) -gt 1024 ]; then
    echo "下载 natpierce 包成功。"
    
    # 解压 natpierce 包
    if tar -xzvf natpierce.tar.gz natpierce; then
        rm natpierce.tar.gz
        echo "解压 natpierce 包成功。"
    else
        echo "解压 natpierce 包失败。"
        exit 1
    fi
else
    echo "下载natpierce包失败，请检查版本号与官网是否一致或网络连接！！！"
    exit 1
fi

# 移动 natpierce 二进制文件到工作目录
if mv natpierce /app/natpierce/natpierce; then
    echo "natpierce 二进制文件已成功移动到工作目录。"
else
    echo "移动 natpierce 二进制文件失败。"
    exit 1
fi