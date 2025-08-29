#!/bin/sh

# 配置仓库信息
REPO="natpierce/luci-app-natpierce"
API_URL="https://api.github.com/repos/${REPO}/releases/latest"

add_apk_pubkey() {
    PUBKEY_URL="https://raw.githubusercontent.com/${REPO}/refs/heads/main/assets/Public_key/openwrt_natpierce_public.pem"
    PUBKEY_FILE="/etc/apk/keys/openwrt_natpierce_public.pem"
    
    echo "正在下载 APK 包所需公钥文件..."
    # 尝试下载公钥文件，如果失败则退出
    if ! (command -v wget >/dev/null 2>&1 && wget -q -O "$PUBKEY_FILE" "$PUBKEY_URL") && \
       ! (command -v curl >/dev/null 2>&1 && curl -s -o "$PUBKEY_FILE" "$PUBKEY_URL"); then
        echo "下载公钥失败或找不到可用的下载工具（wget 或 curl）。"
        exit 1
    fi

    echo "公钥已成功添加到 /etc/apk/keys/ 目录。"
    echo ""
}

# 动态判断包管理器并设置下载模式
if command -v apk >/dev/null 2>&1; then
    echo "检测到 apk 包管理器，将下载 .apk 格式软件包。"
    PACKAGE_SUFFIX="apk"
    INSTALL_CMD="apk add"
    add_apk_pubkey
elif command -v opkg >/dev/null 2>&1; then
    echo "检测到 opkg 包管理器，将下载 .ipk 格式软件包。"
    PACKAGE_SUFFIX="ipk"
    INSTALL_CMD="opkg install"
else
    echo "未检测到可用的包管理器 (apk 或 opkg)。"
    exit 1
fi

PATTERN="luci-app-natpierce.*\.${PACKAGE_SUFFIX}"

# 获取最新 Release 的 JSON 数据
JSON=$(wget -qO- "$API_URL" 2>/dev/null || curl -s "$API_URL")

# 从 JSON 中提取下载链接
DOWNLOAD_URL=$(echo "$JSON" | grep -o '"browser_download_url": *"[^"]*"' | grep -E "$PATTERN" | cut -d'"' -f4)

if [ -z "$DOWNLOAD_URL" ]; then
    echo "未找到符合条件的 ${PACKAGE_SUFFIX} 文件。"
    exit 1
fi

# 从下载链接中提取文件名
FILENAME=$(basename "$DOWNLOAD_URL")

echo "正在下载: $FILENAME"

# 下载文件（兼容 wget 和 curl）
if command -v wget >/dev/null 2>&1; then
    wget -O "$FILENAME" "$DOWNLOAD_URL"
elif command -v curl >/dev/null 2>&1; then
    curl -L -o "$FILENAME" "$DOWNLOAD_URL"
else
    echo "找不到可用的下载工具（wget 或 curl）。"
    exit 1
fi

echo "下载完成: $FILENAME"
echo ""

# 执行安装
echo "正在安装软件包..."
$INSTALL_CMD "$FILENAME"

# 清理下载的安装包
echo ""
echo "正在清理下载的软件包..."
rm "$FILENAME"

echo "安装和清理过程已完成。"