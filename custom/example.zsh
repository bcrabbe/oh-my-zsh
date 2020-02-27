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
export MANPATH=$MANPATH:"/usr/local/Cellar/erlang/22.0.1/lib/erlang/man/"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
#set zsh editing commands to emacs - see man zle
bindkey -e
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=4"

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
    grep --color -nri --exclude-dir=node_modules -e $1 *
}

alias kafka-up="exec ~/Software/localKafka/brokers.sh & "

#generates a rudimentary tags file for scala programs
alias sctags="/usr/local/Cellar/ctags/5.8_1/bin/ctags -R -e"
# requires:
# ~/.ctags:
# --langdef=Scala
# --langmap=Scala:.scala
# --regex-Scala=/^[^\*\/]*class[ \\t]*([a-zA-Z0-9_]+)/\1/c,classes/
# --regex-Scala=/^[^\*\/]*object[ \\t]*([a-zA-Z0-9_]+)/\1/o,objects/
# --regex-scala=/^[^\*\/]*trait[ \\t]*([a-zA-Z0-9_]+)/\1/t,traits/
# --regex-Scala=/^[^\*\/]*case[ \\t]*class[ \\t]*([a-zA-Z0-9_]+)/\1/m,case-classes/
# --regex-Scala=/^[^\*\/]*abstract[ \\t]*class[ \\t]*([a-zA-Z0-9_]+)/\1/a,abstract-classes/
# --regex-Scala=/^[^\*\/]*def[ \\t]*([a-zA-Z0-9_]+)[ \\t]*.*[:=]/\1/f,functions/
# --regex-Scala=/^[^\*\/]*val[ \\t]*([a-zA-Z0-9_]+)[ \\t]*[:=]/\1/V,values/
# --regex-Scala=/^[^\*\/]*var[ \\t]*([a-zA-Z0-9_]+)[ \\t]*[:=]/\1/v,variables/
# --regex-Scala=/^[^\*\/]*type[ \\t]*([a-zA-Z0-9_]+)[ \\t]*[\[<>=]/\1/T,types/
# --exclude='*/target/*'

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

docker-attach() {
    local CONTAINER_ID=`docker ps | grep "$1" | awk '{print $1}'`

    if [ -z "${CONTAINER_ID}" ]; then
        echo "ERROR: Could not find container."
    elif [ `echo "${CONTAINER_ID}" | wc -l` -gt 1 ]; then
        echo "ERROR: Found multiple containers."
        docker ps | grep "$1\|CONTAINER ID"
    else
        echo "Found container: ${CONTAINER_ID}"
        docker exec -it ${CONTAINER_ID} /bin/bash
    fi
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

source <(kubectl completion zsh)
# source <(minikube completion zsh)
alias k="kubectl -n ck-service"
alias kgp="kubectl -n ck-service get pods"
alias kdp="kubectl -n ck-service describe pods"

function get-pod(){
    kubectl get pods -n ck-service | grep $1 | tr ' ' '\n' | head -n1
}
function kl(){
    kubectl -n ck-service logs -f $(get-pod $1) ck-service
}

function katt(){
    kubectl exec -it --namespace ck-service $(get-pod $1) -c ck-service bash
}

function kpf(){
    pod_name=$(get-pod $1)
    shift
    kubectl --namespace ck-service port-forward pod/$pod_name $@
}

export NODE_IP=$(cat ~/.kube/config | grep server | cut -d / -f 3 | cut -d : -f 1)
