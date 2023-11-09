<!DOCTYPE html>
<html>
<head>
<title>Ray's Grocery CheckOut Line</title>
</head>
<body>
    <h5> <div class="header">
              
        <ul class="menu">
            <header>
            <a href="shop.html">Shop</a>
            <a href="listprod.jsp">Product List</a>
            <a href="listorder.jsp">Order List</a>
            <a href="showcart.jsp">Cart</a>
            <a href="checkout.jsp">Checkout</a></header> <!-- Add a link to the shop page -->
        </ul>
    </div></h5> 
<h1>Enter your customer id to complete the transaction:</h1>

<form method="get" action="order.jsp">
<input type="text" name="customerId" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset">
</form>

</body>
</html>

