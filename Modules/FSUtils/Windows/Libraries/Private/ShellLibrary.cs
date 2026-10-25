using System;
using System.IO;
using System.Runtime.InteropServices;

namespace FSUtils.WindowsLibraries
{
    [ComImport, Guid("43826d1e-e718-42ee-bc55-a1e261c37bfe")]
    [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    public interface IShellItem
    {
        void BindToHandler(IntPtr pbc, ref Guid bhid, ref Guid riid, out IntPtr ppv);
        void GetParent(out IShellItem ppsi);
        void GetDisplayName(uint sigdnName, [MarshalAs(UnmanagedType.LPWStr)] out string ppszName);
        void GetAttributes(uint sfgaoMask, out uint psfgaoAttribs);
        void Compare(IShellItem psi, uint hint, out int piOrder);
    }

    [ComImport, Guid("11a66efa-382e-451a-9234-1e0e12ef3085")]
    [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    public interface IShellLibrary
    {
        void LoadLibraryFromItem(IShellItem psiLibrary, uint grfMode);
        void LoadLibraryFromKnownFolder(ref Guid kfidLibrary, uint grfMode);
        void AddFolder(IShellItem psiLocation);
        void RemoveFolder(IShellItem psiLocation);
        void GetFolders(int lff, ref Guid riid, out IntPtr ppv);
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

        static Guid IID_IShellItem = new Guid("43826d1e-e718-42ee-bc55-a1e261c37bfe");

        [DllImport("shell32.dll", CharSet = CharSet.Unicode, PreserveSig = false)]
        static extern void SHCreateItemFromParsingName(
            string pszPath, IntPtr pbc, ref Guid riid,
            [MarshalAs(UnmanagedType.Interface)] out IShellItem ppv
        );

        static IShellItem ItemFromPath(string path)
        {
            IShellItem item;
            SHCreateItemFromParsingName(path, IntPtr.Zero, ref IID_IShellItem, out item);
            return item;
        }

        static IShellLibrary Load(string libraryPath, bool write)
        {
            var lib = (IShellLibrary)new ShellLibraryClass();
            var item = ItemFromPath(libraryPath);
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
            var folder = ItemFromPath(folderPath);
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
            var folder = ItemFromPath(folderPath);
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
            var folder = ItemFromPath(folderPath);
            try {
                lib.RemoveFolder(folder);
                lib.Commit();
            }
            finally {
                Marshal.ReleaseComObject(folder);
                Marshal.ReleaseComObject(lib);
            }
        }

        public static void SetDefaultSaveFolder(string libraryPath, string folderPath)
        {
            var lib = Load(libraryPath, true);
            var folder = ItemFromPath(folderPath);
            try {
                lib.SetDefaultSaveFolder(DSFT_DETECT, folder);
                lib.Commit();
            }
            finally {
                Marshal.ReleaseComObject(folder);
                Marshal.ReleaseComObject(lib);
            }
        }
    }

    public static class KnownFolders
    {
        [DllImport("shell32.dll", CharSet = CharSet.Unicode, PreserveSig = false)]
        static extern void SHGetKnownFolderPath(
            ref Guid rfid,
            uint dwFlags,
            IntPtr hToken,
            [MarshalAs(UnmanagedType.LPWStr)] out string ppszPath
        );

        public static string GetPath(Guid id)
        {
            string path;
            SHGetKnownFolderPath(ref id, 0, IntPtr.Zero, out path);
            return path;
        }
    }
}
