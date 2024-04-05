function Get-AssetPath {
    [CmdletBinding()]
    param(
        # Asset identifier (any valid sub-path in the Assets directory)
        [Parameter(Position = 1)]
        [string]
        $Identifier
    )

    process {
        $path = (Join-Path "$PSScriptRoot/../../Assets/" $Identifier)

        if (Test-Path $path) {
            return Resolve-Path $path
        }

        throw "Failed to get asset '$Identifier' because '$path' does not exist"
    }
}
