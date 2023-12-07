<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
<style>
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
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

    .logo img {
        width: 70px;
        height: 50px;
    }

    .menu {
        list-style-type: none;
        margin: 0;
        padding: 0;
        overflow: hidden;
        background-color: #333;
        text-align: center; /* Center the menu items */
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
        margin: 20px;
    }

    h1, h2 {
        color: #333;
    }

    .user-greeting {
        color: #fff;
        margin-left: auto;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
    }

    th, td {
        border: 1px solid #ddd;
        padding: 10px;
        text-align: left;
    }

    th {
        background-color: #333;
        color: #fff;
    }

    form {
        margin-top: 20px;
        max-width: 400px;
        margin-left: auto;
        margin-right: auto;
        text-align: left;
    }

    label {
        display: block;
        margin-bottom: 5px;
    }

    input, textarea, select {
        width: 100%;
        padding: 8px;
        margin-bottom: 10px;
        box-sizing: border-box;
    }

    input[type="submit"], button {
        background-color: #333;
        color: #fff;
        padding: 10px;
        border: none;
        cursor: pointer;
    }

    input[type="submit"]:hover, button:hover {
        background-color: #555;
    }

    p {
        margin-top: 20px;
    }

    a {
        color: #333;
        text-decoration: none;
    }

    a:hover {
        text-decoration: underline;
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
    //session.setAttribute("loginMessage", loginMessage);
    response.sendRedirect("login.jsp"); 
 } else {
        String currentUser = (String) session.getAttribute("authenticatedUser");
   

try {
    
 
        String dbURL = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String dbUser = "sa";
        String dbPass = "304#sa#pw";
        Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);
    

        
        // SQL query to check if user has admin permissions
        String adminSQL = "SELECT isAdmin FROM customer WHERE userId = ?";
        PreparedStatement adminStmt = con.prepareStatement(adminSQL);
        adminStmt.setString(1, currentUser);
        ResultSet adminRS = adminStmt.executeQuery();

        boolean admin = false;
        if (adminRS.next()) {
            int isAdmin = adminRS.getInt("isAdmin");
            admin = (isAdmin == 1);
        }

        if(!admin) {
            String loginMessage = "You have not been authorized to access the URL " + request.getRequestURL().toString();
            session.setAttribute("loginMessage", loginMessage);
            response.sendRedirect("login.jsp"); 
        }
        // Write SQL query to print out total order amount by day
        String sql = "SELECT (orderDate) AS orderDay, SUM(totalAmount) AS totalSales "
                   + "FROM ordersummary "
                   + "GROUP BY (orderDate)";

    PreparedStatement stmt = con.prepareStatement(sql);
    ResultSet rs = stmt.executeQuery();
%>

<%
// Write SQL query to retrieve all customers
String customerQuery = "SELECT * FROM customer";
PreparedStatement customerStmt = con.prepareStatement(customerQuery);
ResultSet customerRS = customerStmt.executeQuery();
%>

<div class="main-content">
    <h2>All Customers</h2>

    <table border="1">
        <tr>
            <th>User ID</th>
            <th>Username</th>
            <th>Email</th>
            <th>Is Admin</th>
        </tr>

        <%
        while (customerRS.next()) {
            String userId = customerRS.getString("userId");
            String name = customerRS.getString("firstName") + " " + customerRS.getString("lastName");
            String email = customerRS.getString("email");
            int isAdmin = customerRS.getInt("isAdmin");
        %>
        <tr>
            <td><%= userId %></td>
            <td><%= name %></td>
            <td><%= email %></td>
            <td><%= (isAdmin == 1) ? "Yes" : "No" %></td>
        </tr>
        <%
        }
        %>

    </table>
</div>

<%
// Close the customer result set and statement
customerRS.close();
customerStmt.close();
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

        <label for="category">Category:</label>
            <select name="category">
            <option value="Pets">Pets</option>
            <option value="Pests">Pests</option>
            <option value="Wild">Wild</option>
            <option value="Food">Food</option>
            <option value="Test Subjects">Test Subjects</option>
            <option value="New York">New York</option></select><br>

        
        <input type="submit" value="Add Product">
    </form>


    <button onclick="window.location.href='updateProducts.jsp'">Update Products</button>


<%
} catch (SQLException ex) {
    out.println("Error retrieving total sales: " + ex.getMessage());
} 
 }
%>

</body>
</html>

