up:
	docker compose up -d

down:
	docker compose down

# Kafka
topic-create:
	docker exec kafka kafka-topics --bootstrap-server kafka:9092 --topic readings --create --partitions 6 --replication-factor 1
topic-check:
	docker exec kafka kafka-topics --bootstrap-server kafka:9092 --describe readings
topic-lag:
	docker exec kafka kafka-run-class kafka.admin.ConsumerGroupCommand --group readings_consumer_group1 --bootstrap-server kafka:9092 --describe
topic-produce-messages:
	docker exec kafka bash producer.sh

# ClickHouse
clickhouse-create-tables:
	docker exec clickhouse clickhouse-client --multiline --queries-file /tmp/queries/readings.sql
	docker exec clickhouse clickhouse-client --multiline --queries-file /tmp/queries/readings_errors.sql
clickhouse-messages-count:
	docker exec clickhouse clickhouse-client --query "select count() from readings"

# Prepare lab
create: up topic-create topic-check clickhouse-create-tables
