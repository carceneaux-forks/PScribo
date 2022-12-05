function Out-JsonTable
{
<#
    .SYNOPSIS
        Output formatted Json table.
#>
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.Management.Automation.PSObject] $Table
    )
    process
    {
        if ($Table.HasCaption)
        {
            # [ref] $null = $tableBuilder.AppendFormat('"caption": "{0}"', $Table.Caption).AppendLine()
        }

        return ($Table.Rows | Select-Object -Property * -ExcludeProperty '*__Style')
    }
}
