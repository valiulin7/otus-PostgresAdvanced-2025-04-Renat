clickhouse-client --query="SELECT * FROM test_10gb INTO OUTFILE 'test_10gb.csv.zst' COMPRESSION 'zstd' FORMAT CSVWithNames"

/usr/bin/time -v clickhouse-client \
  --query="INSERT INTO test_10gb FROM INFILE '/tmp/test_10gb.csv.zst' COMPRESSION 'zstd' FORMAT CSV" \
  2>&1 | tee insert.log
