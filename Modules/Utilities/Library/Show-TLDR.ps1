# ---------
# Show-TLDR
# ---------

function Show-TLDR() {
    tldr --list | fzf --preview 'tldr --color=always {}' --preview-window=right:70% | ForEach-Object { tldr $_ }
}

Set-Alias tldrf Show-TLDR

Export-ModuleMember -Function Show-TLDR
Export-ModuleMember -Alias tldrf
