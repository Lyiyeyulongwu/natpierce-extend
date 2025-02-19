# natpierce-extend

## docker
皎月连docker扩展
### 镜像介绍
皎月连修改镜像 \
修改内容：\
增加时区文件，默认时区为Shanghai，\
持久化文件，存储在存储卷，请自行查看，\
web端口号支持永久更改，更改环境变量webdkh即可,默认值为33272 \
更改镜像组成，使在镜像不变的情况下，更新最新的皎月连版本，你只需要重启镜像即可, 

使用命令：\
`docker run -d --name natpierce --restart=always --privileged --net=host -v natpierce:/natpierce xiyu505/natpierce:latest` 

## linux
linux二进制启动器支持
### 介绍
启动器依赖init建立服务文件，目前支持
