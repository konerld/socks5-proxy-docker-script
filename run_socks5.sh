#!/bin/bash


mkdir -p ~/docker_run/
cd ~/docker_run
git clone https://github.com/elejke/docker-socks5.git
cd docker-socks5


DOCKERFILE_PATH="$HOME/docker_run/docker-socks5/Dockerfile"
DEFAULT_USER="MyProxyUser"
DEFAULT_PASS="Qwertyu123456709!"
RUN_CMD='RUN printf "${PASS}\n${PASS}\n" | adduser ${P_USER}'


echo "Введите proxy user (по умолчанию: $DEFAULT_USER)"
read -p "> " USER_INPUT
if [ "${USER_INPUT}" != "" ]; then
    DEFAULT_USER=${USER_INPUT}
fi

echo "Введите proxy password (по умолчанию: $DEFAULT_PASS )"
read -p "> " PASS_INPUT
if [ "${PASS_INPUT}" != "" ]; then
    DEFAULT_PASS=${PASS_INPUT}
fi

echo "Используем:
user:${DEFAULT_USER}
pass: ${DEFAULT_PASS}"

CONTENT=$(cat <<EOF
FROM wernight/dante
ENV P_USER ${DEFAULT_USER}
ENV PASS ${DEFAULT_PASS}
$RUN_CMD
EOF
)

#echo $CONTENT
#echo $CONTENT > $DOCKERFILE_PATH

printf "%s\n" "$CONTENT" > "$DOCKERFILE_PATH"



docker build -t socks5 .
docker run \
	-d \
	--restart unless-stopped \
	-p 8088:1080 \
	socks5
