package com.campus.events;

import com.campus.auth.AuthDAO;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Handles the final event booking.
 * THIS IS THE CORRECTED VERSION.
 */
@WebServlet("/BookEventServlet")
public class BookEventServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // --- 1. Security & Data Validation ---
        // Check if user is logged in and is an admin
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Get the admin's ID from the session (THIS IS THE FIRST FIX)
        Integer adminIdObj = (Integer) session.getAttribute("userId");

        if (adminIdObj == null) {
            // This is a safety check.
            System.out.println("CRITICAL ERROR: adminId is NULL in session!");
            response.sendRedirect("admin_dashboard.jsp?booking=fail");
            return;
        }
        
        int adminId = adminIdObj; // Safely unbox the Integer

        try {
            // --- 2. Get All Data from the Form ---
            String eventName = request.getParameter("eventName");
            String eventDateStr = request.getParameter("eventDate");
            String startTimeStr = request.getParameter("startTime");
            String endTimeStr = request.getParameter("endTime");
            int venueId = Integer.parseInt(request.getParameter("venueId"));
            
            // Get the new fields
            String eventDescription = request.getParameter("eventDescription");
            String coordinatorContact = request.getParameter("coordinatorContact");

            // --- 3. Convert Data Types (WITH THE FIX) ---
            Date eventDate = Date.valueOf(eventDateStr);
            
            // --- THIS IS THE SECOND FIX ---
            // The HTML <input type="time"> sends "HH:mm" (e.g., "14:00")
            // Java's Time.valueOf() *requires* "HH:mm:ss" (e.g., "14:00:00")
            Time startTime = Time.valueOf(startTimeStr + ":00");
            Time endTime = Time.valueOf(endTimeStr + ":00");

            // --- 4. Call the DAO to Create the Event ---
            EventDAO eventDAO = new EventDAO();
            boolean success = eventDAO.createEvent(
                    eventName,
                    eventDate,
                    startTime,
                    endTime,
                    venueId,
                    adminId,
                    eventDescription,
                    coordinatorContact
            );

            // --- 5. Redirect with Success/Failure Message ---
            if (success) {
                response.sendRedirect("admin_dashboard.jsp?booking=success");
            } else {
                response.sendRedirect("admin_dashboard.jsp?booking=fail");
            }

        } catch (Exception e) {
            // This will catch any errors (like a bad date format or missing parameter)
            System.out.println("--- BOOKING FAILED - EXCEPTION ---");
            e.printStackTrace();
            response.sendRedirect("admin_dashboard.jsp?booking=fail");
        }
    }
}