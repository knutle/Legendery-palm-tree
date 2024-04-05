function Write-MarkdownList {
    [CmdletBinding()]
    param(
        # Row object
        [Parameter(ValueFromPipeline)]
        [string]
        $Item
    )

    process {
        Write-Output "* $Item  "
    }
}
