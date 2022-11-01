CREATE DATABASE IF NOT EXISTS test_kafka ON CLUSTER '{cluster}';

-- Main table
CREATE TABLE IF NOT EXISTS test_kafka.table_mt ON CLUSTER '{cluster}'(
    id Int32 Codec(DoubleDelta, LZ4),
    time DateTime Codec(DoubleDelta, LZ4),
    date ALIAS toDate(time),
    second_id Decimal(5,2) Codec(T64, LZ4)
) Engine = ReplicatedMergeTree('/clickhouse/tables/test_kafka/table_mt', '{replica}')
PARTITION BY toYYYYMM(time)
ORDER BY (id, time);

CREATE TABLE test_kafka.table_distributed ON CLUSTER '{cluster}' AS test_kafka.table_mt
ENGINE = Distributed('{cluster}', test_kafka, table_mt, rand());

CREATE TABLE IF NOT EXISTS test_kafka.table_kafka ON CLUSTER '{cluster}'(
    id Int32,
    time DateTime,
    second_id Decimal(5,2)
)
ENGINE = Kafka
SETTINGS kafka_broker_list = 'kafka:9092',
       kafka_topic_list = 'ids',
       kafka_group_name = 'ids_consumer_group1',
       kafka_format = 'CSV',
       kafka_max_block_size = 1048576,
       kafka_handle_error_mode='stream'; --  write error and message from Kafka itself to virtual columns: _error, _raw_message

CREATE MATERIALIZED VIEW IF NOT EXISTS test_kafka.kafka_to_table ON CLUSTER '{cluster}' TO test_kafka.table_mt AS
SELECT id, time, second_id
FROM test_kafka.table_kafka;
