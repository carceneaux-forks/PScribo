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
            switch ($subSection.Type)
            {
                'PScribo.Section'
                {
                    Write-Host "Section: Section"
                    $sectionBuilder.Add($subSection.Number, (Out-JsonSection -Section $subSection))
                }
                'PScribo.Paragraph'
                {
                    Write-Host "Section: Paragraph"
                    [ref] $null = $sectionBuilder.Add("paragraph$($paragraph)", (Out-JsonParagraph -Paragraph $subSection))
                    $paragraph++
                }
                'PScribo.Table'
                {
                    Write-Host "Section: Table"
                    [ref] $null = $sectionBuilder.Add("table$($table)", [PSCustomObject](Out-JsonTable -Table $subSection))
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
