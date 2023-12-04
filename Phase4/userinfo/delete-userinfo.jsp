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
 
    int userID = (int)session.getAttribute("userID");

 
	String sql = "DELETE FROM USER_INFO " +
			 "WHERE user_id = " + userID;

	int result = stmt.executeUpdate(sql);
	if(result == 1 ) {
		conn.commit();

		
%>
		<script>
		alert("성공적으로 삭제하였습니다 !");
		location.href = "login.html";
		</script>

<%	
	}
	else {

%>
		<script>
		alert("삭제하는 중 문제가 발생하였습니다.");
		history.back();
		</script>

<%	
	}
	
	if(conn != null ) conn.close();
	if(rs != null) rs.close();
	if(stmt != null ) stmt.close();
%>
</body>
</html>