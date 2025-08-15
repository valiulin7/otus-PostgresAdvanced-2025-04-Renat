#!/bin/bash

VIP="192.168.1.100"
HAPROXY_IP="192.168.1.73"
HAPROXY_PORT="7432"  # Добавлен порт HAProxy

# 1. Проверяем доступность HAProxy через PostgreSQL порт
if ! PGPASSWORD=password psql -h $HAPROXY_IP -p $HAPROXY_PORT -U postgres -c "SELECT 1" >/dev/null 2>&1; then
    echo "HAProxy/PostgreSQL недоступен на порту $HAPROXY_PORT" >&2
    # HAProxy не отвечает - продолжаем проверку
else
    # HAProxy доступен (значит VIP еще активен) - ничего не делаем
    echo "HAProxy доступен - VIP еще активен" >&2
    exit 1
fi

# 2. Проверяем статус репликации
if PGPASSWORD=password psql -h 127.0.0.1 -p 7432 -U postgres -c "SELECT pg_is_in_recovery()" | grep -q "t"; then
    echo "VIP свободен, мы в режиме standby - выполняем promote" >&2
    # Выполняем promote
    if ! PGPASSWORD=password psql -h 127.0.0.1 -p 7432 -U postgres -c "SELECT pg_promote()"; then
        echo "Ошибка при выполнении promote" >&2
        exit 1
    fi
    sleep 5 # Даем время на промоут
fi

# 3. Проверяем что мы теперь мастер
if PGPASSWORD=password psql -h 127.0.0.1 -p 7432 -U postgres -c "SELECT pg_is_in_recovery()" | grep -q "f"; then
    echo "Мы теперь мастер - можем держать VIP" >&2
    exit 0
else
    echo "Промоут не удался" >&2
    exit 1
fi
