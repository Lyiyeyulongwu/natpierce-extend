#!/bin/sh

# 网站的URL
url="https://natpierce.oss-cn-beijing.aliyuncs.com/update/version.txt"

# 使用wget获取版本号
version=$(wget -qO- "$url")

if [ -n "$version" ]; then
  echo "当前版本号: $version"
else
  echo "无法找到版本号"
fi