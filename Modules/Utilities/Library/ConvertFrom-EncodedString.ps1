<#
.SYNOPSIS
	Decodes a string
#>
function ConvertFrom-EncodedString(
	# The input string to decode
	[Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
	[Alias("String", "EncodedString", "URL")]
	[string] $InputObject,

	# What are we decoding
	[Parameter(Mandatory)]
	[ValidateSet("URL", "Base64")]
	[string] $Decode
) {
	switch ($Decode) {
		"URL" {
			return [System.Web.HttpUtility]::UrlDecode($InputObject)
		}
		"Base64" {
			return [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($InputObject))
		}
	}
}
