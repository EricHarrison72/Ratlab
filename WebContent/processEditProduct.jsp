<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Process Edit Product</title>
    <!-- Add your stylesheets or scripts here -->
</head>
<body>

<%
    // Retrieve form parameters
    int productId = Integer.parseInt(request.getParameter("productId"));
    String productName = request.getParameter("productName");
    String productDesc = request.getParameter("productDesc");
    double productPrice = Double.parseDouble(request.getParameter("productPrice"));
    int category = Integer.parseInt(request.getParameter("category"));

    try {
        // Database connection details
        String dbURL = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String dbUser = "sa";
        String dbPass = "304#sa#pw";

        // Establish the database connection
        Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);

        // SQL query to update product information
        String sql = "UPDATE product SET productName = ?, productDesc = ?, productPrice = ?, categoryId = ? WHERE productId = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, productName);
        stmt.setString(2, productDesc);
        stmt.setDouble(3, productPrice);
        stmt.setInt(4, category);
        stmt.setInt(5, productId);

        // Execute the update query
        int rowsUpdated = stmt.executeUpdate();

        // Check if the update was successful
        if (rowsUpdated > 0) {
%>
            <h2>Product Updated Successfully</h2>
<%
            // Redirect the user back to updateProducts.jsp
            response.sendRedirect("updateProducts.jsp");
        } else {
%>
            <h2>Error Updating Product</h2>
            <p>There was an error updating the product. Please try again.</p>
<%
        }

        // Close the database resources
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
