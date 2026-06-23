import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import javax.servlet.http.HttpServletRequest;

/**
 * Test that log injection results inside test methods are excluded.
 */
public class LogInjectionTestAnnotation {
    private static final Logger logger = LoggerFactory.getLogger(LogInjectionTestAnnotation.class);

    // GOOD: test methods should not be flagged for log injection
    @Test
    void testLogUserInput(HttpServletRequest request) {
        String userInput = request.getParameter("input");
        logger.info("Testing with input: " + userInput);
    }

    // GOOD: parameterized test should not be flagged
    @ParameterizedTest
    void testLogParameterized(HttpServletRequest request) {
        String userInput = request.getParameter("input");
        logger.warn("Param test: " + userInput);
    }

    // BAD: non-test method should still be flagged
    void handleRequest(HttpServletRequest request) {
        String userInput = request.getParameter("input");
        logger.info("Processing: " + userInput); // $ Alert
    }
}
