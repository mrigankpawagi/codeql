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
  // Primitive types (int, long, short, byte, char, float, double, boolean) cannot contain
  // shell metacharacters when converted to strings.
  expr.getType() instanceof PrimitiveType
  or
  // Boxed types (Integer, Long, etc.) produce only digits/dots/minus when converted to strings.
  expr.getType() instanceof BoxedType
  or
  // Enum constants are compile-time known values.
  expr.(VarAccess).getVariable() instanceof EnumConstant
  or
  // Calls to methods that return inherently safe values.
  exists(Method m | m = expr.(MethodCall).getMethod() |
    // Class.getName(), Class.getCanonicalName(), Class.getSimpleName() return valid Java identifiers.
    m instanceof ClassNameMethod
    or
    m instanceof ClassSimpleNameMethod
    or
    m.hasName("getCanonicalName") and m.getDeclaringType() instanceof TypeClass
    or
    // System.getProperty(...) returns JVM-controlled system properties.
    m instanceof MethodSystemGetProperty
    or
    // Process.pid() and ProcessHandle.pid() return numeric process IDs.
    (m.hasName("pid") or m.hasName("getPid")) and
    m.getReturnType() instanceof PrimitiveType
  )
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
  not execIsTainted(_, _, argument)
select argument, "Command line is built with string concatenation."
