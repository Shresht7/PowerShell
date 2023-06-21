# `Search-Web`

This module provides functionality to search the web using search engines.

---

## 📕 Reference

> Note: The search-engine metadata is stored in the `searchEngines.json` file. It is an array of objects containing the `name`, `shortcut` and `url` properties for a search engine.

### `Search-Web`

Launches the default web-browser to do a web-search using a search-engine

#### Parameters

- `Query`: The search query to perform.
- `Engine`: The search engine to use to perform the search.

#### Examples

Searches the web for 'PowerShell Documentation' using the default search engine

```powershell
Search-Web "PowerShell Documentation"

Search the web for 'Microsoft PowerToys' using the 'bing' search engine

```powershell
Search-Web -Engine bing -Query 'Microsoft PowerToys'
```

Search GitHub for Terminal

```powershell
Search-Web -Engine GitHub -Query Terminal
```

---

## 📄 License

This project is licensed under the [MIT License](./LICENSE).
