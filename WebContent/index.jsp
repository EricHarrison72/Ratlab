<!DOCTYPE html>
<html>
	<html lang="en">
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
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .menu {
            list-style-type: none;
            margin: 0;
            padding: 0;
            overflow: hidden;
            background-color: #333;
            display: flex;
        }

        .menu li {
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

        .user-greeting {
            color: #fff;
            margin-left: auto;
        }

        .logo {
            margin-right: auto;
        }
    </style>
</head>
<body>

<div class="header">
    <div class="logo">
        <img src="img/rat.png" width="70" height="50" alt="Rat">
    </div>
    <ul class="menu">
        <li><a href="index.jsp">Shop</a></li>
        <li><a href="listprod.jsp">Product List</a></li>
        <li><a href="listorder.jsp">Order List</a></li>
        <li><a href="showcart.jsp">Cart</a></li>
        <li><a href="login.jsp">Login</a></li>
        <li><a href="checkout.jsp">Checkout</a></li>
    </ul>
    <% 
        String userName = (String) session.getAttribute("authenticatedUser");
        if (userName != null)
            out.println("<div class='user-greeting'>Signed in as: " + userName + "</div>");
		else
			out.println("<div class='user-greeting'></div>");
    %>
</div>
	

</head>
<body>
<h1 align="center">Welcome to Eric's Grocery</h1>

<h2 align="center"><a href="login.jsp">Login</a></h2>

<h2 align="center"><a href="listprod.jsp">Begin Shopping</a></h2>

<h2 align="center"><a href="listorder.jsp">List All Orders</a></h2>

<h2 align="center"><a href="customer.jsp">Customer Info</a></h2>

<h2 align="center"><a href="admin.jsp">Administrators</a></h2>

<h2 align="center"><a href="logout.jsp">Log out</a></h2>



<h4 align="center"><a href="ship.jsp?orderId=1">Test Ship orderId=1</a></h4>

<h4 align="center"><a href="ship.jsp?orderId=3">Test Ship orderId=3</a></h4>

</body>
</head>


