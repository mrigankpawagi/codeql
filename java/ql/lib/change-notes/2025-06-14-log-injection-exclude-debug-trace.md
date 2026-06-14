---
category: majorAnalysis
---
* The `java/log-injection` query no longer considers DEBUG and TRACE level logging calls (including `fine`, `finer`, `finest` for java.util.logging) as log injection sinks. These log levels are typically disabled in production environments, making them unrealistic targets for log injection attacks.
