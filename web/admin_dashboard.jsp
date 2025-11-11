<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.campus.events.EventDAO" %>
<%@ page import="com.campus.events.EventDetail" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<%
    // --- 0. SECURITY CHECK & DATA FETCH ---
    // Check if user is logged in and is an admin
    if (session.getAttribute("role") == null || !session.getAttribute("role").equals("admin")) {
        response.sendRedirect("login.jsp?error=unauthorized");
        return; // Stop processing the page
    }
    
    // Get the user's ID (which we set in LoginServlet)
    Integer userId = (Integer) session.getAttribute("userId");

    // --- 1. GET ALL THE EVENT DATA ---
    EventDAO dao = new EventDAO();
    List<EventDetail> approvedEvents = dao.getAllEventDetails();
    Map<Integer, Integer> enrollmentCounts = new HashMap<>();
    
    // Pre-fetch all enrollment counts
    for (EventDetail event : approvedEvents) {
        enrollmentCounts.put(event.getEventId(), dao.getEnrollmentCount(event.getEventId()));
    }
    
    // We'll use this to format our dates and times
    SimpleDateFormat dateFormat = new SimpleDateFormat("EEE, dd MMM yyyy");
    SimpleDateFormat timeFormat = new SimpleDateFormat("hh:mm a");
    SimpleDateFormat timestampFormat = new SimpleDateFormat("dd MMM yyyy 'at' hh:mm a");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard | Marwadi Events</title>
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
        /* Style for the new confirmation modal */
        #cancelConfirmModal .modal-content {
            background: #2c3135; 
            color: #fff;
        }
        #cancelConfirmModal .modal-header {
            border-bottom-color: #444;
        }
        #cancelConfirmModal .modal-footer {
            border-top-color: #444;
        }
    </style>
</head>
<body>

    <!-- This includes the navbar we already built -->
    <%@ include file="/WEB-INF/jspf/navbar.jspf" %>

    <!-- Page Content -->
    <div class="container">

        <!-- 
          --- THIS IS THE NEW DEBUG BOX ---
          It will show us EXACTLY what is in the session.
        -->
        


        <!-- --- ALERTS for booking/cancellation --- -->
        <%
            // Check for booking status
            String bookingStatus = request.getParameter("booking");
            if ("success".equals(bookingStatus)) {
        %>
            <div class="alert alert-success mt-4">
                <strong>Success!</strong> The event has been booked.
            </div>
        <%
            } else if ("fail".equals(bookingStatus)) {
        %>
            <div class="alert alert-danger mt-4">
                <strong>Error!</strong> The event could not be booked. Please try again.
            </div>
        <%
            }
            
            // Check for cancellation status
            String cancelStatus = request.getParameter("cancellation");
            if ("success".equals(cancelStatus)) {
        %>
            <div class="alert alert-success mt-4">
                <strong>Event Cancelled!</strong> The event and all its enrollments have been removed.
            </div>
        <%
            } else if ("fail".equals(cancelStatus)) {
        %>
            <div class="alert alert-danger mt-4">
                <strong>Error!</strong> The event could not be cancelled.
            </div>
        <%
            }
        %>


        <div class="row">
            
            <!-- Quick Actions Panel (Column 1) -->
            <div class="col-lg-4">
                <div class="content-panel" style="margin-top: 3rem;">
                    <h4>Quick Actions</h4>
                    <p class="text-light small">Manage your events here.</p>
                    <a href="add_event_form.jsp" class="btn btn-primary w-100">
                        + Add New Event / Find Venue
                    </a>
                </div>
            </div>

            <!-- Approved Events List (Column 2) -->
            <div class="col-lg-8">
                <div class="content-panel">
                    <h1 class="mb-4">Already Approved Events</h1>
                    
                    <%
                        if (approvedEvents == null || approvedEvents.isEmpty()) {
                    %>
                        <div class="alert alert-info">No events are currently booked.</div>
                    <%
                        } else {
                            // --- LOOP THROUGH EVERY EVENT ---
                            for (EventDetail event : approvedEvents) {
                                
                                // Format the data for display
                                String eventDateStr = dateFormat.format(event.getEventDate());
                                String startTimeStr = timeFormat.format(event.getStartTime());
                                String endTimeStr = timeFormat.format(event.getEndTime());
                                String approvedAtStr = timestampFormat.format(event.getCreatedAt());
                                int enrolled = enrollmentCounts.get(event.getEventId());
                    %>
                    
                    <!-- This is the "Event Card" -->
                    <div class="event-card">
                        <h5><%= event.getEventName() %></h5>
                        <p class="mb-2">
                            <span class="event-time"><%= eventDateStr %></span>
                            from <%= startTimeStr %> to <%= endTimeStr %>
                        </p>
                        <p class="text-light mb-2">
                            <strong>Location:</strong> <%= event.getVenueName() %>
                        </p>
                        
                        <!-- 
                          This is the magic button for the modal.
                          It now includes the event_id.
                        -->
                        <button type="button" class="btn btn-outline-warning btn-sm" 
                                data-bs-toggle="modal" 
                                data-bs-target="#eventDetailModal"
                                data-event-id="<%= event.getEventId() %>"
                                data-event-name="<%= event.getEventName() %>"
                                data-event-date="<%= eventDateStr %>"
                                data-event-time="<%= startTimeStr %> - <%= endTimeStr %>"
                                data-event-venue="<%= event.getVenueName() %>"
                                data-event-approved="<%= approvedAtStr %>"
                                data-event-enrolled="<%= enrolled %>"
                                data-event-description="<%= event.getEventDescription() %>"
                                data-event-contact="<%= event.getCoordinatorContact() %>"
                                >
                            View Details
                        </button>
                    </div>
                    
                    <%
                            } // End of the for-loop
                        } // End of the else
                    %>
                    
                </div>
            </div>
        </div>
    </div>

    
    <!-- 
      --- 3. THE BOOTSTRAP MODAL ---
      This is the (hidden) popup box.
    -->
    <div class="modal fade" id="eventDetailModal" tabindex="-1" aria-labelledby="modalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content" style="background: #2c3135; color: #fff;">
                <div class="modal-header" style="border-bottom-color: #444;">
                    <h5 class="modal-title" id="modalLabel" style="color: #f9a826;">Event Details</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <h3 id="modalEventNameHeader" style="color: #f9a826;"></h3>
                    <p><strong>Date:</strong> <span id="modalEventDate"></span></p>
                    <p><strong>Time:</strong> <span id="modalEventTime"></span></p>
                    <p><strong>Location:</strong> <span id="modalEventVenue"></span></p>
                    <p><strong>Enrolled Students:</strong> <span id="modalEventEnrolled"></span></p>
                    
                    <hr style="color: #444;">
                    
                    <strong>About this Event:</strong>
                    <p id="modalEventDescription" class="text-light small" style="background: #23272a; padding: 10px; border-radius: 5px;"></p>
                    
                    <strong>Coordinator Contact:</strong>
                    <p id="modalEventContact" class="text-light small"></p>

                    <p class="text-light small mt-4">
                        <strong>Approved On:</strong> <span id="modalEventApproved"></span>
                    </p>
                </div>
                
                <!-- THIS IS THE MODIFIED MODAL FOOTER -->
                <div class="modal-footer" style="border-top-color: #444;">
                    
                    <!-- This hidden input STORES the event ID for this modal -->
                    <input type="hidden" id="modalCancelEventId">
                    
                    <button type="button" class="btn btn-outline-light" data-bs-dismiss="modal">Close</button>
                    
                    <!-- 
                      This button no longer submits.
                      It now opens the *second* modal (the confirmation modal).
                    -->
                    <button type="button" 
                            class="btn btn-danger" 
                            data-bs-toggle="modal" 
                            data-bs-target="#cancelConfirmModal">
                        Cancel This Event
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    
    <!-- 
      --- NEW: 3b. THE CANCELLATION CONFIRMATION MODAL ---
      This is the "Are you sure?" modal that the user was expecting.
    -->
    <div class="modal fade" id="cancelConfirmModal" tabindex="-1" aria-labelledby="cancelModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="cancelModalLabel">Confirm Cancellation</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to permanently cancel this event?</p>
                    <p class="text-warning small">All student enrollments for this event will be deleted. This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <!-- This button just closes the confirmation modal -->
                    <button type="button" class="btn btn-outline-light" data-bs-dismiss="modal">Go Back</button>
                    
                    <!-- 
                      --- MODIFICATION 1 ---
                      This form no longer submits automatically. I've given it an ID.
                    -->
                    <form action="CancelEventServlet" method="post" style="display: inline;" id="cancelForm">
                        <!-- This input will get the eventId via JavaScript -->
                        <input type="hidden" name="eventId" id="finalCancelEventId">
                        
                        <!-- 
                          --- MODIFICATION 2 ---
                          This is no longer a "submit" button. It's a regular button
                          that we will control with new JavaScript.
                        -->
                        <button type="button" class="btn btn-danger" id="confirmCancelButton">Yes, Cancel Event</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    
    <!-- 
      --- 4. THE JAVASCRIPT ---
      This script adds the "click" listener to all our "View Details" buttons.
    -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Get the modal element
        var eventDetailModal = document.getElementById('eventDetailModal');
        
        // Listen for when the modal is about to be shown
        eventDetailModal.addEventListener('show.bs.modal', function (event) {
            
            // Get the button that triggered the modal
            var button = event.relatedTarget;
            
            // Extract info from the button's "data-" attributes
            var eventId = button.getAttribute('data-event-id');
            var eventName = button.getAttribute('data-event-name');
            var eventDate = button.getAttribute('data-event-date');
            var eventTime = button.getAttribute('data-event-time');
            var eventVenue = button.getAttribute('data-event-venue');
            var eventApproved = button.getAttribute('data-event-approved');
            var eventEnrolled = button.getAttribute('data-event-enrolled');
            var eventDescription = button.getAttribute('data-event-description');
            var eventContact = button.getAttribute('data-event-contact');

            // Find the elements inside the modal
            var modalEventNameHeader = eventDetailModal.querySelector('#modalEventNameHeader');
            var modalEventDate = eventDetailModal.querySelector('#modalEventDate');
            var modalEventTime = eventDetailModal.querySelector('#modalEventTime');
            var modalEventVenue = eventDetailModal.querySelector('#modalEventVenue');
            var modalEventApproved = eventDetailModal.querySelector('#modalEventApproved');
            var modalEventEnrolled = eventDetailModal.querySelector('#modalEventEnrolled');
            var modalEventDescription = eventDetailModal.querySelector('#modalEventDescription');
            var modalEventContact = eventDetailModal.querySelector('#modalEventContact');
            var modalCancelEventId = eventDetailModal.querySelector('#modalCancelEventId');

            // Update the modal's content with the data
            modalEventNameHeader.textContent = eventName;
            modalEventDate.textContent = eventDate;
            modalEventTime.textContent = eventTime;
            modalEventVenue.textContent = eventVenue;
            modalEventApproved.textContent = eventApproved;
            modalEventEnrolled.textContent = eventEnrolled + " Students";
            modalEventDescription.textContent = eventDescription;
            modalEventContact.textContent = eventContact;
            
            // Set the hidden input field in the *details* modal
            // This just STORES the id for the next modal to grab
            modalCancelEventId.value = eventId;
        });
        
        
        // --- NEW JAVASCRIPT FOR THE SECOND MODAL ---
        
        // Get the new confirmation modal
        var cancelConfirmModal = document.getElementById('cancelConfirmModal');
        
        // Listen for when the confirmation modal is about to be shown
        cancelConfirmModal.addEventListener('show.bs.modal', function (event) {
            
            // Find the eventId we stored in the *first* modal's hidden input
            var eventId = document.getElementById('modalCancelEventId').value;
            
            // Find the hidden input in *this* (the confirmation) modal
            var finalCancelInput = document.getElementById('finalCancelEventId');
            
            // Set the value of the form's hidden input
            finalCancelInput.value = eventId;
        });
        
        
        // --- NEW JAVASCRIPT FOR BULLETPROOF SUBMISSION ---
        
        // Listen for a click on our new "confirm" button
        document.getElementById('confirmCancelButton').addEventListener('click', function() {
            
            // Get the form and the hidden input
            var cancelForm = document.getElementById('cancelForm');
            var finalCancelInput = document.getElementById('finalCancelEventId');
            
            var eventId = finalCancelInput.value;
            
            // THE FINAL CHECK:
            // Is the eventId a valid number?
            if (eventId && eventId.length > 0 && !isNaN(eventId)) {
                // Yes, it is. Submit the form.
                cancelForm.submit();
            } else {
                // No, it's blank or not a number.
                // This is the bug we are hunting.
                console.error("CRITICAL: eventId was not passed to the final cancel modal. Value was: '" + eventId + "'");
                // Stop here to prevent the bad submission.
                alert("Could not cancel event: The Event ID was missing. Please close the modal and try again.");
            }
        });
        
    </script>

</body>
</html>