%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Eric Harrison's Grocery Order List</title>
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

// Get customer ID to search for
String customerID = request.getParameter("customerId");

// Make connection
String dbURL = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String dbUser = "sa";
String dbPass = "304#sa#pw";

// Establish a database connection
try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
     Statement stmt = conn.createStatement();
     Statement stmt2 = conn.createStatement();) {
    ResultSet rst = stmt.executeQuery("SELECT os.orderId, orderDate, os.customerId, firstName, lastName, totalAmount FROM ordersummary os JOIN customer  c ON os.customerId = c.customerId");

    out.println("<table><tr><th>Order Id</th><th>Order Date</th><th>Customer ID</th><th>Name</th><th>Total Amount</th></tr>");
    while (rst.next()) {
        out.println("<tr><td>" + rst.getInt(1) + "</td><td>" + rst.getDate(2) + "</td><td>" + rst.getInt(3)+ "</td><td>"+rst.getString(4) +" "+ rst.getString(5)+"</td><td>$" + rst.getFloat(6) + "</td></tr>");
        out.println("<tr><th>Product Id</th><th>Quantity</th><th>Price</th></tr>");
       while(rst.next()){
        ResultSet rst2 = stmt2.executeQuery("SELECT productId, quantity, price from orderproduct");
           out.println("<tr><td>"+ rst2.getInt(1)+"</td><td>"+rst2.getInt(2)+"</td><td>$"+rst2.getFloat(3)+"</td></tr>");
        }

    }
    out.print("</table>");
} catch (SQLException e) {
    out.println("SQL Exception: " + e);
}
// Close connection
%>

</body>
</html>