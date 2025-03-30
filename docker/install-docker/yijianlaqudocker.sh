#!/bin/sh
#注释规则：有改动必有注释
#脚本初版：战地庸医，张哥
#
#

#显示logo
art_text=$(cat <<'EOF'
┌───────────────────────────────────────────────────────────────┐
│                                                               │
│                 [0;1;32;92m▄[0m             [0;1;36;96m▀[0m                               │
│ [0;1;33;93m▄[0m [0;1;32;92m▄[0;1;36;96m▄[0m    [0;1;35;95m▄[0;1;31;91m▄▄[0m   [0;1;32;92m▄[0;1;36;96m▄█[0;1;34;94m▄▄[0m  [0;1;31;91m▄▄[0;1;33;93m▄▄[0m   [0;1;36;96m▄[0;1;34;94m▄▄[0m     [0;1;33;93m▄[0;1;32;92m▄▄[0m    [0;1;35;95m▄[0m [0;1;31;91m▄▄[0m   [0;1;32;92m▄[0;1;36;96m▄▄[0m    [0;1;31;91m▄▄[0;1;33;93m▄[0m  │
│ [0;1;32;92m█[0;1;36;96m▀[0m  [0;1;34;94m█[0m  [0;1;31;91m▀[0m   [0;1;32;92m█[0m    [0;1;34;94m█[0m    [0;1;33;93m█▀[0m [0;1;32;92m▀[0;1;36;96m█[0m    [0;1;35;95m█[0m    [0;1;32;92m█▀[0m  [0;1;34;94m█[0m   [0;1;31;91m█▀[0m  [0;1;32;92m▀[0m [0;1;36;96m█▀[0m  [0;1;35;95m▀[0m  [0;1;31;91m█[0;1;33;93m▀[0m  [0;1;32;92m█[0m │
│ [0;1;36;96m█[0m   [0;1;35;95m█[0m  [0;1;33;93m▄▀[0;1;32;92m▀▀[0;1;36;96m█[0m    [0;1;35;95m█[0m    [0;1;32;92m█[0m   [0;1;34;94m█[0m    [0;1;31;91m█[0m    [0;1;36;96m█▀[0;1;34;94m▀▀[0;1;35;95m▀[0m   [0;1;33;93m█[0m     [0;1;34;94m█[0m      [0;1;33;93m█[0;1;32;92m▀▀[0;1;36;96m▀▀[0m │
│ [0;1;34;94m█[0m   [0;1;31;91m█[0m  [0;1;32;92m▀▄[0;1;36;96m▄▀[0;1;34;94m█[0m    [0;1;31;91m▀[0;1;33;93m▄▄[0m  [0;1;36;96m██[0;1;34;94m▄█[0;1;35;95m▀[0m  [0;1;31;91m▄[0;1;33;93m▄█[0;1;32;92m▄▄[0m  [0;1;34;94m▀█[0;1;35;95m▄▄[0;1;31;91m▀[0m   [0;1;32;92m█[0m     [0;1;35;95m▀█[0;1;31;91m▄▄[0;1;33;93m▀[0m  [0;1;32;92m▀[0;1;36;96m█▄[0;1;34;94m▄▀[0m │
│                      [0;1;34;94m█[0m                                        │
│                      [0;1;35;95m▀[0m                                        │
└───────────────────────────────────────────────────────────────┘
EOF
)

# 打印 ASCII 艺术文本
echo "$art_text"
echo "欢迎使用本脚本,脚本版本:0.9"
echo "测试版施工标志，非测试人员等待正式版" #测试标志不要删除，正式版打上注释
echo "制作:皎月连开发组"
echo "皎月连官网：https://www.natpierce.cn"
echo "运行脚本权限要求：可以使用docker命令的用户，如果权限不足可以使用sudo运行脚本"
echo "环境检查开始"

# 环境检查
# 检查当前用户是否是root，如果不是则退出
if [ "$(id -u)" -ne 0 ]; then
   echo "错误：脚本需要以root用户运行。"
   exit 1
fi

# 如果脚本以root用户运行，则继续执行以下代码
echo "脚本正在以root用户运行。"
# 检查wget是否安装
if ! command -v wget > /dev/null 2>&1; then
    echo "错误：wget尚未安装。请安装wget以继续。"
    exit 1
else
    echo "wget已安装。"
fi

# 检查docker是否安装
if ! command -v docker > /dev/null 2>&1; then
    printf "错误：Docker尚未安装。请安装Docker以继续。"
    exit 1
else
    echo "Docker已安装。"
fi


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

#version="0.1" #版本号异常测试

#用户通过输入yes和no,来确认是否下载

while true; do
  printf "请输入 'yes' 或 'no' 来确认是否继续: "
  read user_input

  case "$user_input" in
    [Yy][Ee][Ss])
      echo "您选择了继续。"
      #Version是赋值给容器版本号的VERSION环境变量，用来指示容器内下载的皎月版本
      Version="$version"
      break
      ;;
    [Nn][Oo])
      echo "您选择了不继续。"
      exit 0
      ;;
    *)
      echo "无效的输入，请输入 'yes' 或 'no'。"
      ;;
  esac
done

#检查变量非空，这一部分虽然可能是多余的
default_version="1.03"
if [ -z "$VERSION" ]; then
  VERSION=$default_version
fi

#这是镜像版本号，如果使用环境变量更新镜像请更改这里
VERSION_jx="1.03"

# 定义不同架构的下载链接和镜像标签
URL_AMD64="https://natpierce.oss-cn-beijing.aliyuncs.com/docker/natpierce-amd64-v${VERSION_jx}.tar"
URL_ARM64="https://natpierce.oss-cn-beijing.aliyuncs.com/docker/natpierce-arm64-v${VERSION_jx}.tar"
URL_ARM32="https://natpierce.oss-cn-beijing.aliyuncs.com/docker/natpierce-arm32-v${VERSION_jx}.tar"
TAG_AMD64="natpierce:amd64"
TAG_ARM64="natpierce:arm64"
TAG_ARM32="natpierce:arm32"

# 检测系统架构
ARCH=$(uname -m)

# 根据系统架构设置下载链接和镜像标签
case $ARCH in
    x86_64)
        URL=$URL_AMD64
        TAG=$TAG_AMD64
        ;;
    aarch64)
        URL=$URL_ARM64
        TAG=$TAG_ARM64
        ;;
    armv7l)
        URL=$URL_ARM32
        TAG=$TAG_ARM32
        ;;
    *)
        echo "不支持的架构: $ARCH"
        exit 1
        ;;
esac

# 下载 Docker 镜像 tar 文件
echo "正在下载适用于 $ARCH 的 Docker 镜像..."
wget -O natpierce.tar $URL

# 检查下载是否成功
if [ $? -ne 0 ]; then
    echo "下载 Docker 镜像失败。"
    exit 1
fi

# 导入 Docker 镜像
echo "正在导入 Docker 镜像..."
docker load -i natpierce.tar

# 检查导入是否成功
if [ $? -ne 0 ]; then
    echo "导入 Docker 镜像失败。"
    exit 1
fi

# 清理下载的 tar 文件
rm natpierce.tar

# 创建并启动 Docker 容器
echo "正在启动 Docker 容器..."
docker run -it --name natpierce --restart=always --privileged=true --net=host -d $TAG
# run后面加入 -e 设定环境变量 如 -e VERSION=$Version -e webdkh=33272
# 检查容器是否启动成功
if [ $? -ne 0 ]; then
    echo "启动 Docker 容器失败。请检查是否存在重复容器"
    exit 1
fi
echo "Docker容器启动成功"
printf "这里是docker版本的介绍文本。\n特性：\nDocker容器启动成功后web面板默认端口号33272，如要更改（等待正式）\n"
