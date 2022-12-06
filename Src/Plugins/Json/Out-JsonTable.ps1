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
    begin
    {
        ## Initializing table object
        $tableBuilder = [System.Collections.ArrayList]::new()
    }
    process
    {
        Write-Host ":::: BEGINNING ::::"
        Write-Host $Table.Rows.GetType()
        # Write-Host "Table: $($Table.Rows.Length)"
        if ($Table.HasCaption)
        {
            [ref] $null = $tableBuilder.Add((Get-JsonTableCaption -Table $Table))
        }

        [ref] $null = $tableBuilder.Add(($Table.Rows | Select-Object -Property * -ExcludeProperty '*__Style'))
        Write-Host "tableBuilder: $($tableBuilder.Length)"
        Write-Host ":::: END ::::"
        return $tableBuilder
    }
}
