# Resolve-ProjectItemPath.Tests.ps1
BeforeAll {
    . "$PSScriptRoot/Common/Initialize.ps1"
}

Describe "Ensure we can easily populate our mock project with dummy items" {
    It "Can initialize only empty directory structure if missing" {
        { Resolve-ProjectItemPath -SubPath "NewFolder/Other/Final" } | Should -Throw -ExpectedMessage "Failed to resolve path to project item 'Final' because '*Final' does not exist"

        Resolve-ProjectItemPath -SubPath "NewFolder/Other/Final" -ForceDirectory | Should -Exist
    }

    It "Can initialize missing file with empty directory structure" {
        { Resolve-ProjectItemPath -SubPath "NewFolder/Other/Final/document.txt" } | Should -Throw -ExpectedMessage "Failed to resolve path to project item 'document.txt' because '*Final*document.txt' does not exist"

        Resolve-ProjectItemPath -SubPath "NewFolder/Other/Final/document.txt" -ForceFile | Should -Exist
    }
}

Describe "Ensure we can resolve project items from mocked base path" {
    BeforeAll {
        "surely this must be the final draft" | Out-File -FilePath (Resolve-ProjectItemPath -SubPath "NewFolder/Other/Final/document.txt" -ForceFile)

        Resolve-ProjectItemPath -SubPath "MyStuff/new/archive" -ForceDirectory

        Resolve-ProjectItemPath -SubPath "Assets/one.xml" -ForceFile
        Resolve-ProjectItemPath -SubPath "Assets/seven.xml" -ForceFile
        Resolve-ProjectItemPath -SubPath "Assets/other.txt" -ForceFile

        "[2, 3, 7, 29]" | Out-File -FilePath (Resolve-ProjectItemPath -SubPath "Assets/data/other.json" -ForceFile)
    }

    It "Can confirm TestDrive: resolves to same path as static value returned from mocked function" {
        Get-ProjectBasePath | Should -BeExactly -ExpectedValue ((Get-PSDrive TestDrive).Root)
        Get-ProjectBasePath | Should -Not -BeLike -ExpectedValue "TestDrive:*"
    }

    It "Can resolve mocked asset paths with contents" {
        $jsonPath = Get-AssetPath "data/other.json"

        $jsonPath | Should -Exist

        $parsedList = Get-Content -Path $jsonPath -Raw | ConvertFrom-Json
        $totalSum = $parsedList | Measure-Object -Sum | Select-Object -ExpandProperty Sum

        $parsedList.Length | Should -BeExactly -ExpectedValue 4
        $totalSum | Should -BeExactly 41
    }

    It "Can resolve mocked arbitrary project item with contents" {
        $itemPath = Resolve-ProjectItemPath -SubPath "NewFolder/Other/Final/document.txt"
        $documentText = Get-Content -Path $itemPath -Raw

        $documentText.Trim() | Should -BeExactly "surely this must be the final draft"
    }
}

Describe "Ensure we can resolve project item paths from real base path" {
    BeforeAll {
        Set-MockedProjectBasePath -Path (Get-RealProjectBasePath)
    }

    It "Can get the real base path of the project" {
        Get-ProjectBasePath | Should -BeLike "*/Legendery-palm-tree"
    }

    It "Can resolve real asset paths" {
        $task2JsonAssetPath = Get-AssetPath "Task2/array.json"

        $task2JsonAssetPath | Should -BeLike "*/Legendery-palm-tree/Assets/Task2/array.json"

        $parsedList = Get-Content -Path $task2JsonAssetPath -Raw | ConvertFrom-Json
        $totalSum = $parsedList | Measure-Object -Sum | Select-Object -ExpandProperty Sum

        $parsedList.Length | Should -BeExactly -ExpectedValue 25
        $totalSum | Should -BeExactly 1241
    }

    It "Can resolve real arbitrary project item path" {
        $itemPath = Resolve-ProjectItemPath -SubPath ".vscode/launch.json"
        $jsonObject = Get-Content -Path $itemPath -Raw | ConvertFrom-Json

        $jsonObject.version | Should -BeExactly "0.2.0"
    }
}
