#!/bin/sh
#请保留各版本注释
#项目版本于1.03版本构建，建立日期: 25/1/19 脚本编辑: xiyu505
# 25/2/17 大版本更新 改变方式
#
#
echo "扩展项目地址"
echo "https://github.com/Lyiyeyulongwu/natpierce-extend"

version_file="/natpierce/version.txt"  # 这是版本文件的路径
app_file="/natpierce/natpierce" #这是程序文件的路径

#最新版本号
echo "开始获取官网最新版本号"


# 网站的URL
url="https://www.natpierce.cn/tempdir/info/version.html"

# 使用wget获取版本号
version=$(wget -qO- "$url")

if [ -n "$version" ]; then
  echo "当前版本号: $version"
else
  echo "无法找到版本号"
fi



# 定义基础URL
base_url="https://natpierce.oss-cn-beijing.aliyuncs.com/linux"

# 获取系统架构
arch=$(uname -m)

# 根据架构获取文件名
case "$arch" in
  x86_64)
    file="natpierce-amd64-v${version}.tar.gz"
    ;;
  aarch64)
    file="natpierce-arm64-v${version}.tar.gz"
    ;;
  arm*)
    file="natpierce-arm32-v${version}.tar.gz"
    ;;
  *)
    echo "不支持的架构: $arch"
    exit 1
    ;;
esac

# 构建完整的下载URL
URL="${base_url}/${file}"


# 检查版本文件是否存在且内容是否与当前版本一致
if [ -f "$version_file" ] && [ "$(cat "$version_file")" = "$version" ] &&[ -f "$app_file" ]; then
    echo "版本文件存在且内容与当前版本一致。"
    version_txt=$(cat "$version_file")
    echo "本地版本号为$version_txt"
else
    wget -O natpierce.tar.gz $URL
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
      echo "下载natpierce包失败，请检查网络连接！！！"
      exit 1
    fi
    # 移动 natpierce 二进制文件到工作目录
    mkdir -p "/natpierce/"
    if mv natpierce /natpierce/natpierce; then
        echo "natpierce 二进制文件已成功移动到工作目录。"
        chmod +x /natpierce/natpierce
        echo "$version" > "/natpierce/version.txt"
    else
        echo "移动 natpierce 二进制文件失败。"
        exit 1
    fi
fi

/natpierce/natpierce -p $webdkh