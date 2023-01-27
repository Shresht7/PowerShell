<#
.SYNOPSIS
    Displays a prompt to the user and returns the choice they made.
.DESCRIPTION
    This function displays a prompt to the user and returns the choice they made. It is similar to the
    `Read-Host` function, but it allows the user to choose from a list of options.
.OUTPUTS
    System.Management.Automation.Host.ChoiceDescription
        The choice that the user made.
.EXAMPLE
    Read-Choice -Title "Choose an option" -Options @(
        New-Choice -Label "Option 1" -HelpMessage "Help for Option 1"
        New-Choice -Label "Option 2" -HelpMessage "Help for Option 2"
        New-Choice -Label "Option 3" -HelpMessage "Help for Option 3"
    )
    Displays a prompt to the user with three options, and returns the choice they made.
#>
function Read-Choice(
    # The title to display to the user.
    [Parameter(Mandatory = $true, Position = 0)]
    [string] $Title,
 
    # The text to display to the user. Defaults to the value of the Title parameter.
    [Parameter(Mandatory = $true, Position = 1)]
    [string] $Info = $Title,
 
    # An array of ChoiceDescription objects that describe the choices available to the user.
    [Parameter(Mandatory = $true, Position = 2)]
    [Alias("Choices")]
    [System.Management.Automation.Host.ChoiceDescription[]] $Options,
 
    # The index of the default choice. Defaults to 0.
    [Parameter(Mandatory = $false, Position = 3)]
    [int] $DefaultChoice = 0
) {
    $Selection = $Host.UI.PromptForChoice($Title, $Info, $Options, $DefaultChoice)
    return $Options[$Selection]
}

Export-ModuleMember -Function Read-Choice

<#
.SYNOPSIS
    Creates a new ChoiceDescription object.
.DESCRIPTION
    This function creates a new ChoiceDescription object. It is used to create the options that are passed to the
    `Read-Choice` function.
.OUTPUTS
    System.Management.Automation.Host.ChoiceDescription
        A new ChoiceDescription object.
.EXAMPLE
    New-Choice -Label "Option 1" -HelpMessage "Option 1"
    Creates a new ChoiceDescription object.
#>
function New-Choice(
    # The label to display to the user.
    [Parameter(Mandatory = $true, Position = 0)]
    [string] $Label,

    # The help message to display to the user.
    [Parameter(Mandatory = $true, Position = 1)]
    [string] $HelpMessage
) {
    return [System.Management.Automation.Host.ChoiceDescription]::new($Label, $HelpMessage)
}

Export-ModuleMember -Function New-Choice
