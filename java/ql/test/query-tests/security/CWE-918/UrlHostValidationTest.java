import java.io.IOException;
import java.net.URI;
import java.net.URL;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class UrlHostValidationTest extends HttpServlet {
    private static final String ALLOWED_HOST = "api.example.com";
    private HttpClient client = HttpClient.newHttpClient();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // GOOD: URL.getHost() is validated before use
            String userUrl = request.getParameter("url");
            URL parsedUrl = new URL(userUrl);
            if (ALLOWED_HOST.equals(parsedUrl.getHost())) {
                HttpRequest r = HttpRequest.newBuilder(parsedUrl.toURI()).build();
                client.send(r, null);
            }

            // BAD: no host validation
            String unsafeUrl = request.getParameter("url2"); // $ Source
            HttpRequest unsafeReq = HttpRequest.newBuilder(new URI(unsafeUrl)).build(); // $ Alert
            client.send(unsafeReq, null); // $ Alert
        } catch (Exception e) {
            // handle exception
        }
    }
}
