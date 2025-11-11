package com.campus.events;

import com.campus.db.DBConnection;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

public class EventDAO {

    /**
     * Fetches all available venues that meet a minimum capacity.
     */
    public List<Venue> getAvailableVenues(int minCapacity) {
        List<Venue> venues = new ArrayList<>();
        // Only select venues that are NOT under renovation
        String sql = "SELECT * FROM venues WHERE is_available = true AND capacity >= ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, minCapacity);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Venue venue = new Venue();
                venue.setVenueId(rs.getInt("venue_id"));
                venue.setVenueName(rs.getString("venue_name"));
                venue.setCapacity(rs.getInt("capacity"));
                venue.setHasMic(rs.getBoolean("has_mic"));
                venue.setHasProjector(rs.getBoolean("has_projector"));
                venue.setHasSpeakers(rs.getBoolean("has_speakers"));
                venue.setHasAc(rs.getBoolean("has_ac"));
                venue.setHasWifi(rs.getBoolean("has_wifi"));
                venue.setHasWhiteboard(rs.getBoolean("has_whiteboard"));
                venue.setHasStage(rs.getBoolean("has_stage"));
                venue.setHasPodium(rs.getBoolean("has_podium"));
                venue.setHasComputer(rs.getBoolean("has_computer"));
                venue.setLocationDetails(rs.getString("location_details"));
                venues.add(venue);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return venues;
    }

    /**
     * Finds all events that conflict with a given date and time range.
     */
    public List<Event> getConflictingEvents(Date eventDate, Time startTime, Time endTime) {
        List<Event> conflicts = new ArrayList<>();
        // This is the logic to find overlapping time slots
        String sql = "SELECT * FROM events WHERE event_date = ? AND ( " +
                     "(start_time < ? AND end_time > ?) OR " +    // Event overlaps the entire slot
                     "(start_time >= ? AND start_time < ?) OR " + // Event starts during the slot
                     "(end_time > ? AND end_time <= ?) )";         // Event ends during the slot

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setDate(1, eventDate);
            ps.setTime(2, endTime);
            ps.setTime(3, startTime);
            ps.setTime(4, startTime);
            ps.setTime(5, endTime);
            ps.setTime(6, startTime);
            ps.setTime(7, endTime);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Event event = new Event();
                event.setEventId(rs.getInt("event_id"));
                event.setVenueId(rs.getInt("venue_id"));
                // We only need the venueId for conflict checking
                conflicts.add(event);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conflicts;
    }

    /**
     * Gets all event details (with venue name) for display.
     */
    public List<EventDetail> getAllEventDetails() {
        List<EventDetail> events = new ArrayList<>();
        // SQL JOIN to get venue_name from the 'venues' table
        String sql = "SELECT e.*, v.venue_name FROM events e " +
                     "JOIN venues v ON e.venue_id = v.venue_id " +
                     "ORDER BY e.event_date, e.start_time";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                EventDetail event = new EventDetail();
                event.setEventId(rs.getInt("event_id"));
                event.setEventName(rs.getString("event_name"));
                event.setEventDate(rs.getDate("event_date"));
                event.setStartTime(rs.getTime("start_time"));
                event.setEndTime(rs.getTime("end_time"));
                event.setVenueName(rs.getString("venue_name"));
                
                // --- THIS LINE IS THE BUG ---
                // event.setNotes(rs.getString("notes")); // <-- DELETE THIS LINE
                // --- END OF BUG ---

                event.setEventDescription(rs.getString("event_description"));
                event.setCoordinatorContact(rs.getString("coordinator_contact"));
                event.setAdminId(rs.getInt("admin_id"));
                event.setCreatedAt(rs.getTimestamp("created_at"));
                event.setVenueId(rs.getInt("venue_id"));
                events.add(event);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return events;
    }

    /**
     * Creates a new event in the database.
     */
    public boolean createEvent(String name, Date date, Time start, Time end, int venueId, int adminId, String description, String contact) {
        boolean success = false;
        String sql = "INSERT INTO events (event_name, event_date, start_time, end_time, venue_id, admin_id, event_description, coordinator_contact) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, name);
            ps.setDate(2, date);
            ps.setTime(3, start);
            ps.setTime(4, end);
            ps.setInt(5, venueId);
            ps.setInt(6, adminId);
            ps.setString(7, description);
            ps.setString(8, contact);
            
            int rowsAffected = ps.executeUpdate();
            success = (rowsAffected > 0);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }

    /**
     * Gets the number of students enrolled in a specific event.
     */
    public int getEnrollmentCount(int eventId) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM event_enrollments WHERE event_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, eventId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    /**
     * Checks if a specific user is already enrolled in a specific event.
     */
    public boolean isUserEnrolled(int eventId, int userId) {
        boolean enrolled = false;
        String sql = "SELECT * FROM event_enrollments WHERE event_id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, eventId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            enrolled = rs.next(); // true if a record is found
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return enrolled;
    }

    /**
     * Enrolls a user into an event.
     */
    public boolean enrollUserInEvent(int eventId, int userId) {
        boolean success = false;
        String sql = "INSERT INTO event_enrollments (event_id, user_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, eventId);
            ps.setInt(2, userId);
            int rowsAffected = ps.executeUpdate();
            success = (rowsAffected > 0);
            
        } catch (SQLIntegrityConstraintViolationException e) {
            // This happens if they try to enroll twice
            System.out.println("User (id=" + userId + ") already enrolled in event (id=" + eventId + ")");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }

    /**
     * Cancels an event, deleting both the event and all enrollments.
     */
    public boolean cancelEvent(int eventId) {
        String deleteEnrollmentsSql = "DELETE FROM event_enrollments WHERE event_id = ?";
        String deleteEventSql = "DELETE FROM events WHERE event_id = ?";
        Connection conn = null;
        
        try {
            conn = DBConnection.getConnection();
            // Start a transaction
            conn.setAutoCommit(false); 
            
            // Step 1: Delete all enrollments for this event
            try (PreparedStatement ps1 = conn.prepareStatement(deleteEnrollmentsSql)) {
                ps1.setInt(1, eventId);
                ps1.executeUpdate();
            }
            
            // Step 2: Delete the event itself
            try (PreparedStatement ps2 = conn.prepareStatement(deleteEventSql)) {
                ps2.setInt(1, eventId);
                int rowsAffected = ps2.executeUpdate();
                if (rowsAffected == 0) {
                    throw new SQLException("Event not found, cancellation failed.");
                }
            }
            
            // If both steps succeeded, commit the changes
            conn.commit();
            return true;
            
        } catch (Exception e) {
            e.printStackTrace();
            // If anything went wrong, roll back all changes
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            // Always set auto-commit back to true and close connection
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}