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
        ## Fix Set-StrictMode
        if (-not (Test-Path -Path Variable:\Options))
        {
            $options = New-PScriboJsonOption
        }
    }
    process
    {
        $tableStyle = Get-PScriboDocumentStyle -TableStyle $Table.Style
        $tableBuilder = New-Object -TypeName System.Text.StringBuilder
        $tableRenderWidth = 0

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
            ## Create new objects with headings as properties
            $tableText = (ConvertTo-PSObjectKeyedListTable -Table $Table |
                            Select-Object -Property * -ExcludeProperty '*__Style' |
                            Format-Table -Wrap -AutoSize |
                                Out-String).Trim([System.Environment]::NewLine)
        }
        elseif ($Table.IsList)
        {
            $tableText = ($Table.Rows |
                Select-Object -Property * -ExcludeProperty '*__Style' |
                    Format-List | Out-String).Trim([System.Environment]::NewLine)
        }
        else
        {
            ## Don't trim tabs for table headers
            ## Tables set to AutoSize as otherwise rendering is different between PoSh v4 and v5
            $tableText = ($Table.Rows |
                            Select-Object -Property * -ExcludeProperty '*__Style' |
                                Format-Table -Wrap -AutoSize |
                                    Out-String).Trim([System.Environment]::NewLine)
        }

        $tableJson = $tableText | ConvertTo-Json -Depth 10

        # if ($Table.HasCaption -and ($tableStyle.CaptionLocation -eq 'Above'))
        # {
        #     $justifiedCaption = Get-JsonTableCaption -Table $Table
        #     [ref] $null = $tableBuilder.AppendLine($justifiedCaption)
        #     [ref] $null = $tableBuilder.AppendLine()
        # }

        ## We don't want to wrap table contents so just justify it
        # $convertToJustifiedStringParams = @{
        #     InputObject = $tableText
        #     Width = $tableRenderWidth
        #     Align = $tableStyle.Align
        # }
        # $justifiedTableText = ConvertTo-JustifiedString @convertToJustifiedStringParams
        
        [ref] $null = $tableBuilder.AppendLine('{')
        [ref] $null = $tableBuilder.AppendLine($tableJson)
        [ref] $null = $tableBuilder.Append(',')

        if ($Table.HasCaption)
        {
            # $justifiedCaption = Get-JsonTableCaption -Table $Table
            [ref] $null = $tableBuilder.AppendFormat('"caption": "{0}"', $Table.Caption).AppendLine()
        }

        [ref] $null = $tableBuilder.AppendLine('}')
        # $convertToIndentedStringParams = @{
        #     InputObject = $tableBuilder.ToString()
        #     Tabs        = $Table.Tabs
        # }

        return $tableBuilder.ToString()
    }
}
