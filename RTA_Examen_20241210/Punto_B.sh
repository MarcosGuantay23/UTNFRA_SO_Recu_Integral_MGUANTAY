#!/bin/bash

sudo mkdir -p /tmp/head-check/Error/cliente /tmp/head-check/Error/servidor /tmp/head-check/ok

tree /tmp/head-check

cat << 'EOF' | sudo tee /usr/local/bin/guantaycheck_URL.sh > /dev/null
#!/bin/bash

sudo mkdir -p /tmp/head-check/Error/cliente /tmp/head-check/Error/servidor /tmp/head-check/ok

tree /tmp/head-check

URL_LIST="UTN-FRA_SO_EXAMENES/202411/bash_script/Lista_URL.txt"

LOG_FILE="/var/log/status_URL.log"

"$LOG_FILE"

while IFS= read -r URL; do

    TIMESTAMP=$(date +"%Y%m%d%H%M%S")

    STATUS_CODE=$(curl -LI -o /dev/null -w '%{http_code}' -s "$URL")

    echo "$TIMESTAMP - Code:$STATUS_CODE - URL:$URL" >> "$LOG_FILE"

    DOMAIN=$(echo "$URL" | awk -F/ '{print $3}')

    if [[ "$STATUS_CODE" -eq 200 ]]; then
        echo "$TIMESTAMP - Code:$STATUS_CODE - URL:$URL" > "/tmp/head-check/ok/$DOMAIN.log"
    elif [[ "$STATUS_CODE" -ge 400 && "$STATUS_CODE" -lt 500 ]]; then
        echo "$TIMESTAMP - Code:$STATUS_CODE - URL:$URL" > "/tmp/head-check/Error/cliente/$DOMAIN.log"
    elif [[ "$STATUS_CODE" -ge 500 && "$STATUS_CODE" -lt 600 ]]; then
        echo "$TIMESTAMP - Code:$STATUS_CODE - URL:$URL" > "/tmp/head-check/Error/servidor/$DOMAIN.log"
    fi
done < "$URL_LIST"
EOF

sudo chmod +x /usr/local/bin/guantay_check_URL.sh
