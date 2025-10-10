# include this in ~/.bashrc or ~/.zshrc
sshf () {
    local hosts
    hosts=$(grep -E '^Host ' ~/.ssh/config | awk '{print $2}' | grep -v '*' | grep -v '*$' | grep -v 'github')
    local selected_host
    selected_host=$(echo "$hosts" | fzf --height=50% --reverse --prompt="SSH into: ")
    if [ -n "$selected_host" ]; then
        ssh "$selected_host"
    fi
}
