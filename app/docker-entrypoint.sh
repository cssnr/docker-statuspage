#!/usr/bin/env bash

set -e

echo "Checking for DATA_DIR."
[[ -z "${DATA_DIR}" ]] && export DATA_DIR="/data"
DATA_DIR=$(echo ${DATA_DIR} | sed 's|/$||')
echo "Using: ${DATA_DIR}"

echo "Starting nginx..."
sed -i "s|DATA_DIR|${DATA_DIR}|" /etc/nginx/nginx.conf
bash gen-cert.sh
nginx

echo "Copying static..."
mkdir -p "${DATA_DIR}/html"
cp -r source/static "${DATA_DIR}/html"
ls -Ral "${DATA_DIR}/html"

echo "Starting loop..."
while true;do
    pgrep nginx >/dev/null || exit 1
    python3 -u status.py
    sleep 60
done
