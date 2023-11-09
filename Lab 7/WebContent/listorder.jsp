<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Eric Harrison's Grocery Order List</title>
    <style>
        body {
            background-color: #cccccca4; /* Grey background for the entire page */
        }

        table {
            border-collapse: collapse;
            width: 100%;
            background-color: #0073e66e; /* Blue background for the main table */
        }

        table, th, td {
            border: 1px solid #ccc;
        }

        th, td {
            padding: 8px;
            text-align: left;
            color: white; /* White text color for table headers and cells */
        }

        th {
            background-color: #0058b07d; /* Dark blue background for table headers */
        }

        tr:nth-child(even) {
            background-color: #6eaed0; /* Light blue background for even rows */
        }

        tr:nth-child(odd) {
            background-color: #618bb5; /* Blue background for odd rows */
        }

        /* Styles for the product sub-table */
        .product-table {
            width: 50%;
            margin: 0 auto;
            background-color: #00a6ffab; /* Light blue background for the sub-table */
        }

        .product-table th, .product-table td {
            padding: 4px;
            color: white;
        }
    </style>
</head>
<body>

<h1>Order List</h1>

<%
// Note: Forces loading of SQL Server driver
try {
    // Load driver class
    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
} catch (java.lang.ClassNotFoundException e) {
    out.println("ClassNotFoundException: " + e);
}

// Make connection
String dbURL = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String dbUser = "sa";
String dbPass = "304#sa#pw";

// Establish a database connection
try (Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);)
{
    PreparedStatement pstmt = con.prepareStatement("SELECT os.orderId, orderDate, os.customerId, firstName, lastName, totalAmount FROM ordersummary os JOIN customer c ON os.customerId = c.customerId");

    try (Statement stmt = con.createStatement();
         ResultSet rst = stmt.executeQuery("SELECT DISTINCT os.orderId FROM ordersummary os JOIN orderproduct op ON os.orderId = op.orderId");)
    {
        while (rst.next()) {
            int orderId = rst.getInt(1);

            try (PreparedStatement pstmtos = con.prepareStatement("SELECT os.orderId, orderDate, os.customerId, firstName, lastName, totalAmount FROM ordersummary os JOIN customer c ON os.customerId = c.customerId WHERE os.orderId = ?");)
            {
                pstmtos.setInt(1, orderId);

                try (ResultSet rstos = pstmtos.executeQuery();)
                {
                    if (rstos.next()) {
                        out.println("<table>");
                        out.println("<tr><th>Order Id</th><th>Order Date</th><th>Customer Id</th><th>Customer Name</th><th>Total Amount</th></tr>");
                        out.println("<tr><td>" + rstos.getInt(1) + "</td><td>" + rstos.getTimestamp(2) + "</td><td>" + rstos.getInt(3) + "</td><td>" + rstos.getString(4) + " " + rstos.getString(5) + "</td><td>$" + rstos.getFloat(6) + "</td></tr>");
                        
                        // Create a sub-table for products with a smaller appearance
                        out.println("<table class='product-table'>");
                        out.println("<tr><th>Product Id</th><th>Quantity</th><th>Price</th></tr>");

                        try (PreparedStatement pstmtop = con.prepareStatement("SELECT productId, quantity, price FROM orderproduct WHERE orderId = ?");)
                        {
                            pstmtop.setInt(1, orderId);

                            try (ResultSet rstop = pstmtop.executeQuery();)
                            {
                                while (rstop.next()) {
                                    out.println("<tr><td>" + rstop.getInt(1) + "</td><td>" + rstop.getInt(2) + "</td><td>$" + rstop.getFloat(3) + "</td></tr>");
                                }
                            }
                        }
                        
                        // Close the product sub-table
                        out.println("</table>");
                    }
                }
            }
        }
    }
} catch (SQLException e) {
    out.println("SQL Exception: " + e);
}
// Close connection
%>

</body>
</html>

