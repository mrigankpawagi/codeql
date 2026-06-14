---
category: minorAnalysis
---

* The `java/concatenated-sql-query` query now excludes results in test files. SQL concatenation in test code (e.g., test setup and fixture creation) does not represent a real security vulnerability, and flagging it produces noise. MRVA validation on top-100 Java repositories showed this reduces false positives by approximately 73%.
