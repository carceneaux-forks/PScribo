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
            [ref] $null = $tocBuilder.Add($tocEntry.Number, $tocEntry.Name)
        }
    
        Write-Host ($tocBuilder | ConvertTo-Json -Depth 100)
        return ($tocBuilder)
    }
}
