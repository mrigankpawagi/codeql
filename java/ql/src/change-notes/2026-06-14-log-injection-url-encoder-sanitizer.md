---
category: minorAnalysis
---

* The `java/log-injection` query now recognizes `URLEncoder.encode()` as a sanitizer, since URL encoding replaces newline characters with percent-encoded sequences (`%0A`, `%0D`), preventing log injection. Results in test files are also excluded. This reduces false positives when user-controlled values are URL-encoded before logging.
