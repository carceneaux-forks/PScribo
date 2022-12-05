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
        $tableBuilder = [ordered]@{}
    }
    process
    {        
        foreach ($row in $Table.Rows)
        {
            Write-Host $row.Name
            # foreach ($property in $row.PSObject.Properties)
            # {
            #     if (-not ($property.Name).EndsWith('__Style', 'CurrentCultureIgnoreCase'))
            #     {
            #         $propertyId = ($property.Name -replace '[^a-z0-9-_\.]','').ToLower()
            #         $rowElement = $groupElement.AppendChild($xmlDocument.CreateElement($propertyId))
            #         ## Only add the Name attribute if there's a difference
            #         if ($property.Name -ne $propertyId)
            #         {
            #             [ref] $null = $rowElement.SetAttribute('name', $property.Name)
            #         }
            #         [ref] $null = $rowElement.AppendChild($xmlDocument.CreateTextNode($row.($property.Name)))
            #     }
            # }
        }
        
        # [ref] $null = $tableBuilder.Append($tableJson)
        [ref] $null = $tableBuilder.Add("Table Name","Table Data")

        if ($Table.HasCaption)
        {
            # [ref] $null = $tableBuilder.AppendFormat('"caption": "{0}"', $Table.Caption).AppendLine()
        }

        return $tableBuilder
    }
}
