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
        ## Initializing TOC object
        $tocBuilder = [ordered]@{}
    }
    process {
        ## Populating TOC
        ## Disregarding section numbering as its highly beneficial when parsing JSON after the fact
        foreach ($tocEntry in $Document.TOC) {
            [ref] $null = $tocBuilder.Add($tocEntry.Number, $tocEntry.Name)
        }
        Write-Host ($tocBuilder | ConvertTo-Json -Depth 100)
        return ($tocBuilder)
    }
}
