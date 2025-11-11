<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.campus.events.EventDAO" %>
<%@ page import="com.campus.events.EventDetail" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // --- 1. GET USER ID FROM SESSION ---
    // We must have the user's ID to check if they are enrolled
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return; // Stop processing if not logged in
    }

    // --- 2. GET ALL THE EVENT DATA ---
    EventDAO dao = new EventDAO();
    List<EventDetail> approvedEvents = dao.getAllEventDetails();
    
    // Formatters
    SimpleDateFormat dateFormat = new SimpleDateFormat("EEE, dd MMM yyyy");
    SimpleDateFormat timeFormat = new SimpleDateFormat("hh:mm a");
    SimpleDateFormat timestampFormat = new SimpleDateFormat("dd MMM yyyy 'at' hh:mm a");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Dashboard | Marwadi Events</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #181a1b;
            color: #fff;
        }
        .content-panel {
            background: #23272a;
            padding: 2.5rem;
            border-radius: 1rem;
            margin-top: 3rem;
            margin-bottom: 5rem;
        }
        .btn-primary {
            background: #f9a826;
            border: none;
            color: #181a1b;
            font-weight: bold;
        }
        .btn-primary:hover {
            background: #e09822;
            color: #181a1b;
        }
        .event-card {
            background: #2c3135;
            padding: 1.5rem;
            border-radius: 0.5rem;
            margin-bottom: 1.5rem;
            border-left: 5px solid #f9a826;
        }
        .event-card h5 {
            color: #f9a826;
            font-weight: 500;
        }
        .event-time {
            font-weight: bold;
            color: #a3ffce;
        }
        .modal-body p {
            margin-bottom: 0.5rem;
        }
        .modal-body .event-description {
            background-color: #181a1b;
            padding: 1rem;
            border-radius: 0.25rem;
            font-style: italic;
        }
    </style>
</head>
<body>

    <!-- This includes the navbar we already built -->
    <%@ include file="/WEB-INF/jspf/navbar.jspf" %>

    <!-- Page Content -->
    <div class="container">
        
        <!-- NEW: Enrollment Status Alert -->
        <%
            String enrollStatus = request.getParameter("enroll");
            if (enrollStatus != null) {
                if (enrollStatus.equals("success")) {
        %>
            <div class="alert alert-success mt-4">
                <strong>Success!</strong> You are now enrolled in the event.
            </div>
        <%
                } else if (enrollStatus.equals("fail")) {
        %>
            <div class="alert alert-danger mt-4">
                <strong>Error!</strong> Could not enroll. You may be already enrolled or an error occurred.
            </div>
        <%
                }
            }
        %>

        <div class="row">
            <div class="col-md-10 offset-md-2">
                <div class="content-panel">
                    <h1 class="mb-4">Upcoming Events</h1>
                    
                    <%
                        if (approvedEvents == null || approvedEvents.isEmpty()) {
                    %>
                        <div class="alert alert-info">No events are currently scheduled. Check back soon!</div>
                    <%
                        } else {
                            // --- 3. LOOP THROUGH EVERY EVENT ---
                            for (EventDetail event : approvedEvents) {
                                
                                // --- NEW: Check enrollment status for this user ---
                                int enrolledCount = dao.getEnrollmentCount(event.getEventId());
                                boolean isEnrolled = dao.isUserEnrolled(event.getEventId(), userId);
                                
                                // Format data
                                String eventDateStr = dateFormat.format(event.getEventDate());
                                String startTimeStr = timeFormat.format(event.getStartTime());
                                String endTimeStr = timeFormat.format(event.getEndTime());
                                String approvedAtStr = timestampFormat.format(event.getCreatedAt());
                    %>
                    
                    <!-- This is the "Event Card" -->
                    <div class="event-card">
                        <div class="row">
                            <div class="col-md-8">
                                <h5><%= event.getEventName() %></h5>
                                <p class="mb-2">
                                    <span class="event-time"><%= eventDateStr %></span>
                                    from <%= startTimeStr %> to <%= endTimeStr %>
                                </p>
                                <p class="text-light mb-2">
                                    <strong>Location:</strong> <%= event.getVenueName() %>
                                </p>
                            </div>
                            <div class="col-md-4 text-md-end">
                                <!-- 
                                  *** NEW: ENROLLMENT BUTTON LOGIC ***
                                -->
                                <% if (isEnrolled) { %>
                                    <button class="btn btn-success" disabled>✓ Enrolled</button>
                                <% } else { %>
                                    <form action="EnrollEventServlet" method="post" style="display: inline;">
                                        <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                                        <button type="submit" class="btn btn-primary">Enroll Now</button>
                                    </form>
                                <% } %>
                            </div>
                        </div>

                        <hr style="color: #444;">
                        
                        <!-- 
                          This is the magic button for the modal.
                          It uses "data-" attributes to store all the event details
                        -->
                        <button type="button" class="btn btn-outline-warning btn-sm" 
                                data-bs-toggle="modal" 
                                data-bs-target="#eventDetailModal-<%= event.getEventId() %>"
                                >
                            View Details
                        </button>
                    </div>
                    
                    
                    <!-- 
                      --- 4. THE BOOTSTRAP MODAL (FOR THIS EVENT) ---
                      We make a unique modal for EACH event in the loop.
                    -->
                    <div class="modal fade" id="eventDetailModal-<%= event.getEventId() %>" tabindex="-1" aria-labelledby="modalLabel-<%= event.getEventId() %>" aria-hidden="true">
                      <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content" style="background: #2c3135; color: #fff;">
                          <div class="modal-header" style="border-bottom-color: #444;">
                            <h5 class="modal-title" id="modalLabel-<%= event.getEventId() %>" style="color: #f9a826;"><%= event.getEventName() %></h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                          </div>
                          <div class="modal-body">
                            
                            <p><strong>Date:</strong> <%= eventDateStr %></p>
                            <p><strong>Time:</strong> <%= startTimeStr %> - <%= endTimeStr %></p>
                            <p><strong>Location:</strong> <%= event.getVenueName() %></p>
                            
                            <p><strong>Enrolled Students:</strong> <%= enrolledCount %></p>
                            
                            <hr style="color: #444;">
                            
                            <p><strong>About this Event:</strong></p>
                            <div class="event-description">
                                <span><%= (event.getEventDescription() != null && !event.getEventDescription().isEmpty()) ? event.getEventDescription() : "No description provided." %></span>
                            </div>
                            
                            <p class="mt-3"><strong>Coordinator Contact:</strong> 
                                <span><%= (event.getCoordinatorContact() != null && !event.getCoordinatorContact().isEmpty()) ? event.getCoordinatorContact() : "Not specified." %></span>
                            </p>
                            
                          </div>
                          <div class="modal-footer" style="border-top-color: #444;">
                            <button type="button" class="btn btn-outline-light" data-bs-dismiss="modal">Close</button>
                          </div>
                        </div>
                      </div>
                    </div>
                    
                    <%
                                } // End of the for-loop
                            } // End of the else
                    %>
                    
                </div>
            </div>
        </div>
    </div>
    
    <!-- We must include the Bootstrap JS for modals to work -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>