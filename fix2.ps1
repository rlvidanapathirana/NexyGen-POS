$content = [System.IO.File]::ReadAllText('pos.html', [System.Text.Encoding]::UTF8)
$content = [regex]::Replace($content, '(?m)const\s+_drawerShowReceipt\s*=\s*showReceipt;\s*function\s+showReceipt\(', "const _drawerShowReceipt = showReceipt;`n    showReceipt = function(")
[System.IO.File]::WriteAllText('pos.html', $content, [System.Text.Encoding]::UTF8)
Write-Output "Fixed drawerShowReceipt"
