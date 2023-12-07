<%@ page import="java.io.*,java.sql.*"%>
<%@ include file="auth.jsp"%>
<%@ include file="jdbc.jsp" %>

<%
    // Retrieve userId from the URL parameter
    String userId = request.getParameter("userId");

    try {
        // Establish a database connection
        String dbURL = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String dbUser = "sa";
        String dbPass = "304#sa#pw";
        Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);

        String oldPassword = ""; // Placeholder

        String selectQuery = "SELECT password FROM customer WHERE userId = ?";
        try (PreparedStatement preparedStatement = con.prepareStatement(selectQuery)) {
            preparedStatement.setString(1, userId);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                oldPassword = resultSet.getString("password");
            } else {
                // Handle case where user ID is not found
                out.println("<p>User ID not found</p>");
            }
        }


        // Check if the form is submitted
    if (request.getMethod().equalsIgnoreCase("POST")) {
        // Retrieve form parameters
        String oldPasswordInput = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmNewPassword = request.getParameter("confirmNewPassword");

        // Validate the old password (you may compare it with the retrieved old password from the database)
        if (!oldPasswordInput.equals(oldPassword)) {
            out.println("<p>Incorrect old password.</p>");
        } else if(!newPassword.equals(confirmNewPassword)){
            out.println("<p>New password does not match confirmation password</p>");
        } else if(newPassword.equals(oldPassword)){
            out.println("<p>New password cannot be the same as old password</p>");
        } else{
            String updateQuery = "UPDATE customer SET password = ? WHERE userId = ?";
            try (PreparedStatement updateStatement = con.prepareStatement(updateQuery)) {
                updateStatement.setString(1, newPassword);
                updateStatement.setString(2, userId);
                int rowsUpdated = updateStatement.executeUpdate();
                if (rowsUpdated > 0) {
                    out.println("<p>Password updated successfully!</p>");
                } else {
                    out.println("<p>Error updating password.</p>");
                }
            }
        }
    }

    } catch(SQLException e) {
        out.println("SQL Exception: " + e);
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Change Password</title>
    <style>
        table {
            border-collapse: collapse;
            width: 50%;
            margin: 20px;
        }

        th, td {
            border: 1px solid #dddddd;
            text-align: left;
            padding: 8px;
        }

        th {
            background-color: #f2f2f2;
        }
		body {
            font-family: Arial, sans-serif;
            background-color: #f7f7f7;
            margin: 0;
            padding: 0;
        }

        .header {
            background-color: #333;
            color: #fff;
            padding: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .menu {
            list-style-type: none;
            margin: 0;
            padding: 0;
            overflow: hidden;
            background-color: #333;
        }

        .menu li {
            display: inline-block;
            margin-right: 10px;
        }

        .menu a {
            display: block;
            color: #fff;
            text-align: center;
            padding: 14px 16px;
            text-decoration: none;
        }

        .menu a:hover {
            background-color: #ddd;
            color: #333;
        }

        .main-content {
            text-align: center;
            margin-top: 20px;
        }

        h1, h2 {
            color: #333;
        }

        .user-greeting {
            color: #fff;
            margin-left: auto;
        }

        .logo {
            margin-right: auto;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">
            <img src="img/rat.png" width="70" height="50" alt="Rat">
        </div>
        <ul class="menu">
            <li><a href="index.jsp">Shop</a></li>
            <li><a href="listprod.jsp">Product List</a></li>
            <li><a href="listorder.jsp">Order List</a></li>
            <li><a href="showcart.jsp">Cart</a></li>
            <li><a href="checkout.jsp">Checkout</a></li>
        </ul>
        <% 
        String userName = (String) session.getAttribute("authenticatedUser");
        if (userName != null)
            out.println("<div class='user-greeting'>Signed in as: " + userName + "</div>");
		else
			out.println("<div class='user-greeting'></div>");
    %>
    </div>
</head>
<body>
    <h2>Change Password</h2>
    <form method="post" action="">
        <label for="oldPassword">Old Password:</label>
        <input type="password" id="oldPassword" name="oldPassword" required><br>

        <label for="newPassword">New Password:</label>
        <input type="password" id="newPassword" name="newPassword" required><br>

        <label for="confirmNewPassword">Confirm New Password:</label>
        <input type="password" id="confirmNewPassword" name="confirmNewPassword" required><br>

        <input type="submit" value="Change Password">
    </form>
</body>
</html>
