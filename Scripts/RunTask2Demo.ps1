. "$PSScriptRoot/Common/Initialize.ps1"

Write-Heading "Oppgave 2"

$evenNumbers = Get-Content -Path (Get-AssetPath "Task2/array.json") -Raw | ConvertFrom-Json | Where-Object {
    !($_ % 2)
} | Sort-Object

Write-Heading "Fant $($evenNumbers.Length) partall i denne json fila: " -Level Subtitle -Compact
Write-Host "$($evenNumbers -join ", ")"
Write-Host

Write-Heading "Summen av disse er: $($evenNumbers | Measure-Object -Sum | Select-Object -expand Sum)" -Level Subtitle
