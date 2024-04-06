function Get-AssetPath {
    [CmdletBinding()]
    param(
        # Asset identifier (any valid sub-path in the Assets directory)
        [Parameter(Position = 1)]
        [string]
        $Identifier
    )

    process {
        return Resolve-ProjectItemPath "Assets/$Identifier"
    }
}
