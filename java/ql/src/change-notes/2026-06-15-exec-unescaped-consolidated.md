---
category: minorAnalysis
---
* The `java/concatenated-command-line` query now uses `controlledString` and `CompileTimeConstantExpr` instead of the previous `saneString` heuristic, reducing false positives for expressions that are known to be safe. Additionally, results in test files are now excluded.
