<#
.SYNOPSIS
	Encode a string
#>
function ConvertTo-EncodedString(
	# The input string to encode
	[Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
	[Alias("String", "Text")]
	[string] $InputObject,

	# To what are we encoding
	[Parameter(Mandatory)]
	[ValidateSet("URL", "Base64")]
	[string] $Encode
) {
	switch ($Encode) {
		"URL" {
			return [System.Web.HttpUtility]::UrlEncode($InputObject)
		}
		"Base64" {
			return [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($InputObject))
		}
	}
}
