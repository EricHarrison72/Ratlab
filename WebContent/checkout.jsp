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
    </style>
</head>
<body>
    <div class="header">
        <ul class="menu">
            <li><a href="shop.html">Shop</a></li>
            <li><a href="listprod.jsp">Product List</a></li>
            <li><a href="listorder.jsp">Order List</a></li>
            <li><a href="showcart.jsp">Cart</a></li>
            <li><a href="login.jsp">Login</a></li>
            <li><a href="checkout.jsp">Checkout</a></li>
        </ul>
    </div>

    <h1>Enter your customer id to complete the transaction:</h1>

    <form method="get" action="order.jsp">
        <input type="text" name="customerId" size="50">
        <input type="submit" value="Submit"><input type="reset" value="Reset">
    </form>
</body>
</html>