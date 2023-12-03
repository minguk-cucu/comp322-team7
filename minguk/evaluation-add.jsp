<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*" %>

<%

	String serverIP = "localhost";
	String strSID = "orcl";
	String portNum = "1521";
	String user = "minguk";
	String pass = "0118";
	String url = "jdbc:oracle:thin:@"+serverIP+":"+portNum+":"+strSID;
	
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
    String comment = request.getParameter("comment");
	int rate = Integer.parseInt(request.getParameter("rate"));
	int user_id = (int)session.getAttribute("userID");
	int match_id = (int)session.getAttribute("matchID");
	int e_id = (int)session.getAttribute("eID");
	e_id += 1;

	
	String sql = "INSERT INTO EVALUATION "+
			     "VALUES ( "+e_id + ", "+match_id + ", "+ user_id + ", "+ rate + ", '"+ comment +"' )";
	if ( stmt.executeUpdate(sql) != 1 ){
%>

	<script>
	alert("평가를 삽입하는 데 오류가 발생했습니다.");
	window.close();
	</script>
<%
	}
	else{
%>

	<script>
	alert("성공적으로 평가를 남겼어요 !");
	window.close();
	</script>
	<%
	}
	
	conn.commit();
	
	if(conn != null ) conn.close();
	if(rs != null) rs.close();
	if(stmt != null ) stmt.close();
	

%>


</body>
</html>