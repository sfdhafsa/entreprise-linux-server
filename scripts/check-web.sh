#!/usr/bin/env bash

url="${1:-http://192.168.18.129}"

if status=$(curl -s -o /dev/null -w '%{http_code}' \
    --connect-timeout 5 --max-time 10 "$url"); then
    if [[ "$status" == "200" ]]; then
        echo "OK: $url returned HTTP 200"
        exit 0
    fi

    echo "FAIL: $url returned HTTP $status"
    exit 1
else
    echo "FAIL: could not reach $url"
    exit 1
fi
