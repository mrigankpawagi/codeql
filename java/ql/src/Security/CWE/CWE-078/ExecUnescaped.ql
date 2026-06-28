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
  expr instanceof IntegerLiteral
  or
  expr instanceof LongLiteral
  or
  expr instanceof BooleanLiteral
  or
  // Enum constants are compile-time known
  expr.(FieldAccess).getField().getDeclaringType() instanceof EnumType
  or
  // File.separator, File.pathSeparator
  exists(Field f | expr = f.getAnAccess() |
    f.getDeclaringType().hasQualifiedName("java.io", "File") and
    f.getName() in ["separator", "pathSeparator", "separatorChar", "pathSeparatorChar"]
  )
  or
  // System.getProperty("literal") - system properties are not user-controlled
  exists(MethodCall mc | mc = expr |
    mc.getMethod().hasQualifiedName("java.lang", "System", "getProperty") and
    mc.getArgument(0) instanceof StringLiteral
  )
  or
  // Class.getName(), getCanonicalName(), getSimpleName()
  exists(MethodCall mc | mc = expr |
    mc.getMethod().getDeclaringType().hasQualifiedName("java.lang", "Class") and
    mc.getMethod().getName() in ["getName", "getCanonicalName", "getSimpleName"]
  )
  or
  // Integer.toString(literal), String.valueOf(literal) - type conversion of safe values
  exists(MethodCall mc | mc = expr |
    (
      mc.getMethod().hasName("toString") and
      mc.getMethod().isStatic() and
      mc.getMethod().getDeclaringType().getASupertype*().hasQualifiedName("java.lang", "Number")
      or
      mc.getMethod().hasQualifiedName("java.lang", "String", "valueOf")
    ) and
    forall(Expr arg | arg = mc.getAnArgument() | saneString(arg))
  )
  or
  // Concatenation of sane strings
  exists(AddExpr add | add = expr |
    saneString(add.getLeftOperand()) and saneString(add.getRightOperand())
  )
  or
  // Variable tracking
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
  not execIsTainted(_, _, argument)
select argument, "Command line is built with string concatenation."
