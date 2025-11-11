<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Marwadi Events - Login</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      background: #181a1b;
      color: #fff;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .login-panel {
      background: #23272a;
      padding: 2rem;
      border-radius: 1rem;
      box-shadow: 0 0 12px rgba(20,20,20,0.3);
      width: 100%;
      max-width: 400px;
    }
    .btn-primary {
      background: #f9a826;
      border: none;
    }
    .register-link {
      display: block;
      margin-top: 1.2rem;
      text-align: center;
      color: #fffbe5;
      text-decoration: underline;
      font-size: 1rem;
      cursor: pointer;
    }
    .error-box {
      color: #ffc4c4;
      background: #471b1b;
      border: 1px solid #ff7a7a;
      padding: 1rem;
      margin-bottom: 1.5rem;
      border-radius: 0.5rem;
      text-align: center;
    }
    .success-box {
        background-color: #1d4b31; 
        border: 1px solid #2a7a4a; 
        color: #a3ffce;
        padding: 1rem;
        border-radius: 0.5rem;
        text-align: center;
    }
  </style>
</head>
<body>
  <div class="login-panel">
    <h2 class="text-center mb-4">Login Marwadi Events</h2>

    <%
        // --- THIS IS THE JAVA ERROR-HANDLING CODE ---
        String error = request.getParameter("error");
        if (error != null) {
            String errorMessage = "";
            if (error.equals("invalid")) {
                errorMessage = "Invalid email or password. Please try again.";
            } else if (error.equals("notverified")) {
                errorMessage = "Your account is not verified. Please check your email inbox.";
            } else if (error.equals("verify_failed")) {
                errorMessage = "Email verification failed. The link may be invalid or expired.";
            }
    %>
        <!-- This div displays the error message -->
        <div class="error-box">
            <%= errorMessage %>
        </div>
    <%
        }
        // --- END OF CODE ---
        
        // --- THIS IS THE NEW SUCCESS-HANDLING CODE ---
        String verified = request.getParameter("verified");
        String status = request.getParameter("status"); // <-- NEW

        if (verified != null && verified.equals("true")) {
    %>
        <!-- This div displays the success message -->
        <div class="success-box">
            <strong>Success!</strong> Your email is verified. You can now log in.
        </div>
    <%
        }
        
        // --- NEW LOGOUT SUCCESS MESSAGE ---
        if (status != null && status.equals("logout_success")) {
    %>
        <div class="success-box">
            You have been logged out successfully.
        </div>
    <%
        }
        // --- END OF NEW CODE ---
    %>

    <!-- 
      This form now points to your LoginServlet.
    -->
    <form action="LoginServlet" method="post">
      <div class="mb-3">
        <label for="email" class="form-label">Email ID</label>
        <input type="email" class="form-control" id="email" name="email" required>
      </div>
      <div class="mb-3">
        <label for="password" class="form-label">Password</label>
        <input type="password" class="form-control" id="password" name="password" required>
      </div>
      <button type="submit" class="btn btn-primary w-100">Login</button>
    </form>
    
    <!-- This link now points to the correct register.jsp file -->
    <a class="register-link" href="register.jsp">New member? Register here!</a>
  </div>
</body>
</html>