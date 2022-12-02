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
        $tocBuilder = [System.Collections.ArrayList]::new()

        # ## Initializing TOC
        # $maxSectionNumberLength = $Document.TOC.Number | ForEach-Object { $_.Length } | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
        # 1..$maxSectionNumberLength | ForEach-Object { $tocBuilder.Add(@{}) }

        ## Populating TOC
        if ($Options.ContainsKey('EnableSectionNumbering')) {
            foreach ($tocEntry in $Document.TOC) {
                switch ($tocEntry.Level) {
                    0 {
                        [ref] $null = $tocBuilder.Add([ordered]@{"Section" = $tocEntry.Number; "Name" = $tocEntry.Name})
                        break
                    }
                    1 {
                        [ref] $null = $tocBuilder[-1].Add($tocEntry.Number, [ordered]@{"Section" = $tocEntry.Number; "Name" = $tocEntry.Name})
                        break
                    }
                    2 {
                        [ref] $null = $tocBuilder[-1][-1].Add($tocEntry.Number, [ordered]@{"Section" = $tocEntry.Number; "Name" = $tocEntry.Name})
                        break
                    }
                    3 {
                        [ref] $null = $tocBuilder[-1][-1][-1].Add($tocEntry.Number, [ordered]@{"Section" = $tocEntry.Number; "Name" = $tocEntry.Name})
                        break
                    }
                    4 {
                        [ref] $null = $tocBuilder[-1][-1][-1][-1].Add($tocEntry.Number, [ordered]@{"Section" = $tocEntry.Number; "Name" = $tocEntry.Name})
                        break
                    }
                    5 {
                        [ref] $null = $tocBuilder[-1][-1][-1][-1][-1].Add($tocEntry.Number, [ordered]@{"Section" = $tocEntry.Number; "Name" = $tocEntry.Name})
                        break
                    }
                    6 {
                        [ref] $null = $tocBuilder[-1][-1][-1][-1][-1][-1].Add($tocEntry.Number, [ordered]@{"Section" = $tocEntry.Number; "Name" = $tocEntry.Name})
                        break
                    }
                    7 {
                        [ref] $null = $tocBuilder[-1][-1][-1][-1][-1][-1][-1].Add($tocEntry.Number, [ordered]@{"Section" = $tocEntry.Number; "Name" = $tocEntry.Name})
                        break
                    }
                    8 {
                        [ref] $null = $tocBuilder[-1][-1][-1][-1][-1][-1][-1][-1].Add($tocEntry.Number, [ordered]@{"Section" = $tocEntry.Number; "Name" = $tocEntry.Name})
                        break
                    }
                    9 {
                        [ref] $null = $tocBuilder[-1][-1][-1][-1][-1][-1][-1][-1][-1].Add($tocEntry.Number, [ordered]@{"Section" = $tocEntry.Number; "Name" = $tocEntry.Name})
                        break
                    }
                    10 {
                        [ref] $null = $tocBuilder[-1][-1][-1][-1][-1][-1][-1][-1][-1][-1].Add($tocEntry.Number, [ordered]@{"Section" = $tocEntry.Number; "Name" = $tocEntry.Name})
                        break
                    }
                }
            }
        }
        else {
            $level = $null
            foreach ($tocEntry in $Document.TOC) {
                Write-Host "Beginning...$($tocEntry.Name)"
                Write-Host "Current Level: $($tocEntry.Level)"
                Write-Host "Previous Level: $level"
                switch ($tocEntry.Level) {
                    0 {
                        [ref] $null = $tocBuilder.Add($tocEntry.Name)
                        break
                    }
                    1 {
                        if ($level -ne 1) {
                            if ($tocBuilder[-1].GetType() -eq [string]) {
                                $key = $tocBuilder[-1]
                                $tocBuilder[-1] = @{$key = [System.Collections.ArrayList]::new()}
                            }
                        }
                        else {
                            $key = $tocBuilder[-1].Keys[-1]
                        }
                        Write-Host "Key: $key"
                        [ref] $null = $tocBuilder[-1][$key].Add($tocEntry.Name)
                        break
                    }
                    default {}
                }
                $level = $tocEntry.Level
            }
        }
        Write-Host ($tocBuilder | ConvertTo-Json)
        return ($tocBuilder)
    }
}
