up:
	docker compose up -d

down:
	docker compose down
	docker compose --file docker-compose-ktg.yml down

# Kafka
topic-create:
	docker exec kafka kafka-topics --bootstrap-server kafka:9092 --topic ids --create --partitions 4 --replication-factor 1
topic-check:
	docker exec kafka kafka-topics --bootstrap-server kafka:9092 --describe ids
topic-lag:
	docker exec kafka kafka-run-class kafka.admin.ConsumerGroupCommand --group ids_ch --bootstrap-server kafka:9092 --describe
topic-produce-messages:
	echo "Config file ./configs/ktg/config.yaml"
	docker compose --file docker-compose-ktg.yml up
topic-consumer:
	docker exec kafka kafka-console-consumer --bootstrap-server localhost:9092 --from-beginning --topic ids
topic-consumer-20:
	docker exec kafka kafka-console-consumer --bootstrap-server localhost:9092 --from-beginning --max-messages 20 --topic ids

# ClickHouse
clickhouse-create-tables:
	docker exec lab-clickhouse-kafka-clickhouse-1-1 clickhouse-client --multiline --queries-file /tmp/queries/test_kafka.table_mt.sql
	docker exec lab-clickhouse-kafka-clickhouse-1-1 clickhouse-client --multiline --queries-file /tmp/queries/test_kafka.table_errors.sql
clickhouse-count-messages:
	docker exec lab-clickhouse-kafka-clickhouse-1-1 clickhouse-client --query "select count() from test_kafka.table_distributed"
clickhouse-log-errors:
	docker exec -it lab-clickhouse-kafka-clickhouse-1-1 tail -n 50 -f /var/log/clickhouse-server/clickhouse-server.err.log
clickhouse-client:
	docker exec -it lab-clickhouse-kafka-clickhouse-1-1 clickhouse client

# Prepare lab
create: up topic-create topic-check clickhouse-create-tables
