#!/bin/sh
#让gui界面选择运行脚本时能够弹出终端

current_dir=$(dirname "$(readlink -f "$0")")

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
      #核心文件下载地址

      #
      exit 0
      ;;
    *)
      echo "无效的输入，请输入 'yes' 或 'no'。"
      ;;
  esac
done

sudo chmod +x ${current_dir}/version/cs.sh
sudo ${current_dir}/version/install_natpierce.sh "${current_dir}"
