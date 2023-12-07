<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Remove Product</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f7f7f7;
            margin: 0;
            padding: 0;
        }

        .confirmation {
            margin: 20px;
            text-align: center;
        }

        .confirmation h2 {
            color: #333;
        }

        .confirmation a {
            display: inline-block;
            padding: 10px 20px;
            background-color: #333;
            color: #fff;
            text-decoration: none;
            border-radius: 5px;
        }

        .confirmation a:hover {
            background-color: #555;
        }
    </style>
</head>
<body>
    <div class="confirmation">
        <%
            // Retrieve the product ID from the request parameter
            int productId = Integer.parseInt(request.getParameter("productId"));

            // Database connection details
            String dbURL = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
            String dbUser = "sa";
            String dbPass = "304#sa#pw";

            try {
                // Establish the database connection
                Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);

                // SQL query to remove the product
                String sql = "DELETE FROM product WHERE productId = ?";
                PreparedStatement stmt = con.prepareStatement(sql);
                stmt.setInt(1, productId);

                // Execute the delete query
                int rowsDeleted = stmt.executeUpdate();

                // Close the database resources
                stmt.close();
                con.close();

                // Display confirmation message based on the deletion result
                if (rowsDeleted > 0) {
        %>
                    <h2>Product removed successfully.</h2>
                    <p><a href="updateProducts.jsp">Back to Product List</a></p>
        <%
                } else {
        %>
                    <h2>Error removing product. Product not found.</h2>
                    <p><a href="updateProducts.jsp">Back to Product List</a></p>
        <%
                }

            } catch (SQLException ex) {
                // Handle database connection or query errors
                out.println("Error: " + ex.getMessage());
                ex.printStackTrace();
            }
        %>
    </div>
</body>
</html>
