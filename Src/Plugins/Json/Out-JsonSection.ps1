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
    }
    process
    {
        $section = foreach ($subSection in $Section.Sections.GetEnumerator())
        {
            switch ($subSection.Type)
            {
                'PScribo.Section'
                {
                    Out-JsonSection -Section $subSection
                }
                # 'PScribo.Paragraph'
                # {
                #     [ref] $null = $sectionBuilder.Append((Out-JsonParagraph -Paragraph $subSection))
                # }
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

        [ref] $null = $sectionBuilder.Add($Section.Name, $section)
        [ref] $null = $section

        return $sectionBuilder
    }
}
