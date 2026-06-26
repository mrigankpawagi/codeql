---
category: majorAnalysis
---
* The `java/concatenated-command-line` query now recognizes additional safe expressions in command-line concatenations, reducing false positives. Specifically, expressions of numeric or boxed types, enum constants, and calls to known-safe methods (such as `System.getProperty`, `Class.getName`, and process ID accessors) are now treated as safe strings that do not need escaping.
