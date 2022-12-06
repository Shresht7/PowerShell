# ----
# Deno
# ----

if (-Not (Find-Path deno)) { return }

Invoke-Expression -Command $(deno completions powershell | Out-String)
