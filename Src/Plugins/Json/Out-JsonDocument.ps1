function Out-JsonDocument
{
<#
    .SYNOPSIS
        Json output plugin for PScribo.

    .DESCRIPTION
        Outputs a Json file representation of a PScribo document object.
#>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments','pluginName')]
    param
    (
        ## ThePScribo document object to convert to a Json document
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.Management.Automation.PSObject] $Document,

        ## Output directory path for the .json file
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNull()]
        [System.String] $Path,

        ### Hashtable of all plugin supported options
        [Parameter()]
        [AllowNull()]
        [System.Collections.Hashtable] $Options
    )
    process
    {
        $pluginName = 'Json'
        $stopwatch = [Diagnostics.Stopwatch]::StartNew()
        Write-PScriboMessage -Message ($localized.DocumentProcessingStarted -f $Document.Name)

        ## Merge the document, plugin default and specified/specific plugin options
        $mergePScriboPluginOptionParams = @{
            DefaultPluginOptions = New-PScriboJsonOption
            DocumentOptions = $Document.Options
            PluginOptions = $Options
        }
        $Options = Merge-PScriboPluginOption @mergePScriboPluginOptionParams
        $script:currentPageNumber = 1

        [System.Text.StringBuilder] $jsonBuilder = New-Object -Type 'System.Text.StringBuilder'
        $firstPageHeader = Out-JsonHeaderFooter -Header -FirstPage
        [ref] $null = $jsonBuilder.Append($firstPageHeader)

        foreach ($subSection in $Document.Sections.GetEnumerator())
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
                    [ref] $null = $jsonBuilder.Append((Out-JsonSection -Section $subSection))
                }
                'PScribo.Paragraph'
                {
                    [ref] $null = $jsonBuilder.Append((Out-JsonParagraph -Paragraph $subSection))
                }
                'PScribo.Table'
                {
                    [ref] $null = $jsonBuilder.Append((Out-JsonTable -Table $subSection))
                }
                'PScribo.TOC'
                {
                    [ref] $null = $jsonBuilder.Append((Out-JsonTOC -TOC $subSection))
                }
                Default
                {
                    Write-PScriboMessage -Message ($localized.PluginUnsupportedSection -f $subSection.Type) -IsWarning
                }
            }
        }

        $pageFooter =Out-JsonHeaderFooter -Footer
        [ref] $null = $jsonBuilder.Append($pageFooter)

        $stopwatch.Stop()
        Write-PScriboMessage -Message ($localized.DocumentProcessingCompleted -f $Document.Name)
        $destinationPath = Join-Path -Path $Path ('{0}.json' -f $Document.Name)
        Write-PScriboMessage -Message ($localized.SavingFile -f $destinationPath)
        $jsonBuilder | ConvertTo-Json | Set-Content -Path $destinationPath -Encoding $Options.Encoding
        [ref] $null = $jsonBuilder

        if ($stopwatch.Elapsed.TotalSeconds -gt 90)
        {
            Write-PScriboMessage -Message ($localized.TotalProcessingTimeMinutes -f $stopwatch.Elapsed.TotalMinutes)
        }
        else
        {
            Write-PScriboMessage -Message ($localized.TotalProcessingTimeSeconds -f $stopwatch.Elapsed.TotalSeconds)
        }

        ## Return the file reference to the pipeline
        Write-Output (Get-Item -Path $destinationPath)
    }
}
