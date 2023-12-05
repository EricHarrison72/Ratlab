<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ray's Grocery CheckOut Line</title>
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

        h1 {
            color: #333;
            text-align: center;
            background-color: #cccccc;
            padding: 10px;
            margin: 0;
        }

        form {
            text-align: center;
            margin: 20px 0;
        }

        form input[type="text"] {
            width: 50%;
            padding: 5px;
            font-size: 16px;
            border: 1px solid #ccc;
        }

        form input[type="submit"],
        form input[type="reset"] {
            background-color: #333;
            color: white;
            padding: 5px 7px;
            font-size: 16px;
            border: none;
            cursor: pointer;
        }

        form input[type="submit"]:hover,
        form input[type="reset"]:hover {
            background-color: #555;
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
            padding: 14px 16px;
            text-decoration: none;
            border-radius: 5px;
        }

        .login-button:hover {
            background-color: #ddd !important;
            color: #333 !important;
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

    <h1>Enter your customer id to complete the transaction:</h1>

    <form method="get" action="order.jsp">
        <input type="text" name="customerId" size="50">
        <input type="submit" value="Submit"><input type="reset" value="Reset">
    </form>
</body>
</html>