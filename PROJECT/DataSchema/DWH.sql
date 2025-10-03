CREATE DATABASE BINANCE_A;

CREATE TABLE public.binance_a_klines (
	id serial4 NOT NULL,
	ticker varchar(20) NOT NULL,
	"interval" varchar(10) NOT NULL,
	"year" int4 NOT NULL,
	"month" int4 NOT NULL,
	open_time int8 NOT NULL,
	open_price numeric(20, 8) NOT NULL,
	high_price numeric(20, 8) NOT NULL,
	low_price numeric(20, 8) NOT NULL,
	close_price numeric(20, 8) NOT NULL,
	volume numeric(30, 8) NOT NULL,
	close_time int8 NOT NULL,
	quote_asset_volume numeric(30, 8) NOT NULL,
	number_of_trades int4 NOT NULL,
	taker_buy_base_asset_volume numeric(30, 8) NOT NULL,
	taker_buy_quote_asset_volume numeric(30, 8) NOT NULL,
	unused_field varchar(10) NULL,
	CONSTRAINT binance_a_klines_pkey PRIMARY KEY (ticker, "interval", open_time),
	CONSTRAINT binance_a_klines_ticker_interval_open_time_key UNIQUE (ticker, "interval", open_time)
)
PARTITION BY RANGE (open_time);

-- Partitions

CREATE TABLE public.binance_a_klines_2020_01 PARTITION OF public.binance_a_klines  FOR VALUES FROM ('1577836800000') TO ('1580515200000');
CREATE INDEX binance_a_klines_2020_01_open_time_idx ON public.binance_a_klines_2020_01 USING btree (open_time);
CREATE INDEX binance_a_klines_2020_01_ticker_interval_open_time_idx ON public.binance_a_klines_2020_01 USING btree (ticker, "interval", open_time);
CREATE INDEX binance_a_klines_2020_01_ticker_open_time_idx ON public.binance_a_klines_2020_01 USING btree (ticker, open_time);

CREATE TABLE public.binance_a_klines_2020_02 PARTITION OF public.binance_a_klines  FOR VALUES FROM ('1580515200000') TO ('1583020800000');
CREATE INDEX binance_a_klines_2020_02_open_time_idx ON public.binance_a_klines_2020_02 USING btree (open_time);
CREATE INDEX binance_a_klines_2020_02_ticker_interval_open_time_idx ON public.binance_a_klines_2020_02 USING btree (ticker, "interval", open_time);
CREATE INDEX binance_a_klines_2020_02_ticker_open_time_idx ON public.binance_a_klines_2020_02 USING btree (ticker, open_time);

CREATE TABLE public.binance_a_klines_2020_03 PARTITION OF public.binance_a_klines  FOR VALUES FROM ('1583020800000') TO ('1585699200000');
CREATE INDEX binance_a_klines_2020_03_open_time_idx ON public.binance_a_klines_2020_03 USING btree (open_time);
CREATE INDEX binance_a_klines_2020_03_ticker_interval_open_time_idx ON public.binance_a_klines_2020_03 USING btree (ticker, "interval", open_time);
CREATE INDEX binance_a_klines_2020_03_ticker_open_time_idx ON public.binance_a_klines_2020_03 USING btree (ticker, open_time);

CREATE TABLE public.binance_a_klines_2020_04 PARTITION OF public.binance_a_klines  FOR VALUES FROM ('1585699200000') TO ('1588291200000');
CREATE INDEX binance_a_klines_2020_04_open_time_idx ON public.binance_a_klines_2020_04 USING btree (open_time);
CREATE INDEX binance_a_klines_2020_04_ticker_interval_open_time_idx ON public.binance_a_klines_2020_04 USING btree (ticker, "interval", open_time);
CREATE INDEX binance_a_klines_2020_04_ticker_open_time_idx ON public.binance_a_klines_2020_04 USING btree (ticker, open_time);

CREATE TABLE public.binance_a_klines_2020_05 PARTITION OF public.binance_a_klines  FOR VALUES FROM ('1588291200000') TO ('1590969600000');
CREATE INDEX binance_a_klines_2020_05_open_time_idx ON public.binance_a_klines_2020_05 USING btree (open_time);
CREATE INDEX binance_a_klines_2020_05_ticker_interval_open_time_idx ON public.binance_a_klines_2020_05 USING btree (ticker, "interval", open_time);
CREATE INDEX binance_a_klines_2020_05_ticker_open_time_idx ON public.binance_a_klines_2020_05 USING btree (ticker, open_time);

CREATE TABLE public.binance_a_klines_2020_06 PARTITION OF public.binance_a_klines  FOR VALUES FROM ('1590969600000') TO ('1593561600000');
CREATE INDEX binance_a_klines_2020_06_open_time_idx ON public.binance_a_klines_2020_06 USING btree (open_time);
CREATE INDEX binance_a_klines_2020_06_ticker_interval_open_time_idx ON public.binance_a_klines_2020_06 USING btree (ticker, "interval", open_time);
CREATE INDEX binance_a_klines_2020_06_ticker_open_time_idx ON public.binance_a_klines_2020_06 USING btree (ticker, open_time);

CREATE TABLE public.binance_a_klines_2020_07 PARTITION OF public.binance_a_klines  FOR VALUES FROM ('1593561600000') TO ('1596240000000');
CREATE INDEX binance_a_klines_2020_07_open_time_idx ON public.binance_a_klines_2020_07 USING btree (open_time);
CREATE INDEX binance_a_klines_2020_07_ticker_interval_open_time_idx ON public.binance_a_klines_2020_07 USING btree (ticker, "interval", open_time);
CREATE INDEX binance_a_klines_2020_07_ticker_open_time_idx ON public.binance_a_klines_2020_07 USING btree (ticker, open_time);

CREATE TABLE public.binance_a_klines_2020_08 PARTITION OF public.binance_a_klines  FOR VALUES FROM ('1596240000000') TO ('1598918400000');
CREATE INDEX binance_a_klines_2020_08_open_time_idx ON public.binance_a_klines_2020_08 USING btree (open_time);
CREATE INDEX binance_a_klines_2020_08_ticker_interval_open_time_idx ON public.binance_a_klines_2020_08 USING btree (ticker, "interval", open_time);
CREATE INDEX binance_a_klines_2020_08_ticker_open_time_idx ON public.binance_a_klines_2020_08 USING btree (ticker, open_time);

CREATE TABLE public.binance_a_klines_2020_09 PARTITION OF public.binance_a_klines  FOR VALUES FROM ('1598918400000') TO ('1601510400000');
CREATE INDEX binance_a_klines_2020_09_open_time_idx ON public.binance_a_klines_2020_09 USING btree (open_time);
CREATE INDEX binance_a_klines_2020_09_ticker_interval_open_time_idx ON public.binance_a_klines_2020_09 USING btree (ticker, "interval", open_time);
CREATE INDEX binance_a_klines_2020_09_ticker_open_time_idx ON public.binance_a_klines_2020_09 USING btree (ticker, open_time);

CREATE TABLE public.binance_a_klines_2020_10 PARTITION OF public.binance_a_klines  FOR VALUES FROM ('1601510400000') TO ('1604188800000');
CREATE INDEX binance_a_klines_2020_10_open_time_idx ON public.binance_a_klines_2020_10 USING btree (open_time);
CREATE INDEX binance_a_klines_2020_10_ticker_interval_open_time_idx ON public.binance_a_klines_2020_10 USING btree (ticker, "interval", open_time);
CREATE INDEX binance_a_klines_2020_10_ticker_open_time_idx ON public.binance_a_klines_2020_10 USING btree (ticker, open_time);

CREATE TABLE public.binance_a_klines_2020_11 PARTITION OF public.binance_a_klines  FOR VALUES FROM ('1604188800000') TO ('1606780800000');
CREATE INDEX binance_a_klines_2020_11_open_time_idx ON public.binance_a_klines_2020_11 USING btree (open_time);
CREATE INDEX binance_a_klines_2020_11_ticker_interval_open_time_idx ON public.binance_a_klines_2020_11 USING btree (ticker, "interval", open_time);
CREATE INDEX binance_a_klines_2020_11_ticker_open_time_idx ON public.binance_a_klines_2020_11 USING btree (ticker, open_time);

CREATE TABLE public.binance_a_klines_2020_12 PARTITION OF public.binance_a_klines  FOR VALUES FROM ('1606780800000') TO ('1609459200000');
CREATE INDEX binance_a_klines_2020_12_open_time_idx ON public.binance_a_klines_2020_12 USING btree (open_time);
CREATE INDEX binance_a_klines_2020_12_ticker_interval_open_time_idx ON public.binance_a_klines_2020_12 USING btree (ticker, "interval", open_time);
CREATE INDEX binance_a_klines_2020_12_ticker_open_time_idx ON public.binance_a_klines_2020_12 USING btree (ticker, open_time);



CREATE TABLE public.daily_aggregation (
	ticker varchar(20) NOT NULL,
	trade_day date NOT NULL,
	day_open numeric(20, 8) NULL,
	day_high numeric(20, 8) NULL,
	day_low numeric(20, 8) NULL,
	day_close numeric(20, 8) NULL,
	day_volume numeric(30, 8) NULL,
	day_trades int4 NULL,
	absolute_range numeric(20, 8) NULL,
	percent_range numeric(10, 4) NULL,
	avg_daily_volatility_20d numeric(10, 4) NULL,
	calculation_time timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	CONSTRAINT daily_aggregation_pkey PRIMARY KEY (ticker, trade_day)
);

CREATE TABLE public.daily_sma (
	ticker varchar(20) NOT NULL,
	"date" date NOT NULL,
	daily_close numeric(20, 8) NULL,
	sma_7_days numeric(20, 8) NULL,
	sma_30_days numeric(20, 8) NULL,
	deviation_from_30d_sma_percent numeric(10, 4) NULL,
	calculation_time timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	CONSTRAINT daily_sma_pkey PRIMARY KEY (ticker, date)
);

CREATE TABLE public.volume_analysis (
	ticker varchar(20) NOT NULL,
	"date" date NOT NULL,
	total_daily_volume numeric(30, 8) NULL,
	total_buy_volume numeric(30, 8) NULL,
	total_quote_volume numeric(30, 8) NULL,
	buy_volume_percentage numeric(10, 4) NULL,
	avg_volume_20d numeric(30, 8) NULL,
	volume_ratio numeric(10, 4) NULL,
	volume_alert varchar(20) NULL,
	calculation_time timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	CONSTRAINT volume_analysis_pkey PRIMARY KEY (ticker, date)
);

