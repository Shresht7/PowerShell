# -----------------
# Set-FuzzyLocation
# -----------------

function Set-FuzzyLocation() {
    fd --type directory | fzf | Set-Location
}

Set-Alias cdf Set-FuzzyLocation
