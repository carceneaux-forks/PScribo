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
            foreach ($tocEntry in $Document.TOC) {
                [ref] $null = $tocBuilder.Add(@{"Section"=$tocEntry.Number;"Name"=$tocEntry.Name})
            }
        }
        else {
            foreach ($tocEntry in $Document.TOC) {
                [ref] $null = $tocBuilder.Add(@{"Name"=$tocEntry.Name})
            }
        }
        Write-Host ($tocBuilder | ConvertTo-Json)
        return ($tocBuilder)
    }
}
