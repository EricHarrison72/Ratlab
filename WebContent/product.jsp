<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Ray's Grocery - Product Information</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="header.jsp" %>

<%
// Get product name to search for
// TODO: Retrieve and display info for the product
// String productId = request.getParameter("id");

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
        String productDescription = rs.getString("productDescription");

        // Display product details
%>
        <div class="container mt-4">
            <h2><%= productName %></h2>
            <p>Price: <%= NumberFormat.getCurrencyInstance().format(productPrice) %></p>
            <p>Description: <%= productDescription %></p>

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

// TODO: If there is a productImageURL, display using IMG tag
		
// TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
		

%>

</body>
</html>

