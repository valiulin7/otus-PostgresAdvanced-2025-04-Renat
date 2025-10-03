#!/bin/bash
# load_binance.sh

DB_HOST="192.168.1.100"
DB_PORT="7432"
DB_NAME="binance"
DB_USER="postgres"
DB_PASS="password"
DATA_DIR="/prj/binance_files/"

# Функция для обработки каждого файла
process_file() {
    local zip_file="$1"
    local base_name=$(basename "$zip_file" .zip)
    
    # Парсим компоненты из имени файла
    ticker=$(echo "$base_name" | cut -d'-' -f1)
    interval=$(echo "$base_name" | cut -d'-' -f2)
    year=$(echo "$base_name" | cut -d'-' -f3)
    month=$(echo "$base_name" | cut -d'-' -f4)
    
    echo "Processing: $zip_file"
    echo "Ticker: $ticker, Interval: $interval, Year: $year, Month: $month"
    
    # Создаем папку года если не существует
    local year_dir="$DATA_DIR/$year"
    if [ ! -d "$year_dir" ]; then
        mkdir -p "$year_dir"
        echo "Created directory: $year_dir"
    fi
    
    # Создаем временную таблицу и загружаем данные через pipe
    PGPASSWORD="$DB_PASS" psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" << EOF
    \\echo 'Loading data from $zip_file'
    
    CREATE TEMP TABLE temp_import (
        open_time BIGINT,
        open_price DECIMAL(20, 8),
        high_price DECIMAL(20, 8),
        low_price DECIMAL(20, 8),
        close_price DECIMAL(20, 8),
        volume DECIMAL(30, 8),
        close_time BIGINT,
        quote_asset_volume DECIMAL(30, 8),
        number_of_trades INTEGER,
        taker_buy_base_asset_volume DECIMAL(30, 8),
        taker_buy_quote_asset_volume DECIMAL(30, 8),
        unused_field TEXT
    );
    
    -- Загружаем данные напрямую из unzip через pipe
    \\copy temp_import FROM PROGRAM 'unzip -p "$zip_file" "${base_name}.csv"' WITH (FORMAT csv, DELIMITER ',');
    
    INSERT INTO binance_klines (
        ticker, interval, year, month,
        open_time, open_price, high_price, low_price, close_price, volume,
        close_time, quote_asset_volume, number_of_trades,
        taker_buy_base_asset_volume, taker_buy_quote_asset_volume, unused_field
    )
    SELECT 
        '$ticker', '$interval', $year, $month,
        open_time, open_price, high_price, low_price, close_price, volume,
        close_time, quote_asset_volume, number_of_trades,
        taker_buy_base_asset_volume, taker_buy_quote_asset_volume, unused_field
    FROM temp_import
    ON CONFLICT (ticker, interval, open_time) DO NOTHING;
    
    SELECT 'Loaded ' || COUNT(*) || ' records from $zip_file' FROM temp_import;
    
    DROP TABLE temp_import;
EOF

    # Перемещаем обработанный файл в папку года
    mv "$zip_file" "$year_dir/"
    echo "Moved $zip_file to $year_dir/"
}

# Основной цикл
export DB_HOST DB_PORT DB_NAME DB_USER DB_PASS DATA_DIR
export -f process_file

# Получаем общее количество файлов для обработки
total_files=$(find "$DATA_DIR" -name "*.zip" | wc -l)
processed_files=0

echo "Found $total_files files to process"
echo "=========================================="

# Обрабатываем все zip файлы
find "$DATA_DIR" -name "*.zip" -exec bash -c '
    process_file "$0"
    processed_files=$((processed_files + 1))
    remaining_files=$((total_files - processed_files))
    echo "Processed: $processed_files/$total_files, Remaining: $remaining_files"
    echo "------------------------------------------"
' {} \;

echo "All files processed!"
echo "=========================================="
echo "Total processed: $processed_files"
echo "Files moved to respective year directories"