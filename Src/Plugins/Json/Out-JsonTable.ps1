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
            $caption = Get-TextTableCaption -Table $Table
            Write-Host $caption
            [ref] $null = $Table.Rows | Add-Member -NotePropertyName Caption -NotePropertyValue $caption
        }

        return ($Table.Rows | Select-Object -Property * -ExcludeProperty '*__Style')
    }
}
