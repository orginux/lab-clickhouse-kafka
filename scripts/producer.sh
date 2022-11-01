#! /bin/bash
x="${1:-1000}"
MESSAGES_FILE="/tmp/messages.csv"

echo "Generate ${x} messages"

# Clean up
rm -f ${MESSAGES_FILE}

i=1

while [ $i -le ${x} ]
do

    j=$((i/2))

    echo "$i, `date +'%Y.%m.%d %T'`, $j" >> ${MESSAGES_FILE}

    i=$(( $i + 1 ))
done

kafka-console-producer --broker-list kafka:9092 --topic ids < ${MESSAGES_FILE}

# Clean up
rm -f ${MESSAGES_FILE}
