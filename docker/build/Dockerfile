FROM alpine
RUN apk add --no-cache tzdata
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
COPY zgx_natpierce.sh /natpierce/version/zgx_natpierce.sh
RUN chmod +x /natpierce/version/zgx_natpierce.sh
ENV webdkh=33272
WORKDIR /natpierce
LABEL org.opencontainers.image.authors="Lyiyeyulongwu"
LABEL org.opencontainers.image.source="https://github.com/Lyiyeyulongwu/natpierce-extend"
CMD [ "/natpierce/version/zgx_natpierce.sh" ]
