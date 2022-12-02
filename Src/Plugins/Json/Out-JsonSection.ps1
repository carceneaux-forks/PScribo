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
                    $sectionBuilder.Add($subSection.Number, (Out-JsonSection -Section $subSection))
                }
                'PScribo.Paragraph'
                {
                    [ref] $null = $sectionBuilder.Add("paragraph$($paragraph)", (Out-JsonParagraph -Paragraph $subSection))
                    $paragraph++
                }
                # 'PScribo.Table'
                # {
                #     [ref] $null = $sectionBuilder.Append((Out-JsonTable -Table $subSection))
                # }
                # 'PScribo.Image'
                # {
                #     [ref] $null = $sectionBuilder.Append((Out-JsonImage -Image $subSection))
                # }
                Default
                {
                    Write-PScriboMessage -Message ($localized.PluginUnsupportedSection -f $subSection.Type) -IsWarning
                }
            }
        }


        return $sectionBuilder
    }
}
