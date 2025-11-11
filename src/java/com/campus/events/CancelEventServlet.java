package com.campus.events;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Handles the "Cancel Event" button click from the admin dashboard modal.
 */
@WebServlet("/CancelEventServlet")
public class CancelEventServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        
        // --- 1. Security Check ---
        // Must be logged in AND must be an admin
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // --- 2. Get Event ID ---
            int eventId = Integer.parseInt(request.getParameter("eventId"));
            
            // --- 3. Call DAO to Cancel ---
            EventDAO dao = new EventDAO();
            boolean success = dao.cancelEvent(eventId);

            // --- 4. Redirect with Status ---
            if (success) {
                response.sendRedirect("admin_dashboard.jsp?cancellation=success");
            } else {
                response.sendRedirect("admin_dashboard.jsp?cancellation=fail");
            }
            
        } catch (NumberFormatException e) {
            // This happens if eventIdToCancel is missing or not a number
            e.printStackTrace();
            response.sendRedirect("admin_dashboard.jsp?cancellation=fail");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin_dashboard.jsp?cancellation=fail");
        }
    }
}