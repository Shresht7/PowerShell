# ----------
# GitHub CLI
# ----------

if (-Not (Find-Path gh)) { return }

Invoke-Expression -Command $(gh completion -s powershell | Out-String)
