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
        ## Fix Set-StrictMode
        if (-not (Test-Path -Path Variable:\Options))
        {
            $options = New-PScriboJsonOption
        }
    }
    process
    {
        $padding = ''.PadRight(($Section.Tabs * 4), ' ')
        $sectionBuilder = New-Object -TypeName System.Text.StringBuilder
        if ($Document.Options['EnableSectionNumbering'])
        {
            [string] $sectionName = '{0} {1}' -f $Section.Number, $Section.Name
        }
        else
        {
            [string] $sectionName = '{0}' -f $Section.Name
        }
        [ref] $null = $sectionBuilder.AppendLine()
        [ref] $null = $sectionBuilder.Append($padding)
        [ref] $null = $sectionBuilder.AppendLine($sectionName.TrimStart())
        [ref] $null = $sectionBuilder.Append($padding)
        [ref] $null = $sectionBuilder.AppendLine(''.PadRight(($options.SeparatorWidth - $padding.Length), $options.SectionSeparator))

        foreach ($subSection in $Section.Sections.GetEnumerator())
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
                'PScribo.Paragraph'
                {
                    [ref] $null = $sectionBuilder.Append((Out-JsonParagraph -Paragraph $subSection))
                }
                'PScribo.Table'
                {
                    [ref] $null = $sectionBuilder.Append((Out-JsonTable -Table $subSection))
                }
                'PScribo.Image'
                {
                    [ref] $null = $sectionBuilder.Append((Out-JsonImage -Image $subSection))
                }
                Default
                {
                    Write-PScriboMessage -Message ($localized.PluginUnsupportedSection -f $subSection.Type) -IsWarning
                }
            }
        }

        return $sectionBuilder.ToString()
    }
}
