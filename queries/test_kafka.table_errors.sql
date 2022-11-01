CREATE DATABASE IF NOT EXISTS test_kafka;

-- Error handling
CREATE MATERIALIZED VIEW IF NOT EXISTS test_kafka.errors_mv TO test_kafka.table_errors AS
SELECT _topic       AS topic,
       _partition   AS partition,
       _offset      AS offset,
       _raw_message AS raw,
       _error       AS error
FROM test_kafka.table_kafka
WHERE length(_error) > 0;

CREATE TABLE IF NOT EXISTS test_kafka.table_errors
(
    event_time  DateTime DEFAULT now(),
    `topic`     String,
    `partition` Int64,
    `offset`    Int64,
    `raw`       String,
    `error`     String
)
    ENGINE = MergeTree
        ORDER BY (event_time)
        TTL event_time + INTERVAL 7 day;
