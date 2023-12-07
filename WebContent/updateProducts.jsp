<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Products</title>
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

        .product-list {
            margin: 20px;
        }

        table {
            border-collapse: collapse;
            width: 100%;
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

        form {
            margin-top: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
        }

        input, textarea {
            width: 100%;
            padding: 8px;
            margin-bottom: 10px;
            box-sizing: border-box;
        }

        input[type="submit"] {
            background-color: #333;
            color: #fff;
            cursor: pointer;
        }

        .action-links a {
            margin-right: 10px;
            text-decoration: none;
            color: #333;
        }

        .action-links a:hover {
            color: #f00; /* Change color on hover as per your preference */
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
    <div class="product-list">
        <h2>Update Products</h2>

        <table>
            <thead>
                <tr>
                    <th>Product ID</th>
                    <th>Product Name</th>
                    <th>Product Description</th>
                    <th>Product Price</th>
                    <th>Category</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    String dbURL = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
                    String dbUser = "sa";
                    String dbPass = "304#sa#pw";
                    Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);

                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT * FROM product");

                    while (rs.next()) {
                        int productId = rs.getInt("productId");
                        String productName = rs.getString("productName");
                        String productDesc = rs.getString("productDesc");
                        double productPrice = rs.getDouble("productPrice");
                        String category = rs.getString("categoryId");
                %>
                <tr>
                    <td><%= productId %></td>
                    <td><%= productName %></td>
                    <td><%= productDesc %></td>
                    <td><%= productPrice %></td>
                    <td><%= category %></td>
                    <td class="action-links">
                        <a href="editProduct.jsp?productId=<%= productId %>">Edit</a>
                        <a href="removeProduct.jsp?productId=<%= productId %>">Remove</a>
                    </td>
                </tr>
                <%
                    }
                    rs.close();
                    stmt.close();
                    con.close();
                %>
            </tbody>
        </table>
    </div>
</body>
</html>
