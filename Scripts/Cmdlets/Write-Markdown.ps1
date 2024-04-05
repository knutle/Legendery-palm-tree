function Write-Markdown {
    [CmdletBinding()]
    param(
        # Markdown string
        [Parameter(Position = 1)]
        [string]
        $Value,

        # Text format
        [Parameter()]
        [ValidateSet(
            "Title",
            "Heading1",
            "Heading2",
            "Heading3",
            "Bold",
            "Italic",
            "Code",
            "CodeBlock",
            "Blockquote",
            "MathEquation",
            "Spacer",
            "Default"
        )]
        [string]
        $Format = "Default"
    )

    process {
        $prefix = ""
        $suffix = ""

        switch ($Format) {
            "Title" {
                $prefix = "# "
                $suffix = ""
            }
            "Heading1" {
                $prefix = "## "
                $suffix = ""
            }
            "Heading2" {
                $prefix = "### "
                $suffix = ""
            }
            "Heading3" {
                $prefix = "#### "
                $suffix = ""
            }
            "Bold" {
                $prefix = "**"
                $suffix = "**"
            }
            "Italic" {
                $prefix = "*"
                $suffix = "*"
            }
            "Blockquote" {
                $prefix = "> "
                $suffix = "  "
            }
            "Code" {
                $prefix = "``"
                $suffix = "``"
            }
            "CodeBlock" {
                $prefix = "``````  "
                $suffix = "  ``````"
            }
            "MathEquation" {
                $prefix = "`$"
                $suffix = "`$"
            }
            "Spacer" {
                $prefix = "  "
                $suffix = ""
            }
            "Default" {
                $prefix = ""
                $suffix = ""
            }
        }

        Write-Output "$prefix$Value$suffix  "
    }
}
