#!/bin/bash

if [[ -z "$BUPT_USERNAME" || -z "$BUPT_PASSWORD" ]]; then
    echo "你必须设置两个环境变量用于网关认证: \$BUPT_USERNAME 为你的学号, \$BUPT_PASSWORD 为你的网关密码"
    exit 1
fi

cmd="/bupt-net-login >/proc/1/fd/1 2>/proc/1/fd/2"

cron="0-59/5 * * * *"

# Use user-specified cron, if possible.
if [[ "$1" != "" ]]; then
    cron="$1"
fi

echo "Login once at start up:"

# 重定向符无法通过变量展开获得 ($cmd 展开后的 > 只会成为普通参数), 必须直接书写
/bupt-net-login >/proc/1/fd/1 2>/proc/1/fd/2

echo "Initialized with the following cron job:"
echo "----- BEGIN CRON -----"
echo "$cron $cmd" | tee /var/spool/cron/crontabs/root
echo "-----  END CRON  -----"

echo "Cron job will be scheduled subsequently."

crond -l 2 -f
