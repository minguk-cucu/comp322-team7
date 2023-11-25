<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*" %>


<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
 <%@ 
    String userID = request.getParameter("email");
    String password = request.getParameter("password");

    session.setAttribute("userID", userID);
    
    response.sendRedirect("userinfo.jsp");
 %>


</body>
</html>