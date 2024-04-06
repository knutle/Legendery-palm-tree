. "$PSScriptRoot/../../Scripts/Common/Initialize.ps1"

$snapshotsPath = "$PSScriptRoot/../Snapshots"
$originalProjectBasePath = "$(Get-ProjectBasePath)"

if (!(Test-Path $snapshotsPath)) {
    New-Item -Path $snapshotsPath -ItemType Directory
}

function Get-RealProjectBasePath() {
    return $originalProjectBasePath
}

$Script:PESTER_MOCKED_BASE_PATH = $TestDrive
function Set-MockedProjectBasePath([string]$Path) {
    $Script:PESTER_MOCKED_BASE_PATH = $Path
}

function Repair-MockPaths($Source) {
    return $Source -replace $TestDrive, $originalProjectBasePath
}
function Publish-ProjectFakes() {
    Copy-Item -Path "$PSScriptRoot/../Fakes/*" -Destination $TestDrive -Recurse
}

function Compare-StringSnapshot([string]$SnapshotId, [string]$InputValue) {
    $snapshotPath = "$snapshotsPath/$SnapshotId"

    if (!(Test-Path $snapshotPath)) {
        Set-Content -Path $snapshotPath -Value $InputValue -Force

        Set-ItResult -Inconclusive -Because "Created new snapshot: $SnapshotId ($snapshotPath)"
    }

    $normalizedInputValue = $InputValue
    $snapshotContent = Get-Content $snapshotPath -Raw

    [String]::IsNullOrWhiteSpace($snapshotContent) | Should -Not -BeTrue -Because "initial snapshot content cannot be empty"
    [String]::IsNullOrWhiteSpace($normalizedInputValue) | Should -Not -BeTrue -Because "comparing empty strings is not supported"
    Should -ActualValue $normalizedInputValue.Trim() -Be -ExpectedValue $snapshotContent.Trim() -Because "actual input value does not match existing snapshot $SnapshotId"
}


Mock Get-ProjectBasePath { return $Script:PESTER_MOCKED_BASE_PATH }
Publish-ProjectFakes
Mock Get-Date { return "2024-04-06 08:06" }
Mock Get-PoshEditionString { return "PowerShell Core 7.4.1" }
Mock Get-OsRuntimeIdentifierString { return "osx-arm64 14.4.1 (Arm64)" }
