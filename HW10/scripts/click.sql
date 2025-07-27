CREATE TABLE default.test_10gb
(
    `id` UInt64,
    `event_date` Date,
    `event_time` DateTime,
    `value` Float64,
    `category` FixedString(1),

    PROJECTION category_stats_proj
    (
        SELECT
            event_date,
            category,
            sum(value) AS total_value,
            count() AS count_events
        GROUP BY
            event_date,
            category
    )
)
ENGINE = MergeTree
ORDER BY (event_time, id)
SETTINGS index_granularity = 8192;

CREATE TABLE category_dict_source
(
    category String,
    category_full String
) ENGINE = MergeTree()
ORDER BY category;

INSERT INTO category_dict_source VALUES
('A', 'A_full_description'),
('B', 'B_full_description'),
('C', 'C_full_description'),
('D', 'D_full_description');

CREATE DICTIONARY category_dict
(
    category String,
    category_full String
)
PRIMARY KEY category
SOURCE(CLICKHOUSE(
    TABLE 'category_dict_source'
    USER 'default'
    PASSWORD ''
))
LAYOUT(COMPLEX_KEY_HASHED())
LIFETIME(0);

SELECT * FROM category_dict;

INSERT INTO test_10gb
SELECT
    number AS id,
    toDate('2023-01-01') + number % 365 AS event_date,
    toDateTime('2023-01-01 00:00:00') + number % 86400 AS event_time,
    randDouble64(0, 1000) AS value,
    arrayElement(['A','B','C','D'], number % 4 + 1) AS category
FROM numbers(398000000);


SELECT 
    t.*,
    dictGetString('category_dict', 'category_full', t.category) AS category_full
FROM test_10gb t
ORDER BY t.event_time DESC
LIMIT 100;

SELECT t.query_duration_ms, t.`type`, t.read_bytes, t.memory_usage, *
FROM system.query_log t
WHERE 1=1
AND query_id = '28b6ef5f-38e1-4774-8142-409f959f10f6'
AND  t.`type` = 'QueryFinish';



SELECT 
    t.category,
    dictGetString('category_dict', 'category_full', t.category) AS category_full,
    SUM(t.value) AS total_value
FROM test_10gb t
WHERE t.event_date > '2023-01-01' AND t.event_date < '2023-04-04'
GROUP BY t.category
ORDER BY total_value DESC;

SELECT t.query_duration_ms, t.`type`, t.read_bytes, t.memory_usage, *
FROM system.query_log t
WHERE 1=1
AND query_id = '302ae80c-9aaa-4740-b0a5-6a0d4d2faa51'
AND  t.`type` = 'QueryFinish';