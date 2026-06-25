---
category: majorAnalysis
---
* The `java/log-injection` query now excludes calls to DEBUG and TRACE level logging methods (`debug`, `trace`, `fine`, `finer`, `finest`) from its sinks, since these log levels are typically disabled in production.
* Added `java.net.URLEncoder.encode()` as a sanitizer for the `java/log-injection` query, since URL encoding replaces line breaks with percent-encoded equivalents.
