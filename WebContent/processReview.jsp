<%@ page import="java.sql.*, java.io.*, java.util.*" %>
<%@ include file="jdbc.jsp" %>

<%
// Retrieve review information from the form parameters
String productId = request.getParameter("productId"); // Get productId from request parameters
String ratingParam = request.getParameter("rating");
String comment = request.getParameter("comment");

// Validate and convert rating to an integer
int rating = 0;
try {
    rating = Integer.parseInt(ratingParam);
} catch (NumberFormatException e) {
    out.println("<h2>Invalid rating. Please provide a valid rating.</h2>");
    return;
}

// Get customer ID from the session
String customerId = (String) session.getAttribute("customerId");

// Check for null values
if (customerId == null || productId == null) {
    out.println("<h2>Invalid request. Please try again.</h2>");
    return;
}

// Insert the review into the database
String insertReviewQuery = "INSERT INTO review (reviewRating, reviewDate, customerId, productId, reviewComment) VALUES (?, ?, ?, ?, ?)";
String dbURL = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String dbUser = "sa";
String dbPassword = "304#sa#pw";

try (
    Connection connection = DriverManager.getConnection(dbURL, dbUser, dbPassword);
    PreparedStatement insertReviewStmt = connection.prepareStatement(insertReviewQuery)) {

    insertReviewStmt.setInt(1, rating);
    insertReviewStmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
    insertReviewStmt.setInt(3, Integer.parseInt(customerId));
    insertReviewStmt.setInt(4, Integer.parseInt(productId)); // Use productId from request parameters
    insertReviewStmt.setString(5, comment);

    insertReviewStmt.executeUpdate();

    response.sendRedirect("product.jsp?id=" + productId); // Redirect back to the product page
} catch (SQLException | IOException ex) {
    out.println("<h2>Error adding review. Please try again.</h2>");
    ex.printStackTrace();
}
%>


