<%@page import="java.util.Map"%>
<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.text.*,java.sql.*,java.time.*, java.util.*"%>
<%
String serverIP = "localhost";
String strSID = "orcl";
String portNum = "1521";
String user = "proj";
String pass = "proj";
String url = "jdbc:oracle:thin:@" + serverIP + ":" + portNum + ":" + strSID;

Connection conn = null;
Class.forName("oracle.jdbc.driver.OracleDriver");
conn = DriverManager.getConnection(url, user, pass);
ArrayList<ResultSet> rsArr = new ArrayList<ResultSet>();
ArrayList<ResultSetMetaData> rsmdArr = new ArrayList<ResultSetMetaData>();
ArrayList<String> sqlArr = new ArrayList<String>();
//rs0 = MATCH HOME,AWAY,SCORE,FORMATION
//
//url에 따라 바꾸기
String sql0 = "SELECT *" + " FROM (" + " SELECT M.*, TP.TEAM_NAME, tp.score, tp.formation,t.stadium"
		+ " FROM TEAM T, MATCH M JOIN TEAM_PLAYED_MATCH TP ON  M.MATCH_ID = TP.MATCH_ID"
		+ " WHERE t.team_name = m.home_team_name ORDER BY M.MATCH_ID DESC" + " )" + " WHERE MATCH_ID = 93354";
sqlArr.add(0, sql0);
//rs1 = MATCH LOG
//url에 따라 바꾸기
String sql1 = "SELECT *" + " FROM MATCH_LOG " + " where match_id = 93354";
sqlArr.add(1, sql1);

//rs2 = HOME LINEUP
//url에 따라 바꾸기
String sql2 = "SELECT distinct pl.Name, pl.Position, ps.passes as pass, pl.team_name"
		+ " FROM PLAYER pl,PLAYER_STAT ps,PLAYER_PLAYED_MATCH ppm,MATCH mc,TEAM_PLAYED_MATCH tpm"
		+ " WHERE mc.match_id = 93420" + " AND mc.home_team_name  = pl.team_name" + " AND pl.Player_id = ps.Player_id"
		+ " AND pl.Player_id = ppm.Player_id" + " AND ppm.Match_id = mc.Match_id" + " AND mc.Match_id = tpm.Match_id"
		+ " AND ps.passes is not null" + " ORDER BY pass DESC ";
sqlArr.add(2, sql2);

//rs3 = AWAY LINEUP
//url에 따라 바꾸기
String sql3 = "SELECT distinct pl.Name, pl.Position, ps.passes as pass, pl.team_name"
		+ " FROM PLAYER pl,PLAYER_STAT ps,PLAYER_PLAYED_MATCH ppm,MATCH mc,TEAM_PLAYED_MATCH tpm"
		+ " WHERE mc.match_id = 93420" + " AND mc.home_team_name  != pl.team_name" + " AND pl.Player_id = ps.Player_id"
		+ " AND pl.Player_id = ppm.Player_id" + " AND ppm.Match_id = mc.Match_id" + " AND mc.Match_id = tpm.Match_id"
		+ " AND ps.passes is not null" + " ORDER BY pass DESC ";
sqlArr.add(3, sql3);
%>
<!DOCTYPE html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Match List</title>
<link rel="stylesheet" href="log.css">
</head>
<body>
	<header>
		<div id="header">
			<div class="inner">
				<img src="pics/lion.png" alt="this is lion">
				<div class="navi">
					<a href="" title="service-info"> <span>서비스 안내</span>
					</a> <a href="" title="matches" class="selected"> <span>경기</span>
					</a> <a href="" title="teams"> <span>팀</span>
					</a> <a href="" title="players"> <span>선수</span>
					</a> <a href="" title="user-info"> <span>내 정보</span>
					</a>
				</div>
			</div>
		</div>

	</header>
	<%
	for (int i = 0; i < sqlArr.size(); i++) {
		String sql = sqlArr.get(i);
// 		out.println("<p>" + sql + "</p>");
		PreparedStatement pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
		ResultSet rs = pstmt.executeQuery();
		ResultSetMetaData rsmd = rs.getMetaData();
		rsArr.add(i, rs);
		rsmdArr.add(i, rsmd);
		/* while (rs.next()) {
			out.println("<p>");
			for (int j = 1; j <= rsmd.getColumnCount(); j++) {
		out.println(rs.getObject(j) + ",,,,");
			}
			out.println("</p>");
		} */

	}
	ResultSet rs0 = rsArr.get(0);
	ResultSet rs1 = rsArr.get(1);
	ResultSet rs2 = rsArr.get(2);
	ResultSet rs3 = rsArr.get(3);

	rs0.next();
	String home_team = rs0.getString(5);
	int home_score = rs0.getInt(6);
	String home_form = rs0.getString(7);
	rs0.next();
	String away_team = rs0.getString(5);
	int away_score = rs0.getInt(6);
	String away_form = rs0.getString(7);

	String home_goalkeeper = "";
	ArrayList<String> home_forward = new ArrayList<String>();
	ArrayList<String> home_mid = new ArrayList<String>();
	ArrayList<String> home_def = new ArrayList<String>();
	ArrayList<String> home_sub = new ArrayList<String>();
	String away_goalkeeper = "";
	ArrayList<String> away_forward = new ArrayList<String>();
	ArrayList<String> away_mid = new ArrayList<String>();
	ArrayList<String> away_def = new ArrayList<String>();
	ArrayList<String> away_sub = new ArrayList<String>();
	for (int i = 0; i < 11; i++) {
		rs2.next();
		if (rs2.getString(2).equals("Goalkeeper")) {
			home_goalkeeper = rs2.getString(1);
		} else if (rs2.getString(2).equals("Forward")) {
			home_forward.add(rs2.getString(1));
		} else if (rs2.getString(2).equals("Midfielder")) {
			home_mid.add(rs2.getString(1));
		} else if (rs2.getString(2).equals("Defender")) {
			home_def.add(rs2.getString(1));
		}
	}
	while (rs2.next()) {
		home_sub.add(rs2.getString(1));
	}
	for (int i = 0; i < 11; i++) {
		rs3.next();
		if (rs3.getString(2).equals("Goalkeeper")) {
			away_goalkeeper = rs3.getString(1);
		} else if (rs3.getString(2).equals("Forward")) {
			away_forward.add(rs3.getString(1));
		} else if (rs3.getString(2).equals("Midfielder")) {
			away_mid.add(rs3.getString(1));
		} else if (rs3.getString(2).equals("Defender")) {
			away_def.add(rs3.getString(1));
		}
	}
	while (rs3.next()) {
		away_sub.add(rs3.getString(1));
	}
	%>
	<div class="real_body">
		<div class="subtitle">
			<div class="subtitle_div" id="home">
				<div class="subtitle_group" id="home">
					<div class="team_title" id="home">
						<div class="team_name_div" id="home">
							<p class="team_name" id="home">
								<%=home_team%>
							</p>

						</div>
						<div class="team_img_div" id="home">
							<!-- <img> -->

						</div>

					</div>
					<div class="team_event" id="home">

						<%
						String event;
						while (rs1.next()) {
							event = rs1.getString(5);
							if (event.equals("goal")) {
						%>

						<div class="team_event_detail">
							<div class="detail_name_div">
								<p class="detail_name">
									<%=rs1.getString(4)%>
								</p>
							</div>
							<div class="detail_img_div">
								<p class="detail_img">
									<!-- img -->
								</p>

							</div>


						</div>
						<%
						}
						%>


						<%
						}
						%>

					</div>
				</div>
			</div>
			<div class="center_div">
				<div class="center_group">
					<div class="score_div">
						<p class="score"><%=home_score%>-<%=away_score%></p>
					</div>
					<div class="date_div">
						<p class="date"><%=rs0.getDate(3).getMonth()%>.<%=rs0.getDate(3).getDate()%></p>
					</div>
					<div class="stadium_div">
						<p class="stadium"><%=rs0.getString(8)%></p>

					</div>
				</div>

			</div>
			<div class="subtitle_div" id="away">
				<%
				rs0.next();
				%>

				<div class="subtitle_group" id="away">
					<div class="team_title" id="away">
						<div class="team_name_div" id="away">
							<p class="team_name" id="away">
								<%=away_team%>
							</p>

						</div>
						<div class="team_img_div" id="away">
							<!-- <img> -->

						</div>

					</div>
					<div class="team_event" id="away">

						<%
						out.println("<p>away</p>");
						rs1.beforeFirst();
						while (rs1.next()) {
							event = rs1.getString(5);
							if (event.equals("goal")) {
						%>

						<div class="team_event_detail">
							<div class="detail_name_div">
								<p class="detail_name">
									<%=rs1.getString(4)%>
								</p>
							</div>
							<div class="detail_img_div">
								<p class="detail_img">
									<!-- img -->
								</p>

							</div>


						</div>
						<%
						}
						}
						%>

					</div>
				</div>
			</div>
		</div>
		<div class="log_div">
			<div class="log_group">
				<div class="log_list" id="home">
					<%
					rs1.beforeFirst();
					while (rs1.next()) {
					%>
					<div class="log_oneline">
						<div class="event_player">
							<p class="event_name"><%=rs1.getString(4)%></p>
						</div>
						<div class="event_type">
							<p><%=rs1.getString(5)%></p>
							<!-- img -->
						</div>
						<div class="event_time_div">
							<div class="event_circle">
								<!-- css에 circle 넣기 -->
								<p class="event_time"><%=rs1.getString(3)%>
								</p>
							</div>

						</div>

					</div>
					<%
					}
					%>
				</div>
				<div class="formation_div" id="home">
					<div class="formation_group">
						<div class="form_str_div" id="home">
							<div class="form_info" id="home">
								<div class="form_info_pic" id="home">
									<!-- img -->
								</div>
								<div class="form_info_str" id="home">
									<p><%=home_form%></p>
								</div>
							</div>
						</div>
						<div class="field_div">
							<div class="field_in" id="home">
								<!--반복문 -->
							</div>
							<div class="field_in" id="away">
								<!--반복문 -->
							</div>
						</div>
						<div class="form_str_div" id="away">
							<div class="form_info" id="away">
								<div class="form_info_pic" id="away">
									<!-- img -->
								</div>
								<div class="form_info_str" id="home">
									<%=away_form%>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="log_list" id="away">
					<!-- 		반복문 -->
				</div>
			</div>

		</div>
		<div class="lineup_div">
			<div class="lineup_group">
				<div class="lineup_list_div" id="home">
					<div class="lineup_list_group" id="home">
						<div class="each_role" id="Goalkeeper">
							<div class="role_title" id="home">
								<p class="role_name" id="home">Goalkeeper</p>
							</div>
							<div class="role_lineup" id="home">
								<div class="player_each" id="home">
									<div class="player_info" id="home">
										<p class="player_name" id="home">
											home_goalk:<%=home_goalkeeper%>
										</p>
									</div>
									<div class="player_img" id="home">
										<!-- img -->
									</div>
								</div>
							</div>
						</div>
						<div class="each_role_empty"></div>
						<div class="each_role" id="Defender">
							<div class="role_title" id="home">
								<p class="role_name" id="home">/=Defender</p>
							</div>
							<div class="role_lineup" id="home">
								<%
								for (int i = 0; i < home_def.size(); i++) {
								%>
								<div class="player_each" id="home">
									<div class="player_info" id="home">
										<p class="player_name" id="home">
											defender:
											<%=home_def.get(i)%>
										</p>
									</div>
									<div class="player_img" id="home">
										<!-- img -->
									</div>
								</div>
								<%
								}
								%>
							</div>
						</div>
						<div class="each_role_empty"></div>
						<div class="each_role" id="Midfielder">
							<div class="role_title" id="home">
								<p class="role_name" id="home">/=Midfielder</p>
							</div>
							<div class="role_lineup" id="home">
								<%
								for (int i = 0; i < home_mid.size(); i++) {
								%>
								<div class="player_each" id="home">
									<div class="player_info" id="home">
										<p class="player_name" id="home">
											Forward:
											<%=home_mid.get(i)%>
										</p>
									</div>
									<div class="player_img" id="home">
										<!-- img -->
									</div>
								</div>
								<%
								}
								%>
							</div>
						</div>
						<div class="each_role_empty"></div>
						<div class="each_role" id="Forward">
							<div class="role_title" id="home">
								<p class="role_name" id="home">/=Forward</p>
							</div>
							<div class="role_lineup" id="home">
								<%
								for (int i = 0; i < home_forward.size(); i++) {
								%>
								<div class="player_each" id="home">
									<div class="player_info" id="home">
										<p class="player_name" id="home">
											Forward:
											<%=home_forward.get(i)%>
										</p>
									</div>
									<div class="player_img" id="home">
										<!-- img -->
									</div>
								</div>
								<%
								}
								%>
							</div>
						</div>
						<div class="each_role_empty"></div>
						<div class="each_role" id="Sub">
							<div class="role_title" id="home">
								<p class="role_name" id="home">/=Sub</p>
							</div>
							<div class="role_lineup" id="home">
								<%
								for (int i = 0; i < home_sub.size(); i++) {
								%>
								<div class="player_each" id="home">
									<div class="player_info" id="home">
										<p class="player_name" id="home">
											sub:
											<%=home_sub.get(i)%>
										</p>
									</div>
									<div class="player_img" id="home">
										<!-- img -->
									</div>
								</div>
								<%
								}
								%>
							</div>
						</div>

					</div>
				</div>
				<div class="lineup_list_empty"></div>
				<div class="lineup_list_div" id="away">
					<div class="lineup_list_group" id="away">
						<div class="each_role" id="Goalkeeper">
							<div class="role_title" id="away">
								<p class="role_name" id="away">Goalkeeper</p>
							</div>
							<div class="role_lineup" id="away">
								<div class="player_each" id="away">
									<div class="player_info" id="away">
										<p class="player_name" id="away">
											away_goalk:<%=away_goalkeeper%>
										</p>
									</div>
									<div class="player_img" id="away">
										<!-- img -->
									</div>
								</div>
							</div>
						</div>
						<div class="each_role_empty"></div>
						<div class="each_role" id="Defender">
							<div class="role_title" id="away">
								<p class="role_name" id="away">Defender</p>
							</div>
							<div class="role_lineup" id="away">
								<%
								for (int i = 0; i < away_def.size(); i++) {
								%>
								<div class="player_each" id="away">
									<div class="player_info" id="away">
										<p class="player_name" id="away">
											Defender:
											<%=away_def.get(i)%>
										</p>
									</div>
									<div class="player_img" id="away">
										<!-- img -->
									</div>
								</div>
								<%
								}
								%>
							</div>
						</div>
						<div class="each_role_empty"></div>
						<div class="each_role" id="Midfielder">
							<div class="role_title" id="away">
								<p class="role_name" id="away">/=Midfielder</p>
							</div>
							<div class="role_lineup" id="away">
								<%
								for (int i = 0; i < away_mid.size(); i++) {
								%>
								<div class="player_each" id="away">
									<div class="player_info" id="away">
										<p class="player_name" id="away">
											Midfielder:
											<%=away_mid.get(i)%>
										</p>
									</div>
									<div class="player_img" id="away">
										<!-- img -->
									</div>
								</div>
								<%
								}
								%>
							</div>
						</div>
						<div class="each_role_empty"></div>
						<div class="each_role" id="Forward">
							<div class="role_title" id="away">
								<p class="role_name" id="away">/=Forward</p>
							</div>
							<div class="role_lineup" id="away">
								<%
								for (int i = 0; i < away_forward.size(); i++) {
								%>
								<div class="player_each" id="away">
									<div class="player_info" id="away">
										<p class="player_name" id="away">
											Forward:
											<%=away_forward.get(i)%>
										</p>
									</div>
									<div class="player_img" id="away">
										<!-- img -->
									</div>
								</div>
								<%
								}
								%>
							</div>
						</div>
						<div class="each_role_empty"></div>
						<div class="each_role" id="Sub">
							<div class="role_title" id="away">
								<p class="role_name" id="away">/=Sub</p>
							</div>
							<div class="role_lineup" id="away">
								<%
								for (int i = 0; i < away_sub.size(); i++) {
								%>
								<div class="player_each" id="away">
									<div class="player_info" id="away">
										<p class="player_name" id="away">
											sub:
											<%=away_sub.get(i)%>
										</p>
									</div>
									<div class="player_img" id="away">
										<!-- img -->
									</div>
								</div>
								<%
								}
								%>
							</div>
						</div>

					</div>
				</div>
			</div>


		</div>

	</div>

</body>
</html>