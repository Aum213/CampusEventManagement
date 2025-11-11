Campus Event Management System

A dynamic, database-driven web application for managing campus events, built with Java Servlets, JSP, and a MySQL backend. This project provides a full-featured platform for both administrators and students, including role-based authentication, event creation, booking, and email verification.

✨ Core Features

Role-Based Access Control: Secure authentication system with two distinct roles:

Admin: Full CRUD (Create, Read, Update, Delete) capabilities over all events and user bookings. Has access to a powerful admin dashboard.

Student: Can view upcoming events, manage their own bookings, and browse event details.

Secure User Registration with Email Verification:

New users register and receive a unique verification link via email (powered by JavaMail API).

Users cannot log in until their email address has been successfully verified, enhancing security.

Full Event Lifecycle Management (Admin):

Create Events: Admins can add new events with details like name, date, location, and description.

Book Students: Admins can manually book any student into any event.

Cancel Events: Admins can cancel an entire event, which automatically removes it from the system and all student enrollments.

Student Dashboard:

Students can view a list of all available events.

(Future-proofing, based on dashboard.jsp) Students can book and cancel their own enrollments.

Venue Recommendation Engine:

An intelligent feature that suggests suitable campus venues based on event requirements (e.g., expected capacity).

Dynamic Frontend:

The UI is built with Bootstrap 5 and JSPs, making it responsive and modern.

JSTL is used to dynamically render all event lists and conditional content (like error/success messages).

Vanilla JavaScript powers interactive components like the confirmation and booking modals.

🛠️ Tech Stack

Backend: Java Servlets, Java EE 8

Frontend: JSP (JavaServer Pages), HTML5, CSS3

Database: MySQL

DB Connector: Pure JDBC (no ORM)

Styling: Bootstrap 5, Custom CSS

Interactivity: Vanilla JavaScript

Email: JavaMail API

Server: Apache Tomcat

Libraries: JSTL, MySQL Connector/J, Jakarta Mail

🚀 Getting Started

To get a local copy up and running, follow these simple steps.

Prerequisites

You will need the following software installed on your machine:

JDK 21 (or 11+)

Apache Tomcat 9.0 (or 10.0)

[suspicious link removed] & MySQL Workbench

1. Database Setup

Open MySQL Workbench and connect to your local server.

Create a new database schema. You can name it whatever you like (e.g., campus_event_db).

CREATE DATABASE campus_event_db;


Run the following SQL script to create all the necessary tables:

USE campus_event_db;

-- Table for user information, roles, and verification
CREATE TABLE users (
  user_id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(100) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  role ENUM('admin', 'student') NOT NULL DEFAULT 'student',
  is_verified BOOLEAN DEFAULT FALSE,
  verification_token VARCHAR(255)
);

-- Table for event details
CREATE TABLE events (
  event_id INT PRIMARY KEY AUTO_INCREMENT,
  event_name VARCHAR(255) NOT NULL,
  event_date DATETIME NOT NULL,
  location VARCHAR(255),
  description TEXT,
  max_capacity INT DEFAULT 100
);

-- Mapping table for student enrollments
CREATE TABLE student_enrollments (
  enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT,
  event_id INT,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  FOREIGN KEY (event_id) REFERENCES events(event_id) ON DELETE CASCADE,
  -- A student can't enroll in the same event twice
  UNIQUE KEY uk_user_event (user_id, event_id)
);

-- (Optional) Table for venue recommendations
CREATE TABLE venues (
  venue_id INT PRIMARY KEY AUTO_INCREMENT,
  venue_name VARCHAR(255) NOT NULL,
  capacity INT NOT NULL,
  location VARCHAR(255),
  amenities TEXT
);

-- (Optional) Create a default admin user
INSERT INTO users (username, email, password, role, is_verified) 
VALUES ('admin', 'admin@youremail.com', 'adminpass', 'admin', TRUE);



2. Project Configuration

Database Connection:

Open com/campus/db/DBConnection.java (or your EventDAO.java/AuthDAO.java).

Update the JDBC connection string with your database name, username, and password.

Find: jdbc:mysql://localhost:3306/your_db_name

Replace with: jdbc:mysql://localhost:3306/campus_event_db

Update the DB_USER and DB_PASS variables.

JavaMail API (CRITICAL):

Open com/campus/auth/EmailUtil.java.

Find the MY_EMAIL and MY_PASSWORD variables.

Enter a valid Gmail email address and its "App Password".

Note: You cannot use your regular Gmail password. You must generate an "App Password" from your Google Account security settings. How-to Guide

3. Deployment

Build the Project: Build the project in your IDE (NetBeans/Eclipse/IntelliJ) to produce a .war (Web Archive) file.

Deploy to Tomcat:

Stop your Tomcat server.

Copy the generated .war file.

Paste it into the webapps directory inside your Tomcat installation folder (e.g., C:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\).

Run:

Start your Tomcat server (by running startup.bat or startup.sh).

Tomcat will automatically unzip and deploy your project.

Open your browser and go to: http://localhost:8080/YourProjectName/

(The YourProjectName is usually the name of your .war file, e.g., http://localhost:8080/CampusEventManagement/)

📸 Screenshots

(Add your screenshots here!)

A great idea is to add screenshots for:

Login Page

Registration Page

Admin Dashboard (showing event list)

Student Dashboard

The "Book Event" Modal
