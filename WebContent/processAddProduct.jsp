<%@ page import="java.sql.*, java.io.*, java.nio.file.*, java.nio.file.attribute.*, javax.servlet.http.Part, java.text.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Process Add Product</title>
    <!-- Add any additional styles or script imports here -->
</head>
<body>
    <%
    String productName = request.getParameter("productName");
    String productPriceParam = request.getParameter("productPrice");
    double productPrice = (productPriceParam != null && !productPriceParam.isEmpty()) ?
            Double.parseDouble(productPriceParam) : 10.00;
    String productDesc = request.getParameter("productDesc");

    // Check if categoryId parameter is not null
    String categoryIdParam = request.getParameter("categoryId");
    int categoryId = (categoryIdParam != null && !categoryIdParam.isEmpty()) ?
            Integer.parseInt(categoryIdParam) : 1; // Default to 1 or another suitable default value

    try {
        String dbURL = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String dbUser = "sa";
        String dbPass = "304#sa#pw";
        Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);

        // Insert the new product into the database
        String sql = "INSERT INTO product (productName, productPrice, productDesc, categoryId) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setString(1, productName);
            stmt.setDouble(2, productPrice);
            stmt.setString(3, productDesc);
            stmt.setInt(4, categoryId);
       
            stmt.executeUpdate();
        }

        con.close();
        out.println("<h2>Product added successfully!</h2>");
        response.sendRedirect("index.jsp");
    } catch (SQLException | IOException ex) {
        ex.printStackTrace();
        out.println("<h2>Error adding product. Please try again.</h2>");
    }
    %>
</body>
</html>

