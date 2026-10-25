using System;
using System.Runtime.InteropServices;

namespace PSFSUtils.Shell
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

    [ComImport, Guid("b63ea76d-1f85-456f-a19c-48159efa858b")]
    [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    public interface IShellItemArray
    {
        void BindToHandler(IntPtr pbc, ref Guid bhid, ref Guid riid, out IntPtr ppvOut);
        void GetPropertyStore(int flags, ref Guid riid, out IntPtr ppv);
        void GetPropertyDescriptionList(IntPtr keyType, ref Guid riid, out IntPtr ppv);
        void GetAttributes(int attribFlags, uint sfgaoMask, out uint psfgaoAttribs);
        void GetCount(out uint pdwNumItems);
        void GetItemAt(uint dwIndex, out IShellItem ppsi);
        void EnumItems(out IntPtr ppenumShellItems);
    }

    public static class ShellItems
    {
        const uint SIGDN_FILESYSPATH = 0x80058000;
        static Guid IID_IShellItem = new Guid("43826d1e-e718-42ee-bc55-a1e261c37bfe");

        [DllImport("shell32.dll", CharSet = CharSet.Unicode, PreserveSig = false)]
        static extern void SHCreateItemFromParsingName(
            string pszPath,
            IntPtr pbc,
            ref Guid riid,
            [MarshalAs(UnmanagedType.Interface)] out IShellItem ppv
        );

        public static IShellItem FromPath(string path)
        {
            IShellItem item;
            SHCreateItemFromParsingName(path, IntPtr.Zero, ref IID_IShellItem, out item);
            return item;
        }

        public static string GetPath(IShellItem item)
        {
            string path;
            item.GetDisplayName(SIGDN_FILESYSPATH, out path);
            return path;
        }

        [DllImport("shell32.dll", PreserveSig = false)]
        static extern void SHGetKnownFolderItem(
            ref Guid rfid,
            uint flags,
            IntPtr hToken,
            ref Guid riid,
            [MarshalAs(UnmanagedType.Interface)] out IShellItem ppv
        );

        public static IShellItem FromKnownFolder(Guid id)
        {
            IShellItem item;
            SHGetKnownFolderItem(ref id, 0, IntPtr.Zero, ref IID_IShellItem, out item);
            return item;
        }
    }

    public static class KnownFolders
    {
        [DllImport("shell32.dll", CharSet = CharSet.Unicode, PreserveSig = false)]
        static extern void SHGetKnownFolderPath(
            ref Guid rfid,
            uint dwFlags,
            IntPtr hToken,
            [MarshalAs(UnmanagedType.LPWStr)] out string pszPath
        );

        public static string GetPath(Guid id)
        {
            string path;
            SHGetKnownFolderPath(ref id, 0, IntPtr.Zero, out path);
            return path;
        }
    }
}
