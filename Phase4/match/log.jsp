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
ArrayList<ResultSet> rsArr = new ArrayList<ResultSet>();
ArrayList<ResultSetMetaData> rsmdArr = new ArrayList<ResultSetMetaData>();
ArrayList<String> sqlArr = new ArrayList<String>();
//rs0 = MATCH HOME,AWAY,SCORE,FORMATION
//
//url에 따라 바꾸기

String match_id = "93354";
try {
	match_id = request.getParameter("match_id");
} catch (Exception e) {
	match_id = "93354";
	out.println(e.getMessage());
}

String sql0 = "SELECT *" + " FROM (" + " SELECT M.*, TP.TEAM_NAME, tp.score, tp.formation,t.stadium"
		+ " FROM TEAM T, MATCH M JOIN TEAM_PLAYED_MATCH TP ON  M.MATCH_ID = TP.MATCH_ID"
		+ " WHERE t.team_name = m.home_team_name ORDER BY M.MATCH_ID DESC" + " )" + " WHERE MATCH_ID = " + match_id;
sqlArr.add(0, sql0);
//rs1 = MATCH LOG
//url에 따라 바꾸기
String sql1 = "SELECT *" + " FROM MATCH_LOG " + " where match_id = " + match_id;
sqlArr.add(1, sql1);

//rs2 = HOME LINEUP
//url에 따라 바꾸기
String sql2 = "SELECT distinct pl.Name, pl.Position, ps.passes as pass, pl.team_name"
		+ " FROM PLAYER pl,PLAYER_STAT ps,PLAYER_PLAYED_MATCH ppm,MATCH mc,TEAM_PLAYED_MATCH tpm"
		+ " WHERE mc.match_id =" + match_id + " AND mc.home_team_name  = pl.team_name"
		+ " AND pl.Player_id = ps.Player_id" + " AND pl.Player_id = ppm.Player_id" + " AND ppm.Match_id = mc.Match_id"
		+ " AND mc.Match_id = tpm.Match_id" + " AND ps.passes is not null" + " ORDER BY pass DESC ";
sqlArr.add(2, sql2);

//rs3 = AWAY LINEUP
//url에 따라 바꾸기
String sql3 = "SELECT distinct pl.Name, pl.Position, ps.passes as pass, pl.team_name"
		+ " FROM PLAYER pl,PLAYER_STAT ps,PLAYER_PLAYED_MATCH ppm,MATCH mc,TEAM_PLAYED_MATCH tpm"
		+ " WHERE mc.match_id =" + match_id + " AND mc.home_team_name  != pl.team_name"
		+ " AND pl.Player_id = ps.Player_id" + " AND pl.Player_id = ppm.Player_id" + " AND ppm.Match_id = mc.Match_id"
		+ " AND mc.Match_id = tpm.Match_id" + " AND ps.passes is not null" + " ORDER BY pass DESC ";
sqlArr.add(3, sql3);
%>
<!DOCTYPE html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Match List</title>
<link rel = "stylesheet" href = "../header.css">
<link rel = "stylesheet" href="log.css">
</head>
<body>
	<%
	PreparedStatement pstmt = null;
	for (int i = 0; i < sqlArr.size(); i++) {
		String sql = sqlArr.get(i);
		// 		out.println("<p>" + sql + "</p>");
		pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
		ResultSet rs = pstmt.executeQuery();
		
		if(!rs.next()){
			sql0 = "SELECT distinct pl.Name, pl.Position, ps.passes as pass, pl.team_name"
						+ " FROM PLAYER pl,PLAYER_STAT ps,PLAYER_PLAYED_MATCH ppm,MATCH mc,TEAM_PLAYED_MATCH tpm"
						+ " WHERE mc.match_id =" + match_id + " AND pl.team_name is null"
						+ " AND pl.Player_id = ps.Player_id" + " AND pl.Player_id = ppm.Player_id" + " AND ppm.Match_id = mc.Match_id"
						+ " AND mc.Match_id = tpm.Match_id" + " AND ps.passes is not null" + " ORDER BY pass DESC ";
			pstmt = conn.prepareStatement(sql0, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
			rs = pstmt.executeQuery();
		}else{
			rs.beforeFirst();
		}
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
	List<Map<String, Object>> event_home = new ArrayList<Map<String, Object>>();
	List<Map<String, Object>> event_away = new ArrayList<Map<String, Object>>();
	ResultSetMetaData rsmd1 = rsmdArr.get(1);
	int columnCount = rsmd1.getColumnCount();
	ResultSet rs11;
	String sql11;
	String player;
	String[] splited_player;
	while (rs1.next()) {
		player = rs1.getString(4);
		splited_player = player.split("[.] ");
		player = splited_player[1];
		sql1 = "SELECT p.team_name FROM player P WHERE P.NAME = '" + player + "'";
		pstmt = conn.prepareStatement(sql1);
		rs11 = pstmt.executeQuery();
		Map<String, Object> columns = new LinkedHashMap<String, Object>();

		rs11.next();
		try {
			if (rs11.getString(1).equals(home_team)) {
		for (int i = 1; i <= columnCount; i++) {
			columns.put(rsmd1.getColumnLabel(i), rs1.getObject(i));
		}
		event_home.add(columns);
			} else if (rs11.getString(1).equals(away_team)) {
		for (int i = 1; i <= columnCount; i++) {
			columns.put(rsmd1.getColumnLabel(i), rs1.getObject(i));
		}
		event_away.add(columns);
			}

		} catch (NullPointerException e) {
			if (home_team.equals("AFC Bournemouth")) {
				for (int j = 1; j <= columnCount; j++) {
					columns.put(rsmd1.getColumnLabel(j), rs1.getObject(j));
				}
				event_home.add(columns);
			}
			else if (away_team.equals("AFC Bournemouth")) {
				for (int j = 1; j <= columnCount; j++) {
					columns.put(rsmd1.getColumnLabel(j), rs1.getObject(j));
				}
				event_away.add(columns);
			}
		}

	}

	try {
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

	} catch (Exception e) {
		out.println("<p></p>");
	}
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
	String name = "";
	try {
		for (int i = 0; i < 11; i++) {
			rs3.next();
			name = rs3.getString(2);
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

	} catch (Exception e) {
		out.println("<p></p>");
	}
	%>
	<script src="./log.js"></script>
	
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
							<img class="team_logo" src="../pics/<%=home_team%>.png">

						</div>

					</div>
					<div class="team_event" id="home">

						<%
						String event;

						for (int i = 0; i < event_home.size(); i++) {
							if (event_home.get(i).get("ACTION").equals("goal")) {
						%>

						<div class="team_event_detail" id="home">
							<div class="detail_name_div" id="home">
								<p class="detail_name">
									<%-- 									<%=rs1.getString(4)%> --%>
									<%=event_home.get(i).get("SUBJECT")%>
								</p>

							</div>
							<div class="detail_img_div" id="home">
								<img class="detail_action"
									id=<%=event_home.get(i).get("ACTION")%> src="">

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
						<p class="date"><%=rs0.getDate(3).getMonth()+1%>.<%=rs0.getDate(3).getDate()%></p>
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
						<div class="team_img_div" id="away">
							<img class="team_logo" src="../pics/<%=away_team%>.png">

						</div>
						<div class="team_name_div" id="away">
							<p class="team_name" id="away">
								<%=away_team%>
							</p>

						</div>


					</div>
					<div class="team_event" id="away">

						<%
						for (int i = 0; i < event_away.size(); i++) {
							if (event_away.get(i).get("ACTION").equals("goal")) {
						%>

						<div class="team_event_detail" id="away">
							<div class="detail_name_div" id="away">
								<p class="detail_name">
									<%=event_away.get(i).get("SUBJECT")%>
								</p>
							</div>
							<div class="detail_img_div" id="away">

								<img class="detail_action"
									id=<%=event_away.get(i).get("ACTION")%> src="">


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
		<div class="eval_div">
			<div class="eval_star_div">
				<%
				String eval_sql = "SELECT E.*\r\n" + "FROM EVALUATION E \r\n" + "WHERE e.MATCH_ID = " + match_id;
				pstmt = conn.prepareStatement(eval_sql);
				ResultSet rs_eval = pstmt.executeQuery();
				int eval_score;
				String eval_review = "";
				try {
					rs_eval.next();
					eval_score = rs_eval.getInt(4);
					eval_review = rs_eval.getString(5);
				} catch (Exception e) {
					eval_score = 0;
					eval_review = "남겨진 평가가 없습니다.";
				}
				int not_fill_score = 5 - eval_score;
				%>
				<div class="star_info">
					<p class="star_p">
						<%=eval_review%>
					</p>
				</div>
				<div class="star_div">
					<%
					for (int i = 0; i < eval_score; i++) {
					%>
					<div class="star_each">
						<img class="star" src="../pics/ShineStar.svg">
					</div>
					<%
					}
					%>
					<%
					for (int i = 0; i < not_fill_score; i++) {
					%>
					<div class="star_each">
						<img class="star" src="../pics/BlankStar.svg">
					</div>
					<%
					}
					%>
				</div>
			</div>

			<div class="score_button_div">
				<div class="eval_button">
					<!-- 링크 수정 필요 -->
					<button class="button_b"
						onclick="javascript:window.open('../userinfo/evaluation.jsp?mid='+<%=match_id%>,'PopupWin','width=1094, height=722')">평가
						더 보기</button>
				</div>

			</div>
		</div>

		<div class="log_div">
			<div class="log_group">
				<div class="log_list" id="home">
					<%
					for (int i = 0; i < event_home.size(); i++) {
					%>
					<div class="log_oneline">
						<div class="event_player">
							<p class="event_name"><%=event_home.get(i).get("SUBJECT")%></p>
						</div>
						<div class="event_type" id="home">
							<img class="event_img" id=<%=event_home.get(i).get("ACTION")%>
								src="">
						</div>
						<div class="event_time_div">
							<div class="event_circle">
								<!-- css에 circle 넣기 -->
								<p class="event_time"><%=event_home.get(i).get("TIME")%>
								</p>
							</div>

						</div>

					</div>
					<%
					}
					%>
				</div>
				<div class="formation_div">
					<div class="formation_group">
						<div class="form_str_div" id="home">
							<div class="form_info" id="home">
								<div class="form_info_pic" id="home">
									<img class="team_form_logo"
										src="../pics/<%=home_team%>.png">
								</div>
								<div class="form_info_str" id="home">
									<p class="form_info_p" id="home"><%=home_form%></p>
								</div>
							</div>
						</div>
						<div class="field_div" id="home">
							<div class="field_in" id="home">
								<div class="formation_row" id="home">
									<div class="formation_col" id="home">
										<img class="form_each" src="../pics/home_form.png">
									</div>
								</div>
								<%
								String[] home_formation_split = home_form.split("[-]");
								int form_num;

								for (int i = 0; i < home_formation_split.length; i++) {
								%>
								<div class="formation_row" id="home">
									<%
									form_num = Integer.parseInt(home_formation_split[i]);
									for (int j = 0; j < form_num; j++) {
									%>
									<div class="formation_col">
										<img class="form_each" src="../pics/home_form.png">
									</div>

									<%
									}
									%>



								</div>


								<%
								}
								%>
							</div>
							<div class="field_in" id="away">
								<div class="formation_row" id="away">
									<div class="formation_col" id="away">
										<img class="form_each" src="../pics/away_form.png">
									</div>
								</div>
								<%
								String[] away_formation_split = away_form.split("[-]");

								for (int i = 0; i < away_formation_split.length; i++) {
								%>
								<div class="formation_row" id="away">
									<%
									form_num = Integer.parseInt(away_formation_split[i]);
									for (int j = 0; j < form_num; j++) {
									%>
									<div class="formation_col" id="away">
										<img class="form_each" src="../pics/away_form.png">
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
						<div class="form_str_div" id="away">
							<div class="form_info" id="away">
								<div class="form_info_pic" id="away">
									<img class="team_form_logo"
										src="../pics/<%=away_team%>.png">
								</div>
								<div class="form_info_str" id="away">
									<p class="form_info_p" id="away">
										<%=away_form%>
									</p>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="log_list" id="away">
					<%
					for (int i = 0; i < event_away.size(); i++) {
					%>
					<div class="log_oneline" id="away">
						<div class="event_player" id="away">
							<p class="event_name" id="away"><%=event_away.get(i).get("SUBJECT")%></p>
						</div>
						<div class="event_type" id="away">
							<img class="event_img" id=<%=event_away.get(i).get("ACTION")%>
								src="">
						</div>
						<div class="event_time_div" id="away">
							<div class="event_circle" id="away">
								<!-- css에 circle 넣기 -->
								<p class="event_time" id="away"><%=event_away.get(i).get("TIME")%>
								</p>
							</div>

						</div>

					</div>
					<%
					}
					%>
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
										<div class="name_div" id="home">
											<p class="player_name" id="home">
												<%=home_goalkeeper%>
											</p>
										</div>
										<div class="team_div" id="home">
											<p class="player_team" id="home">
												<%=home_team%>
											</p>
										</div>
									</div>
									<div class="player_img" id="home">
										<img class="player_pic" src="../pics/player.png">
									</div>
								</div>
							</div>
						</div>
						<div class="each_role_empty"></div>
						<div class="each_role" id="Defender">
							<div class="role_title" id="home">
								<p class="role_name" id="home">Defender</p>
							</div>
							<div class="role_lineup" id="home">
								<%
								for (int i = 0; i < home_def.size(); i++) {
								%>
								<div class="player_each" id="home">
									<div class="player_info" id="home">
										<div class="name_div" id="home">
											<p class="player_name" id="home">
												<%=home_def.get(i)%>
											</p>
										</div>
										<div class="team_div" id="home">
											<p class="player_team" id="home">
												<%=home_team%>
											</p>
										</div>
									</div>
									<div class="player_img" id="home">
										<img class="player_pic" src="../pics/player.png">
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
								<p class="role_name" id="home">Midfielder</p>
							</div>
							<div class="role_lineup" id="home">
								<%
								for (int i = 0; i < home_mid.size(); i++) {
								%>
								<div class="player_each" id="home">
									<div class="player_info" id="home">
										<div class="name_div" id="home">
											<p class="player_name" id="home">
												<%=home_mid.get(i)%>
											</p>
										</div>
										<div class="team_div" id="home">
											<p class="player_team" id="home">
												<%=home_team%>
											</p>
										</div>
									</div>
									<div class="player_img" id="home">
										<img class="player_pic" src="../pics/player.png">
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
								<p class="role_name" id="home">Forward</p>
							</div>
							<div class="role_lineup" id="home">
								<%
								for (int i = 0; i < home_forward.size(); i++) {
								%>
								<div class="player_each" id="home">
									<div class="player_info" id="home">
										<div class="name_div" id="home">
											<p class="player_name" id="home">
												<%=home_forward.get(i)%>
											</p>
										</div>
										<div class="team_div" id="home">
											<p class="player_team" id="home">
												<%=home_team%>
											</p>
										</div>
									</div>
									<div class="player_img" id="home">
										<img class="player_pic" src="../pics/player.png">
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
								<p class="role_name" id="home">Sub</p>
							</div>
							<div class="role_lineup" id="home">
								<%
								for (int i = 0; i < home_sub.size(); i++) {
								%>
								<div class="player_each" id="home">
									<div class="player_info" id="home">
										<div class="name_div" id="home">
											<p class="player_name" id="home">
												<%=home_sub.get(i)%>
											</p>
										</div>
										<div class="team_div" id="home">
											<p class="player_team" id="home">
												<%=home_team%>
											</p>
										</div>
									</div>
									<div class="player_img" id="home">
										<img class="player_pic" src="../pics/player.png">
									</div>
								</div>
								<%
								}
								%>
							</div>
						</div>

					</div>
				</div>
				<div class="lineup_list_div" id="away">
					<div class="lineup_list_group" id="away">
						<div class="each_role" id="Goalkeeper">
							<div class="role_title" id="away">
								<p class="role_name" id="away">Goalkeeper</p>
							</div>
							<div class="role_lineup" id="away">
								<div class="player_each" id="away">
									<div class="player_info" id="away">
										<div class="name_div" id="away">
											<p class="player_name" id="away">
												<%=away_goalkeeper%>
											</p>
										</div>
										<div class="team_div" id="away">
											<p class="player_team" id="away">
												<%=away_team%>
											</p>
										</div>


									</div>
									<div class="player_img" id="away">
										<img class="player_pic" src="../pics/player.png">
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
										<div class="name_div" id="away">
											<p class="player_name" id="away">
												<%=away_def.get(i)%>
											</p>
										</div>
										<div class="team_div" id="away">
											<p class="player_team" id="away">
												<%=away_team%>
											</p>
										</div>
									</div>
									<div class="player_img" id="away">
										<img class="player_pic" src="../pics/player.png">
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
								<p class="role_name" id="away">Midfielder</p>
							</div>
							<div class="role_lineup" id="away">
								<%
								for (int i = 0; i < away_mid.size(); i++) {
								%>
								<div class="player_each" id="away">
									<div class="player_info" id="away">
										<div class="name_div" id="away">
											<p class="player_name" id="away">
												<%=away_mid.get(i)%>
											</p>
										</div>
										<div class="team_div" id="away">
											<p class="player_team" id="away">
												<%=away_team%>
											</p>
										</div>
									</div>
									<div class="player_img" id="away">
										<img class="player_pic" src="../pics/player.png">
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
								<p class="role_name" id="away">Forward</p>
							</div>
							<div class="role_lineup" id="away">
								<%
								for (int i = 0; i < away_forward.size(); i++) {
								%>
								<div class="player_each" id="away">
									<div class="player_info" id="away">
										<div class="name_div" id="away">
											<p class="player_name" id="away">
												<%=away_forward.get(i)%>
											</p>
										</div>
										<div class="team_div" id="away">
											<p class="player_team" id="away">
												<%=away_team%>
											</p>
										</div>
									</div>
									<div class="player_img" id="away">
										<img class="player_pic" src="../pics/player.png">
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
								<p class="role_name" id="away">Sub</p>
							</div>
							<div class="role_lineup" id="away">
								<%
								for (int i = 0; i < away_sub.size(); i++) {
								%>
								<div class="player_each" id="away">
									<div class="player_info" id="away">
										<div class="name_div" id="away">
											<p class="player_name" id="away">
												<%=away_sub.get(i)%>
											</p>
										</div>
										<div class="team_div" id="away">
											<p class="player_team" id="away">
												<%=away_team%>
											</p>
										</div>


									</div>
									<div class="player_img" id="away">
										<img class="player_pic" src="../pics/player.png">
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

</body>
</html>