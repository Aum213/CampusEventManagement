package com.campus.events;

/**
 * This is a "Java Bean" or "POJO" (Plain Old Java Object).
 * It's just a simple container to hold data about one venue.
 * Notice the fields match the columns in your 'venues' table.
 */
public class Venue {

    // --- Basic Info ---
    private int venueId;
    private String venueName;
    private int capacity;
    private String locationDetails;
    private boolean isAvailable; // e.g., not under renovation

    // --- Facilities ---
    private boolean hasMic;
    private boolean hasProjector;
    private boolean hasSpeakers;
    private boolean hasAc;
    private boolean hasWifi;
    private boolean hasWhiteboard;
    private boolean hasStage;
    private boolean hasPodium;
    private boolean hasComputer;
    
    // --- Algorithm Status (We'll set these later) ---
    // These fields are NOT in the database. They are for our logic.
    private boolean isBooked = false; // Is it booked at the requested time?
    private boolean hasCapacity = true;  // Does it have enough capacity?
    
    // We'll add a list of missing facilities here for the UI
    private java.util.List<String> missingFacilities = new java.util.ArrayList<>();

    
    // --- Getters and Setters ---
    // These are standard methods to get/set the private fields.
    // The web server and JSP pages use these to access the data.

    public int getVenueId() { return venueId; }
    public void setVenueId(int venueId) { this.venueId = venueId; }

    public String getVenueName() { return venueName; }
    public void setVenueName(String venueName) { this.venueName = venueName; }

    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }

    public String getLocationDetails() { return locationDetails; }
    public void setLocationDetails(String locationDetails) { this.locationDetails = locationDetails; }

    public boolean isIsAvailable() { return isAvailable; }
    public void setIsAvailable(boolean isAvailable) { this.isAvailable = isAvailable; }

    public boolean isHasMic() { return hasMic; }
    public void setHasMic(boolean hasMic) { this.hasMic = hasMic; }

    public boolean isHasProjector() { return hasProjector; }
    public void setHasProjector(boolean hasProjector) { this.hasProjector = hasProjector; }

    public boolean isHasSpeakers() { return hasSpeakers; }
    public void setHasSpeakers(boolean hasSpeakers) { this.hasSpeakers = hasSpeakers; }

    public boolean isHasAc() { return hasAc; }
    public void setHasAc(boolean hasAc) { this.hasAc = hasAc; }

    public boolean isHasWifi() { return hasWifi; }
    public void setHasWifi(boolean hasWifi) { this.hasWifi = hasWifi; }

    public boolean isHasWhiteboard() { return hasWhiteboard; }
    public void setHasWhiteboard(boolean hasWhiteboard) { this.hasWhiteboard = hasWhiteboard; }

    public boolean isHasStage() { return hasStage; }
    public void setHasStage(boolean hasStage) { this.hasStage = hasStage; }

    public boolean isHasPodium() { return hasPodium; }
    public void setHasPodium(boolean hasPodium) { this.hasPodium = hasPodium; }

    public boolean isHasComputer() { return hasComputer; }
    public void setHasComputer(boolean hasComputer) { this.hasComputer = hasComputer; }

    // --- Getters/Setters for our Algorithm Logic ---
    
    public boolean isIsBooked() { return isBooked; }
    public void setIsBooked(boolean isBooked) { this.isBooked = isBooked; }

    public boolean isHasCapacity() { return hasCapacity; }
    public void setHasCapacity(boolean hasCapacity) { this.hasCapacity = hasCapacity; }

    public java.util.List<String> getMissingFacilities() { return missingFacilities; }
    
    // --- THIS IS THE NEW METHOD YOU NEED TO ADD ---
    public void setMissingFacilities(java.util.List<String> missingFacilities) {
        this.missingFacilities = missingFacilities;
    }
    // --- END OF NEW METHOD ---

    public void addMissingFacility(String facilityName) { this.missingFacilities.add(facilityName); }
}