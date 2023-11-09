<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Iterator" %>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Update Cart</title>
</head>
<body>
<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList != null) {
    // Process the form submission and update the quantities in the cart
    Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
    while (iterator.hasNext()) {
        Map.Entry<String, ArrayList<Object>> entry = iterator.next();
        String productId = entry.getKey();
        String quantityParam = request.getParameter("quantity_" + productId);

        if (quantityParam != null && !quantityParam.isEmpty()) {
            try {
                int newQuantity = Integer.parseInt(quantityParam);
                if (newQuantity >= 0) {
                    ArrayList<Object> product = entry.getValue();
                    product.set(3, newQuantity); // Update the quantity in the cart
                }
            } catch (NumberFormatException e) {
                // Handle invalid quantity input
                out.println("Invalid quantity for product: " + productId);
            }
        }
    }

    // Update the session attribute with the modified cart
    session.setAttribute("productList", productList);
    response.sendRedirect("showcart.jsp"); // Redirect back to the cart page
} else {
    out.println("<H1>Your shopping cart is empty!</H1>");
}
%>
</body>
</html>


