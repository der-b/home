FROM alpine
RUN apk add --no-cache rtl_433
CMD ["rtl_433", "-f", "868M", "-s", "1024k", "-F", "mqtt://nextcloud.lan,devices=rtl_433[/model][/id]"]
