#!/bin/bash
#brokerids="0,1,2,3,4"
topics=`cat $1`
while read -r line; do lines+=("$line"); done <<<"$topics"
echo '{"version":1,
  "partitions":['
for t in $topics; do
    sep=","
    topicdetail=$(kafka-topics.sh --describe --zookeeper zookeeer_address --topic $t)
    pcount=$(echo -e "${topicdetail}"|grep -o "PartitionCount:[ 0-9]*"|awk '{print $2}')
    for i in $(seq 0 $[pcount - 1]); do
        if [ "${t}" == "${lines[-1]}" ] && [ "$[pcount - 1]" == "$i" ]; then sep=""; fi
        #randombrokers=$(echo "$brokerids" | sed -r 's/,/ /g' | tr " " "\n" | shuf | tr  "\n" "," | head -c -1)
        leader=$(echo -e "${topicdetail}"|grep "Partition: $i[[:space:]]"|grep -o "Leader:[ 0-9]*"|awk '{print $2}')
        #singlereplicas=$(echo "$brokerids"  | sed -r 's/,/ /g'| tr " " "\n" | shuf | head -n 1 | tr -d "\n")
        echo "    {\"topic\":\"${t}\",\"partition\":${i},\"replicas\":[${leader}]}$sep"
    done
done

echo '  ]
}'
