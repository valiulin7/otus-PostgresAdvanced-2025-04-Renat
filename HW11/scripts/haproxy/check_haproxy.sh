#!/bin/bash

HAPROXY_PORT="7432"

# 1. Проверка подключения к PostgreSQL через HAProxy
if ! PGPASSWORD=password psql -h 127.0.0.1 -p $HAPROXY_PORT -U postgres -c "SELECT 1" >/dev/null 2>&1; then
    echo "HAProxy/PostgreSQL недоступен на порту $HAPROXY_PORT" >&2
    exit 1
fi

# 2. Проверка процесса HAProxy
if ! pgrep -x haproxy >/dev/null; then
    echo "Процесс HAProxy не работает" >&2
    exit 1
fi

# 3. Проверка страницы статистики
if ! curl -sSf "http://127.0.0.1:7000/" >/dev/null 2>&1; then
    echo "Страница статистики HAProxy недоступна" >&2
    exit 1
fi

exit 0
