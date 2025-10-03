CREATE DATABASE BINANCE_CH;

CREATE TABLE binance_ch.binance_klines_ch (
    id UInt64,
    ticker String,
    interval String,
    year UInt16,
    month UInt8,
    open_time Int64,
    open_price Decimal(20, 8),
    high_price Decimal(20, 8),
    low_price Decimal(20, 8),
    close_price Decimal(20, 8),
    volume Decimal(30, 8),
    close_time Int64,
    quote_asset_volume Decimal(30, 8),
    number_of_trades UInt32,
    taker_buy_base_asset_volume Decimal(30, 8),
    taker_buy_quote_asset_volume Decimal(30, 8),
    unused_field String
) ENGINE = ReplacingMergeTree()
PARTITION BY (year, month)
ORDER BY (ticker, interval, open_time) 
SETTINGS index_granularity = 8192;


CREATE TABLE binance_ch.ema_values
(

    `ticker` String,

    `date` Date,

    `daily_close` Decimal(30,
 8),

    `ema_7` Decimal(30,
 8),

    `ema_9` Decimal(30,
 8),

    `ema_20` Decimal(30,
 8),

    `deviation_from_ema_7_percent` Decimal(20,
 4),

    `deviation_from_ema_9_percent` Decimal(20,
 4),

    `deviation_from_ema_20_percent` Decimal(20,
 4),

    `calculation_time` DateTime DEFAULT now()
)
ENGINE = MergeTree
PARTITION BY toYYYYMM(date)
ORDER BY (ticker,
 date)
SETTINGS index_granularity = 8192;

CREATE TABLE binance_ch.daily_sma
(
    `ticker` String,
    `date` Date,
    `daily_close` Decimal(20, 8),
    `sma_7_days` Float64,
    `sma_30_days` Float64,
    `deviation_from_30d_sma_percent` Nullable(Float64),
    `calculation_time` DateTime
)
ENGINE = MergeTree
PARTITION BY toYYYYMM(date)
ORDER BY (ticker, date)
SETTINGS index_granularity = 8192;

CREATE MATERIALIZED VIEW binance_ch.daily_sma_mv
TO binance_ch.daily_sma
AS
WITH daily_close_price AS
(
    SELECT
        ticker,
        toDate(toDateTime(open_time / 1000)) AS date,
        argMax(close_price, open_time) AS daily_close
    FROM binance_ch.binance_klines_ch
    GROUP BY
        ticker,
        toDate(toDateTime(open_time / 1000))
)
SELECT
    ticker,
    date,
    daily_close,
    avg(daily_close) OVER (PARTITION BY ticker ORDER BY date ASC ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS sma_7_days,
    avg(daily_close) OVER (PARTITION BY ticker ORDER BY date ASC ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS sma_30_days,
    ((daily_close - avg(daily_close) OVER (PARTITION BY ticker ORDER BY date ASC ROWS BETWEEN 29 PRECEDING AND CURRENT ROW)) / nullIf(avg(daily_close) OVER (PARTITION BY ticker ORDER BY date ASC ROWS BETWEEN 29 PRECEDING AND CURRENT ROW), 0)) * 100 AS deviation_from_30d_sma_percent,
    now() AS calculation_time
FROM daily_close_price;


INSERT INTO binance_ch.daily_sma
SELECT
    ticker,
    date,
    daily_close,
    avg(daily_close) OVER (PARTITION BY ticker ORDER BY date ASC ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS sma_7_days,
    avg(daily_close) OVER (PARTITION BY ticker ORDER BY date ASC ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS sma_30_days,
    ((daily_close - avg(daily_close) OVER (PARTITION BY ticker ORDER BY date ASC ROWS BETWEEN 29 PRECEDING AND CURRENT ROW)) / nullIf(avg(daily_close) OVER (PARTITION BY ticker ORDER BY date ASC ROWS BETWEEN 29 PRECEDING AND CURRENT ROW), 0)) * 100 AS deviation_from_30d_sma_percent,
    now() AS calculation_time
FROM
(
    SELECT
        ticker,
        toDate(toDateTime(open_time / 1000)) AS date,
        argMax(close_price, open_time) AS daily_close
    FROM binance_ch.binance_klines_ch
    GROUP BY
        ticker,
        toDate(toDateTime(open_time / 1000))
);