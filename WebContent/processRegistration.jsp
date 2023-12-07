<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
String firstName = request.getParameter("firstName");
String lastName = request.getParameter("lastName");
String email = request.getParameter("email");
String phonenum = request.getParameter("phonenum");
String address = request.getParameter("address");
String city = request.getParameter("city");
String state = request.getParameter("state");
String postalCode = request.getParameter("postalCode");
String country = request.getParameter("country");
String userId = request.getParameter("userId");
String password = request.getParameter("password");

try {
    // JDBC connection code here
    String dbURL = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
                String dbUser = "sa";
                String dbPass = "304#sa#pw";
                Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
    // Get the current max customerId
    String getMaxCustomerIdSql = "SELECT MAX(customerId) FROM customer";
    PreparedStatement getMaxCustomerIdStatement = conn.prepareStatement(getMaxCustomerIdSql);
    ResultSet maxCustomerIdResult = getMaxCustomerIdStatement.executeQuery();
    int nextCustomerId = 1; // Default to 1 if no customers exist yet

    if (maxCustomerIdResult.next()) {
        nextCustomerId = maxCustomerIdResult.getInt(1) + 1;
    }

    // Insert the new customer with the incremented customerId
    String sql = "INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userId, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    PreparedStatement statement = conn.prepareStatement(sql);
    statement.setString(1, firstName);
    statement.setString(2, lastName);
    statement.setString(3, email);
    statement.setString(4, phonenum);
    statement.setString(5, address);
    statement.setString(6, city);
    statement.setString(7, state);
    statement.setString(8, postalCode);
    statement.setString(9, country);
    statement.setString(10, userId);
    statement.setString(11, password);

    int rowsInserted = statement.executeUpdate();

    if (rowsInserted > 0) {
        out.println("<h2>Registration successful! Your customer ID is: " + nextCustomerId + "</h2>");
    } else {
        out.println("<h2>Registration failed. Please try again.</h2>");
    }

    conn.close();
} catch (SQLException e) {
    e.printStackTrace();
    out.println("<h2>Database error. Please try again.</h2>");
}
%>
