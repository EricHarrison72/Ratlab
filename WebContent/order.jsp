<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Eric Grocery Order Processing</title>
</head>
<body>
	<h5> <div class="header">
              
		<ul class="menu">
			<header>
			<a href="shop.html">Shop</a>
			<a href="listprod.jsp">Product List</a>
			<a href="listorder.jsp">Order List</a>
			<a href="showcart.jsp">Cart</a>
			<a href="checkout.jsp">Checkout</a></header> <!-- Add a link to the shop page -->
		</ul>
	</div></h5> 
	<h1>Order Summary</h1>
	<table border="1">
		<thead>
			<tr>
				<th>Product Id</th>
				<th>Product Name</th>
				<th>Quantity</th>
				<th>Price</th>
				<th>Subtotal</th>
			</tr>
		</thead>
		<tbody>
<% 
// Declare variables
    String firstName = "";
    String lastName = "";
    int orderId = 0;
// Get customer id
String custId = request.getParameter("customerId");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

// Determine if valid customer id was entered
// Determine if there are products in the shopping cart
// If either are not true, display an error message
if (custId == null || custId.isEmpty()) {
	response.sendRedirect("errorPage.jsp?message=Please enter a valid customer ID.");
} else if (productList == null || productList.isEmpty()) {
	response.sendRedirect("errorPage.jsp?message=Your shopping cart is empty.");
} else {
	

// Make connection
 try {
        // Make a database connection (replace with your own database credentials)
        String dbURL = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String dbUser = "sa";
        String dbPass = "304#sa#pw";
        Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);

        
// Save order information to database
        String insertOrderSQL = "INSERT INTO ordersummary (customerID, totalAmount) VALUES (?, ?)";
        PreparedStatement orderStmt = con.prepareStatement(insertOrderSQL, Statement.RETURN_GENERATED_KEYS);
        orderStmt.setString(1, custId);
        orderStmt.setDouble(2, 0); // Initial total amount

      

	/*
	// Use retrieval of auto-generated keys.
	PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);			
	ResultSet keys = pstmt.getGeneratedKeys();
	keys.next();
	int orderId = keys.getInt(1);
	*/
	
	
        if (orderStmt.executeUpdate() > 0) {
            ResultSet generatedKeys = orderStmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                orderId = generatedKeys.getInt(1);
            } else {
                throw new SQLException("Failed to retrieve the generated order ID.");
            }


// Insert each item into OrderProduct table using OrderId from previous INSERT
String insertOrderProductSQL = "INSERT INTO orderproduct (orderID, productID, quantity, price) VALUES (?, ?, ?, ?)";
            PreparedStatement orderProductStmt = con.prepareStatement(insertOrderProductSQL);

            double totalAmount = 0;
            Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
				while (iterator.hasNext()) {
					Map.Entry<String, ArrayList<Object>> entry = iterator.next();
					ArrayList<Object> product = entry.getValue();
					String productId = (String) product.get(0);
					String productName = (String) product.get(1);
					double quantity = Double.parseDouble((String) product.get(2));
					double price = Double.parseDouble(String.valueOf(product.get(3)));
					double subtotal = quantity * price;
					
					orderProductStmt.setInt(1, orderId);
   					orderProductStmt.setString(2, productId);
   					orderProductStmt.setDouble(3, quantity);
    				orderProductStmt.setDouble(4, price);

                if (orderProductStmt.executeUpdate() > 0) {
                    totalAmount += subtotal;
               
					// Print out product details
					out.println("<tr>");
					out.println("<td>" + productId + "</td>");
					out.println("<td>" + productName + "</td>");
					out.println("<td>" + quantity + "</td>");
					out.println("<td>" + price + "</td>");
					out.println("<td>" + subtotal + "</td>");
					out.println("</tr>");
				} else {
                    // Handle insertion failure
                }
            }
// Update total amount for order record
String updateTotalAmountSQL = "UPDATE ordersummary SET totalAmount = ? WHERE orderID = ?";
PreparedStatement updateTotalStmt = con.prepareStatement(updateTotalAmountSQL);
updateTotalStmt.setDouble(1, totalAmount);
updateTotalStmt.setInt(2, orderId);
if (updateTotalStmt.executeUpdate() <= 0) {
	// Handle update failure
}
// Here is the code to traverse through a HashMap
// Each entry in the HashMap is an ArrayList with item 0-id, 1-name, 2-quantity, 3-price

/*
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext())
	{ 
		Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		String productId = (String) product.get(0);
        String price = (String) product.get(2);
		double pr = Double.parseDouble(price);
		int qty = ( (Integer)product.get(3)).intValue();
            ...
	}
*/
String customerName = ""; // Initialize with an empty string
String customerNameSQL = "SELECT firstName,lastName FROM customer WHERE customerID = ?";
PreparedStatement customerNameStmt = con.prepareStatement(customerNameSQL);
customerNameStmt.setString(1, custId);
ResultSet customerNameResult = customerNameStmt.executeQuery();
if (customerNameResult.next()) {
	firstName = customerNameResult.getString("firstName");
	lastName = customerNameResult.getString("lastName");
}
// Print out order summary

out.println("Total Amount: $" + totalAmount);
out.println("<p>Order completed. Will be shipped soon...</p>");
out.println("<p>Your order reference number is: " + orderId + "</p>");
out.println("<p>Shipping to customer: " + custId + " Name: " + firstName + " " + lastName + "</p>");

// Clear cart if order placed successfully
session.removeAttribute("productList");
        } else {
            // Handle order insertion failure
        }

        // Close the database connection
        con.close();
    } catch (SQLException e) {
        out.println("SQL Exception: " + e);
    }
}
%>
</tbody>
</table>
</BODY>
</HTML>
