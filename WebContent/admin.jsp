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
            <li><a href="login.jsp">Login</a></li>
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
    java.util.Date orderDate = rs.getDate("orderDay");
    if (orderDate != null) {
        String orderDay = new SimpleDateFormat("yyyy-MM-dd").format(orderDate);
        double totalSales = rs.getDouble("totalSales");
%>
<tr>
    <td><%= orderDay %></td>
    <td><%= "$" + totalSales %></td>
</tr>
<%
    }
}
%>

</table>

<div class="main-content">
    <h2>Add New Product</h2>

    <form method="post" action="processAddProduct.jsp">
        <label for="productName">Product Name:</label>
        <input type="text" name="productName" required><br>

        <label for="productDesc">Product Description:</label>
        <textarea name="productDesc" required></textarea><br>
        
        <label for="paroductPrice">Product Price:</label>
        <input type="text" name="productPrice" required><br>

            <select name="category">
            <option value="Pets">Pets</option>
            <option value="Pests">Pests</option>
            <option value="Wild">Wild</option>
            <option value="Food">Food</option>
            <option value="Test Subjects">Test Subjects</option>
            <option value="New York">New York</option>


        <input type="submit" value="Add Product">
    </form>

<%
} catch (SQLException ex) {
    out.println("Error retrieving total sales: " + ex.getMessage());
} 
 }
%>

</body>
</html>

