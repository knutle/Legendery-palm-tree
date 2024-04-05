. "$PSScriptRoot/../Common/Initialize.ps1"

Write-Markdown "Oppgave 3" -Format Heading1

$matchingPaths = Get-ChildItem -Path (Get-AssetPath "Task3") -Filter "*.txt" -Recurse -File | Select-Object -ExpandProperty FullName | Where-Object {
    (Get-Content -Path $_ -Raw) -like "*Sommer*"
}

Write-Markdown "Det fantes $($matchingPaths.Length) filer i oppgavens mappestruktur som oppfylte de gitte kriteriene" -Format Heading3

$assetParentPath = (Get-AssetPath)
$matchingPaths | ForEach-Object {
    [PSCustomObject]@{
        AssetPath    = $_ -replace "^$assetParentPath/*", ""
        AbsolutePath = $_
    }
} | Write-MarkdownTable "AssetPath", "AbsolutePath"
