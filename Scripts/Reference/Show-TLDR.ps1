<#
.SYNOPSIS
    Show an interactive fuzzy selector for tldr pages
.DESCRIPTION
    This script allows you to fuzzy search through the available tldr pages and display the content.
.EXAMPLE
    .\Show-TLDR.ps1
    This will open a fuzzy selection interface where you can select a tldr page.
    The content of the selected page will be displayed in `bat` with syntax highlighting.
.NOTES
    Requires a `tldr` client (e.g. the official tldr clients or tealdeer).
#>

tldr --list |
Select-Fuzzy -Preview { tldr --color=always $_ } -PreviewSize 70% |
ForEach-Object { tldr $_ }
