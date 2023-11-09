<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Eric Harrison's Grocery Order List</title>
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

        h1 {
            color: #333;
            text-align: center;
            background-color: #cccccc;
            padding: 10px;
            margin: 0;
        }

        table {
            border-collapse: collapse;
            width: 100%;
            background-color: #cccccc;
        }

        table, th, td {
            border: 1px solid #ccc;
        }

        th, td {
            padding: 8px;
            text-align: left;
            color: #333;
        }

        th {
            background-color: #666;
            color: #fff;
        }

        tr:nth-child(even) {
            background-color: #ddd;
        }

        tr:nth-child(odd) {
            background-color: #ccc;
        }

        /* Styles for the product sub-table */
        .product-table {
            width: 50%;
            margin: 0 auto;
            background-color: #dddddd;
        }

        .product-table th, .product-table td {
            padding: 4px;
            color: #333;
        }
    </style>
</head>
<body>
    <div class="header">
        <ul class="menu">
            <li><a href="shop.html">Shop</a></li>
            <li><a href="listprod.jsp">Product List</a></li>
            <li><a href="listorder.jsp">Order List</a></li>
            <li><a href="showcart.jsp">Cart</a></li>
            <li><a href="checkout.jsp">Checkout</a></li>
        </ul>
    </div>

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

