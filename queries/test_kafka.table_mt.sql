CREATE DATABASE IF NOT EXISTS test_kafka ON CLUSTER '{cluster}';

-- Main table
CREATE TABLE IF NOT EXISTS test_kafka.table_mt ON CLUSTER '{cluster}'(
    id Int32 Codec(DoubleDelta, LZ4),
    time DateTime Codec(DoubleDelta, LZ4),
    date ALIAS toDate(time),
    second_id Decimal(5,2) Codec(T64, LZ4)
) ENGINE = ReplicatedMergeTree('/clickhouse/tables/{shard}/test_kafka/table_mt', '{replica}')
PARTITION BY toYYYYMM(time)
ORDER BY (id, time);

CREATE TABLE IF NOT EXISTS test_kafka.table_distributed ON CLUSTER '{cluster}' AS test_kafka.table_mt
ENGINE = Distributed('{cluster}', test_kafka, table_mt, rand());

-- DROP TABLE IF EXISTS test_kafka.table_kafka ON CLUSTER '{cluster}';
CREATE TABLE IF NOT EXISTS test_kafka.table_kafka ON CLUSTER '{cluster}'(
    id Int32,
    time DateTime,
    second_id Decimal(5,2)
)
ENGINE = Kafka
SETTINGS kafka_broker_list = 'kafka:9092',
       kafka_topic_list = 'ids',
       kafka_group_name = 'ids_ch',
       kafka_format = 'JSONEachRow',
       kafka_max_block_size = 1000000,     -- The maximum batch size (in messages) for poll
       kafka_poll_timeout_ms = 1000,       -- Timeout for single poll from Kafka
       kafka_handle_error_mode = 'stream', -- Write error and message from Kafka itself to virtual columns: _error, _raw_message
       kafka_num_consumers = 4             -- The number of consumers. The total number of consumers should not exceed the number of partitions.
;

CREATE MATERIALIZED VIEW IF NOT EXISTS test_kafka.kafka_to_table ON CLUSTER '{cluster}' TO test_kafka.table_distributed AS
SELECT id, time, second_id
FROM test_kafka.table_kafka;
