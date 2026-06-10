import java.lang.ProcessBuilder;

/**
 * Test cases for the controlledString predicate in ExecUnescaped.ql.
 * Controlled strings (literals, null, variables assigned only from literals) should
 * not be flagged, while uncontrolled concatenation should still be flagged.
 */
class ExecUnescapedControlledString {

  // GOOD: Concatenation with string literals is controlled and should NOT be flagged.
  public static void safeWithLiterals() throws java.io.IOException {
    String cmd = "/bin/echo" + " hello";
    ProcessBuilder pb = new ProcessBuilder(new String[]{"/bin/bash", "-c", cmd});
    pb.start();
  }

  // GOOD: Variable assigned from a literal is controlled and should NOT be flagged.
  public static void safeWithLiteralVariable() throws java.io.IOException {
    String suffix = "world";
    String cmd = "/bin/echo " + suffix;
    ProcessBuilder pb = new ProcessBuilder(new String[]{"/bin/bash", "-c", cmd});
    pb.start();
  }

  // GOOD: Null is controlled and should NOT be flagged.
  public static void safeWithNull() throws java.io.IOException {
    String suffix = null;
    String cmd = "/bin/echo " + suffix;
    ProcessBuilder pb = new ProcessBuilder(new String[]{"/bin/bash", "-c", cmd});
    pb.start();
  }

  // BAD: Concatenation with uncontrolled input (method parameter) should still be flagged.
  public static void unsafeWithParameter(String userInput) throws java.io.IOException {
    ProcessBuilder pb = new ProcessBuilder(new String[]{"/bin/bash", "-c", "/bin/echo " + userInput});
    pb.start();
  }
}
