function Out-JsonParagraph
{
<#
    .SYNOPSIS
        Output formatted paragraph run.
#>
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNull()]
        [System.Management.Automation.PSObject] $Paragraph
    )
    begin
    {
        ## Fix Set-StrictMode
        if (-not (Test-Path -Path Variable:\Options))
        {
            $options = New-PScriboTextOption;
        }
    }
    process
    {
        # $convertToAlignedStringParams = @{
        #     Width       = 0
        #     Tabs        = $Paragraph.Tabs
        #     Align       = 'Left'
        # }

        # if (-not [System.String]::IsNullOrEmpty($Paragraph.Style))
        # {
        #     $paragraphStyle = Get-PScriboDocumentStyle -Style $Paragraph.Style
        #     $convertToAlignedStringParams['Align'] = $paragraphStyle.Align
        # }

        [System.Text.StringBuilder] $paragraphBuilder = New-Object -TypeName 'System.Text.StringBuilder'
        [ref] $null = $paragraphBuilder.AppendLine('[')
        foreach ($paragraphRun in $Paragraph.Sections)
        {
            [ref] $null = $paragraphBuilder.Append('{"')
            $text = Resolve-PScriboToken -InputObject $paragraphRun.Text
            [ref] $null = $paragraphBuilder.Append($text)

            if (($paragraphRun.IsParagraphRunEnd -eq $false) -and
                ($paragraphRun.NoSpace -eq $false))
            {
                [ref] $null = $paragraphBuilder.Append(' ')
            }
            [ref] $null = $paragraphBuilder.AppendLine('"},')
        }

        # $convertToAlignedStringParams['InputObject'] = $paragraphBuilder.ToString()
        [ref] $null = $paragraphBuilder.AppendLine('],')
        return $paragraphBuilder.ToString()
    }
}
