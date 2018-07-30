# You can put files here to add functionality separated per file, which
# will be ignored by git.
# Files on the custom/ directory will be automatically loaded by the init
# script, in alphabetical order.

# For example: add yourself some shortcuts to projects you often work on.
#
# brainstormr=~/Projects/development/planetargon/brainstormr
# cd $brainstormr
#
alias dsls="docker service ls"
alias dsps="docker service ps"
alias dss="docker service scale"

export EDITOR=vi

sshec2 () {
    ssh -i ~/.ssh/devenv-key.pem ec2-user@$1
}

consume-local () {
    ~/Software/kafka_2.11-1.1.0/bin/kafka-console-consumer.sh --bootstrap-server $(ipconfig getifaddr en0):9092 --topic $1
}

consume () {
    ~/Software/kafka_2.11-1.1.0/bin/kafka-console-consumer.sh --bootstrap-server $1:9092 --topic $2 $3
}

produce-local() {
    ~/Software/kafka_2.11-1.1.0/bin/kafka-console-producer.sh --broker-list $(ipconfig getifaddr en0):9092 --topic $1
}
produce() {
    ~/Software/kafka_2.11-1.1.0/bin/kafka-console-producer.sh --broker-list $1:9092 --topic $2
}

consumer-group() {
    ~/Software/kafka_2.11-1.1.0/bin/kafka-consumer-groups.sh --bootstrap-server $1:9092 --group $3
}

create-local() {
    /Users/bcrabbe/Software/kafka_2.11-1.1.0/bin/kafka-topics.sh --create --topic $1 --zookeeper $(ipconfig getifaddr en0):2181 --partitions 1 --replication-factor 1
}

list-local() {
    ~/Software/kafka_2.11-1.1.0/bin/kafka-topics.sh --list --zookeeper localhost:2181
}

list-topics() {
    ~/Software/kafka_2.11-1.1.0/bin/kafka-topics.sh --list --zookeeper $1:2181
}

gref() {
    grep -nri -e $1 *
}

alias kafka-up="exec ~/Software/localKafka/brokers.sh"
docker-stop() {
    docker rm -f $(docker ps -aq)
}
alias gloga="glog --all"

fb() {
    cd /Users/bcrabbe/p/fb-messenger-cli
    node cli
}
