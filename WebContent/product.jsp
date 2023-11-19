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
    <link href="css/bootstrap.min.css" rel="stylesheet">
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
                <%-- Display product image using productImageURL --%>
            <img src="<%= productImageURL %>" alt="<%= productName %>" class="img-fluid">

            <%-- binary field (productImage) using displayImage.jsp --%>
            <img src="displayImage.jsp?id=<%= productId %>" alt="<%= productName %>" class="img-fluid">
                <%-- Add links to "Add to Cart" and "Continue Shopping" --%>
                <p>
                    <a href="addcart.jsp?id=<%= productId %>&name=<%= URLEncoder.encode(productName, "UTF-8") %>&price=<%= productPrice %>">Add to Cart</a>
                    | <a href="listprod.jsp">Continue Shopping</a>
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


