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

	int userID = (int)session.getAttribute("userID");
	String username=null;
	String password=null;
	String team = null;
	
	String sql = "SELECT ui.name, ui.password, uf.team_name FROM USER_INFO ui,USER_FOLLOW_TEAM uf WHERE ui.user_id = uf.user_id AND ui.user_id = " + userID;
	rs = stmt.executeQuery(sql);
	if(rs.next()){
		username = rs.getString(1);
		password = rs.getString(2);
		team = rs.getString(3);
	}
	
	
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
 	String originPass = request.getParameter("current-password");
 	String newPass = request.getParameter("password");
 	String newPassConf = request.getParameter("password-confirm");
 	String newTeam = request.getParameter("teams");
 	
 	//
 	if(!originPass.equals(password)){
 %>
 		<script>
 		alert("기존 비밀번호가 틀렸습니다.");
 		history.back();
 		</script>
<%
 	}
 	else{
 		if(!newPass.equals(newPassConf)){
 %>
 			<script>
 			alert("새 비밀번호가 일치하지 않습니다.");
 			history.back();
 			</script>
 <%
 			
 		}
 		else{
 			sql = "UPDATE USER_INFO " +
 				"SET password = '"+ newPass + "' "+
 				"WHERE user_id = " + userID;
 			
 			//success updating password
 			if( stmt.executeUpdate(sql) != 1){
%>
 	 			<script>
 	 			alert("비밀번호를 변경하는 중 오류가 생겼습니다.");
 	 			history.back();
 	 			</script>
<% 				 				
 			}
 			else{
 				
 				sql = "UPDATE USER_FOLLOW_TEAM " +
 					"SET team_name ='"+ newTeam +"' "+
 					"WHERE user_id = " + userID;
 				
 				if( stmt.executeUpdate(sql) != 1 ){
%>
 	 	 			<script>
 	 	 			alert("구독 팀을 변경하는 중 오류가 생겼습니다.");
 	 	 			history.back();
 	 	 			</script>
<% 		 					
 				}
 				else{
%>
 	 	 			<script>
 	 	 			alert("성공적으로 변경완료했습니다 !");
 					location.href = "userinfo.jsp";
 	 	 			</script>
<% 		 		 
					conn.commit();
 				}
 			}
 		}
 	}
 	


	if(conn != null ) conn.close();
	if(rs != null) rs.close();
	if(stmt != null ) stmt.close();
%>
</body>
</html>