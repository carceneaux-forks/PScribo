function Get-JsonTableCaption
{
<#
    .SYNOPSIS
        Generates caption from a PScribo.Table object.
#>
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNull()]
        [System.Management.Automation.PSObject] $Table
    )
    process
    {
        # $tableStyle = Get-PScriboDocumentStyle -TableStyle $Table.Style
        # $convertToAlignedStringParams = @{
        #     InputObject = '{0} {1} {2}' -f $tableStyle.CaptionPrefix, $Table.CaptionNumber, $Table.Caption
        #     Width       = 0
        #     Tabs        = $Table.Tabs
        #     Align       = $tableStyle.Align
        # }
        $caption = '{0} {1} {2}' -f $tableStyle.CaptionPrefix, $Table.CaptionNumber, $Table.Caption

        return $caption
    }
}
