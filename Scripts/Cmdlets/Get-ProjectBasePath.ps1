function Get-ProjectBasePath {
    [CmdletBinding()]
    param()

    process {
        return Join-Path $PSScriptRoot "../.." -Resolve
    }
}
