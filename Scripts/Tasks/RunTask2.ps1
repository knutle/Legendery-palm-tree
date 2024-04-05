. "$PSScriptRoot/../Common/Initialize.ps1"

Write-Markdown "Oppgave 2" -Format Heading1

$allNumbers = Get-Content -Path (Get-AssetPath "Task2/array.json") -Raw | ConvertFrom-Json

$evenNumbers = $allNumbers | Where-Object {
    !($_ % 2)
} | Sort-Object

$evenNumbersSum = $($evenNumbers | Measure-Object -Sum | Select-Object -expand Sum)

$abbr = Get-MarkdownAbbreviation -Name "array.json" -Value "Assets/Task2/array.json"

Write-Markdown "Listen fra $abbr inneholder totalt $($allNumbers.Length) tall hvorav $($evenNumbers.Length) er partall" -Format Heading3
Write-Markdown "\displaystyle \sum \ \textcolor{gray}{\{$($evenNumbers -join ",")\}} = \;  \textcolor{green}{\textbf{$evenNumbersSum}}" -Format MathEquation
