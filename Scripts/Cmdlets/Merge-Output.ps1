function Merge-Output {
    [CmdletBinding()]
    param(
        # Input string value
        [Parameter(ValueFromPipeline)]
        [string]
        $InputValue,

        # Append input to here
        [Parameter(Position = 1)]
        [string]
        $OutputVariableName
    )

    process {
        $currentValue = Get-Variable -Name $OutputVariableName -ValueOnly -Scope Script -ErrorAction SilentlyContinue

        if (!$currentValue) {
            $currentValue = @()
        }

        $currentValue += $InputValue

        Set-Variable -Name $OutputVariableName -Value $currentValue -Scope Script
    }
}
