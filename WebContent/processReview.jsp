<%@ page import="java.sql.*, java.io.*, java.util.*" %>
<%@ include file="jdbc.jsp" %>

<%
// Retrieve review information from the form parameters
String productId = request.getParameter("productId");
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

// Check if the authenticatedUser attribute exists in the session
String authenticatedUser = (String) session.getAttribute("authenticatedUser");
if (authenticatedUser == null) {
    out.println("<h2>Invalid request. Please log in and try again.</h2>");
    return;
}

// Retrieve customerId using the authenticatedUser
int customerId;
String getCustomerIdQuery = "SELECT customerId FROM customer WHERE userId = ?";
String dbURL = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String dbUser = "sa";
String dbPassword = "304#sa#pw";

try (
    Connection connection = DriverManager.getConnection(dbURL, dbUser, dbPassword);
    PreparedStatement getCustomerIdStmt = connection.prepareStatement(getCustomerIdQuery)) {

    getCustomerIdStmt.setString(1, authenticatedUser);
    ResultSet customerIdRs = getCustomerIdStmt.executeQuery();

    if (customerIdRs.next()) {
        customerId = customerIdRs.getInt("customerId");
    } else {
        out.println("<h2>Invalid request. Unable to find customer information.</h2>");
        return;
    }
} catch (SQLException ex) {
    out.println("<h2>Error retrieving customer information. Please try again.</h2>");
    ex.printStackTrace();
    return;
}

// Check for an existing review for the given customerId and productId
String checkReviewQuery = "SELECT * FROM review WHERE customerId = ? AND productId = ?";
boolean existingReview = false;

try (
    Connection connection = DriverManager.getConnection(dbURL, dbUser, dbPassword);
    PreparedStatement checkReviewStmt = connection.prepareStatement(checkReviewQuery)) {

    checkReviewStmt.setInt(1, customerId);
    checkReviewStmt.setInt(2, Integer.parseInt(productId));
    ResultSet existingReviewRs = checkReviewStmt.executeQuery();

    existingReview = existingReviewRs.next();
} catch (SQLException ex) {
    out.println("<h2>Error checking for existing reviews. Please try again.</h2>");
    ex.printStackTrace();
    return;
}

// If an existing review is found, display an error message
if (existingReview) {
    out.println("<h2>You have already submitted a review for this product.</h2>");
    return;
}

// Check for null values
if (customerId <= 0 || productId == null) {
    out.println("<h2>Invalid request. Please try again.</h2>");
    return;
}

// Insert the review into the database
String insertReviewQuery = "INSERT INTO review (reviewRating, reviewDate, customerId, productId, reviewComment) VALUES (?, ?, ?, ?, ?)";

try (
    Connection connection = DriverManager.getConnection(dbURL, dbUser, dbPassword);
    PreparedStatement insertReviewStmt = connection.prepareStatement(insertReviewQuery)) {

    insertReviewStmt.setInt(1, rating);
    insertReviewStmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
    insertReviewStmt.setInt(3, customerId);
    insertReviewStmt.setInt(4, Integer.parseInt(productId));
    insertReviewStmt.setString(5, comment);

    insertReviewStmt.executeUpdate();

    response.sendRedirect("product.jsp?id=" + productId); // Redirect back to the product page
} catch (SQLException | IOException ex) {
    out.println("<h2>Error adding review. Please try again.</h2>");
    ex.printStackTrace();
}
%>
