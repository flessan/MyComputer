#!/bin/bash
export INPUTRC=/dev/null
# ==============================================================================
#  ██████╗  ██████╗ ███╗   ██╗████████╗ █████╗ ██╗███╗   ██╗███████╗██████╗
# ██╔════╝ ██╔═══██╗████╗  ██║╚══██╔══╝██╔══██╗██║████╗  ██║██╔════╝██╔══██╗
# ██║  ███╗██║   ██║██╔██╗ ██║   ██║   ███████║██║██╔██╗ ██║█████╗  ██████╔╝
# ██║   ██║██║   ██║██║╚██╗██║   ██║   ██╔══██║██║██║╚██╗██║██╔══╝  ██╔══██╗
# ╚██████╔╝╚██████╔╝██║ ╚████║   ██║   ██║  ██║██║██║ ╚████║███████╗██║  ██║
#  ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝
#
#   ARCH LINUX ENHANCED BASH CONFIGURATION v2.0
#   Designed for productivity, security, and aesthetics
# ==============================================================================

# ==============================================================================
# 0. GUARD CLAUSE - Prevent non-interactive execution
# ==============================================================================
[[ $- != *i* ]] && return

# ==============================================================================
# 1. CORE ENGINE - Ble.sh (Auto-complete & Syntax Highlighting)
# ==============================================================================
# ⚠️ PERINGATAN KERAS: JANGAN PERNAH MENARUH "export INPUTRC=/dev/null" DI SINI!
#    (Melakukannya akan mematikan keyboard sebelum ble.sh sempat jalan).
#
# 📝 CATATAN WARNING:
#    Saat loading, mungkin akan muncul warning "unsupported readline function"
#    atau "unrecognized keymap name". Ini adalah perilaku NORMAL dari ble.sh
#    saat membaca file /etc/inputrc bawaan Arch Linux.
#    Warning ini SAMA SEKALI tidak berpengaruh pada fungsi keyboard Anda.
#    Silakan abaikan, jangan dipaksa untuk di-suppress.
# ==============================================================================

#if [[ -f /usr/share/blesh/ble.sh ]]; then
#export BLE_OPTS='-nort'
#    source /usr/share/blesh/ble.sh --noattach
    # Set flag agar blok di bagian bawah tahu bahwa ble.sh sudah siap
#    export _BLE_BASE_LOADED=1
#fi

# Biasanya sudah ada di Arch/EndeavourOS
#[[ -r "/usr/share/bash-completion/bash_completion" ]] && . "/usr/share/bash-completion/bash_completion"


# ==============================================================================
# 2. TERMINAL SETTINGS & COLORS
# ==============================================================================
# Set default editor
export EDITOR="nvim"
export VISUAL="nvim"
export SUDO_EDITOR="nvim"

# Color utilities
export TERM=xterm-256color
export COLORTERM=truecolor

# Less settings (better color support)
export LESS="--RAW-CONTROL-CHARS --ignore-case --tabs=4"
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;36m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[1;33;40m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;37m'

# ==============================================================================
# 3. ENHANCED HISTORY (Intelligent & Persistent)
# ==============================================================================
export HISTSIZE=50000
export HISTFILESIZE=100000
export HISTTIMEFORMAT="%F %T │ "  # Timestamp format
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="ls:ll:la:cd:cd ..:clear:exit:history:*--help:fastfetch:neofetch"

shopt -s histappend           # Append, don't overwrite
shopt -s cmdhist              # Multi-line commands as one entry
shopt -s lithist              # Preserve multi-line formatting

# Real-time history sync between terminals
prompt_command() {
    local exit_status=$?
    history -a                 # Append to history immediately
    history -c                 # Clear current session history
    history -r                 # Re-read from history file
    return $exit_status
}

# ==============================================================================
# 4. SHELL OPTIONS (Smart Behavior)
# ==============================================================================
shopt -s autocd               # Type directory name to cd
shopt -s cdspell              # Auto-correct directory typos
shopt -s dirspell             # Auto-correct directory typos in completion
shopt -s checkwinsize         # Check window size after each command
shopt -s dotglob              # Include hidden files in glob
shopt -s extglob              # Extended pattern matching
shopt -s globstar             # ** for recursive globbing
shopt -s nocaseglob           # Case-insensitive globbing
shopt -s nullglob             # Non-matching globs expand to nothing
shopt -s nocasematch          # Case-insensitive pattern matching

# ==============================================================================
# 5. SAFETY SETTINGS (Prevent Disasters)
# ==============================================================================
set -o noclobber              # Prevent > from overwriting files
set -o notify                 # Notify when background jobs complete

# ==============================================================================
# 6. DIRECTORY BOOKMARKS SYSTEM
# ==============================================================================
BOOKMARKS_FILE="$HOME/.local/share/bash_bookmarks"
[[ -d "$HOME/.local/share" ]] || mkdir -p "$HOME/.local/share"
[[ -f "$BOOKMARKS_FILE" ]] || touch "$BOOKMARKS_FILE"

# Save current directory as bookmark
bm() {
    local name="${1:-default}"
    local path="$(pwd)"
    if grep -q "^${name}:" "$BOOKMARKS_FILE" 2>/dev/null; then
        sed -i "s|^${name}:.*|${name}:${path}|" "$BOOKMARKS_FILE"
    else
        echo "${name}:${path}" >> "$BOOKMARKS_FILE"
    fi
    echo "✓ Bookmark saved: $name → $path"
}

# Go to bookmark
gm() {
    local name="${1:-default}"
    local path=$(grep "^${name}:" "$BOOKMARKS_FILE" 2>/dev/null | cut -d: -f2-)
    if [[ -n "$path" ]]; then
        cd "$path"
    else
        echo "✗ Bookmark not found: $name"
    fi
}

# List all bookmarks
bm_list() {
    if [[ -s "$BOOKMARKS_FILE" ]]; then
        echo "📚 Bookmarks:"
        while IFS=: read -r name path; do
            [[ -n "$name" ]] && printf "  %-15s → %s\n" "$name" "$path"
        done < "$BOOKMARKS_FILE"
    else
        echo "No bookmarks saved"
    fi
}

# Remove bookmark
bm_rm() {
    local name="$1"
    if grep -q "^${name}:" "$BOOKMARKS_FILE" 2>/dev/null; then
        sed -i "/^${name}:/d" "$BOOKMARKS_FILE"
        echo "✓ Bookmark removed: $name"
    else
        echo "✗ Bookmark not found: $name"
    fi
}

# ==============================================================================
# 7. ENHANCED ALIASES
# ==============================================================================

# --- 7.1 Navigation & Directory Listing ---
alias ls='eza --icons --color=auto --group-directories-first'
alias ll='eza -lah --icons --color=auto --group-directories-first --git'
alias la='eza -a --icons --color=auto --group-directories-first'
alias lt='eza --tree --icons --color=auto --level=2 --git-ignore'
alias lt3='eza --tree --icons --color=auto --level=3 --git-ignore'
alias l.='eza -a --icons --color=auto --group-directories-first | grep "^\."'

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias -- -='cd -'
alias ~='cd ~'

# --- 7.2 Package Management (yay/pacman) ---
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

# --- 7.3 Safety Aliases (Interactive Mode) ---
alias rm='rm -Iv'
alias cp='cp -iv'
alias mv='mv -iv'
alias ln='ln -iv'

# --- 7.4 Visual & Display Tools ---
alias cat='bat --paging=never --style=plain'
alias catn='bat --paging=never'  # bat with line numbers
alias htop='btm --basic'
alias df='df -h --output=source,target,size,used,avail,pcent'
alias du='du -h --max-depth=1'
alias free='free -h'
alias ps='ps auxf'
alias ip='ip -color=auto'

# --- 7.5 Git Shortcuts ---
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
alias guncommit='git reset --soft HEAD~1'

# --- 7.6 Quick Access Commands ---
alias x='exit'
alias c='clear'
alias h='history'
alias ports='ss -tlnp'
alias open='xdg-open'
alias ping='ping -c 4'
alias wget='wget -q --show-progress'
alias curl='curl -sL'
alias mkdir='mkdir -pv'

# --- 7.7 System Information ---
alias kernel='uname -r'
alias uptime='uptime -p'
alias disks='lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,UUID'
alias gpu='lspci | grep -i vga'
alias cpu='lscpu | grep "Model name"'

# ==============================================================================
# 8. ENHANCED CUSTOM FUNCTIONS
# ==============================================================================

# --- 8.1 Universal Archive Extractor ---
extract() {
    if [[ ! -f "$1" ]]; then
        echo "✗ '$1' is not a valid file"
        return 1
    fi
    
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
        *)
            echo "✗ Cannot extract '$1' - unknown format"
            return 1
            ;;
    esac
    echo "✓ Extracted: $1"
}

# --- 8.2 Create Archive (Smart Compression) ---
compress() {
    local target="${1%%/}"
    local archive="$2"
    
    if [[ -z "$archive" ]]; then
        archive="${target}.tar.gz"
    fi
    
    case "$archive" in
        *.tar.gz|*.tgz)  tar -czf "$archive" "$target" ;;
        *.tar.bz2|*.tbz2) tar -cjf "$archive" "$target" ;;
        *.tar.xz|*.txz)  tar -cJf "$archive" "$target" ;;
        *.tar.zst|*.tzst) tar --zstd -cf "$archive" "$target" ;;
        *.zip)            zip -r "$archive" "$target" ;;
        *.7z)             7z a "$archive" "$target" ;;
        *) echo "✗ Unknown archive format"; return 1 ;;
    esac
    echo "✓ Created: $archive"
}

# --- 8.3 mkdir + cd Combined ---
mkcd() {
    if [[ -z "$1" ]]; then
        echo "Usage: mkcd <directory>"
        return 1
    fi
    mkdir -pv "$1" && cd "$1"
}

# --- 8.4 Quick Notes System ---
NOTES_DIR="$HOME/.local/share/notes"
[[ -d "$NOTES_DIR" ]] || mkdir -p "$NOTES_DIR"

note() {
    local note_name="${1:-$(date +%Y-%m-%d)}"
    local note_file="$NOTES_DIR/${note_name}.md"
    
    if [[ "$1" == "list" ]] || [[ "$1" == "ls" ]]; then
        echo "📝 Notes:"
        ls -1 "$NOTES_DIR"/*.md 2>/dev/null | xargs -I{} basename {} .md | sed 's/^/  /'
        return 0
    fi
    
    if [[ "$1" == "delete" ]] || [[ "$1" == "rm" ]]; then
        if [[ -f "$NOTES_DIR/${2}.md" ]]; then
            rm "$NOTES_DIR/${2}.md"
            echo "✓ Deleted note: $2"
        else
            echo "✗ Note not found: $2"
        fi
        return 0
    fi
    
    ${EDITOR:-nvim} "$note_file"
}

# --- 8.5 Quick Todo List ---
TODO_FILE="$HOME/.local/share/todo.txt"
[[ -f "$TODO_FILE" ]] || touch "$TODO_FILE"

todo() {
    case "$1" in
        add|a)
            shift
            echo "[ ] $*" >> "$TODO_FILE"
            echo "✓ Added: $*"
            ;;
        done|d)
            local num="$2"
            if [[ -n "$num" ]]; then
                sed -i "${num}s/\[ \]/[x]/" "$TODO_FILE"
                echo "✓ Marked as done: #$num"
            fi
            ;;
        undo|u)
            local num="$2"
            if [[ -n "$num" ]]; then
                sed -i "${num}s/\[x\]/[ ]/" "$TODO_FILE"
                echo "✓ Unmarked: #$num"
            fi
            ;;
        list|ls|"")
            if [[ -s "$TODO_FILE" ]]; then
                nl -ba "$TODO_FILE" | sed 's/\[ \]/☐ /g; s/\[x\]/☑ /g'
            else
                echo "📝 No todos yet. Use: todo add <task>"
            fi
            ;;
        clean)
            grep -v "\[x\]" "$TODO_FILE" > "${TODO_FILE}.tmp" && mv "${TODO_FILE}.tmp" "$TODO_FILE"
            echo "✓ Removed completed tasks"
            ;;
        clear)
            > "$TODO_FILE"
            echo "✓ Cleared all todos"
            ;;
        *)
            echo "Usage: todo [add|done|undo|list|clean|clear] [args]"
            ;;
    esac
}

# --- 8.6 Process Search & Kill ---
pskill() {
    local pattern="$1"
    if [[ -z "$pattern" ]]; then
        echo "Usage: pskill <pattern>"
        return 1
    fi
    
    local pids=$(pgrep -f "$pattern")
    if [[ -n "$pids" ]]; then
        echo "Found processes matching '$pattern':"
        ps auxf | grep -E "$pattern" | grep -v grep
        echo -n "Kill these processes? [y/N] "
        read -r confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            echo "$pids" | xargs kill -9
            echo "✓ Killed processes"
        fi
    else
        echo "✗ No processes found matching '$pattern'"
    fi
}

# --- 8.7 Port Checker ---
port_check() {
    local port="$1"
    if [[ -z "$port" ]]; then
        ss -tlnp
        return 0
    fi
    ss -tlnp | grep ":$port " || echo "Port $port is not in use"
}

# --- 8.8 Quick IP Info ---
myip() {
    echo "🌐 Public IP:  $(curl -sL ifconfig.me)"
    echo "🔗 Local IPv4: $(ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1' | head -1)"
    echo "🔗 Local IPv6: $(ip -6 addr show | grep -oP '(?<=inet6\s)[\da-f:]+' | head -1)"
}

# --- 8.9 Weather Check ---
weather() {
    local location="${1:-Jakarta}"
    curl -sL "wttr.in/${location}?format=3" 
    echo ""
    curl -sL "wttr.in/${location}?1"
}

# --- 8.10 Quick Calculator ---
calc() {
    echo "scale=4; $*" | bc -l
}

# --- 8.11 JSON Formatter ---
jsonf() {
    if [[ -z "$1" ]]; then
        jq .
    else
        jq . "$1"
    fi
}

# --- 8.12 Find Files Quickly ---
ff() {
    find . -type f -iname "*$1*" 2>/dev/null
}

# --- 8.13 Find in Files (grep) ---
fg() {
    grep -rn --color=auto "$1" . 2>/dev/null
}

# --- 8.14 Backup File ---
backup() {
    local file="$1"
    if [[ -f "$file" ]]; then
        cp "$file" "${file}.backup.$(date +%Y%m%d_%H%M%S)"
        echo "✓ Backup created: ${file}.backup.$(date +%Y%m%d_%H%M%S)"
    else
        echo "✗ File not found: $file"
    fi
}

# --- 8.15 Git Commit & Push Quick ---
quickpush() {
    local msg="${1:-Update}"
    git add -A
    git commit -m "$msg"
    git push
    echo "✓ Pushed: $msg"
}

# --- 8.16 Docker Shortcuts ---
if command -v docker &>/dev/null; then
    alias d='docker'
    alias dc='docker compose'
    alias dps='docker ps'
    alias dpsa='docker ps -a'
    alias di='docker images'
    alias drm='docker rm'
    alias drmi='docker rmi'
    alias dlog='docker logs -f'
    dex() {
        docker exec -it "$1" "${2:-bash}"
    }
fi

# ==============================================================================
# 9. FZF INTEGRATION (Fuzzy Finder)
# ==============================================================================
if command -v fzf &>/dev/null; then
    # FZF default options
    export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --border=rounded --cycle --marker='>' --pointer='▶' --separator='─'"
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    
    # Enable fzf keybindings (if fzf installed with keybindings)
    if [[ -f /usr/share/fzf/key-bindings.bash ]]; then
        source /usr/share/fzf/key-bindings.bash
    fi
    if [[ -f /usr/share/fzf/completion.bash ]]; then
        source /usr/share/fzf/completion.bash
    fi
    
    # Custom fzf functions
    # Fuzzy search history
    fh() {
        history | fzf --tac --no-sort | awk '{$1=""; print substr($0,2)}'
    }
    
    # Fuzzy find file and open in editor
    vf() {
        local file=$(fzf)
        [[ -n "$file" ]] && ${EDITOR:-nvim} "$file"
    }
    
    # Fuzzy cd
    fcd() {
        local dir=$(fd --type d --hidden --follow --exclude .git | fzf)
        [[ -n "$dir" ]] && cd "$dir"
    }
    
    # Fuzzy kill process
    fkill() {
        local pid=$(ps auxf | fzf | awk '{print $2}')
        [[ -n "$pid" ]] && kill -9 "$pid" && echo "✓ Killed PID: $pid"
    }
fi

# ==============================================================================
# 10. KEYBOARD SHORTCUTS UNCOMMENT IF NOT WORKING
# ==============================================================================
# History search with arrow keys (if using ble.sh or standalone)
# Arrow key history search (standalone bash, safe with ble.sh)
#bind '"\e[A": history-search-backward'
#bind '"\e[B": history-search-forward'
# Ctrl+Left/Right for word navigation
#bind '"\e[1;5D": backward-word'
#bind '"\e[1;5C": forward-word'
#bind '"\e[3~": delete-char'
# Common shortcuts
#bind '"\e[1;5D": backward-word'      # Ctrl+Left
#bind '"\e[1;5C": forward-word'       # Ctrl+Right
#bind '"\e[3~": delete-char'          # Delete key

# ==============================================================================
# 11. PATH MODIFICATIONS
# ==============================================================================
# Add local bin
export PATH="$HOME/.local/bin:$PATH"

# Add yarn global
[[ -d "$HOME/.yarn/bin" ]] && export PATH="$HOME/.yarn/bin:$PATH"

# Add cargo
[[ -d "$HOME/.cargo/bin" ]] && export PATH="$HOME/.cargo/bin:$PATH"

# Add go
[[ -d "/usr/local/go/bin" ]] && export PATH="/usr/local/go/bin:$PATH"
[[ -d "$HOME/go/bin" ]] && export PATH="$HOME/go/bin:$PATH"

# ==============================================================================
# 12. PROMPT & VISUAL (Starship)
# ==============================================================================
if command -v starship &>/dev/null; then
    eval "$(starship init bash)"
fi

# ==============================================================================
# 13. WELCOME SCREEN (Fastfetch)
# ==============================================================================
if command -v fastfetch &>/dev/null; then
    fastfetch
elif command -v neofetch &>/dev/null; then
    neofetch
fi

# ==============================================================================
# 14. GREETING MESSAGE
# ==============================================================================
show_greeting() {
    local hour=$(date +%H)
    local greeting
    
    if (( hour < 12 )); then
        greeting="Selamat Pagii ^^"
    elif (( hour < 18 )); then
        greeting="Selamat Siangg, brrbrr +_="
    else
        greeting="Sore kaka.."
    fi
    
    echo ""
    echo "  $greeting, $(whoami)! 🌟"
    echo "  $(date '+%A, %B %d, %Y - %H:%M')"
    
    # Show pending todos if any
    local pending=$(grep -c '\[ \]' "$TODO_FILE" 2>/dev/null)
    if (( pending > 0 )); then
        echo "  📋 You have $pending pending todo(s) — type 'todo list'"
    fi
    echo ""
}

show_greeting

# ==============================================================================
# 15. FINAL SETUP - Attach Ble.sh
# ==============================================================================
# Ble.sh di-attach di akhir file agar semua settingan alias, fungsi, dan PATH
# sudah terbaca terlebih dahulu oleh shell sebelum ble.sh mengambil alih UI.
#if [[ -n "$_BLE_BASE_LOADED" ]]; then
#    ble-attach
#fi
# ==============================================================================
# END OF CONFIGURATION
# ==============================================================================
