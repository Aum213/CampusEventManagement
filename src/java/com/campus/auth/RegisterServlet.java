package com.campus.auth;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name     = request.getParameter("name");
        String email    = request.getParameter("email");
        String password = request.getParameter("password");
        
        // --- NEW LOGIC ---
        // Determine the user's role based on their email domain
        String userRole = "student"; // Default role
        if (email != null && (email.endsWith("@marwadieducation.edu.in") || email.equals("ompujara2103@gmail.com") || email.equals("Niyathakkar.142709@marwadiuniversity.ac.in") || email.equals("gautamiharsh93@gmail.com"))) {
            userRole = "admin";
        }
        // --- END OF NEW LOGIC ---

        String token = UUID.randomUUID().toString();

        AuthDAO dao = new AuthDAO();
        // Pass the new 'userRole' variable to the DAO
        boolean registered = dao.registerUserWithToken(name, email, password, token, userRole);

        if (registered) {
            // build verification link
            String context = request.getContextPath();
            String verifyLink = request.getScheme() + "://" 
                                + request.getServerName() + ":" + request.getServerPort()
                                + context + "/VerifyEmailServlet?token=" + token;

            String subject = "Verify your Campus Event account";
            String body = "Hi " + name + ",\n\n"
                        + "Thanks for registering. Click the link below to verify your email:\n\n"
                        + verifyLink + "\n\n"
                        + "If you didn't register, ignore this message.\n\nRegards,\nCampus Team";

            EmailUtil.sendEmail(email, subject, body);

            // --- THIS IS THE CHANGE ---
            // OLD CODE (using PrintWriter) DELETED.
            // NEW CODE: Redirect back to the register page with a success flag.
            response.sendRedirect("register.jsp?success=true");
            // --- END OF CHANGE ---

        } else {
            response.sendRedirect("register.jsp?error=Registration failed (email may exist).");
        }
    }
}