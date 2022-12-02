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
        $tocBuilder = [ordered]@{}

        ## Populating TOC
        ## Disregarding section numbering as it'd be highly beneficial when parsing JSON
        foreach ($tocEntry in $Document.TOC) {
            switch ($tocEntry.Level) {
                0 {
                    [ref] $null = $tocBuilder.Add($tocEntry.Number, [ordered]@{"Name" = $tocEntry.Name})
                    break
                }
                1 {
                    [ref] $null = $tocBuilder[-1].Add($tocEntry.Number, [ordered]@{"Name" = $tocEntry.Name})
                    break
                }
                2 {
                    [ref] $null = $tocBuilder[-1][-1].Add($tocEntry.Number, [ordered]@{"Name" = $tocEntry.Name})
                    break
                }
                3 {
                    [ref] $null = $tocBuilder[-1][-1][-1].Add($tocEntry.Number, [ordered]@{"Name" = $tocEntry.Name})
                    break
                }
                4 {
                    [ref] $null = $tocBuilder[-1][-1][-1][-1].Add($tocEntry.Number, [ordered]@{"Name" = $tocEntry.Name})
                    break
                }
                5 {
                    [ref] $null = $tocBuilder[-1][-1][-1][-1][-1].Add($tocEntry.Number, [ordered]@{"Name" = $tocEntry.Name})
                    break
                }
                6 {
                    [ref] $null = $tocBuilder[-1][-1][-1][-1][-1][-1].Add($tocEntry.Number, [ordered]@{"Name" = $tocEntry.Name})
                    break
                }
                7 {
                    [ref] $null = $tocBuilder[-1][-1][-1][-1][-1][-1][-1].Add($tocEntry.Number, [ordered]@{"Name" = $tocEntry.Name})
                    break
                }
                8 {
                    [ref] $null = $tocBuilder[-1][-1][-1][-1][-1][-1][-1][-1].Add($tocEntry.Number, [ordered]@{"Name" = $tocEntry.Name})
                    break
                }
                9 {
                    [ref] $null = $tocBuilder[-1][-1][-1][-1][-1][-1][-1][-1][-1].Add($tocEntry.Number, [ordered]@{"Name" = $tocEntry.Name})
                    break
                }
                10 {
                    [ref] $null = $tocBuilder[-1][-1][-1][-1][-1][-1][-1][-1][-1][-1].Add($tocEntry.Number, [ordered]@{"Name" = $tocEntry.Name})
                    break
                }
            }
        }
    
        Write-Host ($tocBuilder | ConvertTo-Json -Depth 100)
        return ($tocBuilder)
    }
}
