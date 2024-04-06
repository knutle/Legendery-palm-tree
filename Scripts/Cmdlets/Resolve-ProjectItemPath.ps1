function Resolve-ProjectItemPath {
    [CmdletBinding()]
    param(
        # Any valid sub-path from project base directory to resolve
        [Parameter(Position = 1)]
        [string]
        $SubPath,

        # Create any missing folder structure
        [Parameter()]
        [switch]
        $ForceDirectory,

        # Create any missing folder structure and initialize empty file
        [Parameter()]
        [switch]
        $ForceFile
    )

    process {
        $path = (Join-Path (Get-ProjectBasePath) $SubPath)

        if (!(Test-Path $path)) {
            if ($ForceDirectory -and !$ForceFile) {
                New-Item -Path $path -ItemType Directory -Force | Out-Null
            }

            if ($ForceFile) {
                $itemDirPath = Split-Path $path -Parent
                $itemFileName = Split-Path $path -Leaf

                New-Item -Path $itemDirPath -Name $itemFileName -ItemType File -Force | Out-Null
            }
        }

        if (Test-Path $path) {
            return Resolve-Path $path
        }

        throw "Failed to resolve path to project item '$(Split-Path $SubPath -Leaf)' because '$path' does not exist"
    }
}
