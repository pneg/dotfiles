#
# ~/.bashrc
#

# save path on cd
function cd {
    builtin cd $@
    pwd > /tmp/last_dir
}

# restore last saved path
if [ -f /tmp/last_dir ]
    then cd `cat /tmp/last_dir`
fi

# Save working directory on exit
# trap "echo $PWD > ~/.lastdir" EXIT

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

export PATH=/usr/local/bin:$PATH:/home/user/.dotnet/tools:/usr/local/racket/bin
#export QT_STYLE_OVERRIDE=kvantum
#export XDG_CURRENT_DESKTOP=KDE

# needed for sudoedit
export EDITOR=vim

vman() {
      vim -c "SuperMan $*"

      if [ "$?" != "0" ]; then
        echo "No manual entry for $*"
      fi
    }

# emit OSC-7 escape sequence
osc7_cwd() {
    local strlen=${#PWD}
    local encoded=""
    local pos c o
    for (( pos=0; pos<strlen; pos++ )); do
        c=${PWD:$pos:1}
        case "$c" in
            [-/:_.!\'\(\)~[:alnum:]] ) o="${c}" ;;
            * ) printf -v o '%%%02X' "'${c}" ;;
        esac
        encoded+="${o}"
    done
    printf '\e]7;file://%s%s\e\\' "${HOSTNAME}" "${encoded}"
}
PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }osc7_cwd

export XKB_DEFAULT_LAYOUT=us
