. "$PSScriptRoot/Common/Initialize.ps1"

Write-Markdown "Prosjektrapport" -Format Title | Merge-Output ReportOutput
Write-Markdown "Sist oppdatert: $(Get-Date -Format "yyyy-MM-dd HH:mm") / PowerShell $($PSVersionTable.PSEdition) $($PSVersionTable.PSVersion) / $([System.Runtime.InteropServices.RuntimeInformation]::RuntimeIdentifier) $([System.Environment]::OSVersion.Version.ToString()) ($([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture))" -Format Blockquote | Merge-Output ReportOutput

Write-Markdown "Dette dokumentet samler resultatene fra hver enkelt oppgave i en helhetlig oversikt." -Format Italic | Merge-Output ReportOutput
Write-Markdown "Referanser til detaljer rundt prosjektstruktur og enkeltkomponenter finnes i relevante deler av rapporten." -Format Italic | Merge-Output ReportOutput
Write-Markdown "Oppdatering av rapporten håndteres av __Scripts/GenerateProjectReport.ps1__." -Format Italic | Merge-Output ReportOutput
Write-Markdown "Det er definert launch configs i VSCode for denne i tillegg til hovedkomponentene i prosjektet." -Format Italic | Merge-Output ReportOutput

. "$PSScriptRoot/Tasks/RunTask1.ps1" | Merge-Output ReportOutput
. "$PSScriptRoot/Tasks/RunTask2.ps1" | Merge-Output ReportOutput
. "$PSScriptRoot/Tasks/RunTask3.ps1" | Merge-Output ReportOutput
. "$PSScriptRoot/Tasks/RunTask4.ps1" | Merge-Output ReportOutput

$path = "$PSScriptRoot/../readme.md"
$script:ReportOutput | Out-File $path


$html = ConvertFrom-Markdown -Path $path | Select-Object -ExpandProperty Html
$template = Get-Content -Path (Get-AssetPath "Report/ReportTemplate.html") -Raw
$output = $template.Replace("<!-- {CONTENT} -->", $html)

$outputPath = (Get-AssetPath "../Output/ProjectReport.html")
$output | Out-File -FilePath $outputPath

Invoke-Expression $outputPath
