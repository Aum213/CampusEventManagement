<%--
    This is the "Results Page" that shows the red/green recommendations.
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.campus.events.Venue" %>
<%-- This page imports our Java classes so we can use them --%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Venue Recommendations | Marwadi Events</title>
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
        
        /* --- This is the CSS for your colored borders --- */
        .venue-card {
            background: #2c3135;
            padding: 1.5rem;
            border-radius: 0.5rem;
            margin-bottom: 1.5rem;
            border: 3px solid #2c3135; /* Default border */
        }
        
        /* This class will be added if the venue is a perfect match */
        .border-success {
            border-color: #2a7a4a; /* Green */
        }
        
        /* This class will be added if the venue has ANY problems */
        .border-danger {
            border-color: #7a2a2a; /* Red */
        }
        
        .venue-card h4 {
            color: #f9a826;
            font-weight: bold;
        }
        
        .status-list {
            list-style: none;
            padding-left: 0;
        }
        
        .status-ok { color: #a3ffce; } /* Green text */
        .status-fail { color: #ffc4c4; } /* Red text */
        
        .btn-primary {
            background: #f9a826;
            border: none;
            color: #181a1b;
            font-weight: bold;
        }
        .btn-primary:hover {
            background: #e09822;
        }
        
    </style>
</head>
<body>

    <!-- Include the navbar -->
    <%@ include file="/WEB-INF/jspf/navbar.jspf" %>

    <!-- Page Content -->
    <div class="container">
        <div class="row">
            <div class="col-md-10 offset-md-1">
                <div class="content-panel">
                    
                    <h1 class="mb-3">Venue Recommendations</h1>
                    <p class="lead">Based on your requirements for the event "<%= request.getAttribute("eventName") %>", here are the best matches.</p>
                    <a href="add_event_form.jsp">&laquo; Back to edit requirements</a>
                    
                    <hr class="my-4" style="color: #444;">

                    <%
                        // --- 1. GET THE RECOMMENDATION LIST ---
                        List<Venue> recommendations = (List<Venue>) request.getAttribute("recommendations");

                        if (recommendations == null || recommendations.isEmpty()) {
                    %>
                        <div class="alert alert-warning">No venues could be found that meet your capacity requirements.</div>
                    <%
                        } else {
                            
                            // --- 2. LOOP THROUGH EVERY VENUE ---
                            for (Venue venue : recommendations) {
                                
                                // --- 3. DETERMINE THE STATUS (RED OR GREEN BORDER) ---
                                boolean isPerfect = true; // Assume it's perfect
                                String statusClass = "border-success"; // Start with green
                                
                                if (venue.isIsBooked() || !venue.isHasCapacity() || !venue.getMissingFacilities().isEmpty()) {
                                    isPerfect = false;
                                    statusClass = "border-danger"; // Change to red if ANY problem exists
                                }
                    %>
                    
                    <!-- 
                      This is the card for a single venue.
                      We use our Java variable 'statusClass' to set the border color.
                    -->
                    <div class="venue-card <%= statusClass %>">
                        <div class="row">
                            <div class="col-md-8">
                                <h4><%= venue.getVenueName() %></h4>
                                <small class="text-muted"><%= venue.getLocationDetails() %></small>
                            </div>
                            <div class="col-md-4 text-md-end">
                                <% if (isPerfect) { %>
                                    <span class="badge bg-success fs-6">RECOMMENDED</span>
                                <% } else { %>
                                    <span class="badge bg-danger fs-6">NOT SUITABLE</span>
                                <% } %>
                            </div>
                        </div>

                        <hr style="color: #444;">
                        
                        <ul class="status-list">
                            <!-- Check 1: Capacity -->
                            <% if (venue.isHasCapacity()) { %>
                                <li class="status-ok">✅ **Capacity:** Fits <%= venue.getCapacity() %> (Sufficient)</li>
                            <% } else { %>
                                <li class="status-fail">❌ **Capacity:** Only fits <%= venue.getCapacity() %> (Not enough)</li>
                            <% } %>

                            <!-- Check 2: Availability (Booking) -->
                            <% if (venue.isIsBooked()) { %>
                                <li class="status-fail">❌ **Availability:** Already booked at this time!</li>
                            <% } else { %>
                                <li class="status-ok">✅ **Availability:** Free at this time.</li>
                            <% } %>
                                
                            <!-- Check 3: Facilities -->
                            <% if (venue.getMissingFacilities().isEmpty()) { %>
                                <li class="status-ok">✅ **Facilities:** Has all your required items.</li>
                            <% } else { %>
                                <li class="status-fail">❌ **Missing Facilities:**
                                    <%-- Loop through and list all missing items --%>
                                    <% for (String item : venue.getMissingFacilities()) { %>
                                        <span class="badge bg-danger"><%= item %></span>
                                    <% } %>
                                </li>
                            <% } %>
                        </ul>
                        
                        <%-- This is the "Book This Venue" button/form --%>
                        <% if (isPerfect) { %>
                            <!-- 
                                This <form> is the button.
                                It submits all the event data to our BookEventServlet.
                            -->
                            <form action="BookEventServlet" method="POST" class="mt-3">
                                <!-- These hidden fields pass all the data -->
                                <input type="hidden" name="eventName" value="<%= request.getAttribute("eventName") %>">
                                <input type="hidden" name="eventDate" value="<%= request.getAttribute("eventDate") %>">
                                <input type="hidden" name="startTime" value="<%= request.getAttribute("startTime") %>">
                                <input type="hidden" name="endTime" value="<%= request.getAttribute("endTime") %>">
                                <input type="hidden" name="venueId" value="<%= venue.getVenueId() %>">
                                
                                <!-- The new hidden fields -->
                                <input type="hidden" name="eventDescription" value="<%= request.getAttribute("eventDescription") %>">
                                <input type="hidden" name="coordinatorContact" value="<%= request.getAttribute("coordinatorContact") %>">
                                
                                <button type="submit" class="btn btn-primary">Book This Venue</button>
                            </form>
                        <% } else { %>
                            <button class="btn btn-secondary mt-3" disabled>Unavailable</button>
                        <% } %>

                    </div>
                    
                    <%
                            } // End of the for-loop
                        } // End of the else
                    %>
                    
                </div>
            </div>
        </div>
    </div>

</body>
</html>