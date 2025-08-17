#!/bin/sh

# 让gui界面选择运行脚本时能够弹出终端

run_as_root() {
    if [ "$(id -u)" -eq 0 ]; then
        echo "[INFO] 正在以 root 权限执行: $1"
        eval "$1"
    else
        echo "[INFO] 需要管理员权限来执行: $1"
        if command -v sudo >/dev/null 2>&1; then
            # sudo 存在，尝试使用 sudo 执行
            echo "[INFO] 检测到 sudo，将使用它来提权。"
            sudo sh -c "$1"
        else
            echo "[ERROR] 需要管理员权限，但 'sudo' 命令未找到。"
            echo "[ERROR] 请以 root 用户身份运行此脚本，或安装 sudo 并配置好权限。"
            exit 1
        fi
    fi
}


current_dir=$(dirname "$(readlink -f "$0")")

# 确保目标目录存在
target_directory="${current_dir}/version"
mkdir -p "$target_directory"

while true; do
  printf "请输入 'yes' 或 'no' 来确认是否继续: "
  read linshi_input
  case "$linshi_input" in
    [Yy][Ee][Ss])
      echo "您选择了继续。"
      break
      ;;
    [Nn][Oo])
      echo "您选择了不继续。"
      exit 0
      ;;
    [Yy][Ll][Gg][Xx])
      echo "恭喜你发现了隐藏的依赖更新选项，这个是用来更新核心文件的，因为github不一定能正常访问所以隐藏了起来"
      # 定义下载链接和目标文件名
      url="https://raw.githubusercontent.com/XingHeYuZhuan/natpierce-extend/refs/heads/main/natpierce_linux/version/install_natpierce.sh"
      filename="install_natpierce.sh"
      # 使用wget下载文件
      wget -O "$filename" "$url"
      # 检查下载是否成功
      if [ $? -eq 0 ]; then
          # 移动文件到指定目录
          mv "$filename" "$target_directory"
          echo "文件已下载并移动到 $target_directory"
      else
          echo "下载失败"
          exit 1
      fi
      exit 0
      ;;
    *)
      echo "无效的输入，请输入 'yes' 或 'no'。"
      ;;
  esac
done

# 确保脚本有执行权限
run_as_root "chmod +x '${current_dir}/installnatpierce.sh'"
# 执行安装脚本
run_as_root "'${current_dir}/installnatpierce.sh' '${current_dir}'"
