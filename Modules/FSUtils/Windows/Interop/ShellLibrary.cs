using System;
using System.IO;
using System.Collections.Generic;
using System.Runtime.InteropServices;

using PSFSUtils.Shell;

namespace PSFSUtils.WindowsLibraries
{
    [ComImport, Guid("11a66efa-382e-451a-9234-1e0e12ef3085")]
    [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    public interface IShellLibrary
    {
        void LoadLibraryFromItem(IShellItem psiLibrary, uint grfMode);
        void LoadLibraryFromKnownFolder(ref Guid kfidLibrary, uint grfMode);
        void AddFolder(IShellItem psiLocation);
        void RemoveFolder(IShellItem psiLocation);
        void GetFolders(int lff, ref Guid riid, [MarshalAs(UnmanagedType.Interface)] out IShellItemArray ppv);
        void ResolveFolder(IShellItem psiFolderToResolve, uint dwTimeout, ref Guid riid, out IntPtr ppv);
        void GetDefaultSaveFolder(int dsft, ref Guid riid, out IntPtr ppv);
        void SetDefaultSaveFolder(int dsft, IShellItem psi);
        void GetOptions(out uint plofOptions);
        void SetOptions(uint lofMask, uint lofOptions);
        void GetFolderType(out Guid pftid);
        void SetFolderType(ref Guid ftid);
        void GetIcon([MarshalAs(UnmanagedType.LPWStr)] out string ppszIcon);
        void SetIcon([MarshalAs(UnmanagedType.LPWStr)] string pszIcon);
        void Commit();
        void Save(IShellItem psiFolderToSaveIn, [MarshalAs(UnmanagedType.LPWStr)] string pszLibraryName, uint lsf, out IShellItem ppsiSavedTo);
        void SaveInKnownFolder(ref Guid kfidToSaveIn, [MarshalAs(UnmanagedType.LPWStr)] string pszLibraryName, uint lsf, out IShellItem ppsiSavedTo);
    }

    [ComImport, Guid("d9b3211d-e57f-4426-aaef-30a806add397")]
    public class ShellLibraryClass { }

    public static class ShellLibraryInterop
    {
        const uint STGM_READ = 0x0;
        const uint STGM_READWRITE = 0x2;
        const int DSFT_DETECT = 1; // let the shell decide private/public
        const uint LSF_FAILIFTHERE = 0;

        const int LFF_ALLITEMS = 3;
        static Guid IID_IShellItemArray = new Guid("b63ea76d-1f85-456f-a19c-48159efa858b");

        static IShellLibrary Load(string libraryPath, bool write)
        {
            var lib = (IShellLibrary)new ShellLibraryClass();
            var item = ShellItems.FromPath(libraryPath);
            try 
            {
                lib.LoadLibraryFromItem(item, write ? STGM_READWRITE : STGM_READ);
            }
            finally
            {
                Marshal.ReleaseComObject(item);
            }
            return lib;
        }

        public static void Create(string folderPath, string libraryName)
        {
            var lib = (IShellLibrary)new ShellLibraryClass();
            var folder = ShellItems.FromPath(folderPath);
            IShellItem saved = null;
            try 
            {
                lib.Save(folder, libraryName, LSF_FAILIFTHERE, out saved);
            }
            finally
            {
                if (saved != null) Marshal.ReleaseComObject(saved);
                Marshal.ReleaseComObject(folder);
                Marshal.ReleaseComObject(lib);
            }
        }

        public static void AddFolder(string libraryPath, string folderPath)
        {
            var lib = Load(libraryPath, true);
            var folder = ShellItems.FromPath(folderPath);
            try
            {
                lib.AddFolder(folder);
                lib.Commit();
            }
            finally
            {
                Marshal.ReleaseComObject(folder);
                Marshal.ReleaseComObject(lib);
            }
        }

        public static void RemoveFolder(string libraryPath, string folderPath)
        {
            var lib = Load(libraryPath, true);
            IShellItemArray array = null;
            try
            {
                lib.GetFolders(LFF_ALLITEMS, ref IID_IShellItemArray, out array);

                uint count;
                array.GetCount(out count);

                string target = folderPath.TrimEnd('\\');

                for (uint i = 0; i < count; i++)
                {
                    IShellItem item;
                    array.GetItemAt(i, out item);
                    try
                    {
                        string path = ShellItems.GetPath(item);

                        if (string.Equals(path.TrimEnd('\\'), target, StringComparison.OrdinalIgnoreCase))
                        {
                            lib.RemoveFolder(item);
                            lib.Commit();
                            return;
                        }
                    }
                    finally
                    {
                        Marshal.ReleaseComObject(item);
                    }
                }

                throw new InvalidOperationException("Folder not found in library: " + folderPath);
            }
            finally
            {
                if (array != null) Marshal.ReleaseComObject(array);
                Marshal.ReleaseComObject(lib);
            }
        }

        public static void SetDefaultSaveFolder(string libraryPath, string folderPath)
        {
            var lib = Load(libraryPath, true);
            var folder = ShellItems.FromPath(folderPath);
            try {
                lib.SetDefaultSaveFolder(DSFT_DETECT, folder);
                lib.Commit();
            }
            finally {
                Marshal.ReleaseComObject(folder);
                Marshal.ReleaseComObject(lib);
            }
        }

        public static string[] GetFolders(string libraryPath)
        {
            var lib = Load(libraryPath, false);
            IShellItemArray array = null;
            var paths = new List<string>();
            try
            {
                lib.GetFolders(LFF_ALLITEMS, ref IID_IShellItemArray, out array);

                uint count;
                array.GetCount(out count);

                for (uint i = 0; i < count; i++)
                {
                    IShellItem item;
                    array.GetItemAt(i, out item);
                    try
                    {
                        string path = ShellItems.GetPath(item);
                        paths.Add(path);
                    }
                    finally
                    {
                        Marshal.ReleaseComObject(item);
                    }
                }
            }
            finally {
                if (array != null) Marshal.ReleaseComObject(array);
                Marshal.ReleaseComObject(lib);
            }

            return paths.ToArray();
        }

        public static void AddKnownFolder(string libraryPath, Guid knownFolderId)
        {
            var lib = Load(libraryPath, true);
            var folder = ShellItems.FromKnownFolder(knownFolderId);
            try
            {
                lib.AddFolder(folder);
                lib.Commit();
            }
            finally
            {
                Marshal.ReleaseComObject(folder);
                Marshal.ReleaseComObject(lib);
            }
        }
    }
}
