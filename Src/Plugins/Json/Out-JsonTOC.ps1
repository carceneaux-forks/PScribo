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

        # ## Initializing TOC
        # $maxSectionNumberLength = $Document.TOC.Number | ForEach-Object { $_.Length } | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
        # 1..$maxSectionNumberLength | ForEach-Object { $tocBuilder.Add(@{}) }

        ## Populating TOC
        # if ($Options.ContainsKey('EnableSectionNumbering')) {
            foreach ($tocEntry in $Document.TOC) {
                switch ($tocEntry.Level) {
                    0 {
                        [ref] $null = $tocBuilder.Add(@{"Section"=$tocEntry.Number;"Name"=$tocEntry.Name})
                        break
                    }
                    1 {
                        $level1 = $tocBuilder.Count - 1
                        [ref] $null = $tocBuilder[$level1].Add($tocEntry.Number,@{"Section"=$tocEntry.Number;"Name"=$tocEntry.Name})
                        break
                    }
                    2 {
                        $level1 = $tocBuilder.Count - 1
                        $level2 = $tocBuilder[$level1].Count - 1
                        [ref] $null = $tocBuilder[$level1][$level2].Add($tocEntry.Number,@{"Section"=$tocEntry.Number;"Name"=$tocEntry.Name})
                        break
                    }
                    3 {
                        $level1 = $tocBuilder.Count - 1
                        $level2 = $tocBuilder[$level1].Count - 1
                        $level3 = $tocBuilder[$level1][$level2].Count - 1
                        [ref] $null = $tocBuilder[$level1][$level2][$level3].Add($tocEntry.Number,@{"Section"=$tocEntry.Number;"Name"=$tocEntry.Name})
                        break
                    }
                }                
            }
        # }
        # else {
        #     foreach ($tocEntry in $Document.TOC) {
        #         [ref] $null = $tocBuilder.Add(@{"Section"=$tocEntry.Number;"Name"=$tocEntry.Name})
        #     }
        # }
        Write-Host ($tocBuilder | ConvertTo-Json)
        return ($tocBuilder)
    }
}
