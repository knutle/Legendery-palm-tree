Get-ChildItem -Path "$PSScriptRoot/../Cmdlets" -Filter "*-*.ps1" | ForEach-Object {
    . $_.FullName
}
