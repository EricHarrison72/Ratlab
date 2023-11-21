<!DOCTYPE html>
<html>
<head>
        
			<meta charset="UTF-8">
			<meta name="viewport" content="width=device-width, initial-scale=1.0">
			<title>Eric Grocery Main Page</title>
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
<h1 align="center">Welcome to Eric's Grocery</h1>

<h2 align="center"><a href="login.jsp">Login</a></h2>

<h2 align="center"><a href="listprod.jsp">Begin Shopping</a></h2>

<h2 align="center"><a href="listorder.jsp">List All Orders</a></h2>

<h2 align="center"><a href="customer.jsp">Customer Info</a></h2>

<h2 align="center"><a href="admin.jsp">Administrators</a></h2>

<h2 align="center"><a href="logout.jsp">Log out</a></h2>

<%
	String userName = (String) session.getAttribute("authenticatedUser");
	if (userName != null)
		out.println("<h3 align=\"center\">Signed in as: "+userName+"</h3>");
%>

<h4 align="center"><a href="ship.jsp?orderId=1">Test Ship orderId=1</a></h4>

<h4 align="center"><a href="ship.jsp?orderId=3">Test Ship orderId=3</a></h4>
<img src="img/rat.png" width = "800" height = "600" alt="Rat">
</body>
</head>


