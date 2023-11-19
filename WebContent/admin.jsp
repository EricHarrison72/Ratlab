<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
</head>
<body>
    <div class="header">
        <ul class="menu">
            <li><a href="shop.html">Shop</a></li>
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

