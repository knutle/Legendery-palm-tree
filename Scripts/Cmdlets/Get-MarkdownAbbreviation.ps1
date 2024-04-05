function Get-MarkdownAbbreviation {
    [CmdletBinding()]
    param(
        # Abbreviation
        [Parameter(Position = 1)]
        [string]
        $Name,

        # Description
        [Parameter(Position = 2)]
        [string]
        $Value
    )

    process {
        return "<abbr title=`"$Value`">$Name</abbr>"
    }
}
