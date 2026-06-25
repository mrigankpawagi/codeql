/**
 * @name Query built by concatenation with a possibly-untrusted string
 * @description Building a SQL or Java Persistence query by concatenating a possibly-untrusted string
 *              is vulnerable to insertion of malicious code.
 * @kind problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision medium
 * @id java/concatenated-sql-query
 * @tags security
 *       external/cwe/cwe-089
 *       external/cwe/cwe-564
 */

import java
import semmle.code.java.security.SqlConcatenatedLib
import semmle.code.java.security.SqlInjectionQuery
import semmle.code.java.security.SqlConcatenatedQuery
private import semmle.code.java.dataflow.internal.ModelExclusions

from QueryInjectionSink query, Expr uncontrolled
where
  (
    builtFromUncontrolledConcat(query.asExpr(), uncontrolled)
    or
    exists(StringBuilderVar sbv |
      uncontrolledStringBuilderQuery(sbv, uncontrolled) and
      UncontrolledStringBuilderSourceFlow::flow(DataFlow::exprNode(sbv.getToStringCall()), query)
    )
  ) and
  not queryIsTaintedBy(query, _, _) and
  // Exclude test files: SQL concatenation in tests is typically for test setup
  // and does not represent a real security vulnerability.
  not isInTestFile(query.asExpr().getFile())
select query, "Query built by concatenation with $@, which may be untrusted.", uncontrolled,
  "this expression"
