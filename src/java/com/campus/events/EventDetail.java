package com.campus.events;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

/**
 * This is our "data-holder" class.
 * It's not a database table, it's a custom Java class that holds
 * the combined results of our SQL JOIN query.
 *
 * --- THIS IS THE UPDATED VERSION ---
 * It has all the new fields and methods.
 */
public class EventDetail {

    // --- From events table ---
    private int eventId;
    private String eventName;
    private Date eventDate;
    private Time startTime;
    private Time endTime;
    private int adminId;
    private Timestamp createdAt;
    
    // --- From venues table ---
    private int venueId;
    private String venueName;
    
    // --- NEW FIELDS ---
    private String eventDescription;
    private String coordinatorContact;
    private int enrolledCount; // Will hold the result of our COUNT(*) query
    private boolean isUserEnrolled; // Will be true/false for the specific student
    

    // --- Getters and Setters for all fields ---

    public int getEventId() { return eventId; }
    public void setEventId(int eventId) { this.eventId = eventId; }

    public String getEventName() { return eventName; }
    public void setEventName(String eventName) { this.eventName = eventName; }

    public Date getEventDate() { return eventDate; }
    public void setEventDate(Date eventDate) { this.eventDate = eventDate; }

    public Time getStartTime() { return startTime; }
    public void setStartTime(Time startTime) { this.startTime = startTime; }

    public Time getEndTime() { return endTime; }
    public void setEndTime(Time endTime) { this.endTime = endTime; }

    public int getAdminId() { return adminId; }
    public void setAdminId(int adminId) { this.adminId = adminId; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public int getVenueId() { return venueId; }
    public void setVenueId(int venueId) { this.venueId = venueId; }

    public String getVenueName() { return venueName; }
    public void setVenueName(String venueName) { this.venueName = venueName; }

    // --- Getters/Setters for NEW FIELDS ---

    public String getEventDescription() { return eventDescription; }
    public void setEventDescription(String eventDescription) { this.eventDescription = eventDescription; }

    public String getCoordinatorContact() { return coordinatorContact; }
    public void setCoordinatorContact(String coordinatorContact) { this.coordinatorContact = coordinatorContact; }

    public int getEnrolledCount() { return enrolledCount; }
    public void setEnrolledCount(int enrolledCount) { this.enrolledCount = enrolledCount; }
    
    public boolean getIsUserEnrolled() { return isUserEnrolled; }
    public void setIsUserEnrolled(boolean isUserEnrolled) { this.isUserEnrolled = isUserEnrolled; }
}