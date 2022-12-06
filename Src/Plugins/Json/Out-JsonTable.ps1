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
            $caption = Get-JsonTableCaption -Table $Table
            Write-Host $Table.Rows.Gettype()
            $Table.Rows += [PSCustomObject] @{
                caption = $caption
            }
            [ref] $null = $caption
        }

        return ($Table.Rows | Select-Object -Property * -ExcludeProperty '*__Style')
    }
}
