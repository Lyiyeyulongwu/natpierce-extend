# natpierce-extend
[gituhub仓库地址](https://github.com/Lyiyeyulongwu/natpierce-extend "https://github.com/Lyiyeyulongwu/natpierce-extend")

## docker
皎月连docker扩展
### 镜像介绍
皎月连扩展镜像  
修改内容： 
增加时区文件，默认时区为Shanghai   
持久化文件，存储在存储卷，请自行查看  
web端口号支持永久更改，更改环境变量webdkh即可,默认值为33272   
新增版本更新选择,环境变量update的值true或者false,决定是否需要保持最新版   
环境变量customversion是手动决定的版本号,这只在update为false生效   
更改镜像组成，使在镜像不变的情况下，更新最新的皎月连版本，你只需要重启镜像即可  

#### docker run：  
使用前请确认已安装docker
```
docker run -d --name natpierce \
    --restart=always \
    --privileged \
    --net=host \
    -v natpierce_data:/natpierce \
    xiyu505/natpierce:latest  
```
#### docker compose：  
使用前请确认已安装docker compose
```
services:
  natpierce:
    image: xiyu505/natpierce:latest
    container_name: natpierce
    restart: always
    privileged: true
    network_mode: host
    environment:
      webdkh: "33272"
      update: "true"
      customversion: "null"
    volumes:
      - data:/natpierce
volumes:
  data:
```  
## Linux
linux二进制启动器支持
### 介绍
它会自动下载最新的皎月连二进制文件并且记录版本号，可以打开时检查更新
提供更方便的交互选项，减少敲命令的过程
启动器依赖init建立服务文件  
#### 目前支持  
* systemd
* openrc  

欢迎其他有兴趣的贡献者提交对其他类型的init的支持

#### 使用
下载***natpierce_linux***包,然后运行里面的***gui.sh***脚本，剩下的按提示来


## 1panel本地应用
将应用目录上传到 1Panel 的 /opt/1panel/resource/apps/local 文件夹下
注意：/opt 为 1Panel 默认安装目录，请根据自己的实际情况修改
上传完成后，目录结构如下
```  
├──natpierce 
	├── logo.png 
	├── data.yml
	├── README.md 
	├── latest_1.0 
	    ├── data.yml 
	    └── docker-compose.yml
```        
在 1Panel 应用商店中，点击更新应用列表按钮同步本地应用