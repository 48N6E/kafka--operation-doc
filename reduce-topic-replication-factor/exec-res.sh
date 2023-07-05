#!/bin/bash
# execute reassignment

 cd /root/resjson/;
 for i in `ls `;
    do
        grep $i /tmp/worklog
        if [ $? -ne 0 ]; then
                sleep 3
                export KAFKA_HEAP_OPTS="-Xms1g -Xmx1g"
            echo "start run `date +%Y-%M-%d-%H-%M-%S`-$i"
            echo  "`date +%Y-%M-%d-%H-%M-%S`-$i" >> /tmp/worklog
            kafka-reassign-partitions.sh --zookeeper   zookeeer_address  --reassignment-json-file ./$i --execute
            while (( `   kafka-reassign-partitions.sh --bootstrap-server kafka_address   --reassignment-json-file ./$i --verify |grep -e "is still in progress" -e "rather"|wc -l` >0));
            do
                echo "$i running" && sleep 1 && kafka-reassign-partitions.sh --zookeeper zookeeer_address --reassignment-json-file ./$i --execute;
            done
        else
            echo "$i already execute"
        fi

    done
