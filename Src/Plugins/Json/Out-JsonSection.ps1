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
        # if ($Document.Options['EnableSectionNumbering'])
        # {
            [string] $sectionName = '{0} {1}' -f $Section.Number, $Section.Name
        # }
        # else
        # {
        #     [string] $sectionName = '{0}' -f $Section.Name
        # }
        # [ref] $null = $sectionBuilder.AppendFormat('"{0}": [',$sectionName.TrimStart()).AppendLine()

        $section = foreach ($subSection in $Section.Sections.GetEnumerator())
        {
            $currentIndentationLevel = 1
            if ($null -ne $subSection.PSObject.Properties['Level'])
            {
                $currentIndentationLevel = $subSection.Level +1
            }
            Write-PScriboProcessSectionId -SectionId $subSection.Id -SectionType $subSection.Type -Indent $currentIndentationLevel

            switch ($subSection.Type)
            {
                'PScribo.Section'
                {
                    [ref] $null = $sectionBuilder.Append((Out-JsonSection -Section $subSection))
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

        [ref] $null = $sectionBuilder.Add($sectionName, $section)

        return $sectionBuilder
    }
}
