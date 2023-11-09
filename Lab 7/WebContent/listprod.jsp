<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Your Grocery</title>
    <style>
        body {
            background-color: #cccccca4; /* Grey background for the entire page */
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }

        h1 {
            background-color: #0073e6; /* Blue background for headings */
            color: white;
            text-align: center;
            padding: 10px;
            margin: 0;
        }

        form {
            text-align: center;
            margin: 20px 0;
        }

        form input[type="text"] {
            width: 50%;
            padding: 5px;
            font-size: 16px;
            border: 1px solid #ccc;
        }

        form input[type="submit"], form input[type="reset"] {
            background-color: #0073e6; /* Blue background for buttons */
            color: white;
            padding: 5px 7px;
            font-size: 16px;
            border: none;
            cursor: pointer;
        }

        form input[type="submit"]:hover, form input[type="reset"]:hover {
            background-color: #0057b0; /* Darker blue on hover */
        }

        .product-info {
            background-color: #fff; /* White background for product info */
            border: 1px solid #ccc;
            margin: 10px;
            padding: 10px;
        }

        .product-link {
            background-color: #0073e6; /* Blue background for product links */
            color: white;
            padding: 5px 10px;
            text-decoration: none;
        }

        .product-link:hover {
            background-color: #0057b0; /* Darker blue on hover */
        }
    </style>
</head>
<body>

<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp">
    <input type="text" name="productName" size="50">
    <input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
</form>

<% 
String dbURL = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String dbUser = "sa";
String dbPassword = "304#sa#pw";

// Get product name to search for
String name = request.getParameter("productName");

// Initialize connection and result set
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
    // Make the connection
    conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

    // Variable name now contains the search string the user entered
    // Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!
    String query = "SELECT * FROM product WHERE productName LIKE ?";
    pstmt = conn.prepareStatement(query);
    pstmt.setString(1, "%" + name + "%");
    rs = pstmt.executeQuery();

    // Print out the ResultSet
    while (rs.next()) {
        int productId = rs.getInt("productId");
        String productName = rs.getString("productName");
        double productPrice = rs.getDouble("productPrice");

        // Create a link to add the product to the cart
        String addCartLink = "addcart.jsp?id=" + productId + "&name=" + URLEncoder.encode(productName, "UTF-8") + "&price=" + productPrice;
%>
    <!-- For each product, create a link to add it to the cart -->
    <div class="product-info">
        <p>
            Product Name: <%= productName %><br>
            Price: <%= productPrice %><br>
            <a class="product-link" href="<%= addCartLink %>">Add to Cart</a>
        </p>
    </div>
<%
    }
} catch (SQLException e) {
    out.println("SQL Exception: " + e);
} finally {
    // Close resources (connection, prepared statement, result set)
    try {
        if (rs != null) {
            rs.close();
        }
        if (pstmt != null) {
            pstmt.close();
        }
        if (conn != null) {
            conn.close();
        }
    } catch (SQLException ex) {
        out.println("SQL Exception during cleanup: " + ex);
    }
}
%>

</body>
</html>

