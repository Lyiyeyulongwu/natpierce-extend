#!/bin/sh
#这是用来获取皎月官网的版本号的脚本
# 网站的URL
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
