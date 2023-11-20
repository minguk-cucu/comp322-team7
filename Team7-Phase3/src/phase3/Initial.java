package phase3;

import java.sql.*;
import java.util.Scanner;

public class Initial {
	public static void initialInterface(Connection conn, Statement stmt) throws SQLException{
		Scanner sc = new Scanner(System.in);
		int ch;
		
		while(true) {

			while(true) {
				System.out.println("\n=======================================================");
				System.out.println("Hi ! Welcome to Our System.");
				System.out.println("=======================================================");
				System.out.println("1.Log in 2.Register 3.Exit");
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
				loginProcess(conn,stmt);
				break;
			case 2:
				registerProcess(conn,stmt);
				break;
			case 3:
				System.out.println("Bye ! Hope you see later.");
				System.exit(0);
			default:
				System.exit(0);
			}

		}
	}
	
	public static void registerProcess(Connection conn, Statement stmt) throws SQLException{
		Scanner sc = new Scanner(System.in);
		String username;
		String password;
		String sql;
		ResultSet rs;
		int id;
		int ch;
		String[] teams = {"Arsenal", "Aston Villa", "AFC Bournemouth", "Brentford", "Brighton & Hove Albion",
		                  "Burnley", "Chelsea", "Crystal Palace", "Everton", "Fulham", "Liverpool", "Luton Town",
		                  "Manchester City", "Manchester United", "Newcastle United", "Nottingham Forest",
		                  "Sheffield United", "Tottenham Hotspur", "West Ham United", "Wolverhampton Wanderers"};
		
		
		
		
		System.out.print("Username : ");
		username = sc.nextLine();
		System.out.print("Password  : ");
		password = sc.nextLine();
		
		int i = 0;
		while(true) {
			System.out.println("\n=======================================================");
			System.out.println("Lastly, Which team do you support/follow in 22/23 EPL ?");
			System.out.println("=======================================================");
			System.out.print("0.Nothing(Seriously)");
			System.out.print(" 1."+teams[i]);
			System.out.print(" 2."+teams[i+1]);
			System.out.print(" 3."+teams[i+2]);
			System.out.print(" 4."+teams[i+3]);
			System.out.print(" 5."+teams[i+4]);
			System.out.println(" 6.Next Page");
			System.out.print(": ");
			try{
				ch = sc.nextInt();
				if( ch == 6 ) {
					i = ( i + 5 ) % 20;
					continue;
				}
				ch = ch + i - 1;
				break;
			}catch(java.util.InputMismatchException e) {
				System.out.println("You should give proper input");
				sc.nextLine();
			}			
		}
		
		sql = "SELECT user_id FROM USER_INFO WHERE name = '" + username + "' ";
		rs = stmt.executeQuery(sql);
		if(rs.next()) {
			System.out.println("There is same name in using . .");
			return;
		}

		
		sql = "SELECT user_id FROM USER_INFO ORDER BY user_id DESC";
		rs = stmt.executeQuery(sql);
		if( rs.next() ) {
			id = rs.getInt(1) + 1;
		}
		else {
			id = 1;
		}
		sql = "INSERT INTO USER_INFO VALUES( " + id + ", '" + username + "', '" + password + "' )"; 
		if ( stmt.executeUpdate(sql) == 1 ) {
			sql = "INSERT INTO USER_FOLLOW_TEAM VALUES( " + id + ", '" + teams[ch] +"' )";
			if( stmt.executeUpdate(sql) == 1 ) {
				System.out.println("Thank you ! Register Successfully done ! You can login immediately");
			
			}
			else {
				System.out.println("Something went wrong while registering. please try again.");
			}
		}
		else {
			System.out.println("Something went wrong while registering. please try again.");
		}
		
		conn.commit();

		rs.close();
		return;
		
	}
	
	public static void loginProcess(Connection conn, Statement stmt) throws SQLException {
		Scanner sc = new Scanner(System.in);
		String username;
		String password;
		String sql;
		ResultSet rs;
		
		
		System.out.print("Username : ");
		username = sc.nextLine();
		System.out.print("Password  : ");
		//echo ²ø±î .. ?
		password = sc.nextLine();
		
		sql = "SELECT user_id FROM USER_INFO WHERE name = '" + username + "' AND password = '" + password + "'";
		rs = stmt.executeQuery(sql);
		
		
		if(rs.next()) {
			User.user_id = rs.getInt(1);
			System.out.println("\n=======================================================");
			System.out.println("You ARE our member. Welcome back !");
			System.out.println("=======================================================");
			rs.close();
			T7P3.menuList(conn, stmt);
		}
		else {
			System.out.println("\n=======================================================");
			System.out.println("You are NOT our member. Try again or Register first");
			System.out.println("=======================================================");
			rs.close();
			return;
		}


	}

}
