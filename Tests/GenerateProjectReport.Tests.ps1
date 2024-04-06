# GenerateProjectReport.Tests.ps1
BeforeAll {
    . "$PSScriptRoot/../Scripts/Common/Initialize.ps1"

    $snapshotsPath = "$PSScriptRoot/Snapshots"

    if (!(Test-Path $snapshotsPath)) {
        New-Item -Path $snapshotsPath -ItemType Directory
    }

    $OriginalBasePath = Get-ProjectBasePath

    function Repair-MockPaths([string]$Source) {
        return $Source.Replace($TestDrive, $OriginalBasePath)
    }

    Mock Get-ProjectBasePath { return $TestDrive }

    Copy-Item -Path "$PSScriptRoot/Fakes/*" -Destination (Get-ProjectBasePath) -Recurse
}

Describe "GenerateProjectReport" {
    BeforeEach {
        $htmlReportPath = Resolve-ProjectItemPath -SubPath "Output/ProjectReport.html"

        Mock Invoke-Expression {} -Verifiable -ParameterFilter { $Command -eq $htmlReportPath }
        Mock Get-Date { return "2024-04-06 08:06" }
        Mock Get-PoshEditionString { return "PowerShell Core 7.4.1" }
        Mock Get-OsRuntimeIdentifierString { return "osx-arm64 14.4.1 (Arm64)" }

        # randomized path, to get fresh file for each test
        $markdownOutputTempFilePath = "$([System.IO.Directory]::CreateTempSubdirectory().FullName)/$([Guid]::NewGuid())_GenerateProjectReport.Readme.Output.md"
        $htmlOutputTempFilePath = "$([System.IO.Directory]::CreateTempSubdirectory().FullName)/$([Guid]::NewGuid())_GenerateProjectReport.Output.html"

        & "$PSScriptRoot/../Scripts/GenerateProjectReport.ps1"
        $markdownOutput = Get-Content -Path (Resolve-ProjectItemPath -SubPath "readme.md") -Raw
        (Repair-MockPaths $markdownOutput) | Out-String | Out-File -FilePath $markdownOutputTempFilePath -Force

        $htmlOutput = Get-Content -Path $htmlReportPath -Raw
        $htmlOutput | Out-String | Out-File -FilePath $htmlOutputTempFilePath -Force
    }

    AfterEach {
        if (Test-Path $markdownOutputTempFilePath) {
            Remove-Item $markdownOutputTempFilePath -Force
        }

        if (Test-Path $htmlOutputTempFilePath) {
            Remove-Item $htmlOutputTempFilePath -Force
        }
    }

    It "Tries to open html report in new browser window" {
        Should -InvokeVerifiable
        Should -Invoke -CommandName "Invoke-Expression" -Times 1 -Exactly
    }

    It "Markdown version of project report matches snapshot" {
        $snapshotPath = "$snapshotsPath/GenerateProjectReport.Output.md"
        if (!(Test-Path $snapshotPath)) {
            $markdownOutput | Out-String | Out-File -FilePath $snapshotPath -Force

            Set-ItResult -Inconclusive -Because "Created new snapshot: $snapshotPath"
        }

        $tempOutputFileContents = Repair-MockPaths (Get-Content $markdownOutputTempFilePath -Raw)

        $snapshotContents = (Get-Content $snapshotPath -Raw)

        [String]::IsNullOrWhiteSpace($snapshotContents) | Should -Not -BeTrue -Because "We need initial snapshot with actual data"
        [String]::IsNullOrWhiteSpace($tempOutputFileContents) | Should -Not -BeTrue
        $snapshotContents | Should -BeExactly -ExpectedValue $tempOutputFileContents
    }

    It "Html version of project report matches snapshot" {
        $snapshotPath = "$snapshotsPath/GenerateProjectReport.Output.html"
        if (!(Test-Path $snapshotPath)) {
            $htmlOutput | Out-String | Out-File -FilePath $snapshotPath -Force

            Set-ItResult -Inconclusive -Because "Created new snapshot: $snapshotPath"
        }

        $tempHtmlOutputFileContents = Repair-MockPaths (Get-Content $htmlOutputTempFilePath -Raw)

        $snapshotContents = (Get-Content $snapshotPath -Raw)

        [String]::IsNullOrWhiteSpace($snapshotContents) | Should -Not -BeTrue -Because "We need initial snapshot with actual data"
        [String]::IsNullOrWhiteSpace($tempHtmlOutputFileContents) | Should -Not -BeTrue
        $snapshotContents | Should -Be -ExpectedValue $tempHtmlOutputFileContents -Because "Expected value from generated html report $($htmlReportPath) should still match snapshot $(Split-Path $snapshotPath -Leaf)"
    }
}
