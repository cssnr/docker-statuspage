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
if [[ -n "${SETTING_THEME}" ]];then
    SETTING_THEME=$(echo "${SETTING_THEME}" | tr '[:upper:]' '[:lower:]')
    if [[ -f "source/themes/${SETTING_THEME}.min.css" ]];then
        cp -f "source/themes/${SETTING_THEME}.min.css" "${DATA_DIR}/html/static/bootstrap.min.css"
        echo "Using theme: ${SETTING_THEME}"
    else
        echo "Theme file source/themes/${SETTING_THEME}.min.css not found, using default."
    fi
fi
ls -Ral "${DATA_DIR}/html"

echo "Starting loop..."
while true;do
    pgrep nginx >/dev/null || exit 1
    python3 -u status.py
    sleep 60
done
