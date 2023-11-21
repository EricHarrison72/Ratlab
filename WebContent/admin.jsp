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

    <h1>Welcome, <%= currentUser %>!</h1>
<%
// TODO: Include files auth.jsp and jdbc.jsp
<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %>

<%
boolean authenticated = session.getAttribute("authenticatedUser") == null ? false : true;

if (!authenticated)
{
    String loginMessage = "You have not been authorized to access the URL " + request.getRequestURL().toString();
    session.setAttribute("loginMessage", loginMessage);
    response.sendRedirect("login.jsp");
}
%>
%>
<%
// Write SQL query to print out total order amount by day
String sql = "SELECT DATE(orderDate) AS orderDay, SUM(totalAmount) AS totalSales "
           + "FROM Orders "
           + "GROUP BY DATE(orderDate)";
try {
    getConnection();
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
} finally {
    closeConnection();
}
%>

</body>
</html>

