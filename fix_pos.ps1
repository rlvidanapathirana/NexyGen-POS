$content = [System.IO.File]::ReadAllText('pos.html', [System.Text.Encoding]::UTF8)
$pattern1 = '(?m)const\s+_[a-zA-Z0-9_]*\s*=\s*([a-zA-Z0-9_]+);\s*async\s+function\s+\1\s*\('
$content = [regex]::Replace($content, $pattern1, {
    param($m)
    $funcName = $m.Groups[1].Value
    return $m.Value.Replace("async function $funcName(", "$funcName = async function(")
})

$pattern2 = '(?m)const\s+_[a-zA-Z0-9_]*\s*=\s*([a-zA-Z0-9_]+);\s*function\s+\1\s*\('
$content = [regex]::Replace($content, $pattern2, {
    param($m)
    $funcName = $m.Groups[1].Value
    return $m.Value.Replace("function $funcName(", "$funcName = function(")
})

[System.IO.File]::WriteAllText('pos.html', $content, [System.Text.Encoding]::UTF8)
Write-Output "Replacements completed successfully."
