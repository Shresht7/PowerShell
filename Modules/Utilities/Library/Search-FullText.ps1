# ---------------
# Search-FullText
# ---------------

# Dependencies: fzf, PSFzf, ripgrep and bat

<#
.SYNOPSIS
Performs full-text search
.DESCRIPTION
Uses ripgrep (rg) and fuzzy-finder (fzf) to perform an interactive full-text search and shows the preview using bat
.PARAMETER text
The text or regular expression to search for
.EXAMPLE
Search-FullText TODO:		# Searches for all file containing TODO:
#>
function Search-FullText($text) {
    # rg $text --line-number | fzf --delimiter=":" --preview 'bat --style=numbers --color=always --highlight-line {2} --line-range {2}: {1}'
    Invoke-PsFzfRipgrep $text
}

Set-Alias fts Search-FullText

Export-ModuleMember -Function Search-FullText
Export-ModuleMember -Alias fts
