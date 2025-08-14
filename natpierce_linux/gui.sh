#!/bin/sh

# 让gui界面选择运行脚本时能够弹出终端

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
      # 核心文件下载地址
      #
      exit 0
      ;;
    *)
      echo "无效的输入，请输入 'yes' 或 'no'。"
      ;;
  esac
done

# 确保脚本有执行权限
sudo chmod +x "${current_dir}/version/install_natpierce.sh"
# 执行安装脚本
sudo "${current_dir}/version/install_natpierce.sh" "${current_dir}"
