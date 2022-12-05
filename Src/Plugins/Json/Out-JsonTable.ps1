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
            if ($Table.IsKeyedList)
            {
                Write-Host "Keyed List"
                Write-Host $row | ConvertTo-Json -Depth 100
                ## Create new objects with headings as properties
                # $tableText = (ConvertTo-PSObjectKeyedListTable -Table $Table |
                #                 Select-Object -Property * -ExcludeProperty '*__Style' |
                #                 Format-Table -Wrap -AutoSize |
                #                     Out-String).Trim([System.Environment]::NewLine)
                # $tableText = (ConvertTo-PSObjectKeyedListTable -Table $Table |
                #                 Select-Object -Property * -ExcludeProperty '*__Style') #|
                                #Format-Table -Wrap -AutoSize
            }
            elseif ($Table.IsList)
            {
                Write-Host "List"
                Write-Host $row.GetType()          
                # Write-Host $row | ConvertTo-Json -Depth 100  
                # $tableText = ($Table.Rows |
                #     Select-Object -Property * -ExcludeProperty '*__Style' |
                #         Format-List | Out-String).Trim([System.Environment]::NewLine)
                # $tableText = ($Table.Rows |
                #     Select-Object -Property * -ExcludeProperty '*__Style') #|
                    #Format-Table -Wrap -AutoSize
            }
            else
            {
                # Write-Host "Not a List"
                #Write-Host $row
                ## Don't trim tabs for table headers
                ## Tables set to AutoSize as otherwise rendering is different between PoSh v4 and v5
                # $tableText = ($Table.Rows |
                #                 Select-Object -Property * -ExcludeProperty '*__Style' |
                #                     Format-Table -Wrap -AutoSize |
                #                         Out-String).Trim([System.Environment]::NewLine)
                # $tableText = ($Table.Rows |
                #                 Select-Object -Property * -ExcludeProperty '*__Style') #|
                                #Format-Table -Wrap -AutoSize
            }
            
            
            # foreach ($property in $row.PSObject.Properties)
            # {
            #     if ($property.Value -is [System.Array])
            #     {
            #         $property.Value = [System.String]::Join(' ', $property.Value)
            #     }
            #     $property.Value = Resolve-PScriboToken -InputObject $property.Value
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
