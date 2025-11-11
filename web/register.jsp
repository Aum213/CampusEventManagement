<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Register | Marwadi Events</title>
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
    .register-panel {
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
    .login-link {
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
    /* This is the new style for the success message */
    .success-box {
        background-color: #1d4b31; 
        border: 1px solid #2a7a4a; 
        color: #a3ffce;
        padding: 1rem;
        border-radius: 0.5rem;
    }
  </style>
</head>
<body>
  <div class="register-panel">
    
    <%
        // --- THIS IS THE NEW SUCCESS-HANDLING CODE ---
        String success = request.getParameter("success");
        if (success != null && success.equals("true")) {
    %>
        <!-- This success message is shown INSTEAD of the form -->
        <h2 class="text-center mb-4">Check Your Email!</h2>
        <div class="success-box">
            <strong>Registered successfully!</strong>
            <p>A verification email has been sent to your address. Check your inbox and click the link to activate your account.</p>
        </div>
        <a class="login-link" href="login.jsp" style="margin-top: 1.5rem;">Go to Login</a>

    <%
        } else {
        // --- END OF NEW CODE ---
        
        // This is your existing code, which runs if success is NOT true
    %>
    
    <h2 class="text-center mb-4">Register</h2>

    <%
        // --- THIS IS THE JAVA ERROR-HANDLING CODE ---
        String error = request.getParameter("error");
        if (error != null) {
    %>
        <!-- This div displays the error message (e.g., email already exists) -->
        <div class="error-box">
           Registration failed (email may already exist).
        </div>
    <%
        }
        // --- END OF JAVA CODE ---
    %>

    <!-- 
      This form now points to your RegisterServlet.
    -->
    <form action="RegisterServlet" method="post">
      <div class="mb-3">
        <label for="registerName" class="form-label">Full Name</label>
        <input type="text" class="form-control" id="registerName" name="name" required>
      </div>
      <div class="mb-3">
        <label for="registerEmail" class="form-label">Email ID</label>
        <input type="email" class="form-control" id="registerEmail" name="email" required>
      </div>
      <div class="mb-3">
        <label for="registerPassword" class="form-label">Password</label>
        <input type="password" class="form-control" id="registerPassword" name="password" required>
      </div>
      <button type="submit" class="btn btn-primary w-100">Create Account</button>
    </form>
    
    <!-- This link now points to the correct login.jsp file -->
    <a class="login-link" href="login.jsp">Already have an account? Login!</a>
    
    <%
        // This closing brace finishes the "else" block from above
        } 
    %>
    
  </div>
</body>
</html>