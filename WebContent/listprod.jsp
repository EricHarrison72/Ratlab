<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Eric's Product List</title>
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
                display: flex;
            }
    
            .menu li {
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
    
            .user-greeting {
                color: #fff;
                margin-left: auto;
            }
    
            .logo {
                margin-right: auto;
            }
    
            h1 {
                color: #333;
                text-align: center;
                background-color: #333;
                color: white;
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
    
            form input[type="submit"],
            form input[type="reset"] {
                background-color: #333;
                color: white;
                padding: 5px 7px;
                font-size: 16px;
                border: none;
                cursor: pointer;
            }
    
            form input[type="submit"]:hover,
            form input[type="reset"]:hover {
                background-color: #555;
            }
    
            .product-info {
                background-color: #fff;
                border: 1px solid #ccc;
                margin: 10px;
                padding: 10px;
            }

            .product-link {
                background-color: #333;
                color: white;
                padding: 5px 10px;
                text-decoration: none;
            }
    
            .product-link:hover {
                background-color: #555;
            }

            .login-button {
                background-color: #333;
                color: #fff;
                padding: 14px 16px;
                text-decoration: none;
                border-radius: 5px;
            }
    
            .login-button:hover {
                background-color: #ddd !important;
                color: #333 !important;
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
            <div class="user-greeting">
                <% 
                    String userName = (String) session.getAttribute("authenticatedUser");
                    if (userName != null) {
                        out.println("Signed in as: " + userName);
                    } else {
                        out.println("<a class='login-button' href='login.jsp'>Login</a>");
                    }
                %>
            </div>
        </div>
    
        <h1>Search for the products you want to buy:</h1>
    
        <form method="get" action="listprod.jsp">
            <select name="category">
                <option value="" selected>All Categories</option>
                <option value="Pets">Pets</option>
                <option value="Pests">Pests</option>
                <option value="Wild">Wild</option>
                <option value="Food">Food</option>
                <option value="Test Subjects">Test Subjects</option>
                <option value="New York">New York</option>
                <!-- The catagory drop down doesn't do anything atm -->
            </select>
            <input type="text" name="productName" size="50">
            <input type="submit" value="Submit">
            <input type="reset" value="Reset"> (Leave blank for all products)
        </form>

        <%
        String dbURL = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String dbUser = "sa";
        String dbPassword = "304#sa#pw";
    
        // Get product name to search for
        String name = request.getParameter("productName");
    
        // Get category from drop down
        String category = request.getParameter("category");
    
        // Initialize connection and result set
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
    
        try {
            // Make the connection
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
    
            // Variable name now contains the search string the user entered
            // Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!
            String query = "SELECT * FROM product LEFT JOIN category ON product.categoryId = category.categoryId WHERE productName LIKE ?";
    
            // Append category filter to the query if a category is selected
            if (category != null && !category.isEmpty()) {
                query += " AND categoryName = ?";
            }
    
            pstmt = conn.prepareStatement(query);
    
            // Set parameters after creating the PreparedStatement
            pstmt.setString(1, "%" + name + "%");
    
            // Set category parameter if applicable
            if (category != null && !category.isEmpty()) {
                pstmt.setString(2, category);
            }
    
            rs = pstmt.executeQuery();

            // Print out the ResultSet
            while (rs.next()) {
                int productId = rs.getInt("productId");
                String productName = rs.getString("productName");
                double productPrice = rs.getDouble("productPrice");

                // Retrieve category
                String productCategory = rs.getString("categoryName");

                // Create a link to go to the product detail page
                String productDetailLink = "product.jsp?id=" + productId;
                // Create a link to add the product to the cart
                String addCartLink = "addcart.jsp?id=" + productId + "&name=" + URLEncoder.encode(productName, "UTF-8") + "&price=" + productPrice;
    %>
                <!-- For each product, create a link to add it to the cart -->
                <div class="product-info">
                    <p>
                        Product Name: <a class="product-link" href="<%= productDetailLink %>"><%= productName %></a><br>
                        Category: <%= productCategory %><br>
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
