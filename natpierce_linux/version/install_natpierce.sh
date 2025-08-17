#!/bin/sh

#预设环境组
output_dir=$1 #引入启动脚本提供的定位参数
version_file="${output_dir}/version/version.txt"  # 这是版本文件的路径
app_file="${output_dir}/app/natpierce" #这是程序文件的路径
new_script_path="${output_dir}/version/start_natpierce.sh" # 启动脚本的路径
port_txt_path="${output_dir}/version/port.txt" #端口号文件位置

#介绍头模块
welcome() {
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
echo "扩展项目地址"
echo "https://github.com/XingHeYuZhuan/natpierce-extend"
echo "欢迎使用"
}

#获取更新模块
update() {
#最新版本号
echo "开始获取官网最新版本号"


# 网站的URL
url="https://www.natpierce.cn/tempdir/info/version.html"

# 使用wget获取版本号
version=$(wget -qO- "$url")

if [ -n "$version" ]; then
  echo "当前版本号: $version"
else
  echo "无法找到版本号,请检查网络"
fi
 

# 定义URL
URL_AMD64="https://natpierce.oss-cn-beijing.aliyuncs.com/linux/natpierce-amd64-v${version}.tar.gz"
URL_ARM64="https://natpierce.oss-cn-beijing.aliyuncs.com/linux/natpierce-arm64-v${version}.tar.gz"
URL_ARM32="https://natpierce.oss-cn-beijing.aliyuncs.com/linux/natpierce-arm32-v${version}.tar.gz"
URL_mips="https://natpierce.oss-cn-beijing.aliyuncs.com/linux/natpierce-mips-v${version}.tar.gz"
URL_mipsel="https://natpierce.oss-cn-beijing.aliyuncs.com/linux/natpierce-mipsel-v${version}.tar.gz"
# 获取系统架构
arch=$(uname -m)

# 根据架构获取文件
case "$arch" in
  x86_64)
    URL=$URL_AMD64
    ;;
  aarch64 | arm64)
    URL=$URL_ARM64
    ;;
  armv7*)
    URL=$URL_ARM32
    ;;
  arm*)
    echo "不支持的架构: $arch"
    exit 1
    ;;
  i386 | i686)
    echo "不支持的架构: $arch"
    exit 1
    ;;        
  mips | mipsel)
    if [ "$arch" = "mipsel" ]; then
        URL=$URL_mipsel
    else
        first_byte=$(printf '\1' | hexdump -e '1/1 "%02x"')
        if [ "$first_byte" = "01" ]; then
            URL=$URL_mipsel
        else
            URL=$URL_mips
        fi
    fi
    ;;
  *)
    echo "不支持的架构: $arch"
    exit 1
    ;;
esac


# 检查版本文件是否存在且内容是否与当前版本一致
if [ -f "$version_file" ] && [ "$(cat "$version_file")" = "$version" ] &&[ -f "$app_file" ]; then
    echo "版本文件存在且内容与当前版本一致。"
    version_txt=$(cat "$version_file")
    echo "本地版本号为$version_txt"
else
    echo "是否更新"
    while true; do
    printf "请输入 'yes' 或 'no' 来确认是否继续: "
    read user_input
    case "$user_input" in
        [Yy][Ee][Ss])
        echo "您选择了继续。"
        upgrade
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
fi
}
#升级模块
upgrade() {
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
    mkdir -p "${output_dir}/app"
    if mv natpierce ${output_dir}/app/natpierce; then
        echo "natpierce 二进制文件已成功移动到工作目录。"
        chmod +x ${output_dir}/app/natpierce
        echo "$version" > "${output_dir}/version/version.txt"
    else
        echo "移动 natpierce 二进制文件失败。"
        exit 1
    fi
}
#端口占用检查函数
isportinuse() {
  ss -tuln | grep ":$1 " > /dev/null
  return $?
}
#环境检查模块
examine() {
echo "环境检查开始"

# 环境检查
# 检查wget是否安装
if ! command -v wget > /dev/null 2>&1; then
    echo "错误：wget尚未安装。请安装wget以继续。"
    exit 1
else
    echo "wget已安装。"
fi

# 获取内核版本
KERNEL_VERSION=$(uname -r)
echo "你的内核版本:$KERNEL_VERSION"


# 检查modinfo命令是否存在
if ! command -v modinfo > /dev/null 2>&1; then
  echo "modinfo命令未找到，请确保您的系统已安装此命令。"
  exit 1
fi

# 检查lsmod命令是否存在
if ! command -v lsmod > /dev/null 2>&1; then
  echo "lsmod命令未找到，请确保您的系统已安装此命令。"
  exit 1
fi

# 使用modinfo检查TUN模块
if modinfo tun > /dev/null 2>&1; then
  echo "TUN模块存在于您的系统中。"
  # 检查TUN模块是否已加载
  if lsmod | grep -q 'tun'; then
    echo "TUN模块已加载。"
  else
    echo "TUN模块未加载，您可能需要手动加载该模块。"
  fi
else
  echo "TUN模块不存在于您的系统中。"
  exit 1
fi

#检测ip转发功能是否开启
if [ $(cat /proc/sys/net/ipv4/ip_forward) -eq 1 ]; then
  echo "IP转发已开启。"
else
  echo "IP转发未开启。"
fi

# 获取 PID 1 进程的名称
initprocess=$(cat "/proc/1/comm")
# 根据进程名称判断 init 系统
case "$initprocess" in
  systemd)
    echo "初始化系统: systemd"
    init=systemd
    ;;
  init)
    if [ -f "/sbin/openrc" ] || [ -d "/etc/runlevels" ]; then
        echo "初始化系统: OpenRC"
        init=openrc
    elif [ -f "/etc/inittab" ] && [ -d "/etc/init.d" ]; then
        echo "不支持皎月自启动功能的初始化系统: SysVinit"
        exit 1
    elif [ -f "/sbin/upstart" ] || [ -d "/etc/init" ]; then
        echo "不支持皎月自启动功能的初始化系统: Upstart"
        exit 1
    else
        echo "不支持皎月自启动功能的初始化系统: 未知 init 变体"
        exit 1
    fi
    ;;
  procd)
    echo "不支持皎月自启动功能的初始化系统: procd"
    exit 1
    ;;      
  *)
    echo "不支持皎月自启动功能的初始化系统: $initprocess"
    exit 1
    ;;
esac
}
#检查本地端口号预设模块
port_examine() {
#端口号文件位置
port_txt_path="${output_dir}/version/port.txt"
#检查文件是否存在，且不为空
if [ ! -f "${port_txt_path}" ] || [ -z "$(cat "${port_txt_path}")" ]; then
  echo "33272" > "${port_txt_path}"
fi
#读取端口号
port_file=$(cat "${port_txt_path}")
# 检查portfile是否为数字
if ! echo "$port_file" | grep -qE '^[0-9]+$'; then
  echo "错误：端口号不是数字。"
  exit 1
fi

# 检查portfile是否在10000到65535之间
if [ "$port_file" -lt 10000 ] || [ "$port_file" -gt 65535 ]; then
  echo "错误：端口号不在10000-65535的范围内。"
  exit 1
fi
}
#检查输入端口号模块
port_input() {
    while true; do
      printf "请输入想设定的web端口号(使用10000-65535这个范围)或直接回车使用默认端口33272: "
      read port
      if [ -z "$port" ]; then
        port=33272
        if isportinuse "$port"; then
          echo "默认端口 $port 已被占用，请输入其他端口号。"
        else
          echo "使用默认端口 $port"
          break
        fi
      elif ! echo "$port" | grep -qE '^[0-9]+$'; then
        echo "端口号无效，请输入一个数字。"
      elif [ "$port" -lt 10000 ] || [ "$port" -gt 65535 ]; then
        echo "错误：端口号不在10000-65535的范围内。"  
      elif isportinuse "$port"; then
        echo "端口号 $port 已被占用，请重新输入。"
      else
        echo "端口号 $port 未被占用，可以使用。"
        echo "$port" > "${port_txt_path}"
        break
      fi
    done
}
#服务文件管理模块
init_service() {
port_file=$(cat "${port_txt_path}")    
selectedport=$port_file
# 创建默认预设启动脚本的内容
def_script_content=$(cat <<EOF
#!/bin/sh
# start_natpierce.sh

# 启动程序
exec "${output_dir}/app/natpierce" -p ${selectedport} > ${output_dir}/version/natpierce.log  2>&1 
EOF
)

# 将内容写入启动脚本文件
echo "$def_script_content" > "$new_script_path"

# 使启动脚本可执行
chmod +x "$new_script_path"

case "$init" in
  systemd)
  cat << EOF > /etc/systemd/system/natpierce.service
[Unit]
Description=Natpierce Service
After=network.target

[Service]
Type=simple
User=root
ExecStart=$new_script_path

[Install]
WantedBy=multi-user.target
EOF

    # 重新加载systemd以识别新服务
    systemctl daemon-reload
  ;;
  openrc)
  cat << EOF > /etc/init.d/natpierce
#!/sbin/openrc-run

description="NatPierce Network Tunneler"
command="$new_script_path"
pidfile="/run/\${RC_SVCNAME}.pid"
command_background=true

start() {
    ebegin "Starting \${RC_SVCNAME}"
    start-stop-daemon --start --exec "\$command" --pidfile "\$pidfile" --background --make-pidfile
    eend \$?
}

stop() {
    ebegin "Stopping \${RC_SVCNAME}"
    start-stop-daemon --stop --pidfile "\$pidfile" --retry TERM/10/KILL/5
    eend \$?
}
EOF

    # 给脚本执行权限
    chmod +x /etc/init.d/natpierce
    
  ;;
  *)
  echo "这个正常情况是不可能出现的"
  exit 1
  ;;
esac
}

service_rm(){

case "$init" in
  systemd)
    if [ -f /etc/systemd/system/natpierce.service ]; then
      rm /etc/systemd/system/natpierce.service
      systemctl daemon-reload
      echo "已删除 natpierce.service (systemd)"
    else
      echo "提示：文件 /etc/systemd/system/natpierce.service 不存在"
    fi
    ;;
  openrc)
    if [ -f /etc/init.d/natpierce ]; then
      rm /etc/init.d/natpierce
      echo "已删除 /etc/init.d/natpierce (OpenRC)"
    else
      echo "提示：文件 /etc/init.d/natpierce 不存在"
    fi
    ;;
}

#预设命令模块
service_command() {
SERVICENAME="natpierce" # 服务名称

#预设命令
case "$init" in
  systemd)
    ENABLECMD="systemctl enable $SERVICENAME"
    DISABLECMD="systemctl disable $SERVICENAME"
    STARTCMD="systemctl start $SERVICENAME"
    STOPCMD="systemctl stop $SERVICENAME"
    RESTARTCMD="systemctl restart $SERVICENAME"
    ;;
  openrc)
    ENABLECMD="rc-update add $SERVICENAME default"
    DISABLECMD="rc-update del $SERVICENAME default"
    STARTCMD="rc-service $SERVICENAME start"
    STOPCMD="rc-service $SERVICENAME stop"
    RESTARTCMD="rc-service $SERVICENAME restart"
    ;;
  *)
    echo "这个正常情况是不可能出现的错误代码init：$init"
    exit 1
    ;;
esac
}
state() {
# 检查操作结果
if [ $? -eq 0 ]; then
  echo "操作成功完成。"
else
  echo "操作失败。"
fi  
}


show_menu() {
# 用户交互部分
echo "请选择一个操作:"
echo "1. 设置服务自启动"
echo "2. 取消服务自启动"
echo "3. 启动服务"
echo "4. 停止服务"
echo "5. 重启服务"
echo "6. 设置端口号(将停止服务)"
echo "7. 退出选择"
echo "8. 删除服务文件(删除文件夹前使用)"
}

# 主程序

#函数启动
welcome
examine
update
port_examine
init_service
service_command

while true; do
    show_menu
    read -p "请输入您的选择（1-7）：" choice

    case $choice in
        1)
            echo "正在设置服务自启动..."
            $ENABLECMD
            state
            ;;
        2)
            echo "正在取消服务自启动..."
            $DISABLECMD
            state
            ;;
        3)
            echo "正在启动服务..."
            $STARTCMD
            state    
            ;;  
        4)
            echo "正在停止服务..."
            $STOPCMD
            state
            ;;    
        5)
            echo "正在重启服务..."
            $RESTARTCMD
            state
            ;;
        6)
            $STOPCMD
            port_input
            init_service
            state
            ;;
        7)
            echo "退出程序"
            break
            ;;
        8)
            echo "开始执行清除流程"
            $DISABLECMD
            $STOPCMD
            service_rm
            state
            ;;    
        *)
            echo "无效的选择，请重新输入。"
            ;;
    esac
done

state