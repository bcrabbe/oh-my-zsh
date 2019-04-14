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
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/local/lib"
export LD_LIBRARY_PATH="/usr/local/lib:/usr/lib"
export EDITOR=vi
export MANPATH=$MANPATH:"/usr/local/Cellar/erlang/21.2.4/lib/erlang/man/"

ssho () {
    ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ~/.ssh/devenv-key.pem ec2-user@$1
}

sshb () {
    ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ~/.ssh/betler-key.pem ec2-user@$1
}

consume-local () {
    ~/Software/kafka_2.11-1.1.0/bin/kafka-console-consumer.sh \
        --bootstrap-server \
        $(ipconfig getifaddr en0):9092 \
        --topic $@
}

consume () {
    HOST=$1
    TOPIC=$2
    shift
    shift
    ~/Software/kafka_2.11-1.1.0/bin/kafka-console-consumer.sh \
        --bootstrap-server $HOST:9092 \
        --topic $TOPIC $@
}

produce-local() {
    ~/Software/kafka_2.11-1.1.0/bin/kafka-console-producer.sh \
        --broker-list \
        $(ipconfig getifaddr en0):9092 \
        --topic $@
}

produce() {
    HOST=$1
    shift
    ~/Software/kafka_2.11-1.1.0/bin/kafka-console-producer.sh \
        --broker-list \
        $HOST:9092 \
        --topic $@
}

consumer-group() {
    HOST=$1
    shift
    ~/Software/kafka_2.11-1.1.0/bin/kafka-consumer-groups.sh \
        --bootstrap-server \
        $HOST:9092 \
        --group $@
}

create-local() {
    TOPIC=$1
    shift
    /Users/bcrabbe/Software/kafka_2.11-1.1.0/bin/kafka-topics.sh \
        --create \
        --topic $1 \
        --zookeeper $(ipconfig getifaddr en0):2181 \
        --partitions 1 \
        --replication-factor 1 \
        $@
}

list-local() {
    ~/Software/kafka_2.11-1.1.0/bin/kafka-topics.sh \
        --list \
        --zookeeper $(ipconfig getifaddr en0):2181 \
        $@
}

list-topics() {
    ZK=$1
    shift
    ~/Software/kafka_2.11-1.1.0/bin/kafka-topics.sh \
        --list \
        --zookeeper $ZK:2181 \
        $@
}

describe-grp() {
    KAF=$1
    shift
    ~/Software/kafka_2.11-1.1.0/bin/kafka-consumer-groups.sh \
        --bootstrap-server $KAF:9092 \
        --describe \
        --group $@
}

consumer-grp() {
    KAF=$1
    shift
    ~/Software/kafka_2.11-1.1.0/bin/kafka-consumer-groups.sh \
        --bootstrap-server $KAF:9092 \
        $@
}

gref() {
    grep --color -nri -e $1 *
}

alias kafka-up="exec ~/Software/localKafka/brokers.sh & "

docker-stop() {
    echo "docker rm -f $(docker ps -aq)"
    docker rm -f $(docker ps -aq)
}

docker-rmi() {
    echo "docker rmi -f $(docker images -aq)"
    docker rmi -f $(docker images -aq)
}

docker-rmvol() {
    echo "docker volume prune -f"
    docker volume prune -f
}

docker-clean() {
    docker-stop
    docker-rmi &
    docker-rmvol
}

alias gloga="glog --all"

git-delete-tag() {
    echo "git tag -d $1
    git push origin :refs/tags/$1"
    git tag -d $1
    git push origin :refs/tags/$1
}

#https://medium.com/@Clovis_app/configuration-of-a-beautiful-efficient-terminal-and-prompt-on-osx-in-7-minutes-827c29391961
ZSH_THEME="powerlevel9k/powerlevel9k"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir ssh vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)
POWERLEVEL9K_PROMPT_ON_NEWLINE=false

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

if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi
# alias python=/usr/local/bin/python3.6
# alias pip=pip3.6

source <(kubectl completion zsh)
source <(minikube completion zsh)
alias k="kubectl"

erl-gitignore() {
    echo '*~
*.plt
erl_crash.dump
deps
.eunit
.DS_Store
.erlang.mk.*
ebin
_rel
relx
logs
.erlang.mk
db
xrefr
*.d
elvis
elvis.config
.fuse_hidden*
*.log
\#*\#
.\#*
*.swp
*.swo
'
}

clone-app() {
    FROM=$1
    TO=$2
    cp -rf ~/code/${FROM} ~/code/${TO}
    cd ~/code/${TO}
    sed -i "" "s/${FROM}/${TO}/g" Makefile
    sed -i "" "s/${FROM}/${TO}/g" dev.config
    sed -i "" "s/${FROM}/${TO}/g" README.md
    sed -i "" "s/${FROM}/${TO}/g" relx.config
    find ./src -type f -exec sed -i "" "s/${FROM}/${TO}/g" '{}' ';'
    find ./rel -type f -exec sed -i "" "s/${FROM}/${TO}/g" '{}' ';'
    autoload -U zmv
    zmv -W "./src/${FROM}*" "./src/${TO}*"
    zmv -W "*${FROM}*" "*${TO}*"
    rm -rf .git
    make
    git init
    git flow init -fd
    erl-gitignore > .gitignore
    git add *
    git add .gitignore .gitlab-ci.yml
    git commit -m "initial"
    etags src/*.erl
}
