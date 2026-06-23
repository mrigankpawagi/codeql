package test.cwe209.semmle.tests;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Test that stack traces logged to internal logging frameworks are not
 * flagged as information exposure.
 */
class StackTraceLoggingTest extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(StackTraceLoggingTest.class);

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            doSomeWork();
        } catch (Exception ex) {
            // GOOD: stack trace is logged internally, not exposed to user
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            ex.printStackTrace(pw);
            String stackTrace = sw.toString();
            logger.error("Internal error: {}", stackTrace);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred");
        }
    }

    private void doSomeWork() throws Exception {
        throw new Exception("test");
    }
}
