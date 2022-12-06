# -----------------
# Set-FuzzyLocation
# -----------------

function Set-FuzzyLocation() {
    fd --type directory | fzf | Set-Location
}

Set-Alias cdf Set-FuzzyLocation

Export-ModuleMember -Function Set-FuzzyLocation
Export-ModuleMember -Alias cdf
