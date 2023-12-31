<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Your Shopping Cart</title>
        <style>
            /* Add your styles here to make it prettier */
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
            h1, h2 {
                color: #333;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            th, td {
                border: 1px solid #ddd;
                padding: 8px;
                text-align: left;
            }
            th {
                background-color: #333;
                color: #fff;
            }
            input[type="text"] {
                width: 40px;
                text-align: center;
            }
            input[type="submit"] {
                background-color: #333;
                color: #fff;
                padding: 8px 16px;
                border: none;
                cursor: pointer;
            }
            input[type="submit"]:hover {
                background-color: #555;
            }
            a {
                color: #333;
                text-decoration: none;
            }
            a:hover {
                color: #555;
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

    <h1>Your Shopping Cart</h1>

    <%
        // Get the current list of products
        @SuppressWarnings({"unchecked"})
        HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

        if (productList == null) {
            out.println("<H1>Your shopping cart is empty!</H1>");
            productList = new HashMap<String, ArrayList<Object>>();
        } else {
            NumberFormat currFormat = NumberFormat.getCurrencyInstance();

            out.print("<form method='post' action='updateCart.jsp'>");
            out.print("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th>");
            out.println("<th>Price</th><th>Subtotal</th><th>Remove</th></tr>");

            double total = 0;
            Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
            while (iterator.hasNext()) {
                Map.Entry<String, ArrayList<Object>> entry = iterator.next();
                ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
                if (product.size() < 4) {
                    out.println("<tr><td colspan='6'>Expected product with four entries. Got: " + product + "</td></tr>");
                    continue;
                }

                out.print("<tr><td>" + product.get(0) + "</td>");
                out.print("<td>" + product.get(1) + "</td>");
                out.print("<td align='center'><input type='text' name='quantity_" + product.get(0) + "' value='" + product.get(3) + "'></td>");
                Object price = product.get(2);
                Object itemqty = product.get(3);
                double pr = 0;
                int qty = 0;

                try {
                    pr = Double.parseDouble(price.toString());
                } catch (Exception e) {
                    out.println("<td colspan='3'>Invalid price for product: " + product.get(0) + " price: " + price + "</td></tr>");
                    continue;
                }
                try {
                    qty = Integer.parseInt(itemqty.toString());
                } catch (Exception e) {
                    out.println("<td colspan='3'>Invalid quantity for product: " + product.get(0) + " quantity: " + qty + "</td></tr>");
                    continue;
                }

                out.print("<td align='right'>" + currFormat.format(pr) + "</td>");
                out.print("<td align='right'>" + currFormat.format(pr * qty) + "</td>");
                out.print("<td align='center'><a href='removecart.jsp?productId=" + product.get(0) + "'>Remove</a></td></tr>");
                total += pr * qty;
            }
            out.println("<tr><td colspan='4' align='right'><b>Order Total</b></td>"
                    + "<td align='right'>" + currFormat.format(total) + "</td><td></td></tr>");
            out.println("</table>");
            out.println("<input type='submit' value='Update Cart'>");
            out.println("</form>");

            out.println("<h2><a href='checkout.jsp'>Check Out</a></h2>");
        }
    %>

    <h2><a href='listprod.jsp'>Continue Shopping</a></h2>
</body>
</html>
