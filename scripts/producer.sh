#! /bin/bash
i=0

while :
do

    i=$((i+1))
    j=$((i/2))

    echo "Message #${i}"
    echo "$i, `date +'%Y.%m.%d %T'`, $j" | kafka-console-producer --broker-list kafka:9092 --topic readings

done
