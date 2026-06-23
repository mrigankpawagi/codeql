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

/**
 * Holds if `m` is a test method annotated with a JUnit test annotation.
 */
private predicate isTestMethod(Method m) {
  m.getAnAnnotation().getType().hasQualifiedName("org.junit.jupiter.api",
    ["Test", "ParameterizedTest", "RepeatedTest", "TestFactory"])
  or
  m.getAnAnnotation().getType().hasQualifiedName("org.junit", "Test")
}

from LogInjectionFlow::PathNode source, LogInjectionFlow::PathNode sink
where
  LogInjectionFlow::flowPath(source, sink) and
  not isTestMethod(sink.getNode().getEnclosingCallable())
select sink.getNode(), source, sink, "This log entry depends on a $@.", source.getNode(),
  "user-provided value"
