<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*" %>
<%@ include file="../conf/dbinfo.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Team List</title>
    <link rel = "stylesheet" href = "../header.css">
    <link rel = "stylesheet" href = "team.css">
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
            <a class="selected" href = "team.jsp" title="teams">팀</a>
            <a href = "../player/player.jsp" title="players">선수</a>
            <a href = <% if(session.getAttribute("userID")==null){
            %>
            "../userinfo/login.html" title="login">로그인</a>
            <% }
            else{
            %>
            "../userinfo/userinfo.jsp" title="login">내정보</a>
            <% }
            %>
        </div>
    </div>

    <div id="team-container">
        <div id="season">
            <img id="pre-btn" src="../pics/arrow.png"/>
            <span id="cur-year">2023</span>
            <span>/</span>
            <span id="next-year">24</span>
            <img id="next-btn" src="../pics/arrow.png" style='transform: scaleX(-1);'/>
        </div>
       
       	<div id="team-inner">
	        <table>
	            <thead>
	                <tr>
	                    <th style="border-radius: 1.5rem 0 0 0">순위</th><th width='360rem'>팀</th><th>승리</th><th style="border-radius: 0 1.5rem 0 0">경기수</th>
	                </tr>
	            </thead>
	            <tbody>
	                <%	
	                    String query = "SELECT * FROM TEAM T, TEAM_STAT TS "
	                      			 + "WHERE T.Team_name = TS.Team_name "
	                      			 + "ORDER BY TS.Wins DESC";
	                
	                    pstmt = conn.prepareStatement(query);
	                    rs = pstmt.executeQuery();
	
	                    int rank = 1;
	                    while(rs.next()){
	                        out.println("<tr>");
	                        out.println("<td style='font-weight:bold; font-size: 2rem;'>"+rank+"</td>");
	                        out.println("<td>"
	                                    + "<div id='team-info'>"
	                                        + "<img src='../pics/"
	                                    	+ rs.getString(1)
	                                    	+ ".png' onError=\"this.style.visibility='hidden'\"/>"
                                            + "<span style='white-space: nowrap;'>" + rs.getString(1) + "</span>"
	                                    + "</div>"
	                                    +"</td>");
	                        out.println("<td>"+rs.getInt(18)+"</td>");
	                        out.println("<td>"+rs.getInt(12)+"</td>");

	                        // 4
	                        out.println("<td style='display: none;'>"+rs.getString(3)+"</td>");
	                        out.println("<td style='display: none;'>"+rs.getInt(2)+"</td>");
	                        out.println("<td style='display: none;'>"+rs.getString(4)+"</td>");
	                        out.println("<td style='display: none;'>"+rs.getInt(9)+"</td>");
	                        out.println("<td style='display: none;'>"+rs.getInt(15)+"</td>");
	                        out.println("<td style='display: none;'>"+rs.getInt(13)+"</td>");
	                        out.println("<td style='display: none;'>"+rs.getDouble(17)+"</td>");
	                        out.println("</tr>");

	                        rank++;
	                    }
	                    out.println("</table>");
	                %>
	            </tbody>
	        </table>
	        
            <div class="team-more-info">
            	<div id="team-more-info-title">
            		<img id="team-more-info-img"/>
            		<div id="team-more-info-title-contents">
            			<span id="team-more-info-name" style="font-size: 1.8rem; color: #37003C; font-weight: 700; white-space: nowrap;">이름</span>
            			<span id="team-more-info-stadium">장소</span>
            			<span id="team-more-info-est">연도</span>
            			<span id="team-more-info-mng">감독</span>
            		</div>
          			<span class="team-close-btn">×</span>
            	</div>
            	
            	<div id="team-more-info-contents">
            		<div id="team-more-info-goal">
            			<span>골</span>
            			<div class="gage-bg">
            				<div id="goal-gage" class="gage"></div>
            			</div>
            		</div>
            		<div id="team-more-info-shot">
            			<span>유효 슈팅</span>
            			<div class="gage-bg">
            				<div id="target-gage" class="gage"></div>
            			</div>
            		</div>
            		<div id="team-more-info-pass">
            			<span>패스</span>
            			<div class="gage-bg">
            				<div id="pass-gage" class="gage"></div>
            			</div>
            		</div>
            		<div id="team-more-info-tackle">
            			<span>태클 성공률</span>
            			<div class="gage-bg">
            				<div id="tackle-gage" class="gage"></div>
            			</div>
            		</div>
            	</div>
            </div>
        </div>
    </div>

    <script src="team.js"></script>
</body>
</html>