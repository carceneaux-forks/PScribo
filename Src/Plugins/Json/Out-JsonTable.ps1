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
        ## We need to replace page numbers before outputting the table
        foreach ($row in $Table.Rows)
        {
            foreach ($property in $row.PSObject.Properties)
            {
                if ($property.Value -is [System.Array])
                {
                    $property.Value = [System.String]::Join(' ', $property.Value)
                }
                $property.Value = Resolve-PScriboToken -InputObject $property.Value
            }
        }
        
        ## Rendering the table
        if ($Table.IsKeyedList)
        {
            Write-Host "Keyed List"
            ## Create new objects with headings as properties
            # $tableText = (ConvertTo-PSObjectKeyedListTable -Table $Table |
            #                 Select-Object -Property * -ExcludeProperty '*__Style' |
            #                 Format-Table -Wrap -AutoSize |
            #                     Out-String).Trim([System.Environment]::NewLine)
            $tableText = (ConvertTo-PSObjectKeyedListTable -Table $Table |
                            Select-Object -Property * -ExcludeProperty '*__Style') |
                            Format-Table -Wrap -AutoSize
        }
        elseif ($Table.IsList)
        {
            Write-Host "List"
            # $tableText = ($Table.Rows |
            #     Select-Object -Property * -ExcludeProperty '*__Style' |
            #         Format-List | Out-String).Trim([System.Environment]::NewLine)
            $tableText = ($Table.Rows |
                Select-Object -Property * -ExcludeProperty '*__Style') |
                Format-Table -Wrap -AutoSize
        }
        else
        {
            Write-Host "Not a List"
            ## Don't trim tabs for table headers
            ## Tables set to AutoSize as otherwise rendering is different between PoSh v4 and v5
            # $tableText = ($Table.Rows |
            #                 Select-Object -Property * -ExcludeProperty '*__Style' |
            #                     Format-Table -Wrap -AutoSize |
            #                         Out-String).Trim([System.Environment]::NewLine)
            $tableText = ($Table.Rows |
                            Select-Object -Property * -ExcludeProperty '*__Style') |
                            Format-Table -Wrap -AutoSize
        }

        # Write-Host "tableText type: $($tableText.GetType())"
        Write-Host "tableText unformatted:"
        Write-Host $tableText
        Write-Host "tableText json:"
        Write-Host $tableText | ConvertTo-Json -Depth 100
        
        # [ref] $null = $tableBuilder.Append($tableJson)
        [ref] $null = $tableBuilder.Add("Table Name","Table Data")

        if ($Table.HasCaption)
        {
            # [ref] $null = $tableBuilder.AppendFormat('"caption": "{0}"', $Table.Caption).AppendLine()
        }

        return $tableBuilder
    }
}
