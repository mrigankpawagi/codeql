---
category: majorAnalysis
---
* The `java/concatenated-command-line` query now recognizes additional safe string patterns including `System.getProperty()` calls with literal keys, `File.separator` constants, `Class.getName()` calls, enum constants, and numeric literals. This reduces false positives where non-user-controlled values are concatenated into command lines.
