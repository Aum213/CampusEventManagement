package com.campus.auth;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/VerifyEmailServlet")
public class VerifyEmailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get the token from the URL (the ?token=... part)
        String token = request.getParameter("token");
        
        if (token == null || token.isEmpty()) {
            // No token provided
            response.sendRedirect("login.jsp?error=verify_failed");
            return;
        }

        AuthDAO dao = new AuthDAO();
        boolean isVerified = dao.verifyToken(token);

        if (isVerified) {
            // --- SUCCESS ---
            // Redirect to the login page with a new "verified=true" message
            response.sendRedirect("login.jsp?verified=true");
        } else {
            // --- FAILURE ---
            // The token was invalid or expired
            response.sendRedirect("login.jsp?error=verify_failed");
        }
    }
}