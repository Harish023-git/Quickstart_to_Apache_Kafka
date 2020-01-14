#Step 1 : Download and install kafka
wget https://www-eu.apache.org/dist/kafka/2.4.0/kafka_2.12-2.4.0.tgz
tar -xzf Kafka_2.12-2.4.0.tgz

#Step 2 : Start the server
cd Kafka_2.12-2.4.0
bin/zookeeper-server-start.sh config/zookeeper.properties
bin/kafka-server-start.sh config/server.properties

#Step 3 : Create an topic 
bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic test

#Listing the topics
bin/kafka-topics.sh —-list —-bootstrap-server localhost:9092

#Step 4 : Send message
bin/kafka-console-producer.sh —-broker-list localhost:9092 —-topic test
#eg.This is an first message

#Step 5 : Start consumer
bin/kafka-console-consumer.sh —bootstrap-server localhost:9092 —-topic test —from-beginning

#Step 6 : Multi-Cluster
#Create config file for nodes
cp config/server.properties config/server-1.properties
cp config/server.properties config/server-2.properties

#Edit config file
config/server-1.properties:
    broker.id=1
    listeners=PLAINTEXT://:9093
    log.dirs=/tmp/kafka-logs-1
 
config/server-2.properties:
    broker.id=2
    listeners=PLAINTEXT://:9094
    log.dirs=/tmp/kafka-logs-2

#Start the nodes
bin/kafka-server-start.sh config/server-1.properties
bin/kafka-server-start.sh config/server-2.properties

#Create new topic
bin/kafka-topics.sh —-create —-bootstrap-server localhost:9092 —-replication-factor 3 —-partitions 1 —-topic my-rep-topic 

#To check broker
bin/kafka-topics.sh —-describe —-bootstrap-server localhost:9092 —-topic my-rep-topic

#Publish messages
bin/kafka-console-producer.sh —-broker-list localhost:9092 —-topic my-rep-topic

#Consume message
bin/kafka-console-consumer.sh —-bootstrap-server localhost:9092 —-topic my-rep-topic —-from-beginning

#Check falt-tolerance 
ps aux | grep server-1.properties 
kill -9 <id_no.>

#Check leader and message
bin/kafka-topics.sh —-describe —-bootstrap-server localhost:9092 —-topic my-rep-topic

bin/kafka-console-consumer.sh —-bootstrap-server localhost:9092 --from-beginning —-topic my-rep-topic
