-- Main table
CREATE TABLE IF NOT EXISTS readings (
    readings_id Int32 Codec(DoubleDelta, LZ4),
    time DateTime Codec(DoubleDelta, LZ4),
    date ALIAS toDate(time),
    temperature Decimal(5,2) Codec(T64, LZ4)
) Engine = MergeTree
PARTITION BY toYYYYMM(time)
ORDER BY (readings_id, time);

CREATE TABLE IF NOT EXISTS readings_queue (
    readings_id Int32,
    time DateTime,
    temperature Decimal(5,2)
)
ENGINE = Kafka
SETTINGS kafka_broker_list = 'kafka:9092',
       kafka_topic_list = 'readings',
       kafka_group_name = 'readings_consumer_group1',
       kafka_format = 'CSV',
       kafka_max_block_size = 1048576,
       kafka_handle_error_mode='stream';

CREATE MATERIALIZED VIEW IF NOT EXISTS readings_queue_mv TO readings AS
SELECT readings_id, time, temperature
FROM readings_queue;
