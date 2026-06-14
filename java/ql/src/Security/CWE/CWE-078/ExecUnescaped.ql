/**
 * @name Building a command line with string concatenation
 * @description Using concatenated strings in a command line is vulnerable to malicious
 *              insertion of special characters in the strings.
 * @kind problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision medium
 * @id java/concatenated-command-line
 * @tags security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import java
import semmle.code.java.security.CommandLineQuery
import semmle.code.java.security.ExternalProcess
private import semmle.code.java.dataflow.internal.ModelExclusions

/**
 * Strings that are known to be sane by some simple local analysis. Such strings
 * do not need to be escaped, because the programmer can predict what the string
 * has in it.
 */
predicate saneString(Expr expr) {
  expr instanceof StringLiteral
  or
  expr instanceof NullLiteral
  or
  // Numeric literals cannot contain shell metacharacters.
  expr instanceof IntegerLiteral
  or
  expr instanceof LongLiteral
  or
  expr instanceof FloatingPointLiteral
  or
  expr instanceof DoubleLiteral
  or
  // Expressions of primitive or boxed numeric type cannot contain shell metacharacters
  // when converted to strings (e.g., via string concatenation).
  expr.getType() instanceof PrimitiveType
  or
  expr.getType() instanceof BoxedType
  or
  // Enum constants have programmer-controlled string representations.
  expr.(VarAccess).getVariable() instanceof EnumConstant
  or
  // Compile-time constant expressions are fully controlled by the programmer.
  expr instanceof CompileTimeConstantExpr
  or
  exists(Variable var | var.getAnAccess() = expr and exists(var.getAnAssignedValue()) |
    forall(Expr other | var.getAnAssignedValue() = other | saneString(other))
  )
}

predicate builtFromUncontrolledConcat(Expr expr) {
  exists(AddExpr concatExpr | concatExpr = expr |
    builtFromUncontrolledConcat(concatExpr.getAnOperand())
  )
  or
  exists(AddExpr concatExpr | concatExpr = expr |
    exists(Expr arg | arg = concatExpr.getAnOperand() | not saneString(arg))
  )
  or
  exists(Expr other | builtFromUncontrolledConcat(other) |
    exists(Variable var | var.getAnAssignedValue() = other and var.getAnAccess() = expr)
  )
}

from StringArgumentToExec argument
where
  builtFromUncontrolledConcat(argument) and
  not execIsTainted(_, _, argument) and
  // Exclude test files: command concatenation in tests is typically for test setup
  // and does not represent a real security vulnerability.
  not isInTestFile(argument.getFile())
select argument, "Command line is built with string concatenation."
