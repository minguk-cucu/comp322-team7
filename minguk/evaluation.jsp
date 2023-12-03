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
	
	int user_id = (int)session.getAttribute("userID");
	int match_id = Integer.parseInt(request.getParameter("mid"));
	session.setAttribute("matchID", match_id);
	
	String sql = "SELECT  m.match_date,m.home_team_name, tm.score "+
				 "FROM MATCH m,TEAM_PLAYED_MATCH tm "+
				 "WHERE m.match_id = "+ match_id +" "+
			     "AND m.match_id = tm.match_id "+
			     "AND m.home_team_name = tm.team_name";
	
	
	java.sql.Date match_date=null;
	int month=0, date=0;
	String home_team=null, away_team=null;
	int home_score=0, away_score=0;
	rs = stmt.executeQuery(sql);
	if ( rs.next()){
		match_date = rs.getDate(1);
		month = match_date.getMonth() + 1;
		date = match_date.getDate();
		home_team = rs.getString(2);
		home_score = rs.getInt(3);
	}
	
	sql = "WITH AWAY_TEAM "+
				 "AS( SELECT team_name, match_id FROM TEAM_PLAYED_MATCH WHERE match_id = " + match_id +" "+
		    	 "MINUS "+
		    	 "SELECT home_team_name AS team_name, match_id FROM MATCH WHERE match_id = "+ match_id +" ) "+
				 "SELECT  a.team_name, tm.score "+
				 "FROM AWAY_TEAM a, TEAM_PLAYED_MATCH tm "+
			     "WHERE tm.match_id = " + match_id + " "+
		         "AND a.team_name = tm.team_name ";
	rs = stmt.executeQuery(sql);
	if( rs.next()){
		away_team = rs.getString(1);
		away_score = rs.getInt(2);
	}
	
	
%>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Name Title</title>

    <link rel = "stylesheet" href = "evaluation.css">
</head>
<body>

    <!-- header -->
    <div class="modal-wrapper">
        <div class="modal-header">
            <div class="modal-date">
                <p><b><%=month %>월 <%=date %>일</b></p>
            </div>
        
            <div class="modal-match">
                <div class="modal-hometeam" >
                    <p><b><%=home_team %></b></p>
                    <img src ="pics/<%= home_team%>.svg" style = "width:6rem; height:6rem; float:right;">
                </div>	
                <div class="modal-score">
                    <p><b><%=home_score %>-<%=away_score %></b></p>
                </div>
                <div class="modal-awayteam" >
                    <img src ="pics/<%= away_team %>.svg" style = "width:6rem; height:6rem; float:left;">
                    <p><b><%=away_team %></b></p>
                </div>
            </div>

        </div>
        <div style="clear:both;"></div>
        <!--  -->


        <div class="modal-evaluations">
        	<% sql = "SELECT u.name, e.rating, e.review, e.evaluation_id "+
        			 "FROM USER_INFO u, EVALUATION e " +
        			 "WHERE u.user_id = e.user_id " +
        			    "AND e.match_id = "+ match_id +" "+
        			 "ORDER BY e.evaluation_id DESC"; 
        			 
      	       rs = stmt.executeQuery(sql);
      	       if(rs.next()){
      	    		session.setAttribute("eID", rs.getInt(4));

      	     %>
      	    <div class="modal-single-evaluation">
                <div class="modal-usernrate">
                    <p class="modal-username"><b><%=rs.getString(1) %></b></p>
                    <% 
                    int thres = rs.getInt(2);
                    for(int i = 0; i < thres; i++){
					%>
					<img src="pics/ShineStar.svg">
					<%
					}
                    for(int i = 0; i < (5-thres); i++){
	                %>
	                <img src="pics/BlankStar.svg">
	                <%
	                }
					%>
				</div>
                <div class="modal-comments">
                    <p><%=rs.getString(3) %></p>
                </div>
            </div>
            <div style="clear:both;"></div>
      	    <%	
      	    }
      	    else{
      	   	%>
      	   	<div class="modal-single-evaluation">
                <div class="modal-usernrate">
                    <p class="modal-username"></p>
                </div>
                <div class="modal-comments">
                    <p>평가가 없습니다. 처음으로 남겨보세요 !</p>
                </div>
            </div>
            <div style="clear:both;"></div>
      	   	
      	   	<%
      	    }
        	while(rs.next()){
         	%>
           	    <div class="modal-single-evaluation">
                     <div class="modal-usernrate">
                         <p class="modal-username"><b><%=rs.getString(1) %></b></p>
		                    <% 
		                    int thres = rs.getInt(2);
		                    for(int i = 0; i < thres; i++){
							%>
							<img src="pics/ShineStar.svg">
							<%
							}
		                    for(int i = 0; i < (5-thres); i++){
			                %>
			                <img src="pics/BlankStar.svg">
			                <%
			                }
							%>
     				</div>
                     <div class="modal-comments">
                         <p><%=rs.getString(3) %></p>
                     </div>
                 </div>
                 <div style="clear:both;"></div>
           	    <%	

        	}
        	%>
        
        
        </div>

        <div class="modal-footer">
            <form action = "evaluation-add.jsp" method="POST">
                <div class="rating" style="display:inline;">
                    <img src="pics/BlankStar.svg" class="star" onclick="toggleStar(0)">
                    <img src="pics/BlankStar.svg" class="star" onclick="toggleStar(1)">
                    <img src="pics/BlankStar.svg" class="star" onclick="toggleStar(2)">
                    <img src="pics/BlankStar.svg" class="star" onclick="toggleStar(3)">
                    <img src="pics/BlankStar.svg" class="star" onclick="toggleStar(4)">
                </div>
                <input id = "rate" name = "rate" type = "text" style ="display:none">
                <input class = "modal-textinput" type = "text" name ="comment" placeholder= "평가를 남겨주세요." required>
                <button class = "modal-submit" type = "submit" ><svg xmlns="http://www.w3.org/2000/svg" width="65" height="65" viewBox="0 0 65 65" fill="none">
                    <rect width="65" height="65" rx="15" fill="#37003C"/>
                    <path d="M45.4802 19.716L46.2755 20.5028C47.3715 21.5882 47.2057 23.5125 45.9021 24.8007L29.5003 41.0257L24.1862 42.9486C23.519 43.1913 22.8692 42.8766 22.7371 42.2485C22.6924 42.0207 22.7135 41.785 22.7977 41.5684L24.7794 36.2663L41.1354 20.0854C42.439 18.7972 44.3842 18.6305 45.4802 19.716ZM28.7845 21.3295C28.9615 21.3295 29.1368 21.364 29.3004 21.4311C29.4639 21.4981 29.6125 21.5963 29.7377 21.7201C29.8629 21.844 29.9622 21.991 30.0299 22.1528C30.0977 22.3145 30.1325 22.4879 30.1325 22.6631C30.1325 22.8382 30.0977 23.0116 30.0299 23.1734C29.9622 23.3352 29.8629 23.4822 29.7377 23.606C29.6125 23.7298 29.4639 23.8281 29.3004 23.8951C29.1368 23.9621 28.9615 23.9966 28.7845 23.9966H23.3922C22.6772 23.9966 21.9914 24.2776 21.4858 24.7777C20.9802 25.2779 20.6961 25.9563 20.6961 26.6636V42.6659C20.6961 43.3733 20.9802 44.0516 21.4858 44.5518C21.9914 45.052 22.6772 45.333 23.3922 45.333H39.5689C40.284 45.333 40.9698 45.052 41.4754 44.5518C41.981 44.0516 42.2651 43.3733 42.2651 42.6659V37.3318C42.2651 36.9781 42.4071 36.639 42.6599 36.3889C42.9127 36.1388 43.2556 35.9983 43.6131 35.9983C43.9706 35.9983 44.3135 36.1388 44.5663 36.3889C44.8192 36.639 44.9612 36.9781 44.9612 37.3318V42.6659C44.9612 44.0806 44.3931 45.4373 43.3818 46.4377C42.3706 47.438 40.9991 48 39.5689 48H23.3922C21.9621 48 20.5906 47.438 19.5793 46.4377C18.5681 45.4373 18 44.0806 18 42.6659V26.6636C18 25.2489 18.5681 23.8922 19.5793 22.8919C20.5906 21.8915 21.9621 21.3295 23.3922 21.3295H28.7845Z" fill="white"/>
                    </svg>
                </button>
            </form>
        </div>
    </div>
    <script>
        var stars = Array.from(document.getElementsByClassName('star'));
		var s_num = 0;
        document.getElementById('rate').value = s_num;

        function toggleStar(index) {
            var currentStar = stars[index];
            if (currentStar.src.includes('pics/ShineStar.svg')) {
                if ( index == 0 ){
                	s_num = 0;
                    for (var i = index; i< stars.length; i++) {
                        stars[i].src = 'pics/BlankStar.svg';
                    }
                }else{
                	s_num = index;
                    for (var i = index+1; i< stars.length; i++) {
                        stars[i].src = 'pics/BlankStar.svg';
                    }
                }
            } else {
            	s_num = index+1;
                for (var i = 0; i <= index; i++) {
                    stars[i].src = 'pics/ShineStar.svg';
                }
            }
            document.getElementById('rate').value = s_num;
        }
        
        function submitFunc(){
        	var url = 'evaluation-add.jsp';
        	var comment = document.getElementById('comment').value;
        	var data = {s_num : s_num, comment : comment};
			alert(comment);
        }
    </script>
    
<%

	if(conn != null ) conn.close();
	if(rs != null) rs.close();
	if(stmt != null ) stmt.close();
%>
    
</body>
</html>
