<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if user is logged in
    Integer userId = (Integer) session.getAttribute("userId");
    String firstName = (String) session.getAttribute("firstName");
    String redirectUrl = "index.jsp";
    String redirectText = "Go to Home";
    
    if (userId != null) {
        redirectUrl = "dashboard";
        redirectText = "Go to Dashboard";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Page Not Found</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div style="min-height:100vh;display:flex;align-items:center;justify-content:center;padding:2rem;">
        <div style="text-align:center;max-width:540px;">
            <h1 style="font-size:3rem;margin-bottom:1rem;">404</h1>
            <p style="margin-bottom:1.5rem;">The page you requested was not found.</p>
            <a href="<%=redirectUrl%>"><%=redirectText%></a>
        </div>
    </div>
</body>
</html>
