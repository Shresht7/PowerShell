<#
.SYNOPSIS
    Validates a saved search condition object
.DESCRIPTION
    Checks that a condition has required fields and valid types
#>
function Test-SavedSearchCondition {
    param(
        # The condition to test
        [Parameter(Mandatory)]
        [object] $Condition
    )

    # Extract fields from the condition
    if ($Condition -is [System.Collections.IDictionary]) {
        $Property = if ($Condition.ContainsKey('Property')) { $Condition['Property'] }
        $Operator = if ($Condition.ContainsKey('Operator')) { $Condition['Operator'] }
        $Value = if ($Condition.ContainsKey('Value')) { $Condition['Value'] }
        $PropertyType = if ($Condition.ContainsKey('PropertyType')) { $Condition['PropertyType'] }
    }
    else {
        $Property = $Condition.PSObject.Properties['Property'].Value
        $Operator = $Condition.PSObject.Properties['Operator'].Value
        $Value = $Condition.PSObject.Properties['Value'].Value
        $PropertyType = $Condition.PSObject.Properties['PropertyType'].Value
    }

    # Ensure $Property is set and not empty
    if ([string]::IsNullOrWhiteSpace([string] $Property)) {
        throw 'Each condition must contain a non-empty Property.'
    }

    # Ensure $Operator is set and not empty
    if ([string]::IsNullOrWhiteSpace([string] $Operator)) {
        throw 'Each condition must contain a non-empty Operator.'
    }

    # Ensure $Value is set and not null
    if ($null -eq $Value) {
        throw 'Each condition must contain a Value.'
    }

    # Default PropertyType to string if missing
    if ([string]::IsNullOrWhiteSpace([string] $PropertyType)) {
        $PropertyType = 'string'
    }

    # Check supported types
    $SupportedPropertyTypes = @('string', 'integer', 'date', 'boolean', 'double')
    if ($PropertyType -notin $SupportedPropertyTypes) {
        throw "Unsupported PropertyType '$PropertyType'. Supported types: $($SupportedPropertyTypes -join ', ')."
    }

    # Return validated condition
    [PSCustomObject]@{
        Property     = [string] $Property
        Operator     = [string] $Operator
        Value        = [string] $Value
        PropertyType = [string] $PropertyType
    }
}
