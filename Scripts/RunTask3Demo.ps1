. "$PSScriptRoot/Common/Initialize.ps1"

Write-Heading "Oppgave 3"

$matchingPaths = Get-ChildItem -Path (Get-AssetPath "Task3") -Filter "*.txt" -Recurse -File | Select-Object -ExpandProperty FullName | Where-Object {
    (Get-Content -Path $_ -Raw) -like "*Sommer*"
}

Write-Heading "Fant disse $($matchingPaths.Length) filene som oppfylte kravene: " -Level Subtitle -Compact

$assetParentPath = (Get-AssetPath)
$matchingPaths | ForEach-Object {
    [PSCustomObject]@{
        AssetPath    = $_ -replace "^$assetParentPath/*", ""
        AbsolutePath = $_
    }
} | Format-Table


