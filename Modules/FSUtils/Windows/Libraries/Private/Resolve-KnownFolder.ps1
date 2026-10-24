<#
.SYNOPSIS
    Resolves a known folder ID to its path
.DESCRIPTION
    Uses the KnownFolder API to get the path of a folder by its ID
#>
function Resolve-KnownFolder {

    [CmdletBinding()]
    param(
        # The known folder ID to resolve (GUID)
        [Parameter(Mandatory)]
        [Guid] $Id
    )

    # Load KnownFolderApi if not done so already
    if (-not ('KnownFolderApi' -as [type])) {
        Add-Type @"
using System;
using System.Runtime.InteropServices;

public static class KnownFolderApi
{
    [DllImport("shell32.dll")]
    private static extern int SHGetKnownFolderPath(
        [MarshalAs(UnmanagedType.LPStruct)] Guid rfid,
        uint dwFlags,
        IntPtr hToken,
        out IntPtr ppszPath
    );

    [DllImport("ole32.dll")]
    private static extern void CoTaskMemFree(IntPtr ptr);

    public static string GetPath(Guid folderId) 
    {
        IntPtr pathPtr;

        int hr = SHGetKnownFolderPath(folderId, 0, IntPtr.Zero, out pathPtr);
        
        if (hr != 0)
        {
            Marshal.ThrowExceptionForHR(hr);
        }

        try
        {
            return Marshal.PtrToStringUni(pathPtr);
        }
        finally
        {
            CoTaskMemFree(pathPtr);
        }
    }
}
"@
    }

    # Get the path from the API
    [KnownFolderApi]::GetPath($Id)

}
