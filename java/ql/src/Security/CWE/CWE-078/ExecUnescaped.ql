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
import semmle.code.java.security.ControlledString
import semmle.code.java.security.ExternalProcess

/**
 * Strings that are known to be sane by some simple local analysis. Such strings
 * do not need to be escaped, because the programmer can predict what the string
 * has in it.
 */
predicate saneString(Expr expr) {
  controlledString(expr)
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
  not execIsTainted(_, _, argument)
select argument, "Command line is built with string concatenation."
