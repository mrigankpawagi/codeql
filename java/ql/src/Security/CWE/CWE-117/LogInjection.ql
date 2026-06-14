/**
 * @name Log Injection
 * @description Building log entries from user-controlled data may allow
 *              insertion of forged log entries by malicious users.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 6.1
 * @precision medium
 * @id java/log-injection
 * @tags security
 *       external/cwe/cwe-117
 */

import java
import semmle.code.java.security.LogInjectionQuery
import LogInjectionFlow::PathGraph
private import semmle.code.java.dataflow.internal.ModelExclusions

from LogInjectionFlow::PathNode source, LogInjectionFlow::PathNode sink
where
  LogInjectionFlow::flowPath(source, sink) and
  // Exclude sinks in test files - log injection in tests is not a real vulnerability.
  not isInTestFile(sink.getNode().asExpr().getFile())
select sink.getNode(), source, sink, "This log entry depends on a $@.", source.getNode(),
  "user-provided value"
