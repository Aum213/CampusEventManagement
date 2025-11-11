package com.campus.events;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/RecommendVenueServlet")
public class RecommendVenueServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        // Security check: Only admins can do this.
        if (session == null || !session.getAttribute("role").equals("admin")) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // --- 1. Get All Form Parameters (FIXED) ---
            // These now use the correct camelCase names to match your JSP form
            String eventName = request.getParameter("eventName");
            String eventDateStr = request.getParameter("eventDate");
            String startTimeStr = request.getParameter("startTime");
            String endTimeStr = request.getParameter("endTime");
            String expectedStudentsStr = request.getParameter("expectedStudents");
            
            // --- Validation Check ---
            if (eventName == null || eventName.trim().isEmpty() ||
                eventDateStr == null || eventDateStr.isEmpty() ||
                startTimeStr == null || startTimeStr.isEmpty() ||
                endTimeStr == null || endTimeStr.isEmpty() ||
                expectedStudentsStr == null || expectedStudentsStr.trim().isEmpty()) {
                
                response.sendRedirect("add_event_form.jsp?error=missing_fields");
                return; // Stop processing
            }

            // --- 2. Safely Parse Data ---
            Date eventDate = Date.valueOf(eventDateStr);
            Time startTime = Time.valueOf(startTimeStr + ":00");
            Time endTime = Time.valueOf(endTimeStr + ":00");
            int expectedStudents = Integer.parseInt(expectedStudentsStr);
            
            String eventDescription = request.getParameter("eventDescription");
            String coordinatorContact = request.getParameter("coordinatorContact");

            // Get facility requirements
            boolean reqMic = request.getParameter("req_mic") != null;
            boolean reqProjector = request.getParameter("req_projector") != null;
            boolean reqSpeakers = request.getParameter("req_speakers") != null;
            boolean reqAc = request.getParameter("req_ac") != null;
            boolean reqWifi = request.getParameter("req_wifi") != null;
            boolean reqWhiteboard = request.getParameter("req_whiteboard") != null;
            boolean reqStage = request.getParameter("req_stage") != null;
            boolean reqPodium = request.getParameter("req_podium") != null;
            boolean reqComputer = request.getParameter("req_computer") != null;

            EventDAO dao = new EventDAO();

            // --- 3. The "Algorithm" ---
            List<Venue> allVenues = dao.getAvailableVenues(expectedStudents);
            List<Event> conflictingEvents = dao.getConflictingEvents(eventDate, startTime, endTime);
            List<Venue> recommendations = new ArrayList<>();

            for (Venue venue : allVenues) {
                
                boolean isBooked = false;
                for (Event conflict : conflictingEvents) {
                    if (conflict.getVenueId() == venue.getVenueId()) {
                        isBooked = true;
                        break;
                    }
                }
                venue.setIsBooked(isBooked);
                venue.setHasCapacity(venue.getCapacity() >= expectedStudents);
                
                List<String> missingFacilities = new ArrayList<>();
                if (reqMic && !venue.isHasMic()) missingFacilities.add("Microphone");
                if (reqProjector && !venue.isHasProjector()) missingFacilities.add("Projector");
                if (reqSpeakers && !venue.isHasSpeakers()) missingFacilities.add("Speakers");
                if (reqAc && !venue.isHasAc()) missingFacilities.add("AC");
                if (reqWifi && !venue.isHasWifi()) missingFacilities.add("Wi-Fi");
                if (reqWhiteboard && !venue.isHasWhiteboard()) missingFacilities.add("Whiteboard");
                if (reqStage && !venue.isHasStage()) missingFacilities.add("Stage");
                if (reqPodium && !venue.isHasPodium()) missingFacilities.add("Podium");
                if (reqComputer && !venue.isHasComputer()) missingFacilities.add("Computer");
                
                venue.setMissingFacilities(missingFacilities);
                
                recommendations.add(venue);
            }

            // --- 4. Send Data to JSP ---
            request.setAttribute("recommendations", recommendations);
            
            // Pass all the original event details so the "Book" button can use them
            request.setAttribute("eventName", eventName);
            request.setAttribute("eventDate", eventDate.toString());
            request.setAttribute("startTime", startTime.toString().substring(0, 5)); // Send as HH:mm
            request.setAttribute("endTime", endTime.toString().substring(0, 5));     // Send as HH:mm
            request.setAttribute("eventDescription", eventDescription);
            request.setAttribute("coordinatorContact", coordinatorContact);

            request.getRequestDispatcher("recommendations.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("add_event_form.jsp?error=invalid_number");
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
            response.sendRedirect("add_event_form.jsp?error=invalid_date");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("add_event_form.jsp?error=unknown");
        }
    }
}