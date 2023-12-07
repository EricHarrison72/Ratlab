<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Product</title>
    <!-- Add your stylesheets or scripts here -->
</head>
<body>

<%
    // Retrieve the product ID from the request parameter
    int productId = Integer.parseInt(request.getParameter("productId"));

    try {
        // Database connection details
        String dbURL = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String dbUser = "sa";
        String dbPass = "304#sa#pw";

        // Establish the database connection
        Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);

        // SQL query to retrieve product information based on product ID
        String sql = "SELECT * FROM product WHERE productId = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, productId);
        ResultSet rs = stmt.executeQuery();

        // Check if the product exists
        if (rs.next()) {
            // Retrieve product details from the result set
            String productName = rs.getString("productName");
            String productDesc = rs.getString("productDesc");
            double productPrice = rs.getDouble("productPrice");
            int category = rs.getInt("categoryId");

            // Display the form with the existing product details
%>
            <h2>Edit Product</h2>
            <form method="post" action="processEditProduct.jsp">
                <input type="hidden" name="productId" value="<%= productId %>">
                <label for="productName">Product Name:</label>
                <input type="text" name="productName" value="<%= productName %>" required><br>

                <label for="productDesc">Product Description:</label>
                <textarea name="productDesc" required><%= productDesc %></textarea><br>

                <label for="productPrice">Product Price:</label>
                <input type="text" name="productPrice" value="<%= productPrice %>" required><br>

                <label for="category">Category:</label>
                <select name="category">
                    <option value="1" <%= category == 1 ? "selected" : "" %>>Pets</option>
                    <option value="2" <%= category == 2 ? "selected" : "" %>>Pests</option>
                    <option value="3" <%= category == 3 ? "selected" : "" %>>Wild</option>
                    <option value="4" <%= category == 4 ? "selected" : "" %>>Food</option>
                    <option value="5" <%= category == 5 ? "selected" : "" %>>Test Subjects</option>
                    <option value="6" <%= category == 6 ? "selected" : "" %>>New York</option>
                </select><br>

                <input type="submit" value="Update Product">
            </form>
<%
        } else {
            // Product not found
%>
            <p>Product not found.</p>
<%
        }

        // Close the database resources
        rs.close();
        stmt.close();
        con.close();

    } catch (SQLException ex) {
        // Handle database connection or query errors
        out.println("Error: " + ex.getMessage());
        ex.printStackTrace();
    }
%>

</body>
</html>
