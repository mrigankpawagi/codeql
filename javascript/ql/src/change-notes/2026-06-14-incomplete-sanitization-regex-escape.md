---
category: minorAnalysis
---

* The `js/incomplete-sanitization` query no longer flags "does not escape backslash characters" for replace calls that escape regex special characters (like `$`, `[`, `.`, etc.) for `RegExp` construction, or that escape quote characters within template literal interpolation. These patterns are not security sanitizers and do not need backslash escaping.
