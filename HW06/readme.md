# Домашнее задание "Тюнинг Постгреса"

### Цель: Развернуть инстанс Постгреса в ВМ в ЯО. Оптимизировать настройки



##### Описание/Пошаговая инструкция выполнения домашнего задания:


1. Развернуть Постгрес на ВМ

![0c8dd7075c90258989628a8bf6600fe6.png](./0c8dd7075c90258989628a8bf6600fe6.png)

![5e79cc760c6a9da1cea37e30ddce3aad.png](./5e79cc760c6a9da1cea37e30ddce3aad.png)


2. Протестировать pg_bench

взял бд с https://postgrespro.ru/education/demodb
и вначале прогнал скрипт на сервере с настройками по умолчанию boarding_passes_test.sql

`SELECT min(ticket_no), max(ticket_no)
FROM (
  SELECT *
  FROM bookings.boarding_passes
  WHERE flight_id > 1000
  LIMIT 10000
) AS limited_passes
GROUP BY seat_no
ORDER BY seat_no;

SELECT min(ticket_no), max(ticket_no)
FROM (
  SELECT *
  FROM bookings.boarding_passes
  WHERE flight_id > 100000
  LIMIT 10000
) AS limited_passes
GROUP BY seat_no
ORDER BY seat_no;

SELECT min(ticket_no), max(ticket_no)
FROM (
  SELECT *
  FROM bookings.boarding_passes
  WHERE flight_id > 200000
  LIMIT 10000
) AS limited_passes
GROUP BY seat_no
ORDER BY seat_no;

BEGIN;
WITH rows_to_update AS (
    SELECT ctid
    FROM bookings.boarding_passes
    WHERE flight_id BETWEEN 0 AND 5000
    LIMIT 1000
)
UPDATE bookings.boarding_passes bp
SET seat_no = seat_no
FROM rows_to_update r
WHERE bp.ctid = r.ctid;
COMMIT;

BEGIN;
WITH rows_to_update AS (
    SELECT ctid
    FROM bookings.boarding_passes
    WHERE flight_id BETWEEN 70000 AND 80000
    LIMIT 1000
)
UPDATE bookings.boarding_passes bp
SET seat_no = seat_no
FROM rows_to_update r
WHERE bp.ctid = r.ctid;
COMMIT;

BEGIN;
WITH rows_to_update AS (
    SELECT ctid
    FROM bookings.boarding_passes
    WHERE flight_id BETWEEN 130000 AND 180000
    LIMIT 1000
)
UPDATE bookings.boarding_passes bp
SET seat_no = seat_no
FROM rows_to_update r
WHERE bp.ctid = r.ctid;
COMMIT;`

![8f7d9a3c81ccab2898a3f4fd75cb8798.png](./8f7d9a3c81ccab2898a3f4fd75cb8798.png)


3. Выставить оптимальные настройки

![6fa0872693720c02c6af08c289b2c8f4.png](./6fa0872693720c02c6af08c289b2c8f4.png)

![de699221655625c2c250d67e04a00e3b.png](./de699221655625c2c250d67e04a00e3b.png)

![db2b3cf9868550387d01f2a3ba12333f.png](./db2b3cf9868550387d01f2a3ba12333f.png)

4. Проверить насколько выросла производительность


![7a8635ebbca65777035ac7827dd972db.png](./7a8635ebbca65777035ac7827dd972db.png)

6. Настроить кластер на оптимальную производительность не обращая внимания на стабильность БД

![f074c6e5e1574dcb68663576618819a2.png](./f074c6e5e1574dcb68663576618819a2.png)

![39d9b0800f1ef6e7ff23509915c10dc6.png](./39d9b0800f1ef6e7ff23509915c10dc6.png)

