<#
.SYNOPSIS
Selects objects using fuzzy search (fzf)

.DESCRIPTION
This cmdlet allows you to perform fuzzy searches on a collection of objects using the Fzf utility.

.PARAMETER InputObject
The input collection of objects to search. Defaults to Get-ChildItem.

.PARAMETER Property
The name of the property to use for fuzzy searching.

.PARAMETER OutputScript
A script block to transform the output.

.PARAMETER Multi
Specifies whether multiple items can be selected.

.PARAMETER Preview
A script block to customize the preview functionality.

.PARAMETER FzfArgs
Additional arguments to pass to the Fzf utility.

.EXAMPLE
Get-Process | Select-FuzzyObject -Property Name
This example selects a process from the list of running processes based on their names.

.EXAMPLE
Get-ChildItem | Select-FuzzyObject -Property Name -Multi -Out { $_.FullName }
This example allows selecting multiple files and returns their full paths.

.NOTES
File Name      : Select-FuzzyObject.ps1
Author         : Shresht7
Prerequisite   : PowerShell v3.0
Copyright 2019 - Your Company
#>
function Select-FuzzyObject(
    # The Input Object
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [object[]] $InputObject = (Get-ChildItem),

    # The property name to use for the fuzzy search
    [string] $Property = "Name",

    # Transforms the resulting output using a script-block
    [scriptblock] $OutputScript,

    # Select multiple items
    [switch] $Multi,

    # Script to run for the preview
    [scriptblock] $Preview,

    # Base Fzf Arguments
    [string[]] $FzfArgs
) {
    begin {
        # A collection to aggregate the input objects coming from the pipeline
        $Collection = [System.Collections.ArrayList]::new()
    }
    process {
        # Add each pipeline item to the collection as they come in
        $Collection.Add($InputObject) | Out-Null
    }
    end {
        # If the input is not from the pipeline, set the input object as the collection
        if (!$PSBoundParameters.ContainsKey('InputObject')) {
            $Collection = $InputObject
        }

        # Determine the thing we will perform fzf on
        $Operand = if ($Collection.$Property.Length -gt 0) { $Collection.$Property } else { $Collection }

        # Perform fuzzy search using fzf
        $Selection = $Operand
        | fzf `
        $(if ($Multi) { "--multi" }) `
        $(if ($Preview) {
                $Res = $Preview.ToString()
                "--preview=$Res"      
            }) `
            @FzfArgs

        
        # A variable to store the results
        $Result = ""

        # If the operation was performed on a collection of objects, return the filtered objects ...
        if ($Operand.Length -gt 0) {
            $Result = $Collection | Where-Object { $_.$Property -eq $Selection -or $Selection -contains $_.$Property }
        }
        # ... otherwise, return the actual selection
        else {
            $Result = $Selection
        }

        # If the Out script is present, perform the Out script on each resulting entry and return the results
        if ($OutputScript) {
            return $Result | ForEach-Object $OutputScript
        }

        # Return the results
        return $Result
    }
}
