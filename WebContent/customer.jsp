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

    <div style="display: flex; justify-content: space-around;">
    <div style="flex: 1; padding: 20px;">

        <%
        authenticated = session.getAttribute("authenticatedUser") == null ? false : true;
    
        if (authenticated) {
            String currentUser = (String) session.getAttribute("authenticatedUser");
           
            // TODO: Retrieve and display customer information by username
            String sql = "SELECT * FROM Customer WHERE userId = ?";

            try {
                // Establish a database connection
                String dbURL = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
                String dbUser = "sa";
                String dbPass = "304#sa#pw";
                Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);

                PreparedStatement pstmt = con.prepareStatement(sql);
                pstmt.setString(1, currentUser);
                ResultSet rs = pstmt.executeQuery();

                if (rs.next()) {
                    // Display customer information in a table
                    out.println("<table>");
                    
                        // Update first name form
                        out.println("<form action='updateCustomer.jsp' method='post'>");
                        out.println("<tr><td>First Name</td><td>" + rs.getString("FirstName") + "</td><td>");
                        out.println("<input type='text' name='firstName' value=''>");
                        out.println("<input type='hidden' name='userId' value='" + rs.getString("userid") + "'>");
                        out.println("<input type='submit' value='Update'>");
                        out.println("</form>");

                        // Update last name form
                        out.println("<form action='updateCustomer.jsp' method='post'>");
                        out.println("<tr><td>Last Name</td><td>" + rs.getString("LastName") + "</td><td>");
                        out.println("<input type='text' name='lastName' value=''>");
                        out.println("<input type='hidden' name='userId' value='" + rs.getString("userid") + "'>");
                        out.println("<input type='submit' value='Update'>");
                        out.println("</form>");

                        // Update email form
                        out.println("<form action='updateCustomer.jsp' method='post'>");
                        out.println("<tr><td>Email</td><td>" + rs.getString("Email") + "</td><td>");
                        out.println("<input type='text' name='Email' value=''>");
                        out.println("<input type='hidden' name='userId' value='" + rs.getString("userid") + "'>");
                        out.println("<input type='submit' value='Update'>");
                        out.println("</form>");

                        // Update Phonenumber form
                        out.println("<form action='updateCustomer.jsp' method='post'>");
                        out.println("<tr><td>Phone</td><td>" + rs.getString("PhoneNum") + "</td><td>");
                        out.println("<input type='text' name='PhoneNum' value=''>");
                        out.println("<input type='hidden' name='userId' value='" + rs.getString("userid") + "'>");
                        out.println("<input type='submit' value='Update'>");
                        out.println("</form>");

                        // Update Address form
                        out.println("<form action='updateCustomer.jsp' method='post'>");
                        out.println("<tr><td>Address</td><td>" + rs.getString("Address") + "</td><td>");
                        out.println("<input type='text' name='Address' value=''>");
                        out.println("<input type='hidden' name='userId' value='" + rs.getString("userid") + "'>");
                        out.println("<input type='submit' value='Update'>");
                        out.println("</form>");

                        // Update City form
                        out.println("<form action='updateCustomer.jsp' method='post'>");
                        out.println("<tr><td>City</td><td>" + rs.getString("City") + "</td><td>");
                        out.println("<input type='text' name='City' value=''>");
                        out.println("<input type='hidden' name='userId' value='" + rs.getString("userid") + "'>");
                        out.println("<input type='submit' value='Update'>");
                        out.println("</form>");

                        // Update State form
                        out.println("<form action='updateCustomer.jsp' method='post'>");
                        out.println("<tr><td>State</td><td>" + rs.getString("state") + "</td><td>");
                        out.println("<input type='text' name='state' value=''>");
                        out.println("<input type='hidden' name='userId' value='" + rs.getString("userid") + "'>");
                        out.println("<input type='submit' value='Update'>");
                        out.println("</form>");

                        // Update Postal Code form
                        out.println("<form action='updateCustomer.jsp' method='post'>");
                        out.println("<tr><td>Postal Code</td><td>" + rs.getString("postalCode") + "</td><td>");
                        out.println("<input type='text' name='postalCode' value=''>");
                        out.println("<input type='hidden' name='userId' value='" + rs.getString("userid") + "'>");
                        out.println("<input type='submit' value='Update'>");
                        out.println("</form>");

                        // Update Country form
                        out.println("<form action='updateCustomer.jsp' method='post'>");
                        out.println("<tr><td>Country</td><td>" + rs.getString("Country") + "</td><td>");
                        out.println("<input type='text' name='Country' value=''>");
                        out.println("<input type='hidden' name='userId' value='" + rs.getString("userid") + "'>");
                        out.println("<input type='submit' value='Update'>");
                        out.println("</form>");

					out.println("<tr><td>Username</td><td>" + rs.getString("userid") + "</td></tr>");
                    out.println("</table>");

                    // Link to change password, sends userId
                    out.println("<tr><td colspan='3'><a href='changePassword.jsp?userId=" + rs.getString("userid") + "'>Change Password</a></td></tr>");

                } else {
                    out.println("<p>Error: Customer information not found for user " + currentUser + "</p>");
                }

            } catch (SQLException e) {
                out.println("SQL Exception: " + e);
            }
        }
    %>

</body>
</html>
