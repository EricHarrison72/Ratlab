<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="auth.jsp"%>
<%@ include file="jdbc.jsp" %>

<%
    String userId = request.getParameter("userId");
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String email = request.getParameter("Email");
    String phoneNum = request.getParameter("PhoneNum");
    String address = request.getParameter("Address");
    String city = request.getParameter("City");
    String state = request.getParameter("state");
    String postalCode = request.getParameter("postalCode");
    String country = request.getParameter("Country");

    try {
        // Establish a database connection
        String dbURL = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String dbUser = "sa";
        String dbPass = "304#sa#pw";
        Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);

        // Initialize the update flag
        boolean isUpdated = false;

        // Update FirstName if not null
        if (firstName != null && !firstName.isEmpty()) {
            String updateFirstNameSql = "UPDATE Customer SET FirstName = ? WHERE userId = ?";
            PreparedStatement updateFirstNameStmt = con.prepareStatement(updateFirstNameSql);
            updateFirstNameStmt.setString(1, firstName);
            updateFirstNameStmt.setString(2, userId);
            int rowsUpdated = updateFirstNameStmt.executeUpdate();
            if (rowsUpdated > 0) {
                isUpdated = true;
            }
            updateFirstNameStmt.close();
        }

        // Update LastName if not null
        if (lastName != null && !lastName.isEmpty()) {
            String updateLastNameSql = "UPDATE Customer SET LastName = ? WHERE userId = ?";
            PreparedStatement updateLastNameStmt = con.prepareStatement(updateLastNameSql);
            updateLastNameStmt.setString(1, lastName);
            updateLastNameStmt.setString(2, userId);
            int rowsUpdated = updateLastNameStmt.executeUpdate();
            if (rowsUpdated > 0) {
                isUpdated = true;
            }
            updateLastNameStmt.close();
        }

        // Update Email if not null
        if (email != null && !email.isEmpty()) {
            String updateEmailSql = "UPDATE Customer SET email = ? WHERE userId = ?";
            PreparedStatement updateEmailStmt = con.prepareStatement(updateEmailSql);
            updateEmailStmt.setString(1, email);
            updateEmailStmt.setString(2, userId);
            int rowsUpdated = updateEmailStmt.executeUpdate();
            if (rowsUpdated > 0) {
                isUpdated = true;
            }

            updateEmailStmt.close();
        }

        // Update PhoneNum if not null
        if (phoneNum != null && !phoneNum.isEmpty()) {
            String updatePhoneNumSql = "UPDATE Customer SET PhoneNum = ? WHERE userId = ?";
            PreparedStatement updatePhoneNumStmt = con.prepareStatement(updatePhoneNumSql);
            updatePhoneNumStmt.setString(1, phoneNum);
            updatePhoneNumStmt.setString(2, userId);
            int rowsUpdated = updatePhoneNumStmt.executeUpdate();
            if (rowsUpdated > 0) {
                isUpdated = true;
            }
            updatePhoneNumStmt.close();
        }

        // Update Address if not null
        if (address != null && !address.isEmpty()) {
            String updateAddressSql = "UPDATE Customer SET Address = ? WHERE userId = ?";
            PreparedStatement updateAddressStmt = con.prepareStatement(updateAddressSql);
            updateAddressStmt.setString(1, address);
            updateAddressStmt.setString(2, userId);
            int rowsUpdated = updateAddressStmt.executeUpdate();
            if (rowsUpdated > 0) {
                isUpdated = true;
            }
            updateAddressStmt.close();
        }

        // Update City if not null
        if (city != null && !city.isEmpty()) {
            String updateCitySql = "UPDATE Customer SET City = ? WHERE userId = ?";
            PreparedStatement updateCityStmt = con.prepareStatement(updateCitySql);
            updateCityStmt.setString(1, city);
            updateCityStmt.setString(2, userId);
            int rowsUpdated = updateCityStmt.executeUpdate();
            if (rowsUpdated > 0) {
                isUpdated = true;
            }
            updateCityStmt.close();
        }

        // Update State if not null
        if (state != null && !state.isEmpty()) {
            String updateStateSql = "UPDATE Customer SET State = ? WHERE userId = ?";
            PreparedStatement updateStateStmt = con.prepareStatement(updateStateSql);
            updateStateStmt.setString(1, state);
            updateStateStmt.setString(2, userId);
            int rowsUpdated = updateStateStmt.executeUpdate();
            if (rowsUpdated > 0) {
                isUpdated = true;
            }
            updateStateStmt.close();
        }

        // Update Postal Code if not null
        if (postalCode != null && !postalCode.isEmpty()) {
            String updatePostalCodeSql = "UPDATE Customer SET PostalCode = ? WHERE userId = ?";
            PreparedStatement updatePostalCodeStmt = con.prepareStatement(updatePostalCodeSql);
            updatePostalCodeStmt.setString(1, postalCode);
            updatePostalCodeStmt.setString(2, userId);
            int rowsUpdated = updatePostalCodeStmt.executeUpdate();
            if (rowsUpdated > 0) {
                isUpdated = true;
            }
            updatePostalCodeStmt.close();
        }

        // Update Country if not null
        if (country != null && !country.isEmpty()) {
            String updateCountrySql = "UPDATE Customer SET Country = ? WHERE userId = ?";
            PreparedStatement updateCountryStmt = con.prepareStatement(updateCountrySql);
            updateCountryStmt.setString(1, country);
            updateCountryStmt.setString(2, userId);
            int rowsUpdated = updateCountryStmt.executeUpdate();
            if (rowsUpdated > 0) {
                isUpdated = true;
            }
            updateCountryStmt.close();
        }

        // Check if any update was successful
        if (isUpdated) {
            out.println("<p>Update successful</p>");
            // Redirect back to customer.jsp
            response.sendRedirect("customer.jsp");
        } else {
            out.println("<p>No records were updated</p>");
        }

        // Close the resources
        con.close();

    } catch (SQLException e) {
        out.println("SQL Exception: " + e);
    }
%>
