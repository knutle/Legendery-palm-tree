function Write-Heading {
    [CmdletBinding()]
    param(
        # Heading text
        [Parameter(Position = 1)]
        [string]
        $Value,

        # Heading level
        [Parameter()]
        [ValidateSet("Title", "Subtitle")]
        [string]
        $Level = "Title",

        # Reduce amount of spacing
        [Parameter()]
        [switch]
        $Compact = $false
    )

    process {
        if ($Level -eq "Title") {
            Write-Host "#" -ForegroundColor Yellow
            Write-Host "# $Value" -ForegroundColor Yellow
            Write-Host "#" -ForegroundColor Yellow
            Write-Host -NoNewline:$Compact

            return
        }

        if ($Level -eq "Subtitle") {
            Write-Host "## $Value" -ForegroundColor Cyan
            Write-Host -NoNewline:$Compact

            return
        }
    }
}
