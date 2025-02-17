#!/bin/sh
#请保留各版本注释
#项目版本于1.03版本构建，建立日期: 25/1/19 脚本编辑: xiyu505
# 25/2/17 大版本更新 改变方式
#
#


version_file="/natpierce/version/version.txt"  # 这是版本文件的路径
app_file="/natpierce/app/natpierce" #这是程序文件的路径

#最新版本号
echo "开始获取官网最新版本号"

url="https://www.natpierce.cn/pc/downloads/index_new.html"

# 使用wget获取网页内容
html=$(wget -qO- "$url")

# 使用grep搜索包含"版本"关键字的行，并提取版本号
# 注意：这里版本号紧跟在"当前版本："后面，并以"v"开头，后跟数字和点
version=$(echo "$html" | grep -o '当前版本：v[0-9\.]*')

# 去除"当前版本："前缀
version=$(echo "$version" | sed 's/当前版本：v//')

# 检查是否成功提取版本号
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
    mkdir -p "/natpierce/app"
    if mv natpierce /natpierce/app/natpierce; then
        echo "natpierce 二进制文件已成功移动到工作目录。"
        chmod +x /natpierce/app/natpierce
        echo "$version" > "/natpierce/version/version.txt"
    else
        echo "移动 natpierce 二进制文件失败。"
        exit 1
    fi
fi

/natpierce/app/natpierce -p $webdkh