## Purpose: To globally reduce the number of Kafka topic replicas to 1

### 1. list topic
```shell
kafka-topics.sh --list --zookeeper zookeeper_addreess > /root/topic.txt
```

### 2. Split topics by 5 quantities
```shell
bash split_lines.sh  /root/topic.txt
```

### 3. Generate a JSON that only retains the current leader copy
```shell
bash gen-res.sh
```


### 4. Traverse and execute according to the generated JSON
```shell
bash exec-res.sh
```



#### Note: I execute as root and only retain one replication factor by default. To reduce the number of replication factor to the desired size, please modify dec-new.sh
