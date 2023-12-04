<%@page import="java.util.Map"%>
<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.text.*,java.sql.*,java.time.*, java.util.*"%>
<%@ include file="../conf/dbinfo.jsp" %>

<%
Connection conn = null;
Class.forName("oracle.jdbc.driver.OracleDriver");
conn = DriverManager.getConnection(url, user, pass);
PreparedStatement pstmt = null;
ResultSet rs = null;
ResultSetMetaData rsmd = null;

String sql = "SELECT *\r\n" + "FROM (\r\n" + "SELECT M.MATCH_ID, TP.TEAM_NAME,M.MATCH_DATE, TP.SCORE, T.STADIUM\r\n"
		+ "FROM (MATCH M JOIN TEAM_PLAYED_MATCH TP ON  M.MATCH_ID = TP.MATCH_ID) JOIN TEAM T ON T.TEAM_NAME = m.home_team_name\r\n"
		+ ")\r\n";
pstmt = conn.prepareStatement(sql);
rs = pstmt.executeQuery();
rsmd = rs.getMetaData();
// for (int i = 0; i < rsmd.getColumnCount(); i++) {
// 	out.println(rsmd.getColumnName(i + 1));
// }
Month[] mlist = new Month[12];
int[] mindex = {8, 9, 10, 11, 12, 1, 2, 3, 4, 5, 6, 7};
for (int i = 0; i < 12; i++) {
	mlist[i] = Month.of(mindex[i]);
}
java.sql.Date match_date;
int match_id, home_score, away_score;
String home_name, away_name, stadium;
int month, date;
java.sql.Date d;

HashMap<Integer, HashMap<Integer, ArrayList<String>>> dataByMonth = new HashMap<>();
String match_str = "";
while (rs.next()) {
	match_str = "";
	try {
		match_date = rs.getDate(3);
		month = match_date.getMonth() + 1;
		date = match_date.getDate();
		match_id = rs.getInt(1);
		home_name = rs.getString(2);
		home_score = rs.getInt(4);
		stadium = rs.getString(5);
		match_str = match_str + match_id + ":" + home_name + ":" + match_date + ":" + home_score + ":" + stadium;
		rs.next();
		away_name = rs.getString(2);
		away_score = rs.getInt(4);

		match_str = match_str + ":" + away_name + ":" + away_score;
		if (!dataByMonth.containsKey(month)) {
	dataByMonth.put(month, new HashMap<Integer, ArrayList<String>>());
		}
		if (!dataByMonth.get(month).containsKey(date)) {
	dataByMonth.get(month).put(date, new ArrayList<String>());
		}
		dataByMonth.get(month).get(date).add(match_str);

	} catch (Exception e) {
		out.println("<p>" + e.getMessage() + "</p>");
	}
}
%>


<!DOCTYPE html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Match List</title>
<link rel = "stylesheet" href = "../header.css">
<link rel="stylesheet" href="match.css">
</head>
<body>
	<script src="match.js"></script>
	<script type="text/javascript">
	window.onload = function() {
		// 페이지 로드 시 각 탭의 내용 설정
		<%int todaym = mindex[0];
for (int mon = 0; mon < 12; mon++) {
	if (dataByMonth.get(mindex[mon]) != null) {
		todaym = mindex[mon];
	}
}%>
		tablinks = document.getElementsByClassName("tablink");
		str = tablink<%=todaym%>;
		tablink_today = document.getElementById("tablink<%=todaym%>
		");
			tablink_today.style.display = "block";
			tablink_today.className += " active";
		}
	</script>
	
    <div class="header">
        <img src ="../pics/lion.png" alt="this is lion">
        <div class="header-navi">
            <a class="selected" href = "match.jsp" title="matches">경기</a>
            <a href = "../team/team.jsp" title="teams">팀</a>
            <a href = "../player/player.jsp" title="players">선수</a>
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

	<div id="match">
		<div id="season">
            <img id="pre-btn" src="../pics/arrow.png"/>
            <span id="cur-year">2023</span>
            <span>/</span>
            <span id="next-year">24</span>
            <img id="next-btn" src="../pics/arrow.png" style='transform: scaleX(-1);'/>
        </div>
		<div class="tablist-container">
			<div class="tablist	">
				<%
				for (int mon = 0; mon < 12; mon++) {
				%>
				<button class="tablink" id="tablink<%=mindex[mon]%>"
					onclick="openTab(event, '<%=mindex[mon]%>')"><%=mindex[mon]%>월
				</button>
				<%
				}
				%>
			</div>
			<%
			for (Map.Entry<Integer, HashMap<Integer, ArrayList<String>>> month_entry : dataByMonth.entrySet()) {
			%>
			<div id="Tab<%=month_entry.getKey()%>" class="tabcontent">
				<%
				for (Map.Entry<Integer, ArrayList<String>> date_entry : month_entry.getValue().entrySet()) {
				%>
				<div class="tabdate-content" style="display: none"
					id="tab<%=month_entry.getKey()%>-content">
					<p class="tabdate-info">
						<%=month_entry.getKey()%>/<%=date_entry.getKey()%>
					</p>
					<div class="tabmatch-content"
						id="tabmatch<%=month_entry.getKey() + "." + date_entry.getKey()%>-content-match">
						<div class="match_date">
							<%
							ArrayList<String> this_month = date_entry.getValue();
							String[] match_info_list;
							for (String matches : this_month) {
								match_info_list = matches.split(":");
							%>
							<div class="match_each">
								<div class="match_stadium">
									<p class="p_stadium"><%=match_info_list[4]%></p>
								</div>


								<div class="match_info">
									<div class="team_info" id="home">
										<div class="team_name">
											<p class="t_name"><%=match_info_list[1]%></p>
										</div>
										<div class="team_logo_div" id="home">
											<img class="team_logo"
												src="../pics/<%=match_info_list[1]%>.png">
										</div>
									</div>
									<div class="match_score">
										<div class="score_background">
											<p class="p_score"><%=match_info_list[3]%>-<%=match_info_list[6]%></p>
										</div>

									</div>
									<div class="team_info" id="away">
										<div class="team_logo_div" id="away">
											<img class="team_logo"
												src="../pics/<%=match_info_list[5]%>.png">
										</div>
										<div class="team_name" id="away">
											<p class="t_name"><%=match_info_list[5]%></p>
										</div>
									</div>

								</div>
								<div class="match_buttons">
									<div class="button_each" id="log">
										<button class="button_b" onclick="#">기록</button>
									</div>
									<div class="button_each" id="eval">
										<% if (session.getAttribute("userID") == null ){
										%>
										<button class="button_b" onclick="javascript:alert('평가를 확인하시려면 로그인 해주세요.')">평가</button>
										
										<%} else {
										%>
										<button class="button_b" onclick="javascript:window.open('../userinfo/evaluation.jsp?mid='+<%=match_info_list[0]%>,'PopupWin','width=1094, height=722')">평가</button>
										<% }%>
									</div>
								</div>
							</div>
							<%
							}
							%>
						</div>
					</div>

				</div>
				<%
				}
				%>
			</div>
			<%
			}
			%>
		</div>
	</div>
</body>