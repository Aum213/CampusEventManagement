package com.campus.auth;

import com.campus.db.DBConnection;
import java.sql.*;

public class AuthDAO {

    // This method is for your original, simple registration
    public boolean registerUser(String name, String email, String password) {
        boolean success = false;
        try (Connection con = DBConnection.getConnection()) {
            String query = "INSERT INTO users(name, email, password) VALUES (?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            success = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }
    
    // This is the main registration method with the new 'role' field
    public boolean registerUserWithToken(String name, String email, String password, String token, String role) {
        boolean success = false;
        // This query now correctly includes the 'role' column
        String sql = "INSERT INTO users(name, email, password, verification_token, verified, role) VALUES (?, ?, ?, ?, false, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, token);
            ps.setString(5, role); // Save the role
            
            success = ps.executeUpdate() > 0;
            
        } catch (SQLIntegrityConstraintViolationException e) {
            // This is a "duplicate email" error. We catch it so it doesn't crash.
            System.out.println("Email already exists: " + email);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }

    // This method verifies the user's email token
    public boolean verifyToken(String token) {
        boolean ok = false;
        String update = "UPDATE users SET verified = true, verification_token = NULL WHERE verification_token = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(update)) {
            ps.setString(1, token);
            int rowsAffected = ps.executeUpdate();
            ok = (rowsAffected > 0);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ok;
    }

    // This method checks for a valid, verified user
    public boolean validateUserIfVerified(String email, String password) {
        boolean valid = false;
        String sql = "SELECT * FROM users WHERE email = ? AND password = ? AND verified = true";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            valid = rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return valid;
    }

    // This method gets the user's role (admin or student)
    public String getUserRole(String email) {
        String role = "student"; // Default to student
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT role FROM users WHERE email = ?")) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                role = rs.getString("role");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return role;
    }

    // This checks if the login is correct but the account is not verified
    public boolean doesEmailPasswordMatchButNotVerified(String email, String password) {
        boolean found = false;
        String sql = "SELECT id FROM users WHERE email=? AND password=? AND verified=false";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            found = rs.next();
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return found;
    }
    
    // --- THIS IS THE CRITICAL METHOD FOR THE BOOKING FIX ---
    // This gets the user's ID from their email
    public int getUserIdByEmail(String email) {
        int userId = -1; // Return -1 if not found
        String sql = "SELECT id FROM users WHERE email = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                userId = rs.getInt("id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return userId;
    }
}