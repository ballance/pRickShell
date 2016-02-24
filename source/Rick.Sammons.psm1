<#
    Research.Scripts
    Load all child .ps1 files and expose as a module.
#>


# Get all source files, excluding .Test.ps1 files
$allSourceFiles = Get-Item (Join-Path -Path $PSScriptRoot -ChildPath '*\*.ps1') | 
                    Where-Object { $_.Name -notlike '*payloads*' } |
                    Where-Object { $_.Name -notlike '*.Tests.ps1' }

# Load all source files
foreach($sourceFile in $allSourceFiles) {
 
    Write-Verbose ("Importing sub-module {0}." -f $sourceFile.FullName)
    . $sourceFile.FullName | Out-Null
}

# Create a list of exposed function names using the file name
$publicFunctionNames = $allSourceFiles |
    ForEach-Object {
        [IO.Path]::GetFileNameWithoutExtension( $_.Name )
    }

# Export all function names generated by the file name
Export-ModuleMember -Function $publicFunctionNames -Cmdlet '*' -Alias '*'
