<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
</head>
<body>
	<div class="header">
        <ul class="menu">
            <li><a href="shop.html">Shop</a></li>
            <li><a href="listprod.jsp">Product List</a></li>
            <li><a href="listorder.jsp">Order List</a></li>
            <li><a href="showcart.jsp">Cart</a></li>
            <li><a href="login.jsp">Login</a></li>
            <li><a href="checkout.jsp">Checkout</a></li>
        </ul>
    </div>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
// Check if the user is logged in
boolean authenticated = session.getAttribute("authenticatedUser") != null;

// Display error message if not logged in
if (!authenticated) {
	out.println("<p>Error: You are not logged in. Please <a href='login.jsp'>login</a> to access this page.</p>");
} else {
	// Retrieve authenticated username
	String userName = (String) session.getAttribute("authenticatedUser");

	// TODO: Retrieve and display customer information by username
	String sql = "SELECT * FROM Customers WHERE userId = ?";

	try {
		getConnection();

		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setString(1, userName);
		ResultSet rs = pstmt.executeQuery();

		if (rs.next()) {
			// Display customer information
			out.println("<h1>Welcome, " + rs.getString("FirstName") + " " + rs.getString("LastName") + "!</h1>");
			out.println("<p>Email: " + rs.getString("Email") + "</p>");
			out.println("<p>Phone: " + rs.getString("PhoneNumber") + "</p>");
			out.println("<p>Address: " + rs.getString("Address") + "</p>");
			
		} else {
			out.println("<p>Error: Customer information not found for user " + userName + "</p>");
		}

	} catch (SQLException e) {
		out.println("SQL Exception: " + e);
	} finally {
		closeConnection();
	}
}
%>

</body>
</html>

