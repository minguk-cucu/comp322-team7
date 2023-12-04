<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*" %>
<%@ include file="../conf/dbinfo.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Player List</title>
    <link rel = "stylesheet" href = "../header.css">
    <link rel = "stylesheet" href = "player.css">
</head>
<body>
	<% 
		Connection conn = null;
		PreparedStatement pstmt;
		ResultSet rs;
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn = DriverManager.getConnection(url,user,pass);
		request.setCharacterEncoding("utf-8");
	%>
	
    <div class="header">
        <img src ="../pics/lion.png" alt="this is lion">
        <div class="header-navi">
            <a href = "../match/match.jsp" title="matches">경기</a>
            <a href = "../team/team.jsp" title="teams">팀</a>
            <a class="selected" href = "player.jsp" title="players">선수</a>
            <a href = <% if(session.getAttribute("userID")==null){
            %>
            "../login.html" title="login">로그인</a>
            <% }
            else{
            %>
            "../userinfo/userinfo.jsp" title="userinfo">내정보</a>
            <% }
            %>
        </div>
    </div>

    <div id="player-container">
        <div id="season">
            <img id="pre-btn" src="../pics/arrow.png"/>
            <span id="cur-year">2023</span>
            <span>/</span>
            <span id="next-year">24</span>
            <img id="next-btn" src="../pics/arrow.png" style='transform: scaleX(-1);'/>
        </div>
       
       	<div id="player-inner">
	        <table>
	            <thead>
	                <tr>
	                    <th style="border-radius: 1.5rem 0 0 0">순위</th><th width='360rem'>선수</th><th>득점</th><th style="border-radius: 0 1.5rem 0 0">경기수</th>
	                </tr>
	            </thead>
	            <tbody>
	                <%	
	                    String query = "SELECT * FROM Player P, Player_stat PS "
	                                    + "WHERE P.player_id = PS.player_id "
	                                    + "AND NOT ps.goals IS NULL "
	                                    + "ORDER BY PS.goals DESC, PS.appearances, P.name";
	                    pstmt = conn.prepareStatement(query);
	                    rs = pstmt.executeQuery();
	
	                    int rank = 1;
	                    while(rs.next()){
	                        out.println("<tr>");
	                        out.println("<td style='font-weight:bold; font-size: 2rem;'>"+rank+"</td>");
	                        out.println("<td>"
	                                    + "<div id='player-info'>"
	                                        + "<img src='../pics/"
	                                    	+ rs.getString(7)
	                                    	+ ".png' onError=\"this.style.visibility='hidden'\"/>"
	                                        + "<div id='player-info-contents'>"
	                                            + "<span>" + rs.getString(2) + "</span>"
	                                            + "<span style='font-size: 1rem;'>" + rs.getString(6) + "</span>"
	                                        + "</div>"
	                                    + "</div>"
	                                    +"</td>");
	                        out.println("<td>"+rs.getInt(21)+"</td>");
	                        out.println("<td>"+rs.getInt(12)+"</td>");

                            // 4
	                        out.println("<td style='display: none;'>"+rs.getString(3)+"</td>");
	                        out.println("<td style='display: none;'>"+rs.getString(4)+"</td>");
	                        out.println("<td style='display: none;'>"+rs.getString(5)+"</td>");
	                        // 7
	                        out.println("<td style='display: none;'>"+rs.getInt(13)+"</td>");
	                        out.println("<td style='display: none;'>"+rs.getInt(24)+"</td>");
	                        out.println("<td style='display: none;'>"+rs.getDouble(17)+"</td>");
	                        out.println("<td style='display: none;'>"+rs.getInt(11)+"</td>");
	                        out.println("<td style='display: none;'>"+rs.getInt(16)+"</td>");
	                        out.println("<td style='display: none;'>"+rs.getInt(27)+"</td>");
	                        out.println("</tr>");		
	
	                        rank++;
	                        if (rank == 51)
	                        	break;
	                    }
	                    out.println("</table>");
	                %>
	            </tbody>
	        </table>
	        
            <div class="player-more-info">
                <svg viewBox="-10 -20 115 150" width="300px" height="400px">
                
                    <polygon points="93.30,25.00 93.30,75 50,100 6.69,75 6.69,24.99 49.99,0" style="fill: white; stroke: black; stroke-width: 0.5;"/>
                    <polygon points="93.30,25.00 50,50" style="fill: white; stroke: gray; stroke-width: 0.1;"/>
                    <polygon points="93.30,75 50,50" style="fill: white; stroke: gray; stroke-width: 0.1;"/>
                    <polygon points="50,100 50,50" style="fill: white; stroke: gray; stroke-width: 0.1;"/>
                    <polygon points="6.69,75 50,50" style="fill: white; stroke: gray; stroke-width: 0.1;"/>
                    <polygon points="6.69,24.99 50,50" style="fill: white; stroke: gray; stroke-width: 0.1;"/>
                    <polygon points="49.99,0 50,50" style="fill: white; stroke: gray; stroke-width: 0.1;"/>
                   
				   <text x="93.30" y="15.00" text-anchor="middle" font-size="0.35rem" dy=".3em">어시스트</text>
				   <text x="93.30" y="85.00" text-anchor="middle" font-size="0.35rem" dy=".3em">패스</text>
				   <text x="50" y="105" text-anchor="middle" font-size="0.35rem" dy=".3em">크로스 정확도</text>
				   <text x="6.69" y="85.00" text-anchor="middle" font-size="0.35rem" dy=".3em">공중볼</text>
				   <text x="6.69" y="15.00" text-anchor="middle" font-size="0.35rem" dy=".3em">걷어낸 횟수</text>
				   <text x="50" y="-5" text-anchor="middle" font-size="0.35rem" dy=".3em">유효 슈팅</text>
                </svg>
                
                <div id="player-more-info-contents">
                	<div id="player1" style="margin-bottom: 1rem;">
                		<div class="first-row">
                			<span id="player1-name" style="font-size: 1.5rem">이름</span>
                			<span class="player-close-btn" style="font-size: 2.2rem">×</span>
                		</div>
                		<span id="player1-position">포지션</span>
                		<span id="player1-nat">국적</span>
                		<span id="player1-birth">나이</span>
                		<span id="player1-height">키</span>
                	</div>
                	<div id="player2">
                		<div class="first-row">
	                		<span id="player2-name" style="font-size: 1.5rem">이름</span>
	                		<span class="player-close-btn" style="font-size: 2.2rem">×</span>
                		</div>
                		<span id="player2-position">포지션</span>
                		<span id="player2-nat">국적</span>
                		<span id="player2-birth">나이</span>
                		<span id="player2-height">키</span>
                	</div>
                </div>
            </div>
        </div>
    </div>

    <script src="player.js"></script>
</body>
</html>