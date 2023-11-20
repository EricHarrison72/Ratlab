<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%
    String authenticatedUser = null;
    session = request.getSession(true);

    try {
        authenticatedUser = validateLogin(out, request, session);
    } catch (IOException e) {
        // Handle the exception appropriately, e.g., log it
        e.printStackTrace();
    }

    if (authenticatedUser != null) {
        response.sendRedirect("index.jsp"); // Successful login
    } else {
        response.sendRedirect("login.jsp"); // Failed login - redirect back to login page with a message
    }
%>

<%!
    String validateLogin(JspWriter out, HttpServletRequest request, HttpSession session) throws IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String retStr = null;

        if (username == null || password == null)
            return null;
        if ((username.length() == 0) || (password.length() == 0))
            return null;

        try {
            getConnection();

            // Check if username and password match some user account
            String userSql = "SELECT user_id FROM users WHERE user_id = ? AND password = ?";
            PreparedStatement userPstmt = con.prepareStatement(userSql);
            userPstmt.setString(1, username);
            userPstmt.setString(2, password);
            ResultSet userRs = userPstmt.executeQuery();

            if (userRs.next()) {
                retStr = userRs.getString("user_id");

                // Check if the user is a customer
                String customerSql = "SELECT userid FROM customer WHERE userid = ?";
                PreparedStatement customerPstmt = con.prepareStatement(customerSql);
                customerPstmt.setString(1, retStr);
                ResultSet customerRs = customerPstmt.executeQuery();

                if (customerRs.next()) {
                    // User is a customer
                    session.removeAttribute("loginMessage");
                    session.setAttribute("authenticatedUser", retStr);
                    out.println("<script>window.location.href='customer.jsp';</script>"); // Redirect to customer page
                } else {
                    // User is an admin
                    out.println("<script>window.location.href='admin.jsp';</script>"); // Redirect to admin page
                }
            } else {
                session.setAttribute("loginMessage", "Invalid username/password.");
            }
        } catch (SQLException ex) {
            out.println(ex);
        } finally {
            closeConnection();
        }

        return retStr;
    }
%>

