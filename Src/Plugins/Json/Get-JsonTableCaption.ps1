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
        $caption = '{0} {1} {2}' -f $tableStyle.CaptionPrefix, $Table.CaptionNumber, $Table.Caption

        return [PSCustomObject] @{
            caption = $caption
        }
    }
}
