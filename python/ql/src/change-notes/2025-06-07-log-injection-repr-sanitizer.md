---
category: majorAnalysis
---

* The `py/log-injection` query now recognizes calls to the built-in `repr()` function and use of the `%r` format specifier in logging calls as sanitizers, since these escape special characters such as newlines. This reduces false positives when user-controlled values are logged safely via `repr()` or `%r`.
