# GenerateProjectReport.Tests.ps1
BeforeAll {
    . "$PSScriptRoot/Common/Initialize.ps1"
}

Describe "GenerateProjectReport" {
    BeforeEach {
        $htmlReportPath = Resolve-ProjectItemPath -SubPath "Output/ProjectReport.html"

        Mock Invoke-Expression {} -Verifiable -ParameterFilter { $Command -eq $htmlReportPath }

        & "$PSScriptRoot/../Scripts/GenerateProjectReport.ps1"
    }

    It "Tries to open html report in new browser window" {
        Should -InvokeVerifiable
        Should -Invoke -CommandName "Invoke-Expression" -Times 1 -Exactly
    }

    It "Markdown version of project report matches snapshot" {
        Compare-StringSnapshot -SnapshotId "GenerateProjectReport.Output.md" -InputValue (Get-Content -Path (Resolve-ProjectItemPath -SubPath "readme.md") -Raw)
    }

    It "Html version of project report matches snapshot" {
        Compare-StringSnapshot -SnapshotId "GenerateProjectReport.Output.html" -InputValue (Get-Content -Path $htmlReportPath -Raw)
    }
}
