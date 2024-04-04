. "$PSScriptRoot/Common/Initialize.ps1"

Write-Heading "Oppgave 1"

Write-Heading "Variant 1" -Level Subtitle -Compact

Get-Content -Path (Get-AssetPath "Task1/file.txt") | ForEach-Object {
    [PSCustomObject]@{
        Original = $_
        Reversed = Convert-String $_ -Reverse
    }
} | Format-Table

Write-Heading "Variant 2" -Level Subtitle

Get-Content -Path (Get-AssetPath "Task1/file.txt") | Convert-String -Reverse

