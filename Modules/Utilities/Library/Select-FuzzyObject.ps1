<#
.SYNOPSIS
Selects objects using fuzzy search (fzf)

.DESCRIPTION
This cmdlet allows you to perform fuzzy searches on a collection of objects using the Fzf utility.

.PARAMETER InputObject
The input collection of objects to search. Defaults to Get-ChildItem.

.PARAMETER Property
The name of the property to use for fuzzy searching. Mutually exclusive with -DisplayScript.

.PARAMETER DisplayScript
A script block to build the display string for each object (e.g. { "$($_.Name) ($($_.Id))" }).
Mutually exclusive with -Property.

.PARAMETER OutputScript
A script block to transform the output.

.PARAMETER Multi
Specifies whether multiple items can be selected.

.PARAMETER Preview
A fzf preview command string (e.g. 'bat {1}' or 'cat {1}'). Passed directly to fzf's --preview flag.
Field placeholders like {1}, {2} are automatically offset to account for the internal index field.
Prefer this over passing --preview via -FzfArgs.

.PARAMETER Delimiter
The field delimiter used internally to separate the index from the display value.
Defaults to the ASCII Unit Separator (0x1F), which is invisible and safe for most inputs.
Prefer this over passing --delimiter via -FzfArgs.

.PARAMETER FzfArgs
Additional arguments to pass to the Fzf utility.

.EXAMPLE
Get-Process | Select-FuzzyObject -Property Name
This example selects a process from the list of running processes based on their names.

.EXAMPLE
Get-ChildItem | Select-FuzzyObject -Property Name -Multi -OutputScript { $_.FullName }
This example allows selecting multiple files and returns their full paths.

.EXAMPLE
Get-Process | Select-FuzzyObject -DisplayScript { "$($_.Name) ($($_.Id))" }
This example shows process name and ID in fzf and returns the selected process object.

.NOTES
File Name      : Select-FuzzyObject.ps1
Author         : Shresht7
Prerequisite   : PowerShell v3.0
#>
function Select-FuzzyObject {
    [CmdletBinding(DefaultParameterSetName = 'Property')]
    param (
        # The Input Object
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [object[]] $InputObject = (Get-ChildItem),

        # The property name to use for the fuzzy search
        [Parameter(ParameterSetName = 'Property')]
        [string] $Property = "Name",

        # Script block to build the display string for each object
        [Parameter(ParameterSetName = 'Script')]
        [scriptblock] $DisplayScript,

        # Transforms the resulting output using a script-block
        [scriptblock] $OutputScript,

        # Select multiple items
        [switch] $Multi,

        # Script to run for the preview
        [string] $Preview,

        # Field delimiter used to separate the internal index from the display value
        [string] $Delimiter = [char]0x1F,

        # Base Fzf Arguments
        [string[]] $FzfArgs
    )

    begin {
        # A collection to aggregate the input objects coming from the pipeline
        $Collection = [System.Collections.ArrayList]::new()
    }

    process {
        # Add each pipeline item to the collection as they come in
        [void]$Collection.AddRange($InputObject)
    }

    end {
        # Check if the collection is empty, and return early
        if ($Collection.Count -eq 0) {
            Write-Warning "No input objects were provided."
            return
        }

        # Check if the collection has the specified property (if it has any items)
        $HasProperty = $Collection.Count -gt 0 -and ($Collection | Get-Member -Name $Property)

        # Validate that the specified property exists on the input objects
        if ($PSCmdlet.ParameterSetName -eq 'Property' -and $PSBoundParameters.ContainsKey('Property') -and -not $HasProperty) {
            throw "The property '$Property' does not exist on the input objects."
        }

        # Warn if FzfArgs contains --delimiter or --with-nth as they conflict with internal index-based selection
        if ($FzfArgs -match '^--(delimiter|with-nth)(=.*)?$') {
            Write-Warning "--delimiter and --with-nth are used internally for index-based selection. Use -Delimiter instead of --delimiter, and avoid --with-nth in -FzfArgs."
        }

        # Determine the display values to perform fzf on
        $DisplayValues = if ($PSCmdlet.ParameterSetName -eq 'Script') {
            $Collection | ForEach-Object $DisplayScript
        } elseif ($HasProperty) {
            $Collection.$Property
        } else {
            $Collection
        }

        # Tag each display value with its index so we can recover the original object after selection
        $Operand = 0..($Collection.Count - 1) | ForEach-Object { "$_$Delimiter$($DisplayValues[$_])" }

        # Shift numeric placeholders in the preview string by +1 to account for the internal index field
        $AdjustedPreview = $Preview -replace '\{(\d+)\}', { "{$([int]$_.Groups[1].Value + 1)}" }

        # Perform fuzzy search using fzf
        $Selection = $Operand
        | fzf `
            --with-nth '2..' --delimiter $Delimiter `
        $(if ($Multi) { "--multi" }) `
        $(if ($Preview) { "--preview=$AdjustedPreview" }) `
            @FzfArgs

        # A variable to store the results
        $Result = $null

        # Recover the original objects by parsing the index prefix from each selected line
        if ($Selection) {
            $Result = $Selection | ForEach-Object {
                $Index = [int]($_ -split $Delimiter, 2)[0]
                $Collection[$Index]
            }
        }

        # If the Out script is present, perform the Out script on each resulting entry and return the results
        if ($OutputScript) {
            return $Result | ForEach-Object $OutputScript
        }

        # Return the results
        return $Result
    }
}
