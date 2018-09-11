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
#bindkey -e

export EDITOR=vi

sshec2 () {
    ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ~/.ssh/devenv-key.pem ec2-user@$1
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

#https://medium.com/@Clovis_app/configuration-of-a-beautiful-efficient-terminal-and-prompt-on-osx-in-7-minutes-827c29391961
ZSH_THEME="powerlevel9k/powerlevel9k"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir rbenv vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)
POWERLEVEL9K_PROMPT_ON_NEWLINE=true

# Add a space in the first prompt
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%f"
# Visual customisation of the second prompt line
local user_symbol="$"
if [[ $(print -P "%#") =~ "#" ]]; then
    user_symbol = "#"
fi
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%{%B%F{black}%K{yellow}%} $user_symbol%{%b%f%k%F{yellow}%} %{%f%}"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
# fresh set up ?
# add emacs style editing to iterm2 : https://apple.stackexchange.com/questions/154292/iterm-going-one-word-backwards-and-forwards?newreg=f43b9d3acf884899a01bb28b566b9b27
