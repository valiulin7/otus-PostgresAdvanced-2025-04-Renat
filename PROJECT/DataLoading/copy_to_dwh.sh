#!/bin/bash

SOURCE_HOST="192.168.1.73"
SOURCE_PORT="7433"
SOURCE_DB="binance"
SOURCE_USER="postgres"
SOURCE_PASSWORD="password"

TARGET_HOST="192.168.1.74"
TARGET_PORT="5432"
TARGET_DB="binance_a"
TARGET_USER="postgres"
TARGET_PASSWORD="password"

BATCH_SIZE=100000

source_psql() {
    PGPASSWORD="$SOURCE_PASSWORD" psql -h "$SOURCE_HOST" -p "$SOURCE_PORT" -d "$SOURCE_DB" -U "$SOURCE_USER" -At -c "$1"
}

target_psql() {
    PGPASSWORD="$TARGET_PASSWORD" psql -h "$TARGET_HOST" -p "$TARGET_PORT" -d "$TARGET_DB" -U "$TARGET_USER" -c "$1"
}

TOTAL_ROWS=$(source_psql "SELECT COUNT(*) FROM binance_klines;")
echo "Total rows to transfer: $TOTAL_ROWS"

# Проверка на пустоту
if [ -z "$TOTAL_ROWS" ]; then
    echo "Error: Could not retrieve total rows. Check source DB connection."
    exit 1
fi

OFFSET=0
while [ "$OFFSET" -lt "$TOTAL_ROWS" ]; do
    echo "Processing batch starting at offset $OFFSET"

    # Create a temporary file for the CSV data
    TEMP_CSV=$(mktemp)
    
    # Extract data from source to temporary file
    PGPASSWORD="$SOURCE_PASSWORD" psql -h "$SOURCE_HOST" -p "$SOURCE_PORT" -d "$SOURCE_DB" -U "$SOURCE_USER" -c "\
        COPY (SELECT id, ticker, interval, year, month, open_time, open_price, high_price, low_price, close_price, volume, close_time, quote_asset_volume, number_of_trades, taker_buy_base_asset_volume, taker_buy_quote_asset_volume, unused_field \
              FROM binance_klines ORDER BY id LIMIT $BATCH_SIZE OFFSET $OFFSET) TO STDOUT WITH CSV" > "$TEMP_CSV"

    # Check if we got any data
    if [ ! -s "$TEMP_CSV" ]; then
        echo "No data retrieved for offset $OFFSET, skipping..."
        rm "$TEMP_CSV"
        OFFSET=$((OFFSET + BATCH_SIZE))
        continue
    fi

    # Load data into target using the temporary file
    target_psql "
    BEGIN;
    
    DROP TABLE IF EXISTS temp_binance_klines;
    CREATE TEMP TABLE temp_binance_klines (
        id INTEGER,
        ticker VARCHAR(20),
        interval VARCHAR(10),
        year INTEGER,
        month INTEGER,
        open_time BIGINT,
        open_price DECIMAL(20, 8),
        high_price DECIMAL(20, 8),
        low_price DECIMAL(20, 8),
        close_price DECIMAL(20, 8),
        volume DECIMAL(30, 8),
        close_time BIGINT,
        quote_asset_volume DECIMAL(30, 8),
        number_of_trades INTEGER,
        taker_buy_base_asset_volume DECIMAL(20, 8),
        taker_buy_quote_asset_volume DECIMAL(20, 8),
        unused_field VARCHAR(10)
    );

    COPY temp_binance_klines FROM STDIN WITH CSV;
    
    INSERT INTO binance_a_klines (id, ticker, interval, year, month, open_time, open_price, high_price, low_price, close_price, volume, close_time, quote_asset_volume, number_of_trades, taker_buy_base_asset_volume, taker_buy_quote_asset_volume, unused_field)
    SELECT id, ticker, interval, year, month, open_time, open_price, high_price, low_price, close_price, volume, close_time, quote_asset_volume, number_of_trades, taker_buy_base_asset_volume, taker_buy_quote_asset_volume, unused_field
    FROM temp_binance_klines
    ON CONFLICT (ticker, interval, open_time) DO NOTHING;
    
    COMMIT;
    " < "$TEMP_CSV"

    # Clean up temporary file
    rm "$TEMP_CSV"

    echo "Transferred batch of up to $BATCH_SIZE rows (offset $OFFSET)"
    OFFSET=$((OFFSET + BATCH_SIZE))
done

echo "Data transfer complete."