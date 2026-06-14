---
category: minorAnalysis
---

* The `java/concatenated-command-line` query now has an improved `saneString` predicate that recognizes numeric literals, expressions of primitive/boxed numeric types, enum constants, and compile-time constant expressions as safe values that cannot contain shell metacharacters. Results in test files are also excluded. This significantly reduces false positives where command lines are built with safe numeric values or known constants.
