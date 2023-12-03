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
    
    <link rel = "stylesheet" href = "userinfo-style.css">

</head>
<body>

    <!-- header -->
    <div id="header">
        <div class="inner">
            <img src ="pics/lion.png" alt="this is lion">
            <div class="navi">
                <a href = "" title="service-info">
                    <span>서비스 안내</span>
                </a>
                <a href = "yeongj/match.jsp" title="matches">
                    <span>경기</span>
                </a>
                <a href = "" title="teams">
                    <span>팀</span>
                </a>
                <a href = "" title="players">
                    <span>선수</span>
                </a>
                <a href = "" title="login" class="selected">
                    <span>내 정보</span>
                </a>
            </div>
        </div>
    </div>
    <div class = "img-container">
        <img src ="pics/bar.png" alt="there must be bar">
    </div>
    <!--  -->


    <div class="information">
        <p> 반갑습니다 ! <b><%=username %></b>, 무엇을 도와드릴까요 ?</p>
        <p> 당신은 현재 : <b><%= team%></b> 구독 중 </p>
        <% 
			if(team.equals("Arsenal")) out.println("<img src=\"pics/Arsenal.svg\">");
   			if(team.equals("Aston Villa")) out.println("<img src=\"pics/Aston Villa.svg\">");
			if(team.equals("AFC Bournemouth")) out.println("<img src=\"pics/AFC Bournemouth.svg\">");
			if(team.equals("Brentford")) out.println("<img src=\"pics/Brentford.svg\">");
			if(team.equals("Brighton & Hove Albion")) out.println("<img src=\"pics/Brighton & Hove Albion.svg\">");
			if(team.equals("Burnley")) out.println("<img src=\"pics/Burnley.svg\">");
			if(team.equals("Chelsea")) out.println("<img src=\"pics/Chelsea.svg\">");
			if(team.equals("Crystal Palace")) out.println("<img src=\"pics/Crystal Palace.svg\">");
			if(team.equals("Everton")) out.println("<img src=\"pics/Everton.svg\">");
			if(team.equals("Fulham")) out.println("<img src=\"pics/Fulham.svg\">");
			if(team.equals("Liverpool")) out.println("<img src=\"pics/Liverpool.svg\">");
			if(team.equals("Luton Town")) out.println("<img src=\"pics/Luton Town.svg\">");
			if(team.equals("Manchester City")) out.println("<img src=\"pics/Manchester City.svg\">");
			if(team.equals("Manchester United")) out.println("<img src=\"pics/Manchester United.svg\">");
			if(team.equals("Newcastle United")) out.println("<img src=\"pics/Newcastle United.svg\">");
			if(team.equals("Nottingham Forest")) out.println("<img src=\"pics/Nottingham Forest.svg\">");
			if(team.equals("Sheffield United")) out.println("<img src=\"pics/Sheffield United.svg\">");
			if(team.equals("Tottenham Hotspur")) out.println("<img src=\"pics/Tottenham Hotspur.svg\">");
			if(team.equals("West Ham United")) out.println("<img src=\"pics/West Ham United.svg\">");
			if(team.equals("Wolverhampton Wanderers")) out.println("<img src=\"pics/Wolverhampton Wanderers.svg\">");

        %>   
    </div>

    <div class="update-box">
        <div class="ptext"><p><%= username %></p></div>
        <form action="update-userinfo.jsp" method="POST">
            <input type="password" name = "current-password" placeholder="현재 비밀번호" required>
            <input type="password" id="password" name="password" oninput="checkPasswordMatch()" placeholder="비밀번호" required>
            <input type="password" id="password-confirm" name="password-confirm" oninput="checkPasswordMatch()" placeholder="비밀번호 확인" required>
            <span id ="password-check-text" class="password-check">&nbsp;비밀번호 확인&nbsp;</span>
            <svg id="disabled-check" xmlns="http://www.w3.org/2000/svg" width="30" height="24" viewBox="0 0 30 24" fill="none">
                <path d="M24.5591 0.996888L10.8753 15.738L5.61237 10.0815C5.32643 9.72268 4.97455 9.43122 4.57882 9.22545C4.1831 9.01968 3.75207 8.90405 3.31279 8.88581C2.87351 8.86757 2.43546 8.94713 2.02615 9.11948C1.61683 9.29183 1.24508 9.55325 0.934235 9.88734C0.623385 10.2214 0.380148 10.621 0.219789 11.0609C0.0594292 11.5008 -0.0145906 11.9716 0.00237687 12.4437C0.0193443 12.9159 0.126933 13.3791 0.318387 13.8044C0.509842 14.2298 0.781029 14.608 1.11493 14.9153L8.61067 23.0058C8.90872 23.3235 9.26218 23.5749 9.6508 23.7455C10.0394 23.9161 10.4556 24.0026 10.8753 23.9999C11.7121 23.9962 12.514 23.6391 13.1081 23.0058L29.0565 5.8649C29.3555 5.5462 29.5928 5.16704 29.7547 4.74929C29.9166 4.33153 30 3.88345 30 3.43089C30 2.97833 29.9166 2.53025 29.7547 2.1125C29.5928 1.69474 29.3555 1.31558 29.0565 0.996888C28.4589 0.358388 27.6504 0 26.8078 0C25.9651 0 25.1567 0.358388 24.5591 0.996888Z" fill="#9A9A9A"/>
            </svg>
            <svg id="enabled-check" xmlns="http://www.w3.org/2000/svg" width="30" height="24" viewBox="0 0 30 24" fill="none">
                <path d="M24.5591 0.996888L10.8753 15.738L5.61237 10.0815C5.32643 9.72268 4.97455 9.43122 4.57882 9.22545C4.1831 9.01968 3.75207 8.90405 3.31279 8.88581C2.87351 8.86757 2.43546 8.94713 2.02615 9.11948C1.61683 9.29183 1.24508 9.55325 0.934235 9.88734C0.623385 10.2214 0.380148 10.621 0.219789 11.0609C0.0594292 11.5008 -0.0145906 11.9716 0.00237687 12.4437C0.0193443 12.9159 0.126933 13.3791 0.318387 13.8044C0.509842 14.2298 0.781029 14.608 1.11493 14.9153L8.61067 23.0058C8.90872 23.3235 9.26218 23.5749 9.6508 23.7455C10.0394 23.9161 10.4556 24.0026 10.8753 23.9999C11.7121 23.9962 12.514 23.6391 13.1081 23.0058L29.0565 5.8649C29.3555 5.5462 29.5928 5.16704 29.7547 4.74929C29.9166 4.33153 30 3.88345 30 3.43089C30 2.97833 29.9166 2.53025 29.7547 2.1125C29.5928 1.69474 29.3555 1.31558 29.0565 0.996888C28.4589 0.358388 27.6504 0 26.8078 0C25.9651 0 25.1567 0.358388 24.5591 0.996888Z" fill="#0A154B"/>
            </svg>
            <select name ="teams" required>
                <option value="" selected disabled>구독 팀(반드시 선택)</option>
                <option value="Nothing">없음</option>
                <option value="Arsenal">아스날</option>
                <option value="Aston Villa">아스톤 빌라</option>
                <option value="AFC Bournemouth">AFC 본머스</option>
                <option value="Brentford">브렌트포드</option>
                <option value="Brighton & Hove Albion">브라이튼</option>
                <option value="Burnley">번리</option>
                <option value="Chelsea">첼시</option>
                <option value="Crystal Palace">크리스털 팰리스</option>
                <option value="Everton">에버튼</option>
                <option value="Fulham">풀햄</option> 
                <option value="Liverpool">리버풀</option> 
                <option value="Luton Town">루턴 타운</option>
                <option value="Manchester City">맨체스터 시티</option>
                <option value="Manchester United">맨체스터 유나이티드</option> 
                <option value="Newcastle United">뉴캐슬 유나이티드</option>
                <option value="Nottingham Forest">노팅엄 포레스트</option>
                <option value="Sheffield United">셰필드 유나이티드</option>
                <option value="Tottenham Hotspur">토트넘 핫스퍼</option>
                <option value="West Ham United">웨스트햄 유나이티드</option> 
                <option value="Wolverhampton Wanderers">울버햄튼 원더러스</option>
            </select>

            <input class="submit-button" type="submit" value="변경">
        </form>

    
    <button class="delete-user" onclick="confirmAndDelete()">탈퇴 </button>

	</div>

    <script src="userinfo.js"></script>

<%
	if(conn != null ) conn.close();
	if(rs != null) rs.close();
	if(stmt != null ) stmt.close();

%>

</body>
</html>