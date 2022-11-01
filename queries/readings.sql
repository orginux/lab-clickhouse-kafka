CREATE DATABASE IF NOT EXISTS test_kafka;

-- Main table
CREATE TABLE IF NOT EXISTS test_kafka.table_mt (
    id Int32 Codec(DoubleDelta, LZ4),
    time DateTime Codec(DoubleDelta, LZ4),
    date ALIAS toDate(time),
    second_id Decimal(5,2) Codec(T64, LZ4)
) Engine = MergeTree
PARTITION BY toYYYYMM(time)
ORDER BY (id, time);

CREATE TABLE IF NOT EXISTS test_kafka.table_kafka (
    id Int32,
    time DateTime,
    second_id Decimal(5,2)
)
ENGINE = Kafka
SETTINGS kafka_broker_list = 'kafka:9092',
       kafka_topic_list = 'readings',
       kafka_group_name = 'readings_consumer_group1',
       kafka_format = 'CSV',
       kafka_max_block_size = 1048576,
       kafka_handle_error_mode='stream';

CREATE MATERIALIZED VIEW IF NOT EXISTS test_kafka.kafka_to_table TO test_kafka.table_mt AS
SELECT id, time, second_id
FROM test_kafka.table_kafka;
