package com.campus.auth;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        AuthDAO dao = new AuthDAO();
        boolean isLoginValid = dao.validateUserIfVerified(email, password);

        if (isLoginValid) {
            // --- SUCCESSFUL LOGIN ---
            HttpSession session = request.getSession();
            session.setAttribute("email", email);
            
            // --- THIS IS THE NEW, CRITICAL CODE ---
            // We get the user's ID and role
            int userId = dao.getUserIdByEmail(email);
            String role = dao.getUserRole(email);
            
            // We store them BOTH in the session so other servlets can use them
            session.setAttribute("userId", userId); 
            session.setAttribute("role", role); 

            // Redirect based on role
            if ("admin".equals(role)) {
                response.sendRedirect("admin_dashboard.jsp");
            } else {
                response.sendRedirect("dashboard.jsp");
            }
        
        } else {
            // --- FAILED LOGIN ---
            if (dao.doesEmailPasswordMatchButNotVerified(email, password)) {
                response.sendRedirect("login.jsp?error=notverified");
            } else {
                response.sendRedirect("login.jsp?error=invalid");
            }
        }
    }
}