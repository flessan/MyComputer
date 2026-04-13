[[ $- != *i* ]] && return

# Ble.sh core
export INPUTRC=/dev/null
export _BLE_BASE_LOADED=0
if [[ -f /usr/share/blesh/ble.sh ]]; then
    source /usr/share/blesh/ble.sh --noattach
    export _BLE_BASE_LOADED=1
fi

# Environment
export EDITOR="nano"
export VISUAL="nano"
export SUDO_EDITOR="nano"
export TERM=xterm-256color
export COLORTERM=truecolor
export LESS="--RAW-CONTROL-CHARS --ignore-case --tabs=4"
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;36m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[1;33;40m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;37m'

# Paths
export PATH="$HOME/.local/bin:$PATH"
[[ -d "$HOME/.yarn/bin" ]] && export PATH="$HOME/.yarn/bin:$PATH"
[[ -d "$HOME/.cargo/bin" ]] && export PATH="$HOME/.cargo/bin:$PATH"
[[ -d "/usr/local/go/bin" ]] && export PATH="/usr/local/go/bin:$PATH"
[[ -d "$HOME/go/bin" ]] && export PATH="$HOME/go/bin:$PATH"

# History
export HISTSIZE=50000
export HISTFILESIZE=100000
export HISTTIMEFORMAT="%F %T │ "
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="ls:ll:la:cd:cd ..:clear:exit:history:*--help:fastfetch:neofetch"
shopt -s histappend cmdhist lithist

# Shell options
shopt -s autocd cdspell dirspell checkwinsize dotglob extglob globstar nocaseglob nullglob nocasematch
set -o noclobber notify

# Storage
BOOKMARKS_FILE="$HOME/.local/share/bash_bookmarks"
NOTES_DIR="$HOME/.local/share/notes"
TODO_FILE="$HOME/.local/share/todo.txt"
mkdir -p "$HOME/.local/share" "$NOTES_DIR"
touch "$BOOKMARKS_FILE" "$TODO_FILE"

# Aliases - Navigation & Directory Listing
alias ls='eza --icons --color=auto --group-directories-first'
alias ll='eza -lah --icons --color=auto --group-directories-first --git'
alias la='eza -a --icons --color=auto --group-directories-first'
alias lt='eza --tree --icons --color=auto --level=2 --git-ignore'
alias lt3='eza --tree --icons --color=auto --level=3 --git-ignore'
alias l.='eza -a --icons --color=auto --group-directories-first | grep "^\."'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias -- -='cd -'

# Aliases - Package Management
alias update='yay -Syu --noconfirm && echo "✓ System updated"'
alias update-full='yay -Syu --noconfirm && yay -Y --gendb && yay -Y --devel && echo "✓ Full update complete"'
alias sp='sudo pacman -S'
alias install='yay -S --noconfirm'
alias remove='yay -Rns --noconfirm'
alias search='yay -Ss'
alias info='yay -Si'
alias files='pacman -Ql'
alias orphans='yay -Qtdq'
alias cleanup='yay -Rns $(yay -Qtdq) 2>/dev/null; yay -Sc --noconfirm; echo "✓ Cleanup complete"'
alias cached-size='du -sh ~/.cache/yay/'

# Aliases - Safety & Core
alias rm='rm -Iv'
alias cp='cp -iv'
alias mv='mv -iv'
alias ln='ln -iv'
alias mkdir='mkdir -pv'
alias cat='bat --paging=never --style=plain'
alias catn='bat --paging=never'
alias df='df -h --output=source,target,size,used,avail,pcent'
alias du='du -h --max-depth=1'
alias free='free -h'
alias ps='ps auxf'
alias ip='ip -color=auto'

# Aliases - Git
alias g='git'
alias ga='git add'
alias gaa='git add -A'
alias gb='git branch -v'
alias gba='git branch -va'
alias gc='git commit -m'
alias gcm='git commit -m'
alias gca='git commit -am'
alias gcl='git clone'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gd='git diff'
alias gds='git diff --staged'
alias gf='git fetch --all --prune'
alias gl='git log --oneline --graph --decorate -20'
alias gla='git log --oneline --graph --decorate --all'
alias gp='git push'
alias gpl='git pull'
alias gplr='git pull --rebase'
alias gr='git remote -v'
alias gs='git status -sb'
alias gst='git stash'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gundo='git reset --soft HEAD~1'

# Aliases - Quick Access & System Info
alias x='exit'
alias c='clear'
alias h='history'
alias ports='ss -tlnp'
alias open='xdg-open'
alias ping='ping -c 4'
alias wget='wget -q --show-progress'
alias curl='curl -sL'
alias kernel='uname -r'
alias uptime='uptime -p'
alias disks='lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,UUID'
alias gpu='lspci | grep -i vga'
alias cpu='lscpu | grep "Model name"'

# Lazy Loading - Docker (Massive startup speedup)
_docker_lazy() { unset -f docker dc dex; command docker "$@"; }
_dc_lazy() { unset -f docker dc dex; command docker compose "$@"; }
_dex_lazy() { unset -f docker dc dex; docker exec -it "$1" "${2:-bash}"; }
if command -v docker &>/dev/null; then
    docker() { _docker_lazy "$@"; }
    dc() { _dc_lazy "$@"; }
    dex() { _dex_lazy "$@"; }
fi

# Functions - Smart Command Fixer
fix() {
    local last_cmd=$(history 1 | sed 's/^[0-9]*\*[ ]*//')
    local fixed=""
    if [[ "$last_cmd" == "cd.." || "$last_cmd" == "cd ..." ]]; then fixed="cd .."
    elif [[ "$last_cmd" == "cd-" ]]; then fixed="cd -"
    elif [[ "$last_cmd" != *"sudo "* ]] && [[ "$last_cmd" == pac* || "$last_cmd" == mount* || "$last_cmd" == systemctl* ]]; then fixed="sudo $last_cmd"
    elif [[ "$last_cmd" == "apt install "* || "$last_cmd" == "apt-get install "* ]]; then fixed=$(echo "$last_cmd" | sed 's/apt-get install/pacman -S/; s/apt install/pacman -S/')
    fi
    if [[ -n "$fixed" ]]; then echo -e "\033[1;33mRunning corrected command:\033[0m $fixed"; eval "$fixed"
    else echo "No simple fix found for: $last_cmd"; fi
}

# Functions - Command Not Found Auto-Suggest
command_not_found_handle() {
    local cmd=$1
    echo "bash: $cmd: command not found..."
    if command -v pkgfile &> /dev/null; then
        local pkg=$(pkgfile -bv "$cmd" 2>/dev/null | head -n 1 | awk '{print $1}')
        if [[ -n "$pkg" ]]; then
            echo -e "Suggestion: install via \033[1;32msudo pacman -S $pkg\033[0m or \033[1;32myay -S $pkg\033[0m"
            return 127
        fi
    fi
    echo "Try: yay -Ss $cmd"
    return 127
}

# Functions - Directory Bookmarks
bm() {
    local name="${1:-default}" path="$(pwd)"
    if grep -q "^${name}:" "$BOOKMARKS_FILE" 2>/dev/null; then sed -i "s|^${name}:.*|${name}:${path}|" "$BOOKMARKS_FILE"
    else echo "${name}:${path}" >> "$BOOKMARKS_FILE"; fi
    echo "✓ Bookmark saved: $name → $path"
}
gm() {
    local name="${1:-default}" path=$(grep "^${name}:" "$BOOKMARKS_FILE" 2>/dev/null | cut -d: -f2-)
    if [[ -n "$path" ]]; then cd "$path"; else echo "✗ Bookmark not found: $name"; fi
}
bm_list() {
    if [[ -s "$BOOKMARKS_FILE" ]]; then echo "📚 Bookmarks:"; while IFS=: read -r name path; do [[ -n "$name" ]] && printf "  %-15s → %s\n" "$name" "$path"; done < "$BOOKMARKS_FILE"
    else echo "No bookmarks saved"; fi
}
bm_rm() {
    local name="$1"
    if grep -q "^${name}:" "$BOOKMARKS_FILE" 2>/dev/null; then sed -i "/^${name}:/d" "$BOOKMARKS_FILE" && echo "✓ Bookmark removed: $name"
    else echo "✗ Bookmark not found: $name"; fi
}

# Functions - Notes System
note() {
    local note_name="${1:-$(date +%Y-%m-%d)}" note_file="$NOTES_DIR/${note_name}.md"
    if [[ "$1" == "list" || "$1" == "ls" ]]; then echo "📝 Notes:"; ls -1 "$NOTES_DIR"/*.md 2>/dev/null | xargs -I{} basename {} .md | sed 's/^/  /'; return 0; fi
    if [[ "$1" == "delete" || "$1" == "rm" ]]; then
        if [[ -f "$NOTES_DIR/${2}.md" ]]; then rm "$NOTES_DIR/${2}.md" && echo "✓ Deleted note: $2"; else echo "✗ Note not found: $2"; fi
        return 0
    fi
    ${EDITOR:-nano} "$note_file"
}

# Functions - Todo Manager
todo() {
    case "$1" in
        add|a) shift; echo "[ ] $*" >> "$TODO_FILE" && echo "✓ Added: $*" ;;
        done|d) [[ -n "$2" ]] && sed -i "${2}s/\[ \]/[x]/" "$TODO_FILE" && echo "✓ Marked as done: #$2" ;;
        undo|u) [[ -n "$2" ]] && sed -i "${2}s/\[x\]/[ ]/" "$TODO_FILE" && echo "✓ Unmarked: #$2" ;;
        list|ls|"")
            if [[ -s "$TODO_FILE" ]]; then nl -ba "$TODO_FILE" | sed 's/\[ \]/☐ /g; s/\[x\]/☑ /g'
            else echo "📝 No todos yet. Use: todo add <task>"; fi ;;
        clean) grep -v "\[x\]" "$TODO_FILE" > "${TODO_FILE}.tmp" && mv "${TODO_FILE}.tmp" "$TODO_FILE" && echo "✓ Removed completed tasks" ;;
        clear) > "$TODO_FILE" && echo "✓ Cleared all todos" ;;
        *) echo "Usage: todo [add|done|undo|list|clean|clear] [args]" ;;
    esac
}

# Functions - Archives
extract() {
    if [[ ! -f "$1" ]]; then echo "✗ '$1' is not a valid file"; return 1; fi
    case "$1" in
        *.tar.bz2|*.tbz2)  tar xjf "$1"     ;;
        *.tar.gz|*.tgz)    tar xzf "$1"     ;;
        *.tar.xz|*.txz)    tar xJf "$1"     ;;
        *.tar.lz|*.tlz)    tar --lzip -xf "$1" ;;
        *.tar.zst|*.tzst)  tar --zstd -xf "$1" ;;
        *.bz2)             bunzip2 "$1"     ;;
        *.rar)             unrar x -o+ "$1" ;;
        *.gz)              gunzip "$1"      ;;
        *.zip)             unzip -o "$1"    ;;
        *.Z)               uncompress "$1"  ;;
        *.7z)              7z x "$1"        ;;
        *.deb)             ar x "$1"        ;;
        *.rpm)             rpm2cpio "$1" | cpio -idmv ;;
        *) echo "✗ Cannot extract '$1' - unknown format"; return 1 ;;
    esac && echo "✓ Extracted: $1"
}

compress() {
    local target="${1%%/}" archive="${2:-${target}.tar.gz}"
    case "$archive" in
        *.tar.gz|*.tgz)  tar -czf "$archive" "$target" ;;
        *.tar.bz2|*.tbz2) tar -cjf "$archive" "$target" ;;
        *.tar.xz|*.txz)  tar -cJf "$archive" "$target" ;;
        *.tar.zst|*.tzst) tar --zstd -cf "$archive" "$target" ;;
        *.zip)            zip -r "$archive" "$target" ;;
        *.7z)             7z a "$archive" "$target" ;;
        *) echo "✗ Unknown archive format"; return 1 ;;
    esac && echo "✓ Created: $archive"
}

# Functions - Utilities
mkcd() { [[ -z "$1" ]] && echo "Usage: mkcd <directory>" && return 1; mkdir -pv "$1" && cd "$1"; }
pskill() {
    if [[ -z "$1" ]]; then echo "Usage: pskill <pattern>"; return 1; fi
    local pids=$(pgrep -f "$1")
    if [[ -n "$pids" ]]; then
        echo "Found processes matching '$1':"; ps auxf | grep -E "$1" | grep -v grep
        echo -n "Kill these processes? [y/N] "; read -r confirm
        [[ "$confirm" =~ ^[Yy]$ ]] && echo "$pids" | xargs kill -9 && echo "✓ Killed processes"
    else echo "✗ No processes found matching '$1'"; fi
}
port_check() { [[ -z "$1" ]] && ss -tlnp && return 0; ss -tlnp | grep ":$port " || echo "Port $port is not in use"; }
myip() { echo "🌐 Public IP:  $(curl -sL ifconfig.me)"; echo "🔗 Local IPv4: $(ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1' | head -1)"; }
# Ganti Jakarta menjadi Banjarmasin sebagai default
weather() {
    local location="${1:-Banjarmasin}"
    curl -sL "wttr.in/${location}?format=3"
    echo ""
    curl -sL "wttr.in/${location}?1"
}
calc() { echo "scale=4; $*" | bc -l; }
jsonf() { if [[ -z "$1" ]]; then jq .; else jq . "$1"; fi; }
ff() { find . -type f -iname "*$1*" 2>/dev/null; }
fsearch() { grep -rn --color=auto "$1" . 2>/dev/null; }
backup() { if [[ -f "$1" ]]; then cp "$1" "${1}.backup.$(date +%Y%m%d_%H%M%S)" && echo "✓ Backup created"; else echo "✗ File not found: $1"; fi; }
quickpush() {
    if ! git rev-parse --is-inside-work-tree &> /dev/null; then echo "✗ Not a git repo."; return 1; fi
    local msg="${1:-Update}"; git add -A && git commit -m "$msg" && git push && echo "✓ Pushed: $msg"
}
genpass() { local len=${1:-24}; tr -dc 'A-Za-z0-9!@#$%^&*()' </dev/urandom | head -c "$len"; echo; }
tmpd() { local dir=$(mktemp -d -t "tmp.XXXXXX"); echo "$dir"; cd "$dir"; }

# FZF Integration
#if command -v fzf &>/dev/null; then
#    export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --border=rounded --cycle --marker='>' --pointer='▶' --separator='─'"
#    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
#    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
#    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    
#    [[ -f /usr/share/fzf/key-bindings.bash ]] && source /usr/share/fzf/key-bindings.bash
#    [[ -f /usr/share/fzf/completion.bash ]] && source /usr/share/fzf/completion.bash

#    fh() { history | fzf --tac --no-sort | awk '{$1=""; print substr($0,2)}'; }
#    vf() { local file=$(fzf); [[ -n "$file" ]] && ${EDITOR:-nano} "$file"; }
#    fcd() { local dir=$(fd --type d --hidden --follow --exclude .git | fzf); [[ -n "$dir" ]] && cd "$dir"; }
#    fkill() { local pid=$(ps auxf | fzf | awk '{print $2}'); [[ -n "$pid" ]] && kill -9 "$pid" && echo "✓ Killed PID: $pid"; }
#fi

# Keybindings (Ble.sh vs Standard Bash)
#if [[ -n "$_BLE_BASE_LOADED" ]]; then
    # Menggunakan tanda kutip terpisah untuk key dan command
#    ble-bind -m emacs "C-left" "backward-word" [cite: 83]
#    ble-bind -m emacs "C-right" "forward-word" [cite: 83]
#    ble-bind -m emacs "up" "history-search-backward" [cite: 83]
#    ble-bind -m emacs "down" "history-search-forward" [cite: 83]
#else
#    bind '"\e[1;5D": backward-word' [cite: 83]
#    bind '"\e[1;5C": forward-word' [cite: 83]
#    bind '"\e[A": history-search-backward' [cite: 83]
#    bind '"\e[B": history-search-forward' [cite: 83]
#fi

# Prompt & History Sync (Starship & Ble.sh aware)
if [[ -n "$_BLE_BASE_LOADED" ]]; then
    if command -v starship &>/dev/null; then eval "$(starship init bash)"; fi
else
    if command -v starship &>/dev/null; then
        eval "$(starship init bash)"
        PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND;}history -a; history -r;"
    else
        PROMPT_COMMAND="history -a; history -r;"
    fi
fi

# Base Completions
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then . /etc/bash_completion; fi
fi

# Custom Completions
_todo() {
    local cur="${COMP_WORDS[COMP_CWORD]}" cmds="add a done d undo u list ls clean clear"
    if [[ ${COMP_CWORD} -eq 1 ]]; then
        COMPREPLY=($(compgen -W "$cmds" -- "$cur"))
    elif [[ ${COMP_CWORD} -eq 2 ]] && [[ "${COMP_WORDS[1]}" == "done" || "${COMP_WORDS[1]}" == "d" || "${COMP_WORDS[1]}" == "undo" || "${COMP_WORDS[1]}" == "u" ]]; then
        local nums=$(grep -c '' "$TODO_FILE" 2>/dev/null)
        COMPREPLY=($(compgen -W "$(seq 1 $nums 2>/dev/null)" -- "$cur"))
    fi
}
complete -F _todo todo

_note() {
    local cur="${COMP_WORDS[COMP_CWORD]}" cmds="list ls delete rm"
    if [[ ${COMP_CWORD} -eq 1 ]]; then
        local notes=$(ls -1 "$NOTES_DIR"/*.md 2>/dev/null | xargs -I{} basename {} .md)
        COMPREPLY=($(compgen -W "$cmds $notes" -- "$cur"))
    elif [[ ${COMP_CWORD} -eq 2 ]] && [[ "${COMP_WORDS[1]}" == "delete" || "${COMP_WORDS[1]}" == "rm" ]]; then
        local notes=$(ls -1 "$NOTES_DIR"/*.md 2>/dev/null | xargs -I{} basename {} .md)
        COMPREPLY=($(compgen -W "$notes" -- "$cur"))
    fi
}
complete -F _note note

_bm() {
    local cur="${COMP_WORDS[COMP_CWORD]}" names=$(cut -d: -f1 "$BOOKMARKS_FILE" 2>/dev/null)
    COMPREPLY=($(compgen -W "$names" -- "$cur"))
}
complete -F _bm bm gm bm_rm

_extract() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local exts="tar.bz2 tbz2 tar.gz tgz tar.xz txz tar.lz tlz tar.zst tzst bz2 rar gz zip Z 7z deb rpm"
    local pattern=""
    for ext in $exts; do pattern="$pattern -o -name '*.$ext'"; done
    pattern="\( ${pattern# -o } \)"
    local files=$(find . -maxdepth 1 -type f $pattern 2>/dev/null | sed 's|^\./||')
    COMPREPLY=($(compgen -W "$files" -- "$cur"))
}
complete -F _extract extract

if declare -F _pacman &>/dev/null; then complete -F _pacman sp; fi
if declare -F _yay &>/dev/null; then complete -F _yay update update-full install remove search info cleanup; elif declare -F _pacman &>/dev/null; then complete -F _pacman update update-full install remove search info cleanup; fi

# Welcome Screen & Greeting
if command -v fastfetch &>/dev/null; then fastfetch; elif command -v neofetch &>/dev/null; then neofetch; fi

show_greeting() {
    local hour=$(date +'%H') greeting
    if [ "$hour" -ge 5 ] && [ "$hour" -lt 11 ]; then
        greeting="Selamat Pagiii! ☀️"
    elif [ "$hour" -ge 11 ] && [ "$hour" -lt 15 ]; then
        greeting="Selamat Siang, ayo-semangat! 🚀"
    elif [ "$hour" -ge 15 ] && [ "$hour" -lt 18 ]; then
        greeting="Selamat Sore kakaa ✨"
    else
        # Jam 18:00 sampai 04:59
        greeting="Met Malamm, atau tengah malam nih, hehe.. Jangan lupa istirahat! 💤"
    fi

    echo ""
    echo "  $greeting, $(whoami)! 🌟"
    echo "  $(date '+%A, %B %d, %Y - %H:%M')"

    local pending=$(grep -c '\[ \]' "$TODO_FILE" 2>/dev/null)
    if [ "$pending" -gt 0 ] 2>/dev/null; then
        echo "  📋 Ada $pending tugas di todo list — ketik 'todo list'"
    fi
    echo ""
}
show_greeting

# Final Ble.sh Attach
if [[ -n "$_BLE_BASE_LOADED" ]]; then ble-attach; fi
