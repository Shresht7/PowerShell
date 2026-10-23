# -------------
# Show-Previews
# -------------

function Show-Preview(
	[Parameter(ValueFromRemainingArguments=$true)]
	[string[]] $Rest
) {
	fzf `
		--preview "bat {} --color=always --style=numbers" `
		--preview-window "right:70%" `
		--info inline `
		--bind 'ctrl-p:change-preview-window(right:70%|right:50%|hidden|top:70%|top:50%|hidden|)' `
		$Rest
}

Set-Alias -Name preview -Value Show-Preview -Scope Global
