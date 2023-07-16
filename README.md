# Lab ClickHouse and Kafka
This project demonstrates the integration between ClickHouse and Kafka. It allows you to create a Kafka topic, produce messages to it, and consume them with ClickHouse.

## Prerequisites
Docker

## Installation
Clone the repository
Run the following command to start the project:
```bash
make create
```

## Usage
### ClickHouse
To create the necessary tables in ClickHouse, run:
```bash
make clickhouse-create-tables
```

To count the number of messages stored in ClickHouse, run:
```bash
make clickhouse-messages-count
```

To view the log errors in ClickHouse, run:
```bash
make clickhouse-log-errors
```

### Kafka
To create a Kafka topic, run:
```bash
make topic-create
```

To check the details of the created topic, run:
```bash
make topic-check
```

To produce messages to the topic, run:
```bash
make topic-produce-messages
```
producing messages with [orginux/kafka-traffic-generator](https://github.com/orginux/kafka-traffic-generatror), you can set the messages number or data types in `./configs/ktg/config.yaml`.

To check the lag of the consumer group, run:
```bash
make topic-lag
```

### Stop the project
To stop and remove all the containers, run:
```bash
make down
```
## Links
- https://clickhouse.com/docs/en/engines/table-engines/integrations/kafka/
- https://altinity.com/blog/2020/5/21/clickhouse-kafka-engine-tutorial
- https://kb.altinity.com/altinity-kb-integrations/altinity-kb-kafka/error-handling/
