#!/bin/bash

# Parameters
PG_HOST="192.168.1.74"
PG_PORT="5432"
PG_DB="binance_a"
PG_USER="postgres"
PG_PASS="password"
TABLE_SOURCE="binance_a_klines"
TABLE_TARGET="binance_ch.binance_klines_ch"
CLICKHOUSE_HOST="192.168.1.76"
LOG_FILE="migrate_log.txt"

> $LOG_FILE

# Get list of partition tables
echo "Getting partition tables..." | tee -a $LOG_FILE
PARTITIONS=$(psql "postgresql://$PG_USER:$PG_PASS@$PG_HOST:$PG_PORT/$PG_DB" -t -c \
    "SELECT inhrelid::regclass::text 
     FROM pg_inherits 
     WHERE inhparent = '$TABLE_SOURCE'::regclass 
     ORDER BY inhrelid::regclass::text;")

# If no partitions found, use the main table
if [ -z "$PARTITIONS" ]; then
    PARTITIONS="$TABLE_SOURCE"
fi

BATCH_NUM=1
echo "$PARTITIONS" | while read -r PARTITION; do
    echo "Processing batch $BATCH_NUM (partition: $PARTITION)..." | tee -a $LOG_FILE
    
    # Migrate data from partition
    psql "postgresql://$PG_USER:$PG_PASS@$PG_HOST:$PG_PORT/$PG_DB" -c \
        "COPY (SELECT * FROM $PARTITION ORDER BY open_time) TO STDOUT WITH CSV" | \
    clickhouse-client --query="INSERT INTO $TABLE_TARGET FORMAT CSV" 2>>$LOG_FILE
    
    if [ $? -eq 0 ]; then
        echo "Batch $BATCH_NUM inserted successfully." | tee -a $LOG_FILE
    else
        echo "Error in batch $BATCH_NUM. Cleaning and retrying..." | tee -a $LOG_FILE
        
        # Retry
        psql "postgresql://$PG_USER:$PG_PASS@$PG_HOST:$PG_PORT/$PG_DB" -c \
            "COPY (SELECT * FROM $PARTITION ORDER BY open_time) TO STDOUT WITH CSV" | \
        clickhouse-client --query="INSERT INTO $TABLE_TARGET FORMAT CSV" 2>>$LOG_FILE
        
        if [ $? -eq 0 ]; then
            echo "Batch $BATCH_NUM retry successful." | tee -a $LOG_FILE
        else
            echo "Error in batch $BATCH_NUM after retry." | tee -a $LOG_FILE
            exit 1
        fi
    fi
    
    ((BATCH_NUM++))
    sleep 2
done

echo "Migration completed!" | tee -a $LOG_FILE