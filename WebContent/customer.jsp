<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>Customer Page</title>
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
            text-align: center;
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
    </style>
</head>
<body>
    <div class="header">
        <ul class="menu">
            <li><a href="index.jsp">Shop</a></li>
            <li><a href="listprod.jsp">Product List</a></li>
            <li><a href="listorder.jsp">Order List</a></li>
            <li><a href="showcart.jsp">Cart</a></li>
            <li><a href="login.jsp">Login</a></li>
            <li><a href="checkout.jsp">Checkout</a></li>
        </ul>
    </div>

    <%-- Check if the user is logged in --%>
    <% 
        authenticated = session.getAttribute("authenticatedUser") != null;
    %>

    <%-- Display error message if not logged in --%>
    <% 
        if (!authenticated) {
            out.println("<p>Error: You are not logged in. Please <a href='login.jsp'>login</a> to access this page.</p>");
        } else {
            // Retrieve authenticated username
            String userName = (String) session.getAttribute("authenticatedUser");

            // TODO: Retrieve and display customer information by username
            String sql = "SELECT * FROM Customer WHERE userId = ?";

            try {
                // Establish a database connection
                String dbURL = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
                String dbUser = "sa";
                String dbPass = "304#sa#pw";
                Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);

                PreparedStatement pstmt = con.prepareStatement(sql);
                pstmt.setString(1, userName);
                ResultSet rs = pstmt.executeQuery();

                if (rs.next()) {
                    // Display customer information in a table
                    out.println("<table>");
                    
                    out.println("<tr><td>First Name</td><td>" + rs.getString("FirstName") + "</td></tr>");
                    out.println("<tr><td>Last Name</td><td>" + rs.getString("LastName") + "</td></tr>");
                    out.println("<tr><td>Email</td><td>" + rs.getString("Email") + "</td></tr>");
                    out.println("<tr><td>Phone</td><td>" + rs.getString("PhoneNum") + "</td></tr>");
                    out.println("<tr><td>Address</td><td>" + rs.getString("Address") + "</td></tr>");
					out.println("<tr><td>Sity</td><td>" + rs.getString("city") + "</td></tr>");
					out.println("<tr><td>State</td><td>" + rs.getString("state") + "</td></tr>");
					out.println("<tr><td>Postal Code</td><td>" + rs.getString("postalCode") + "</td></tr>");
					out.println("<tr><td>Country</td><td>" + rs.getString("Country") + "</td></tr>");
					out.println("<tr><td>Username</td><td>" + rs.getString("userid") + "</td></tr>");
                    out.println("</table>");
                } else {
                    out.println("<p>Error: Customer information not found for user " + userName + "</p>");
                }

            } catch (SQLException e) {
                out.println("SQL Exception: " + e);
            }
        }
    %>

</body>
</html>
