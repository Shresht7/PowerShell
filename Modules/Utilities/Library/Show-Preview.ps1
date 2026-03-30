# -------------
# Show-Previews
# -------------

function Show-Preview() {
    fzf --preview 'bat --style=numbers --color=always --line-range :500 {}' --preview-window=right:60%
}

Set-Alias -Name preview -Value Show-Preview -Scope Global
