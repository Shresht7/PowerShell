# `Search-Web`

This module provides functionality to search the web using search engines.

---

## 📘 Usage

1. Import the module:

    ```powershell
    Import-Module -Name Search-Web
    ```

2. Search the web

    ```powershell
    Search-Web -Query 'Northern Lights'
    ```

3. Search GitHub

    ```powershell
    Search-Web -Engine github -Query 'PowerShell'
    ```

---

## 📕 Reference

> Note: The search-engine metadata is stored in the `searchEngines.json` file. It is an array of objects containing the `name`, `shortcut` and `url` properties for a search engine.

### `Search-Web`

Launches the default web-browser to do a web-search using a search-engine

#### Parameters

**Query**: The search query to perform.
**Engine**: The search engine to use to perform the search.

---

## 📄 License

This project is licensed under the [MIT License](./LICENSE).
