# RunTasks.Tests.ps1
BeforeAll {
    . "$PSScriptRoot/Common/Initialize.ps1"
}

Describe "Run Task <taskindex>" -ForEach @(
    @{ TaskIndex = "1" }
    @{ TaskIndex = "2" }
    @{ TaskIndex = "3" }
    @{ TaskIndex = "4" }
) {
    It "Task <taskindex> output matches snapshot" {
        $taskOutput = & "$PSScriptRoot/../Scripts/Tasks/RunTask$taskindex.ps1" | Out-String

        Compare-StringSnapshot -SnapshotId "RunTask$taskindex.Output.md" -InputValue $taskOutput
    }
}
