function Out-JsonTOC {
    <#
    .SYNOPSIS
        Output formatted Table of Contents
#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.Management.Automation.PSObject] $TOC
    )
    begin {
        ## Fix Set-StrictMode
        if (-not (Test-Path -Path Variable:\Options)) {
            $options = New-PScriboJsonOption
        }
    }
    process {
        [System.Collections.ArrayList] $tocBuilder = @()

        if ($Options.ContainsKey('EnableSectionNumbering')) {
            $maxSectionNumberLength = $Document.TOC.Number | ForEach-Object { $_.Length } | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
            foreach ($tocEntry in $Document.TOC) {
                $sectionNumberPaddingLength = $maxSectionNumberLength - $tocEntry.Number.Length
                $sectionNumberIndent = ''.PadRight($tocEntry.Level, ' ')
                $sectionPadding = ''.PadRight($sectionNumberPaddingLength, ' ')
                [ref] $null = $tocBuilder.AppendFormat('"{0}{1}  {2}{3}"', $tocEntry.Number, $sectionPadding, $sectionNumberIndent, $tocEntry.Name)
            }
        }
        else {
            foreach ($tocEntry in $Document.TOC) {
                if ($null -eq $tocBuilder[$tocEntry.Level]) {
                    [ref] $null = $tocBuilder.Add(@())
                }
                [ref] $null = $tocBuilder[$tocEntry.Level].Add($tocEntry.Name)
            }
        }

        return ($tocBuilder | ConvertTo-Json)
    }
}
