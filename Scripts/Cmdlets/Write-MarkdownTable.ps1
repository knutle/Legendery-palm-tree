function Write-MarkdownTable {
    [CmdletBinding()]
    param(
        # Row object
        [Parameter(ValueFromPipeline)]
        [psobject]
        $Item,

        # Table headers
        [Parameter(Mandatory, Position = 1)]
        [string[]]
        $Headers
    )

    begin {
        $headerRow = $Headers -join " | "
        $headerSeparatorRow = ($Headers | ForEach-Object { "-" }) -join " | "

        Write-Output "$headerRow  "
        Write-Output "-$headerSeparatorRow  "
    }

    process {
        Write-Output "$(($Headers | ForEach-Object { $Item.$_ }) -join " | ")  "
    }

    end {
        Write-Markdown -Format Spacer
    }
}
