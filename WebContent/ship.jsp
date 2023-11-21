<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Eric's Rat Grocery Shipment Processing</title>
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
</head>
<body>
    <div class="header">
        <ul class="menu">
            <li><a href="index.jsp">Shop</a></li>
            <li><a href="listprod.jsp">Product List</a></li>
            <li><a href="listorder.jsp">Order List</a></li>
            <li><a href="showcart.jsp">Cart</a></li>
            <li><a href="login.jsp">Login</a></li>
            <li><a href="checkout.jsp">Checkout</a></li>
        </ul>
    </div>

    <%
// Database connection details
String dbURL = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String dbUser = "sa";
String dbPass = "304#sa#pw";

// TODO: Get order id
int orderId = Integer.parseInt(request.getParameter("orderId"));

// TODO: Check if valid order id in the database
Connection connection = null;
PreparedStatement orderStatement = null;
PreparedStatement itemStatement = null;
PreparedStatement insertShipmentStatement = null;
PreparedStatement updateInventoryStatement = null;
ResultSet orderResult = null;
ResultSet itemResult = null;

try {
    connection = DriverManager.getConnection(dbURL, dbUser, dbPass);

    // Start a transaction (turn off auto-commit)
    connection.setAutoCommit(false);

    // Check if the order exists
    String orderQuery = "SELECT * FROM ordersummary WHERE orderId = ?";
    orderStatement = connection.prepareStatement(orderQuery);
    orderStatement.setInt(1, orderId);
    orderResult = orderStatement.executeQuery();

    if (orderResult.next()) {
        // Retrieve all items in the order with the given id
        // Change to a scrollable result set to support moving the cursor backward
        // Declare itemStatement outside the try block
        itemStatement = connection.prepareStatement("SELECT orderproduct.productId, orderproduct.quantity AS order_quantity, productinventory.quantity AS inventory_quantity FROM orderproduct JOIN productinventory ON orderproduct.productId = productinventory.productId WHERE orderId = ?", ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        itemStatement.setInt(1, orderId);
        itemResult = itemStatement.executeQuery();

       boolean suc = true;
        while (itemResult.next()) {
            int prodId = itemResult.getInt("productId");
            int qty = itemResult.getInt("order_quantity");
            int inv = itemResult.getInt("inventory_quantity");
            int newInv = inv-qty;
            if(newInv >= 0) {
                out.print("<p>Ordered product: " + prodId + " Qty: " + qty + " Previous Inventory: " + inv + " New inventory: " + newInv + "</p>");
            } else {
                out.println("<h2>Shipment not done. Insufficient inventory for product id: " + prodId + "</h2>");
                suc = false;
            }
        }

        if(suc) {
            out.print("<h2>Shipment successfully processed</h2>");
        }
        

        // Rest of your existing code remains unchanged

        // Close itemResult when it is no longer needed
        // ...

        // Create a new shipment record
        String insertShipmentQuery = "INSERT INTO shipment (shipmentDate, shipmentDesc, warehouseId) VALUES (?, ?, ?)";
        insertShipmentStatement = connection.prepareStatement(insertShipmentQuery, Statement.RETURN_GENERATED_KEYS);
        insertShipmentStatement.setTimestamp(1, new Timestamp(System.currentTimeMillis())); // Set the current timestamp as shipmentDate
        insertShipmentStatement.setString(2, "Shipment for Order #" + orderId);
        insertShipmentStatement.setInt(3, 1); // Assuming warehouseId 1 for now

        // Rest of your existing code remains unchanged
        

        // Close resources
        if (insertShipmentStatement != null) {
            insertShipmentStatement.close();
        }
    } else {
        // Invalid order id, handle accordingly
        out.println("Invalid order id: " + orderId);
    }
} catch (SQLException ex) {
    // Handle SQL exception and rollback the transaction
    if (connection != null) {
        try {
            connection.rollback();
        } catch (SQLException rollbackEx) {
            // Handle rollback exception
            out.println("Error rolling back transaction: " + rollbackEx.getMessage());
        }
    }
    out.println("SQLException: " + ex.getMessage());
} finally {
    // Close resources in the finally block
    if (itemStatement != null) {
        try {
            itemStatement.close();
        } catch (SQLException closeEx) {
            // Handle close exception
            out.println("Error closing item statement: " + closeEx.getMessage());
        }
    }
    if (orderStatement != null) {
        try {
            orderStatement.close();
        } catch (SQLException closeEx) {
            // Handle close exception
            out.println("Error closing order statement: " + closeEx.getMessage());
        }
    }
    if (updateInventoryStatement != null) {
        try {
            updateInventoryStatement.close();
        } catch (SQLException closeEx) {
            // Handle close exception
            out.println("Error closing update inventory statement: " + closeEx.getMessage());
        }
    }
    if (connection != null) {
        try {
            connection.setAutoCommit(true); // Reset auto-commit to true
            connection.close();
        } catch (SQLException closeEx) {
            // Handle close exception
            out.println("Error closing database connection: " + closeEx.getMessage());
        }
    }
}
%>  
    <!-- Display a message to the user -->
    <h2><a href="index.jsp">Back to Main Page</a></h2>
</body>
</html>
