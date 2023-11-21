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
            try {
                // Change to a scrollable result set to support moving the cursor backward
                itemStatement = connection.prepareStatement("SELECT * FROM orderproduct WHERE orderId = ?", ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                itemStatement.setInt(1, orderId);
                itemResult = itemStatement.executeQuery();
                
                // Rest of your existing code remains unchanged
            } finally {
                // Close the itemStatement in the finally block
                if (itemStatement != null) {
                    itemStatement.close();
                }
            }

            // Create a new shipment record
            String insertShipmentQuery = "INSERT INTO shipment (shipmentDate, shipmentDesc, warehouseId) VALUES (?, ?, ?)";
            insertShipmentStatement = connection.prepareStatement(insertShipmentQuery, Statement.RETURN_GENERATED_KEYS);
            insertShipmentStatement.setTimestamp(1, new Timestamp(System.currentTimeMillis())); // Set the current timestamp as shipmentDate
            insertShipmentStatement.setString(2, "Shipment for Order #" + orderId);
            insertShipmentStatement.setInt(3, 1); // Assuming warehouseId 1 for now
        
            // For each item, verify sufficient quantity available in warehouse 1
            // If any item does not have sufficient inventory, cancel the transaction and rollback
            // Otherwise, update inventory for each item
            boolean inventoryUpdateSuccessful = true;
        
            while (itemResult.next()) {
                int productId = itemResult.getInt("productId");
                int quantity = itemResult.getInt("quantity");
        
                // TODO: Implement logic to check and update inventory for each product in the order
                String checkInventoryQuery = "SELECT quantity FROM productinventory WHERE productId = ? AND warehouseId = ?";
                PreparedStatement checkInventoryStatement = connection.prepareStatement(checkInventoryQuery);
                checkInventoryStatement.setInt(1, productId);
                checkInventoryStatement.setInt(2, 1); // Assuming warehouseId 1 for now
                ResultSet inventoryResult = checkInventoryStatement.executeQuery();
        
                if (inventoryResult.next()) {
                    int availableQuantity = inventoryResult.getInt("quantity");
                    if (availableQuantity < quantity) {
                        // Not enough inventory, cancel the transaction and rollback
                        inventoryUpdateSuccessful = false;
                        break;
                    }
                } else {
                    // Product not found in inventory, cancel the transaction and rollback
                    inventoryUpdateSuccessful = false;
                    break;
                }
            }
        
            if (inventoryUpdateSuccessful) {
                // If everything is successful, commit the transaction
                insertShipmentStatement.executeUpdate();
                ResultSet generatedKeys = insertShipmentStatement.getGeneratedKeys();
        
                if (generatedKeys.next()) {
                    int shipmentId = generatedKeys.getInt(1);
        
                    // TODO: Update inventory for each product in the order
                    String updateInventoryQuery = "UPDATE productinventory SET quantity = quantity - ? WHERE productId = ? AND warehouseId = ?";
                    updateInventoryStatement = connection.prepareStatement(updateInventoryQuery);
        
                    itemResult.beforeFirst(); // Move cursor back to the beginning
        
                    while (itemResult.next()) {
                        int productId = itemResult.getInt("productId");
                        int quantity = itemResult.getInt("quantity");
        
                        updateInventoryStatement.setInt(1, quantity);
                        updateInventoryStatement.setInt(2, productId);
                        updateInventoryStatement.setInt(3, 1); // Assuming warehouseId 1 for now
        
                        updateInventoryStatement.executeUpdate();
                    }
        
                    // Commit the transaction
                    connection.commit();
                }
            } else {
                // Not enough inventory, handle accordingly
                out.println("Not enough inventory for one or more items in the order. Shipment canceled.");
                // Rollback the transaction
                connection.rollback();
            }
        
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
        if (orderStatement != null) {
            try {
                orderStatement.close();
            } catch (SQLException closeEx) {
                // Handle close exception
                out.println("Error closing order statement: " + closeEx.getMessage());
            }
        }
        if (itemStatement != null) {
            try { itemStatement.close();
            } catch (SQLException closeEx) {
                // Handle close exception
                out.println("Error closing item statement: " + closeEx.getMessage());
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
