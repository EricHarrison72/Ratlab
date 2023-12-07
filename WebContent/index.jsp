<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rat Grocery Main Page</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
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
            transition: background-color 0.3s, color 0.3s;
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

        .login-button {
            background-color: #333;
            color: #fff;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s, color 0.3s;
        }

        .login-button:hover {
            background-color: #ddd;
            color: #333;
        }

        .main-content {
            text-align: center;
            margin-top: 20px;
        }

        h1, h2, h4 {
            color: #333;
        }

        a {
            color: #333;
            text-decoration: none;
            transition: color 0.3s;
        }

        a:hover {
            color: #007bff;
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
        <li><a href="checkout.jsp">Checkout</a></li>
    </ul>
    <div class="user-greeting">
        <% 
            String userName = (String) session.getAttribute("authenticatedUser");
            if (userName != null) {
                out.println("Signed in as: " + userName);
            } else {
                out.println("<a class='login-button' href='login.jsp'>Login</a>");
            }
        %>
    </div>
</div>

<div class="main-content">
    <h1>Eric's Rat Grocery</h1>

    <h2><a href="listprod.jsp">Begin Shopping</a></h2>

    <h2><a href="listorder.jsp">List All Orders</a></h2>

    <h2><a href="customer.jsp">Customer Info</a></h2>

    <h2><a href="admin.jsp">Administrators</a></h2>

    <h2><a href="logout.jsp">Log out</a></h2>

    <h4><a href="ship.jsp?orderId=1">Test Ship orderId=1</a></h4>

    <h4><a href="ship.jsp?orderId=3">Test Ship orderId=3</a></h4>
</div>

</body>
</html>
