<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
    <title>Eric's Grocery - Product Information</title>
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
    <link href="css/bootstrap.min.css" rel="stylesheet">
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
    <%
    String dbURL = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String dbUser = "sa";
    String dbPassword = "304#sa#pw";

    // Get product ID from request parameters
    String productId = request.getParameter("id");

    // Initialize connection and result set
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // Make the connection
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // Retrieve product information using PreparedStatement
        String query = "SELECT * FROM product WHERE productId = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, productId);
        rs = pstmt.executeQuery();

        // Display product information
        if (rs.next()) {
            String productName = rs.getString("productName");
            double productPrice = rs.getDouble("productPrice");
            String productDescription = rs.getString("productDesc");
            String productImageURL = rs.getString("productImageURL");

            // Display product details
%>
            <div class="container mt-4">
                <h2><%= productName %></h2>
                <p>Price: <%= NumberFormat.getCurrencyInstance().format(productPrice) %></p>
                <p>Description: <%= productDescription %></p>
                <!-- Display product image using productImageURL -->
                <img src="<%= productImageURL %>" class="img-fluid">

                <!-- Binary field (productImage) using displayImage.jsp -->
                <img src="displayImage.jsp?id=<%= productId %>" class="img-fluid">

                <!-- Add links to "Add to Cart" and "Continue Shopping" -->
                <p>
                    <a href="addcart.jsp?id=<%= productId %>&name=<%= URLEncoder.encode(productName, "UTF-8") %>&price=<%= productPrice %>">Add to Cart</a>
                    | <a href="listprod.jsp">Continue Shopping</a>
                </p>

                <!-- Review Form -->
                <h3>Write a Review</h3>
                <form action="processReview.jsp" method="post">
                    <input type="hidden" name="productId" value="<%= productId %>">
    
                    <label for="rating">Rating:</label>
                    <select name="rating" id="rating">
                        <option value="1">1 (Poor)</option>
                        <option value="2">2 (Fair)</option>
                        <option value="3">3 (Average)</option>
                        <option value="4">4 (Good)</option>
                        <option value="5">5 (Excellent)</option>
                    </select><br>
    
                    <label for="comment">Comment:</label><br>
                    <textarea name="comment" id="comment" rows="4" cols="50"></textarea><br>
    
                    <input type="submit" value="Submit Review">
                </form>

                <!-- Display Warehouse and Inventory Information -->
                <div class="mt-4">
                    <h3>Warehouse and Inventory Information</h3>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Warehouse</th>
                                <th>Quantity</th>
                                <th>Price</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                // Retrieve warehouse and inventory information using PreparedStatement
                                String warehouseQuery = "SELECT w.warehouseName, pi.quantity, pi.price " +
                                                      "FROM warehouse w " +
                                                      "JOIN productInventory pi ON w.warehouseId = pi.warehouseId " +
                                                      "WHERE pi.productId = ?";
                                try (PreparedStatement warehouseStmt = conn.prepareStatement(warehouseQuery)) {
                                    warehouseStmt.setString(1, productId);
                                    ResultSet warehouseRs = warehouseStmt.executeQuery();
    
                                    while (warehouseRs.next()) {
                                        String warehouseName = warehouseRs.getString("warehouseName");
                                        int quantity = warehouseRs.getInt("quantity");
                                        double price = warehouseRs.getDouble("price");
                            %>
                                        <tr>
                                            <td><%= warehouseName %></td>
                                            <td><%= quantity %></td>
                                            <td><%= NumberFormat.getCurrencyInstance().format(price) %></td>
                                        </tr>
                            <%
                                    }
                                } catch (SQLException ex) {
                                    out.println("SQL Exception while fetching warehouse info: " + ex);
                                }
                            %>
                        </tbody>
                    </table>
                </div>

                <!-- Display Reviews -->
                <div class="mt-4">
                    <h3>Customer Reviews</h3>
                    <%
                        String reviewQuery = "SELECT r.reviewRating, r.reviewDate, c.firstName, c.lastName, r.reviewComment FROM review r JOIN customer c ON r.customerId = c.customerId WHERE r.productId = ?";
                        try (PreparedStatement reviewStmt = conn.prepareStatement(reviewQuery)) {
                            reviewStmt.setString(1, productId);
                            ResultSet reviewRs = reviewStmt.executeQuery();

                            while (reviewRs.next()) {
                                int reviewRating = reviewRs.getInt("reviewRating");
                                Timestamp reviewDate = reviewRs.getTimestamp("reviewDate");
                                String customerName = reviewRs.getString("firstName") + " " + reviewRs.getString("lastName");
                                String reviewComment = reviewRs.getString("reviewComment");
                    %>
                                <div class="border p-3 mb-3">
                                    <p><strong><%= customerName %></strong> - <%= reviewDate.toLocalDateTime().toLocalDate() %></p>
                                    <p>Rating: <%= reviewRating %>/5</p>
                                    <p><%= reviewComment %></p>
                                </div>
                    <%
                            }
                        } catch (SQLException ex) {
                            out.println("SQL Exception while fetching reviews: " + ex);
                        }
                    %>
                </div>
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

