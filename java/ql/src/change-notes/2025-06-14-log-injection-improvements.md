---
category: majorAnalysis
---
* The `java/log-injection` query now excludes calls to DEBUG and TRACE level logging methods (`debug`, `trace`, `fine`, `finer`, `finest`) from its results, since these log levels are typically disabled in production and do not present a realistic log injection attack surface.
* The `java/log-injection` query now recognizes `java.net.URLEncoder.encode()` as a sanitizer, since URL encoding replaces line breaks and other special characters with percent-encoded equivalents.
* The `java/log-injection` query now excludes results in test files to reduce noise from non-production code.
