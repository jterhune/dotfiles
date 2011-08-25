export CLICOLOR=1
export GRAILS_HOME=/opt/grails
export GROOVY_HOME=/opt/groovy
export JBOSS_HOME=/opt/jboss
export M2_HOME=/opt/maven
export PATH=$GRAILS_HOME/bin:$M2_HOME/bin:$PATH
# Java -------------------------------------------------------------
export JAVA_HOME=/Library/Java/Home
export JAVA_OPTS="-Xms1024m -Xmx1024m -XX:PermSize=512m -XX:MaxPermSize=512m -server"
# MySql ------------------------------------------------------------
export MYSQL_HOME=/usr/local/mysql
export PATH=${MYSQL_HOME}/bin:${PATH}
export PATH=~/bin:${PATH}
source ~/.bashrc
# For more details on this next line see http://www.huyng.com/bashmarks-directory-bookmarks-for-the-shell/
source /bin/bashmarks.sh
source ~/.git-completion.sh

# Grails -----------------------------------------------------------
# grails > 1.2
export GRAILS_TEST_LOG_DIRECTORY=target/test-reports
alias grr='grails run-app'
alias grt='grails test-app'
alias grtu='grails test-app -unit'
alias grti='grails test-app -integration'
alias grc='grails clean'
alias testlog='for F in `grep -lE "FAILED|Caused\ an\ ERROR" $GRAILS_TEST_LOG_DIRECTORY/plain/*.txt`; do echo ">>> opening" $F; open -a Console $F; done;'


# -----------------------------------------------------------------
# BASH PROMPT
# -----------------------------------------------------------------
## The prompt below gets ideas from the following:
# http://briancarper.net/blog/570/git-info-in-your-zsh-prompt
# http://github.com/adamv/dotfiles/blob/master/bashrc
# http://wiki.archlinux.org/index.php/Color_Bash_Prompt
txtred='\[\e[0;31m\]' # Red
txtwht='\[\e[0;37m\]' # White
bldred='\[\e[1;31m\]' # Red
bldgrn='\[\e[1;32m\]' # Green
bldylw='\[\e[1;33m\]' # Yellow
bldwht='\[\e[1;37m\]' # White
end='\[\e[0m\]'    # Text Reset


function parse_git {
    branch=$(__git_ps1 "%s")
    if [[ -z $branch ]]; then
        return
    fi

    local forward="↑"
    local behind="↓"
    local dot="•"

    remote_pattern_ahead="# Your branch is ahead of"
    remote_pattern_behind="# Your branch is behind"
    remote_pattern_diverge="# Your branch and (.*) have diverged"

    status="$(git status 2>/dev/null)"

    state=""
    if [[ $status =~ "working directory clean" ]]; then
        state=${bldgrn}${dot}${end}
    else
        if [[ $status =~ "Untracked files" ]]; then
            state=${bldred}${dot}${end}
        fi
        if [[ $status =~ "Changes not staged for commit" ]]; then
            state=${state}${bldylw}${dot}${end}
        fi
        if [[ $status =~ "Changes to be committed" ]]; then
            state=${state}${bldylw}${dot}${end}
        fi
    fi

    direction=""
    if [[ $status =~ $remote_pattern_ahead ]]; then
        direction=${bldgrn}${forward}${end}
    elif [[ $status =~ $remote_pattern_behind ]]; then
        direction=${bldred}${behind}${end}
    elif [[ $status =~ $remote_pattern_diverge ]]; then
        direction=${bldred}${forward}${end}${bldgrn}${behind}${end}
    fi

    branch=${txtwht}${branch}${end}
    git_bit="${bldred}[${end}${branch}${state}\
${git_bit}${direction}${bldred}]${end}"

    printf "%s" "$git_bit"
}

# Use ⚡ instead of ❯❯ ?
function set_prompt {
    local snowman=""
    git="$(parse_git)"

    PS1="${txtred}\u${end} ${txtred}\W${end}"
    if [[ -n "$git" ]]; then
        PS1="$PS1 $git ${bldcyn}⚡${end} "
    else
        PS1="$PS1 ${bldcyn}⚡${end} "
    fi
    export PS1
}

export PROMPT_COMMAND=set_prompt
