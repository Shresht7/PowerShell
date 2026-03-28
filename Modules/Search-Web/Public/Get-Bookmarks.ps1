<#
.SYNOPSIS
    Retrieves all browser bookmarks.
.DESCRIPTION
    Reads and parses the JSON bookmarks file for Chromium-based browsers.
.PARAMETER Path
    The file path to the Bookmarks JSON file.
.PARAMETER Browser
    The name of the browser to retrieve bookmarks for (Edge, Chrome, etc.).
.EXAMPLE
    Get-Bookmarks
.EXAMPLE
    Get-Bookmarks -Browser "Chrome"
.EXAMPLE
    Get-Bookmarks -Path "C:\Custom\Path\Bookmarks"
#>
function Get-Bookmarks {
    [CmdletBinding(DefaultParameterSetName = "Browser")]
    param(
        # Path to the Bookmarks source file
        [Parameter(ParameterSetName = "Path")]
        [string] $Path,

        # Name of the browser to retrieve bookmarks for
        [Parameter(ParameterSetName = "Browser")]
        [ValidateSet("Edge", "Chrome")]
        [string] $Browser = (Get-DefaultBrowser)
    )

    process {
        # Determine the final path based on the parameter set
        $TargetFile = if ($PSCmdlet.ParameterSetName -eq "Path") { 
            $Path 
        }
        else { 
            Get-BookmarksPath -Browser $Browser 
        }

        # Check if the path actually exists
        if (-not $TargetFile -or !(Test-Path -Path $TargetFile -PathType Leaf)) {
            Write-Error "Bookmarks file ($TargetFile) does not exist!"
            return
        }

        # Read and parse the Bookmarks JSON file
        try {
            $BookmarksFile = Get-Content -Path $TargetFile -Raw -ErrorAction Stop | ConvertFrom-Json
        }
        catch {
            Write-Error "Failed to read or parse bookmarks file at $TargetFile. Error: $_"
            return
        }

        # List collection to store the bookmarks
        $Bookmarks = [System.Collections.Generic.List[PSCustomObject]]::new()

        # Define a recursive function to traverse the bookmarks hierarchy
        function RecursivelyCollectBookmarks($node, $parent = "\", $root = "bookmark_bar") {
            foreach ($child in $node.children) {
                # Determine the full-path of the bookmark item
                $FullPath = Join-Path $parent $child.name
                # Add the bookmark item
                $Bookmarks.Add([PSCustomObject]@{
                        Name           = $child.name
                        URL            = $child.url
                        Path           = $parent
                        Type           = $child.type
                        Source         = $child.source
                        Date_Added     = $child.date_added
                        Date_Last_Used = $child.date_last_used
                        Guid           = $child.guid
                        Id             = $child.id
                        Show_Icon      = $child.show_icon
                        FullPath       = $FullPath
                        Root           = $root
                    })
            
                # If it's a folder, recursively collect its bookmarks
                if ($child.type -eq "folder") {
                    RecursivelyCollectBookmarks -node $child -parent (Join-Path $parent $child.name) -root $root
                }
            }
        }

        # Iterate over the roots and collect the bookmarks
        foreach ($root in $BookmarksFile.roots.PSObject.Properties) {
            RecursivelyCollectBookmarks -node $root.Value -parent $root.Name -root $root.Name
        }

        return $Bookmarks
    }
}
