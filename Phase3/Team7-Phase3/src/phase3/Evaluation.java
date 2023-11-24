package phase3;


import java.sql.*;
import java.util.Scanner;


public class Evaluation {
	public static void evaluationMenu(Connection conn, Statement stmt) throws SQLException{
		Scanner sc = new Scanner(System.in);
		int ch;
		
		while(true) {
			while(true) {
				System.out.println("\n=======================================================");
				System.out.println("This is a page about evaluations.");
				System.out.println("You can see other user's evaluations or Write down your own evaluations.");
				System.out.println("=======================================================");
				System.out.println("1.Search Evaluations 2.Add Evaluations  3.Go back to upper page");
				System.out.print(": ");
				try{
					ch = sc.nextInt();
					break;
				}catch(java.util.InputMismatchException e) {
					System.out.println("You should give proper input");
					sc.nextLine();
				}		
					
			}
			switch(ch) {
			case 1:
				searchEvaluation(conn,stmt);
				break;
			case 2:
				addEvaluation(conn,stmt,sc);
				break;
			case 3:
				return;
			default:
				System.exit(0);
			}

		}
		
		

	}
	
	public static void searchEvaluation(Connection conn, Statement stmt) throws SQLException {
		Scanner sc = new Scanner(System.in);
		int ch;
		ResultSet rs = null;
		String team;
		int cnt;
		String sql;
		ResultSetMetaData rsmd;

		while(true) {
			System.out.println("\n=======================================================");
			System.out.println("You can search evaluations in this page.");
			System.out.println("1. You can see certain team's follower's evaluations");
			System.out.println("2. You can see evaluations after certain team's match");
			System.out.println("3. Search Evaluation via Match_id");
			System.out.println("4. Go back to upper page");
			System.out.println("=======================================================");
			System.out.print(": ");
			try{
				ch = sc.nextInt();
				break;
			}catch(java.util.InputMismatchException e) {
				System.out.println("You should give proper input");
				sc.nextLine();
			}			
		}
		sc.nextLine();
		
		switch(ch) {
		case 1:
			
			System.out.print("Type a team's FULL name : ");
			team = sc.nextLine();
			
			/////////////////////////////////////////////////////////////////////
			////////////////////////TYPE 2 - 2////////////////////////////////
			//////////////////////////////////////////////////////////////////////
			sql = "SELECT ui.user_id, e.match_id, e.rating, e.review\r\n"
					+ "FROM USER_INFO ui, EVALUATION e, USER_FOLLOW_TEAM uf\r\n"
					+ "WHERE ui.user_id = e.user_id\r\n"
					+ "    AND ui.user_id = uf.user_id\r\n"
					+ "    AND LOWER(uf.TEAM_NAME) = LOWER('" + team +"')";
			
			rs = stmt.executeQuery(sql);
			if ( rs.next()) {
				System.out.println("\n=======================================================");
				rsmd = rs.getMetaData();
				cnt = rsmd.getColumnCount();
				System.out.print("    ");
				for(int i =1;i<=cnt;i++){
					System.out.printf("%10s",rsmd.getColumnName(i));
				}
				System.out.println();
				System.out.printf("%2d %10d %10d %10d %10s\n",1,rs.getInt(1),rs.getInt(2),rs.getInt(3),rs.getString(4));
				for (int i = 2; rs.next(); i++) {
					System.out.printf("%2d %10d %10d %10d %10s\n",i,rs.getInt(1),rs.getInt(2),rs.getInt(3),rs.getString(4));
				}
				if ( rs != null ) rs.close();


			}
			else {
				System.out.println("There is no result");
			}
			System.out.println("=======================================================");
			break;
		case 2:
			System.out.print("Type a team's FULL name : ");
			team = sc.nextLine();
			
			/////////////////////////////////////////////////////////////////////
			////////////////////////TYPE 8 - 2////////////////////////////////
			//////////////////////////////////////////////////////////////////////
			sql = "SELECT ev.match_id,ev.rating, ev.review\r\n"
					+ "FROM evaluation ev, match ch, team_played_match tpm\r\n"
					+ "WHERE tpm.match_id = ch.match_id\r\n"
					+ "AND ch.match_id = ev.match_id\r\n"
					+ "AND LOWER(tpm.team_name) =LOWER('"+ team +"')\r\n"
					+ "ORDER BY ev.rating DESC";
			
			rs = stmt.executeQuery(sql);
			if( rs.next()) {
				System.out.println("\n=======================================================");
				rsmd = rs.getMetaData();
				cnt = rsmd.getColumnCount();
				System.out.print("    ");
				for(int i =1;i<=cnt;i++){
					System.out.printf("%10s",rsmd.getColumnName(i));
				}
				System.out.println();
				System.out.printf("%2d %10d %10d %10s\n",1,rs.getInt(1),rs.getInt(2),rs.getString(3));
				for (int i = 2; rs.next(); i++) {
					System.out.printf("%2d %10d %10d %10s\n",i,rs.getInt(1),rs.getInt(2),rs.getString(3));
				}
				if ( rs != null ) rs.close();
			}
			else {
				System.out.println("There is no result");
			}
			System.out.println("=======================================================");
			break;
		case 3:
			int mid = 0;
			while(true) {
				System.out.println("What is match_id you want to add evaluation ?");
				System.out.print("(eg. 93400, 93374): ");
				try{
					mid = sc.nextInt();
					break;
				}catch(java.util.InputMismatchException e) {
					System.out.println("You should give proper input");
					sc.nextLine();
				}			
			}
			
			sql = "SELECT e.evaluation_id, ui.name AS user_name, m.match_date, m.home_team_name, e.rating, e.review "+
				  "FROM EVALUATION e, USER_INFO ui, MATCH m "+
				  "WHERE e.match_id = m.match_id " +
				  " AND ui.user_id = e.user_id " +
				  " AND e.match_id = "+ mid;
			
			rs = stmt.executeQuery(sql);
			if( rs.next()) {
				System.out.println("\n=======================================================");
				rsmd = rs.getMetaData();
				cnt = rsmd.getColumnCount();
				System.out.print("    ");
				for(int i =1;i<=cnt;i++){
					System.out.printf("%15s",rsmd.getColumnName(i));
				}
				System.out.println();
				System.out.printf("%2d %10d %15s %15s %15s %10d %10s\n",1,rs.getInt(1),rs.getString(2),rs.getDate(3), rs.getString(4), rs.getInt(5), rs.getString(6));
				for (int i = 2; rs.next(); i++) {
					System.out.printf("%2d %10d %15s %15s %15s %10d %10s\n",i,rs.getInt(1),rs.getString(2),rs.getDate(3), rs.getString(4), rs.getInt(5), rs.getString(6));
				}
				if ( rs != null ) rs.close();
			}
			else {
				System.out.println("There is no result");
			}
			System.out.println("=======================================================");
			if ( rs != null ) rs.close();
			break;
		case 4:
			if ( rs != null ) rs.close();
			return;
		default:
			System.exit(0);
		}
		

	}
	
	public static void addEvaluation(Connection conn, Statement stmt, Scanner sc) throws SQLException{
		int mid;
		int ch;
		int rate;
		ResultSet rs =null;
		while(true) {
			System.out.println("What is match_id you want to add evaluation ?");
			System.out.print("(eg. 93418, 93388): ");
			try{
				mid = sc.nextInt();
				break;
			}catch(java.util.InputMismatchException e) {
				System.out.println("You should give proper input");
				sc.nextLine();
			}			
		}
		
		
		/////////////////////////////////////////////////////////////////////
		////////////////////////TYPE 7 - 2////////////////////////////////
		//////////////////////////////////////////////////////////////////////
		
		String sql = "WITH AWAY_TEAM "+
				"AS( SELECT team_name, match_id FROM TEAM_PLAYED_MATCH WHERE match_id = " + mid +
		        " MINUS " +
		        "SELECT home_team_name AS team_name, match_id FROM MATCH WHERE match_id = "+ mid +") "+
				"SELECT m.season_name, m.match_date, m.home_team_name, a.team_name "+
				"FROM MATCH m, AWAY_TEAM a "+
				"WHERE m.match_id = " + mid +
				"AND m.match_id = a.match_id";
		    
		rs = stmt.executeQuery(sql);
		if ( rs.next() ) {
			
			while(true) {
				System.out.println("You meant this match?");
				System.out.println(rs.getString(1) + " Season " + rs.getDate(2) + " home team : " + rs.getString(3) + " away team : " + rs.getString(4));
				System.out.println("=======================================================");
				System.out.print("1.Yes 2.No : ");
				try{
					ch = sc.nextInt();
					break;
				}catch(java.util.InputMismatchException e) {
					System.out.println("You should give proper input");
					sc.nextLine();
				}
			}
			switch(ch) {
			case 1:
				while(true) {
					System.out.print("Rate this match (0-5): ");
					try{
						rate = sc.nextInt();
						break;
					}catch(java.util.InputMismatchException e) {
						System.out.println("You should give proper input");
						sc.nextLine();
					}
				}
				sc.nextLine();
				System.out.println("Leave your comment. Please give ONE line( ~ 1000BYTE)");
				System.out.print(": ");
				String comment =sc.nextLine();
				
				int eid;
				sql = "SELECT evaluation_id FROM EVALUATION WHERE match_id = " + mid + " ORDER BY evaluation_id DESC";
				rs = stmt.executeQuery(sql);
				if( rs.next() ) {
					eid = rs.getInt(1) + 1;
				}
				else {
					eid = 1;
				}
				sql = "INSERT INTO EVALUATION VALUES ( " + eid + ", "+ mid+", "+User.user_id+", "+ rate+ ", '" + comment +"' )";
				int result = stmt.executeUpdate(sql);
				if ( result == 1 ) {
					System.out.println("Successfully Inserted Evaluation");
					conn.commit();
				}
				else {
					System.out.println("Something went wrong inserting evaluation");
				}
				rs.close();
				return;
				
			case 2:
			default:
			return;		
			}
		}
		else {
			System.out.println("It is not proper MATCH_ID");
		}
		if(rs != null ) rs.close();

	}
	
}


