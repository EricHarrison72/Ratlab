<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
<style>
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

    
<%
boolean authenticated = session.getAttribute("authenticatedUser") == null ? false : true;

if (!authenticated)
{
    String loginMessage = "You have not been authorized to access the URL " + request.getRequestURL().toString();
    session.setAttribute("loginMessage", loginMessage);
    response.sendRedirect("login.jsp"); 
 } else {
        String currentUser = (String) session.getAttribute("authenticatedUser");
   

// Write SQL query to print out total order amount by day
String sql = "SELECT (orderDate) AS orderDay, SUM(totalAmount) AS totalSales "
           + "FROM ordersummary "
           + "GROUP BY (orderDate)";
try {
    
 
        String dbURL = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String dbUser = "sa";
        String dbPass = "304#sa#pw";
        Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);
    
    PreparedStatement stmt = con.prepareStatement(sql);
    ResultSet rs = stmt.executeQuery();
%>

<table border="1">
    <tr>
        <th>Day</th>
        <th>Total Sales</th>
    </tr>
    <%
        while (rs.next()) {
            String orderDay = new SimpleDateFormat("yyyy-MM-dd").format(rs.getDate("orderDay"));
            double totalSales = rs.getDouble("totalSales");
    %>
    <tr>
        <td><%= orderDay %></td>
        <td><%= totalSales %></td>
    </tr>
    <%
        }
    %>
</table>

<%
} catch (SQLException ex) {
    out.println("Error retrieving total sales: " + ex.getMessage());
} 
 }
%>

</body>
</html>

