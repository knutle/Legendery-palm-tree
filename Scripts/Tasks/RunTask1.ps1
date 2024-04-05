. "$PSScriptRoot/../Common/Initialize.ps1"

Write-Markdown "Oppgave 1" -Format Heading1

Write-Markdown "Variant 1" -Format Heading2

Get-Content -Path (Get-AssetPath "Task1/file.txt") | ForEach-Object {
    [PSCustomObject]@{
        Original = $_
        Reversed = Convert-String $_ -Reverse
    }
} | Write-MarkdownTable "Original", "Reversed"

Write-Markdown "Variant 2" -Format Heading2
Get-Content -Path (Get-AssetPath "Task1/file.txt") | Convert-String -Reverse | Write-MarkdownList
