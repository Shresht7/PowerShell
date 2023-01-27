<#
.SYNOPSIS
    Preview the themes available for bat
.DESCRIPTION
    The Preview-BatThemes script allows you to preview the themes available for bat.
#>

# Select a file to preview
$File = fzf --prompt "file> " --header "Select a file:" --preview "bat --color=always {}" --preview-window "right:70%"

# Select a theme to preview
$Theme = bat --list-themes | fzf --prompt "theme> " --header "Select a theme:" --preview "bat --theme={} --color=always $File" --preview-window "right:70%"

# Preview the theme
bat --theme=$Theme --color=always $File
$Theme
