package com.campus.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    // --- Database Credentials ---
    private static final String URL = "jdbc:mysql://localhost:3306/campus_event_db";
    private static final String USER = "root";
    private static final String PASSWORD = "";

    /**
     * Establishes and returns a new connection to the database.
     * Each time this method is called, it creates a fresh connection.
     */
    public static Connection getConnection() {
        Connection conn = null;
        try {
            // 1. Register the JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 2. Open a new connection
            conn = DriverManager.getConnection(URL, USER, PASSWORD);

            // By default, new connections are already in auto-commit mode,
            // so you don't even need to set it explicitly.

        } catch (ClassNotFoundException | SQLException e) {
            // Print a more informative error message
            System.err.println("ERROR: Database connection failed!");
            e.printStackTrace();
        }
        return conn;
    }
}