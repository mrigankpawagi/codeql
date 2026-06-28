---
category: majorAnalysis
---
* The `js/incomplete-url-substring-sanitization` query no longer flags substring checks performed on a parsed URL's `.host` or `.hostname` property (e.g., `new URL(x).host.endsWith("github.com")`), since the hostname is already isolated from path and query components, making such checks safe.
