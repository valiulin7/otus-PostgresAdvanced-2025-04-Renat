clickhouse-client --query="SELECT * FROM test_10gb INTO OUTFILE 'test_10gb.csv.zst' COMPRESSION 'zstd' FORMAT CSVWithNames"

/usr/bin/time -v clickhouse-client \
  --query="INSERT INTO test_10gb FROM INFILE '/tmp/test_10gb.csv.zst' COMPRESSION 'zstd' FORMAT CSV" \
  2>&1 | tee insert.log


sudo -u postgres psql -d postgres <<EOF
\timing on
\set VERBOSITY verbose
EXPLAIN (ANALYZE, BUFFERS, VERBOSE, FORMAT JSON)
SELECT
    t.*,
    cd.category_full
FROM
    test_10gb t
LEFT JOIN
    category_dict cd ON t.category = cd.category
ORDER BY
    t.event_time DESC
LIMIT 100;
EOF

sudo -u postgres psql -d postgres <<EOF
\timing on
\set VERBOSITY verbose
EXPLAIN (ANALYZE, BUFFERS, VERBOSE, FORMAT JSON)
SELECT 
    category,
    category_full,
    SUM(total_value) AS total_value
FROM 
    test_10gb_category_stats
WHERE 
    event_date > '2023-01-01' 
    AND event_date < '2023-04-04'
GROUP BY 
    category, category_full
ORDER BY 
    total_value DESC;
EOF
