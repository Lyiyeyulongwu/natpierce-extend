#!/bin/sh

version_file="/natpierce/version.txt"  # 这是版本文件的路径
app_file="/natpierce/natpierce" #这是程序文件的路径

# 检查当前IP转发状态
current_state=$(cat /proc/sys/net/ipv4/ip_forward)

if [ "$current_state" -eq 1 ]; then
  echo "IP转发已经开启。"
else
  echo "IP转发未开启，正在开启..."
  echo 1 > /proc/sys/net/ipv4/ip_forward
  if [ "$(cat /proc/sys/net/ipv4/ip_forward)" -eq 1 ]; then
    echo "IP转发已成功开启。"
  else
    echo "IP转发开启失败。"
  fi
fi

if /usr/sbin/iptables -L >/dev/null 2>&1; then
  echo "nftables后端"
  export iptables_mode="nftables"
elif /usr/sbin/iptables-legacy -L >/dev/null 2>&1; then
  echo "legacy后端"
  export iptables_mode="legacy"
else
  echo "请检查容器是否启用特权模式"
  exit 1
fi

install /version/iptables.sh /usr/local/bin/iptables
install /version/iptables.sh /usr/local/bin/iptables-nft
install /version/iptables.sh /usr/local/bin/iptables-legacy


# 添加iptables规则
# 检查第一条规则是否存在
if ! iptables -C FORWARD -i eth0 -o natpierce -m state --state RELATED,ESTABLISHED -j ACCEPT 2>/dev/null; then
 iptables -A FORWARD -i eth0 -o natpierce -m state --state RELATED,ESTABLISHED -j ACCEPT
 echo "添加了第一条iptables规则。"
fi

# 检查第二条规则是否存在
if ! iptables -C FORWARD -i natpierce -o eth0 -j ACCEPT 2>/dev/null; then
 iptables -A FORWARD -i natpierce -o eth0 -j ACCEPT
 echo "添加了第二条iptables规则。"
fi

iptables -V

#更新

# 网站的URL
url="https://www.natpierce.cn/tempdir/info/version.html"

if [ "x${update}" = "xtrue" ]; then
    echo "开始获取官网最新版本号"
    version=$(wget -qO- "$url")
    if [ -n "${version}" ]; then
        echo "获取当前版本号: ${version}"
    else
        echo "无法找到版本号"
        exit 1
    fi
elif [ "x${update}" = "xfalse" ]; then
    if [ "x${customversion}" = "xnull" ]; then
        echo "错误: customversion 不能为 null"
        exit 1
    else
        echo "使用自定义版本号"
        version="${customversion}"
    fi
else
    echo "错误: update 的值必须是 'true' 或 'false'"
    exit 1
fi

echo "使用版本号: ${version}"

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
  armv7*)
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
if [ -f "$version_file" ] && [ "$(cat "$version_file")" = "$version" ] && [ -f "$app_file" ]; then
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


echo "扩展项目github地址,如果可以,麻烦给个star"
echo "https://github.com/Lyiyeyulongwu/natpierce-extend"

/natpierce/natpierce -p $webdkh
