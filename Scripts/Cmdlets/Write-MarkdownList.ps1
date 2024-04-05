function Write-MarkdownList {
    [CmdletBinding()]
    param(
        # Row object
        [Parameter(ValueFromPipeline)]
        [string]
        $Item
    )

    begin {
        Write-Markdown -Format Spacer
    }

    process {
        Write-Output "* $Item  "
    }

    end {
        Write-Markdown -Format Spacer
    }
}
