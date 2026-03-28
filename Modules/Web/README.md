# `Search-Web`

This module provides functionality to search the web using search engines and manage browser bookmarks and search engines for Chromium-based browsers (Edge, Chrome, etc.).

---

## 📕 Reference

### `Search-Web`

Launches the default web-browser to do a web-search using a search-engine.

#### Parameters

- `Query`: The search query to perform.
- `Engine`: The search engine to use (e.g., google, bing, github).

#### Examples

Searches the web for 'PowerShell Documentation' using the default search engine.
```powershell
Search-Web "PowerShell Documentation"
```

Search GitHub for Terminal.
```powershell
Search-Web -Engine GitHub -Query Terminal
```

---

### `Get-Bookmarks`

Retrieves bookmarks from a Chromium-based browser.

#### Examples

Get bookmarks from the default browser (Edge).
```powershell
Get-Bookmarks
```

Get bookmarks from Google Chrome.
```powershell
Get-Bookmarks -Path (Get-BookmarksPath -Browser Chrome)
```

---

### `Get-BookmarksPath`

Returns the path to the Bookmarks file for a specified browser.

#### Supported Browsers
- Edge (Default)
- Chrome

---

### `Get-SearchEngines`

Retrieves search engine information from the Edge Web Data SQLite database. Requires `sqlite3.exe`.

---

## 📄 License

This project is licensed under the [MIT License](./LICENSE).
