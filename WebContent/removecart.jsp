<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>

<%
String productIdToRemove = request.getParameter("productId");

// Get the current list of products from the session
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

// Check if the productList exists and if the productIdToRemove is not null
if (productList != null && productIdToRemove != null) {
    // Remove the product with the specified productId from the productList
    productList.remove(productIdToRemove);

    // Update the session attribute with the modified productList
    session.setAttribute("productList", productList);
}

// Redirect back to the cart page
response.sendRedirect("showcart.jsp");
%>