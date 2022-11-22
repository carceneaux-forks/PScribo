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
        $tocBuilder = New-Object -TypeName System.Text.StringBuilder
        [ref] $null = $tocBuilder.AppendFormat('"{0}": [', $TOC.Name).AppendLine()

        $level = $null
        if ($Options.ContainsKey('EnableSectionNumbering')) {
            $maxSectionNumberLength = $Document.TOC.Number | ForEach-Object { $_.Length } | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
            foreach ($tocEntry in $Document.TOC) {
                [ref] $null = $tocBuilder.Append('{')
                $sectionNumberPaddingLength = $maxSectionNumberLength - $tocEntry.Number.Length
                $sectionNumberIndent = ''.PadRight($tocEntry.Level, ' ')
                $sectionPadding = ''.PadRight($sectionNumberPaddingLength, ' ')
                [ref] $null = $tocBuilder.AppendFormat('"{0}{1}  {2}{3}"', $tocEntry.Number, $sectionPadding, $sectionNumberIndent, $tocEntry.Name)
                [ref] $null = $tocBuilder.AppendLine('},')
            }
        }
        else {
            $maxSectionNumberLength = $Document.TOC.Level | Sort-Object | Select-Object -Last 1
            foreach ($tocEntry in $Document.TOC) {
                if ($level -eq $tocEntry.Level) {
                    [ref] $null = $tocBuilder.AppendFormat('"{0}",', $tocEntry.Name).AppendLine()
                }
                else {
                    $level = $tocEntry.Level
                    if ($tocEntry.Level -ne 0) {
                        [ref] $null = $tocBuilder.AppendLine(']')
                    }
                    [ref] $null = $tocBuilder.Append('{')
                    [ref] $null = $tocBuilder.AppendFormat('"{0}": [', $tocEntry.Name).AppendLine()
                }
            }
            [ref] $null = $tocBuilder.AppendLine(']')
        }

        [ref] $null = $tocBuilder.AppendLine('],')

        return $tocBuilder.ToString()
    }
}
