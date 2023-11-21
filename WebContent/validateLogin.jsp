<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%
	String authenticatedUser = null;
	session = request.getSession(true);

	try {
		authenticatedUser = validateLogin(out, request, session);
	} catch (IOException e) {
		System.err.println(e);
	}

	if (authenticatedUser != null)
		response.sendRedirect("index.jsp"); // Successful login
	else
		response.sendRedirect("login.jsp"); // Failed login - redirect back to login page with a message
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

        // Database connection details
        String dbURL = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String dbUser = "sa";
        String dbPass = "304#sa#pw";

        try {
            // Establishing the database connection
            try (Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass)) {
                // Check if username and password match some user account
                String userSql = "SELECT userid FROM customer WHERE userid = ? AND password = ?";
                try (PreparedStatement userPstmt = con.prepareStatement(userSql)) {
                    userPstmt.setString(1, username);
                    userPstmt.setString(2, password);
                    try (ResultSet userRs = userPstmt.executeQuery()) {
                        if (userRs.next()) {
                            retStr = userRs.getString("userid");
                        }
                    }
                }
            }
        } catch (SQLException ex) {
            out.println(ex);
        }

        if (retStr != null) {
            session.removeAttribute("loginMessage");
            session.setAttribute("authenticatedUser", username);
        } else {
            session.setAttribute("loginMessage", "Invalid username/password.");
        }

        return retStr;
    }
%>


