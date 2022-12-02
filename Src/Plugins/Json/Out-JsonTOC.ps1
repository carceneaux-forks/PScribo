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
        # if (-not (Test-Path -Path Variable:\Options)) {
        #     $options = New-PScriboJsonOption
        # }
    }
    process {
        $tocBuilder = [ordered]@{}

        ## Populating TOC
        ## Disregarding section numbering as its highly beneficial when parsing JSON after the fact
        foreach ($tocEntry in $Document.TOC) {
            [ref] $null = $tocBuilder.Add($tocEntry.Number, $tocEntry.Name)
        }
    
        return ($tocBuilder)
    }
}
