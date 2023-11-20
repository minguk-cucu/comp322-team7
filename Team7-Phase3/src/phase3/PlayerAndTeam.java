package phase3;

import java.sql.*;
import java.util.Scanner;

public class PlayerAndTeam {
	public static void initialInterface(Connection conn, Statement stmt) throws SQLException {
		Scanner sc = new Scanner(System.in);
		int ch;
		
		while(true) {
			while(true) {
				System.out.println("\n=======================================================");
				System.out.println(" This is a page about players & teams.");
				System.out.println(" You can see or search for players and teams.");
				System.out.println("=======================================================");
				System.out.println("1.See players    2.See teams    3.Go back to upper page");
				System.out.print(": ");
				try {
					ch = sc.nextInt();
					break;
				}
				catch(java.util.InputMismatchException e) {
					System.out.println("You should give proper input");
					sc.nextLine();
				}			
				
			}
			
			switch(ch) {
			case 1:
				seePlayer(conn, stmt ,sc);
				break;
			case 2:
				seeTeam(conn, stmt, sc);
				break;
			case 3:
				return;
			default:
				System.exit(0);
			}
		}
	}
	
	public static void seePlayer(Connection conn, Statement stmt, Scanner sc) throws SQLException {
		int ch, cnt;
		String sql, player;
		ResultSet rs = null;
		ResultSetMetaData rsmd;
		
		//////////////////////////////////////////////////////////////////
		////////////////////////    TYPE 9 - 2    ////////////////////////
		//////////////////////////////////////////////////////////////////
		sql = "SELECT P.Name, COUNT(*) AS APPEARANCES FROM Player P, Player_played_match PPM, Match M\r\n"
				+ "WHERE P.player_id = PPM.Player_id AND PPM.Match_id = M.Match_id\r\n"
				+ "GROUP BY P.Name\r\n"
				+ "ORDER BY APPEARANCES DESC";
		
		rs = stmt.executeQuery(sql);
		if (rs.next()) {
			rsmd = rs.getMetaData();
			cnt = rsmd.getColumnCount();
			System.out.printf("\n%25s%15s\n", rsmd.getColumnName(1), rsmd.getColumnName(2));
			for (int i = 0; i < 10; i++) {
				System.out.printf("%25s%15d\n", rs.getString(1), rs.getInt(2));
				rs.next();
			}
			System.out.printf("%25s%15s\n", "...", "...");
			if ( rs != null ) rs.close();
		}
		else {
			System.out.println("\nThere is no result");
		}
		
		while(true) {
			while(true) {
				System.out.println("\n=======================================================");
				System.out.println(" You can see players in this page.");
				System.out.println("=======================================================");
				System.out.println("1.Search player    2.Go back to upper page");
				System.out.print(": ");
				try {
					ch = sc.nextInt();
					break;
				}
				catch(java.util.InputMismatchException e) {
					System.out.println("You should give proper input");
					sc.nextLine();
				}			
			}
			switch(ch) {
			case 1:
				sc.nextLine();
				System.out.print("Type a player's FULL name : ");
				player = sc.nextLine();
	
				//////////////////////////////////////////////////////////////////
				////////////////////////    TYPE 2 - 1    ////////////////////////
				//////////////////////////////////////////////////////////////////
				sql = "SELECT t.team_name, t.manager, p.name, p.nationality, ps.appearances, ps.goals\r\n"
						+ "FROM PLAYER p, PLAYER_STAT ps, TEAM t\r\n"
						+ "WHERE p.name = '" + player + "'\r\n"
						+ "    AND p.player_id = ps.player_id\r\n"
						+ "    AND p.team_name = t.team_name";
				
				rs = stmt.executeQuery(sql);
				if ( rs.next()) {
					rsmd = rs.getMetaData();
					System.out.printf("\n%20s%20s%20s%15s%15s%10s\n", rsmd.getColumnName(1), rsmd.getColumnName(2), rsmd.getColumnName(3), rsmd.getColumnName(4), rsmd.getColumnName(5), rsmd.getColumnName(6));
					System.out.printf("%20s%20s%20s%15s%15d%10d\n", rs.getString(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getInt(5), rs.getInt(6));
					if ( rs != null ) rs.close();
				}
				else {
					System.out.println("\nThere is no result");
				}
				break;
			case 2:
				if ( rs != null ) rs.close();
				return;
			default:
				System.exit(0);
			}
		}
	}
	
	public static void seeTeam(Connection conn, Statement stmt, Scanner sc) throws SQLException {
		int ch, cnt;
		String sql, team;
		ResultSet rs = null;
		ResultSetMetaData rsmd;
		
		sql = "SELECT T.Team_name, TS.Wins FROM TEAM T, TEAM_STAT TS WHERE T.Team_name = TS.Team_name\r\n"
				+ "ORDER BY TS.Wins DESC";
		
		rs = stmt.executeQuery(sql);
		if (rs.next()) {
			rsmd = rs.getMetaData();
			cnt = rsmd.getColumnCount();
			System.out.printf("\n%25s%15s\n", rsmd.getColumnName(1), rsmd.getColumnName(2));
			for (int i = 0; i < 20; i++) {
				System.out.printf("%25s%15d\n", rs.getString(1), rs.getInt(2));
				rs.next();
			}
			if ( rs != null ) rs.close();
		}
		else {
			System.out.println("\nThere is no result");
		}
		
		while(true) {
			while(true) {
				System.out.println("\n=======================================================");
				System.out.println(" You can see teams in this page.");
				System.out.println("=======================================================");
				System.out.println("1.Search team    2.Go back to upper page");
				System.out.print(": ");
				try {
					ch = sc.nextInt();
					break;
				}
				catch(java.util.InputMismatchException e) {
					System.out.println("You should give proper input");
					sc.nextLine();
				}			
			}
			switch(ch) {
			case 1:
				sc.nextLine();
				System.out.print("Type a team's FULL name : ");
				team = sc.nextLine();
	
				//////////////////////////////////////////////////////////////////
				////////////////////////    TYPE 1 - 2    ////////////////////////
				//////////////////////////////////////////////////////////////////
				sql = "SELECT team_name, est_year, stadium, manager\r\n"
						+ "FROM TEAM\r\n"
						+ "WHERE team_name = '" + team +"'";
				
				rs = stmt.executeQuery(sql);
				if ( rs.next()) {
					rsmd = rs.getMetaData();
					System.out.printf("\n%25s%10s%35s%20s\n", rsmd.getColumnName(1), rsmd.getColumnName(2), rsmd.getColumnName(3), rsmd.getColumnName(4));
					System.out.printf("%25s%10s%35s%20s\n", rs.getString(1), rs.getInt(2), rs.getString(3), rs.getString(4));
					if ( rs != null ) rs.close();
				}
				else {
					System.out.println("\nThere is no result");
				}
				break;
			case 2:
				if ( rs != null ) rs.close();
				return;
			default:
				System.exit(0);
			}
		}
	}
}
