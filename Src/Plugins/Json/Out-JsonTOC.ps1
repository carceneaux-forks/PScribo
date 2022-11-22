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
        $tocBuilder = New-Object -TypeName 'System.Collections.ArrayList'

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
                if ($tocEntry.Level -gt ($tocBuilder.Count-1)) {
                    $list = New-Object -TypeName 'System.Collections.ArrayList'
                    [ref] $null = $list.Add($tocEntry.Name)
                    [ref] $null = $tocBuilder.Add($list)
                    [ref] $null = $list
                }
                [ref] $null = $tocBuilder[$tocEntry.Level].Add($tocEntry.Name)
            }
        }

        return ($tocBuilder | ConvertTo-Json)
    }
}
