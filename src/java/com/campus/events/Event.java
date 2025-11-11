/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.campus.events;

// We need these to handle SQL Date and Time types
import java.sql.Date;
import java.sql.Time;

/**
 * A simple "Java Bean" to hold data about one
 * already-booked event from the 'events' table.
 */
public class Event {

    private int eventId;
    private String eventName;
    private Date eventDate;
    private Time startTime;
    private Time endTime;
    private int venueId;
    
    // --- Getters and Setters ---
    
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

    public int getVenueId() { return venueId; }
    public void setVenueId(int venueId) { this.venueId = venueId; }
}