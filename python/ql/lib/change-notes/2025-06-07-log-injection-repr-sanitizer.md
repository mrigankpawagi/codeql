---
category: majorAnalysis
---

* Added `ReprCallSanitizer` to the log injection library, recognizing calls to the built-in `repr()` function as sanitizers. Also modified `LoggingAsSink` to exclude arguments that are formatted with `%r` in the format string, since `%r` applies `repr()` which escapes special characters.
