# RunTasks.Tests.ps1
BeforeAll {
    $snapshotsPath = "$PSScriptRoot/Snapshots"

    if (!(Test-Path $snapshotsPath)) {
        New-Item -Path $snapshotsPath -ItemType Directory
    }
}

Describe "Run Task <taskindex>" -ForEach @(
    @{ TaskIndex = "1" }
    @{ TaskIndex = "2" }
    @{ TaskIndex = "3" }
    @{ TaskIndex = "4" }
) {
    BeforeEach {
        # randomized path, to get fresh file for each test
        $markdownOutputTempFilePath = "$([System.IO.Directory]::CreateTempSubdirectory().FullName)/$([Guid]::NewGuid())_RunTasks.Output.md"

        $markdownOutput = & "$PSScriptRoot/../Scripts/Tasks/RunTask$taskindex.ps1"
        $markdownOutput | Out-String | Out-File -FilePath $markdownOutputTempFilePath -Force
    }

    AfterEach {
        if (Test-Path $markdownOutputTempFilePath) {
            Remove-Item $markdownOutputTempFilePath -Force
        }
    }

    It "Task <taskindex> output matches snapshot" {
        $snapshotPath = "$snapshotsPath/RunTask$taskindex.Output.md"
        if (!(Test-Path $snapshotPath)) {
            $markdownOutput | Out-String | Out-File -FilePath $snapshotPath -Force

            Set-ItResult -Inconclusive -Because "Created first snapshot: $snapshotPath"
        }

        $tempOutputFileContents = Get-Content $markdownOutputTempFilePath -Raw

        $snapshotContents = (Get-Content $snapshotPath -Raw)

        [String]::IsNullOrWhiteSpace($snapshotContents) | Should -Not -BeTrue -Because "We need initial snapshot with actual data"
        [String]::IsNullOrWhiteSpace($tempOutputFileContents) | Should -Not -BeTrue
        $snapshotContents | Should -BeExactly -ExpectedValue $tempOutputFileContents
    }
}
