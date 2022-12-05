function Out-JsonSection
{
<#
    .SYNOPSIS
        Output formatted Json section.
#>
    [CmdletBinding()]
    param
    (
        ## Section to output
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.Management.Automation.PSObject] $Section
    )
    begin
    {
        ## Initializing section object
        $sectionBuilder = [ordered]@{}

        ## Initializing paragraph counter
        [int]$paragraph = 1

        ## Initializing table counter
        [int]$table = 1
    }
    process
    {
        $sectionBuilder.Add("name", $Section.Name)
        
        foreach ($subSection in $Section.Sections.GetEnumerator())
        {
            Write-Host "Section Type: $($subSection.Type)"
            switch ($subSection.Type)
            {
                'PScribo.Section'
                {
                    Write-Host ($subSection | ConvertTo-Json -Depth 100)
                    # Write-Host ($sectionBuilder | ConvertTo-Json -Depth 100)
                    # Write-Host "Number: $($subSection.Number)"
                    $object = Out-JsonSection -Section $subSection
                    Write-Host $object
                    [ref] $null = $sectionBuilder.Add($subSection.Number, $object)
                    [ref] $null = $object
                }
                'PScribo.Paragraph'
                {
                    [ref] $null = $sectionBuilder.Add("paragraph$($paragraph)", (Out-JsonParagraph -Paragraph $subSection))
                    $paragraph++
                }
                'PScribo.Table'
                {
                    [ref] $null = $sectionBuilder.Add("table$($table)", (Out-JsonTable -Table $subSection))
                    $table++
                }
                Default
                {
                    Write-PScriboMessage -Message ($localized.PluginUnsupportedSection -f $subSection.Type) -IsWarning
                }
            }
        }


        return $sectionBuilder
    }
}
