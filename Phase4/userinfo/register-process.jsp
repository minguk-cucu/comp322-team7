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
    conn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
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
 
    String username = request.getParameter("email");
    String password = request.getParameter("password");
	String passwordConf = request.getParameter("password-confirm");
	String team = request.getParameter("teams");
	String sql;
	int id;
	
	if( !password.equals(passwordConf) ){
%>
	<script>
	alert("비밀번호가 일치하지 않습니다.");
	history.back();
	</script>

	
<%
	}
	else{
		//
		sql = "SELECT user_id FROM USER_INFO WHERE name = '" + username + "' ";
		rs = stmt.executeQuery(sql);
		if(rs.next()) {
%>
			<script>
			alert("이미 존재하는 아이디입니다.");
			history.back();
			</script>

<%
		}
		else{
		//
		sql = "SELECT user_id FROM USER_INFO ORDER BY user_id DESC";
		rs = stmt.executeQuery(sql);
		if( rs.next() ) {
			id = rs.getInt(1) + 1;
		}
		else {
			id = 1;
		}
		
		
		//
		sql = "INSERT INTO USER_INFO VALUES( " + id + ", '" + username + "', '" + password + "' )"; 
		if ( stmt.executeUpdate(sql) == 1 ) {
			sql = "INSERT INTO USER_FOLLOW_TEAM VALUES( " + id + ", '" + team +"' )";
			if( stmt.executeUpdate(sql) == 1 ) {
				
%>
				<script>
				alert("회원가입을 성공적으로 마쳤습니다 ! 바로 로그인하실 수 있습니다.");
				location.href = "../login.html";
				</script>

<%
			
			}
			else {
%>
				<script>
				alert("회원가입 도중 오류가 발생했습니다.");
				history.back();
				</script>

<%
			}
		}
		else {
			
%>
			<script>
			alert("회원가입 도중 오류가 발생했습니다.");
			history.back();
			</script>

<%
		}

		conn.commit();
		}
		
	}

	if(conn != null ) conn.close();
	if(rs != null) rs.close();
	if(stmt != null ) stmt.close();
%>
</body>
</html>