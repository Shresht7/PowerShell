<#
.SYNOPSIS
    Retrieves all browser bookmarks
#>
function Get-Bookmarks(
    # Path to the Bookmarks source file
    [Parameter(ParameterSetName = "Path")]
    [string] $Path = (Get-BookmarksPath)
) {
    # Check if the path actually exists
    if (!(Test-Path -Path $Path -PathType Leaf)) {
        throw "Bookmarks file ($Path) does not exist!"
    }

    # Read and parse the Bookmarks JSON file
    $BookmarksFile = Get-Content -Path $Path -Raw | ConvertFrom-Json

    # ArrayList collection to store the bookmarks
    $Bookmarks = [System.Collections.ArrayList]@()

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
                }) > $null
        
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
