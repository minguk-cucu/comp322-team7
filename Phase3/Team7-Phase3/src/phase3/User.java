package phase3;

import java.sql.*;
import java.util.Scanner;


public class User {
	static int user_id = -1;
	
	public static void userInfo(Connection conn, Statement stmt) throws SQLException {
		if( user_id == -1 ) {
			System.err.println("illegal user");
			System.exit(-1);
		}
		ResultSet rs = null;
		Scanner sc = new Scanner(System.in);
		int ch;
		String sql = "SELECT u.name, t.team_name FROM USER_INFO u, USER_FOLLOW_TEAM t "
				+ "WHERE u.user_id = t.user_id "
				+ "AND u.user_id = " + user_id;

		rs = stmt.executeQuery(sql);
		if(rs.next()) {
			String user = rs.getString(1);
			while(true) {
				System.out.println("\n=======================================================");
				System.out.println("This is your user page.");
				System.out.print("Your name is : " + user);
				System.out.println(" , and You're following : " + rs.getString(2));
				System.out.println("=======================================================");
				System.out.println("1.Delete your account 2. Go back");
				System.out.print(": ");
				try{
					ch = sc.nextInt();
					break;
				}catch(java.util.InputMismatchException e) {
					System.out.println("You should give proper input");
					sc.nextLine();
				}			
			}
			
			switch(ch){
			case 1:
				deleteUserInfo(conn,stmt,user);
			default:
				break;
			}
		}
		else {
			System.err.println("We cannot find user having your id. Who are you .. ?");
			System.exit(-1);
		}
		
		
		rs.close();

	}
	
	public static void deleteUserInfo(Connection conn, Statement stmt, String user) throws SQLException{
		Scanner sc = new Scanner(System.in);
		int ch;
		
		while(true) {
			System.out.println("\n=======================================================");
			System.out.println("Are You SURE to delete this account ? : "+ user);
			System.out.println("=======================================================");
			System.out.println("1. Yes 2. No ");
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
			String sql = "DELETE FROM USER_INFO " +
						 "WHERE user_id = " + user_id;
			int result = stmt.executeUpdate(sql);
			if(result == 1 ) {
				System.out.println("Deletion complete .");
				conn.commit();
				System.exit(0);
			}
			else {
				System.err.println("Something went wrong deleting your account from DB");
				System.exit(-1);
			}
			return;
		case 2:
			return;
		default:
			return;
		}
		
		
		
	}
}
