package com.campus.auth;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet to handle user logout.
 * This servlet invalidates the user's session and redirects them to the login page.
 */
@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {

    /**
     * Handles the HTTP GET request. A GET request is used because the logout
     * will be triggered by a simple link in the navbar.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Get the current session, but do not create a new one if it doesn't exist.
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // 2. Invalidate the session.
            // This removes all attributes (like "email" and "role") and logs the user out.
            session.invalidate();
        }
        
        // 3. Redirect the user back to the login page.
        // We add a status parameter to show a friendly "Logged out" message.
        response.sendRedirect("login.jsp?status=logout_success");
    }

    /**
     * Handles the HTTP POST request.
     * In case a form is ever submitted here, we'll just have it do the same thing as doGet.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}