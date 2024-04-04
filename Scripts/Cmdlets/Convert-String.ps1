function Convert-String {
    [CmdletBinding()]
    param(
        # Input string to convert
        [Parameter(ValueFromPipeline, Position = 1)]
        [string]
        $String,

        # Switch to reverse characters in output string
        [Parameter()]
        [switch]
        $Reverse
    )

    process {
        $charArray = $String.ToCharArray()

        $indexedCharList = @()
        for ($i = 0; $i -lt $charArray.Count; $i++) {
            $indexedCharList += New-Object PSObject -Property @{
                "Index" = $i
                "Item"  = $charArray[$i]
            }
        }

        if ($Reverse) {
            return $indexedCharList | Sort-Object -Property Index -Descending | Join-String -Property Item
        }

        return $indexedCharList
    }
}
