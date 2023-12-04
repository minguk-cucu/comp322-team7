<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*" %>
<%@ include file="../conf/dbinfo.jsp" %>

<%
	//System.out.println(url);
	//out.println(url);
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	Class.forName("oracle.jdbc.driver.OracleDriver");
	conn = DriverManager.getConnection(url,user,pass);
	stmt = conn.createStatement();
	conn.setAutoCommit(false);

%>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
 <%
 
    String name = request.getParameter("email");
    String password = request.getParameter("password");
	
    String sql = "SELECT user_id FROM USER_INFO WHERE name = '" + name + "'" +
    		" AND password = '" + password + "'";
    
	rs = stmt.executeQuery(sql);

    //you ARE our member
    if ( rs.next()){
    	session.setAttribute("userID", rs.getInt(1));
        response.sendRedirect("userinfo.jsp");
    }
    //you ARE NOT out member
    else{
    	
%>
	<script>
	alert("등록되지 않은 아이디이거나 비밀번호가 틀렸습니다.");
	history.back();
	</script>

<%	}

	if(conn != null ) conn.close();
	if(rs != null) rs.close();
	if(stmt != null ) stmt.close();
%>
</body>
</html>