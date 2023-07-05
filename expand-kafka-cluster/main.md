### notice: 
kafka-version: 2.13-2.7.0
Expanding nodes will increase the throughput of the cluster, but it may not necessarily reduce the load.

After expanding the node, you can choose whether to reassign the topic, but be aware that this may cause meaningless data movement.

#### 1.expand kafka broker[k8s]
```
kubectl scale statefulset kafka  --replicas=[replicas]
```
Wait until the node joins the cluster, otherwise the topic migration plan generated later will not include the new node.

#### 2.get all topics
```
kafka-topics.sh --list --zookeeper  zookeeper:2181  > topic-list.txt
```
Because the Kafka migration topic scheme requires a json, the obtained topic names need to be added to the json in batches. Considering that Data migration should not be too large, three topics are divided into a group, with the format:
``` json
{
    "topics":[
        {
            "topic":"topic1"
        },
        {
            "topic":"topic2"
        },
        {
            "topic":"topic3"
        }
    ],
    "version":1
}

```
You can run this nodejs script help you generate json:
``` shell
node topic-5.js
```

#### 3.Generate a migration plan, which will not affect the cluster at this time, only generate the plan
``` shell
kafka-reassign-partitions.sh --zookeeper zookeeper:2181 --topics-to-move-json-file ./topics-to-move.json --broker-list “0,1,2,3,4” --generate |grep “Proposed partition reassignment configuration” -A1 |grep -v “Proposed partition reassignment configuration” >partitions-reassignment.json
```

You can use batch processing script 

``` shell
 mkdir -p /tmp/reassignment/
 for i in  `ls ./topics-to-move.*`;do kafka-reassign-partitions.sh --zookeeper zookeeper:2181 --topics-to-move-json-file ./$i --broker-list "[0,1,2,3,...you brokers]" --generate |grep “Proposed partition reassignment configuration” -A1 |grep -v “Proposed partition reassignment configuration” > /tmp/reassignment/partitions-reassignment-$i.json

```

#### 4.Perform migration
```
kafka-reassign-partitions.sh --zookeeper zookeeper:2181 --reassignment-json-file ./partitions-reassignment.json --execute
```

#### 5.Verify
```
kafka-reassign-partitions.sh --bootstrap-server kafka:9092 --reassignment-json-file ./partitions-reassignment.json --verify
```
