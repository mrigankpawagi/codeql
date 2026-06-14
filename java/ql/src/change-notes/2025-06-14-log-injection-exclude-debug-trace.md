---
category: majorAnalysis
---
* The `java/log-injection` query now excludes calls to DEBUG and TRACE level logging methods from its results, since these log levels are typically disabled in production and do not present a realistic log injection attack surface. This eliminates approximately 41% of previously reported alerts.
