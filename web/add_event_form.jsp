<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add New Event | Marwadi Events</title>
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
        .form-check-input:checked {
            background-color: #f9a826;
            border-color: #f9a826;
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
                    
                    <h1 class="mb-4">Find a Venue for Your Event</h1>
                    <p class="lead">Fill out your event's requirements, and we'll find the best available venues on campus.</p>

                    <!-- 
                      This form submits all data to our "Algorithm" servlet
                    -->
                    <form action="RecommendVenueServlet" method="post" class="mt-4">
                        
                        <!-- Section 1: Basic Details -->
                        <h4 class="mb-3" style="color: #f9a826;">1. Basic Details</h4>
                        <div class="row">
                            <div class="col-md-12 mb-3">
                                <label for="eventName" class="form-label">Event Name</label>
                                <input type="text" class="form-control" id="eventName" name="eventName" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label for="eventDate" class="form-label">Event Date</label>
                                <input type="date" class="form-control" id="eventDate" name="eventDate" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label for="startTime" class="form-label">Start Time</label>
                                <input type="time" class="form-control" id="startTime" name="startTime" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label for="endTime" class="form-label">End Time</label>
                                <input type="time" class="form-control" id="endTime" name="endTime" required>
                            </div>
                        </div>

                        <!-- 
                          *** NEW FIELDS ADDED HERE ***
                        -->
                        <div class="row">
                            <div class="col-md-12 mb-3">
                                <label for="eventDescription" class="form-label">Event Description</label>
                                <textarea class="form-control" id="eventDescription" name="eventDescription" rows="3" placeholder="What is this event about?"></textarea>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="coordinatorContact" class="form-label">Coordinator Contact (Email or Phone)</label>
                                <input type="text" class="form-control" id="coordinatorContact" name="coordinatorContact" placeholder="e.g., student.coord@example.com">
                            </div>
                        </div>
                        <!-- *** END OF NEW FIELDS *** -->


                        <!-- Section 2: Requirements -->
                        <hr class="my-4" style="color: #444;">
                        <h4 class="mb-3" style="color: #f9a826;">2. Venue Requirements</h4>
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label for="expectedStudents" class="form-label">Number of Expected Students</label>
                                <input type="number" class="form-control" id="expectedStudents" name="expectedStudents" min="1" required>
                            </div>
                        </div>

                        <!-- Section 3: Facilities -->
                        <h5 class="mt-3">Required Facilities</h5>
                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="checkbox" name="reqMic" id="reqMic">
                                    <label class="form-check-label" for="reqMic">Microphone</label>
                                </div>
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="checkbox" name="reqProjector" id="reqProjector">
                                    <label class="form-check-label" for="reqProjector">Projector</label>
                                </div>
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="checkbox" name="reqSpeakers" id="reqSpeakers">
                                    <label class="form-check-label" for="reqSpeakers">Speakers</label>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="checkbox" name="reqAc" id="reqAc">
                                    <label class="form-check-label" for="reqAc">Air Conditioning (AC)</label>
                                </div>
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="checkbox" name="reqWifi" id="reqWifi">
                                    <label class="form-check-label" for="reqWifi">Wi-Fi</label>
                                </div>
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="checkbox" name="reqWhiteboard" id="reqWhiteboard">
                                    <label class="form-check-label" for="reqWhiteboard">Whiteboard</label>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="checkbox" name="reqStage" id="reqStage">
                                    <label class="form-check-label" for="reqStage">Stage</label>
                                </div>
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="checkbox" name="reqPodium" id="reqPodium">
                                    <label class="form-check-label" for="reqPodium">Podium</label>
                                </div>
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="checkbox" name="reqComputer" id="reqComputer">
                                    <label class="form-check-label" for="reqComputer">Computer</label>
                                </div>
                            </div>
                        </div>

                        <!-- Submit Button -->
                        <hr class="my-4" style="color: #444;">
                        <button type="submit" class="btn btn-primary btn-lg w-100">Find Venues</button>
                    
                    </form>
                </div>
            </div>
        </div>
    </div>

</body>
</html>