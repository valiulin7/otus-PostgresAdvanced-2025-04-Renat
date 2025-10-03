CREATE DATABASE BINANCE;

CREATE TABLE public.binance_klines (
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
	CONSTRAINT binance_klines_pkey PRIMARY KEY (id),
	CONSTRAINT binance_klines_ticker_interval_open_time_key UNIQUE (ticker, "interval", open_time)
);