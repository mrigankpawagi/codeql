---
category: majorAnalysis
---
* The `java/concatenated-sql-query` query now recognizes additional controlled string patterns including method calls on objects constructed from literals, constructor calls with all-literal arguments, and static final field accesses. This reduces false positives from patterns like `new Sha256Hash("admin").toHex()`.
