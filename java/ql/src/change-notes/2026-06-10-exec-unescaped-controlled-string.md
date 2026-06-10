---
category: majorAnalysis
---
* The `java/concatenated-command-line` query now uses the shared `controlledString` predicate to identify safe expressions in command-line concatenations, reducing false positives for expressions involving numeric types, enum constants, class names, and other programmer-controlled values.
