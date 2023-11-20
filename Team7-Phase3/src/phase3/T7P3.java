package phase3;

import java.sql.*;
import java.util.Scanner;

public class T7P3 {	
	public static void main(String[] args) {
		/////CUSTOMIZE THIS
		String serverIP = "localhost";
		String strSID = "orcl";
		String portNum = "1521";
		String user = "minguk";
		String pass = "0118";
		String url = "jdbc:oracle:thin:@"+serverIP+":"+portNum+":"+strSID;
		/////
		Connection conn = null;
		ResultSet rs = null;
		Statement stmt = null;
		PreparedStatement pstmt = null;
		
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DriverManager.getConnection(url,user,pass);
			stmt = conn.createStatement();
			
			conn.setAutoCommit(false);
			
			Initial.initialInterface(conn, stmt);
			
			if( stmt != null ) stmt.close();
			if( conn != null ) conn.close();
			if( rs != null ) rs.close();
//			if( pstmt != null ) pstmt.close();
	
		}catch (ClassNotFoundException e){
			e.printStackTrace();
			System.err.println("Cannot Load OracleDriver");
			System.exit(-1);
		}catch ( SQLException ex ) {
			ex.printStackTrace();
			System.err.println("SQL Error");
			System.exit(-1);
		}
	
	}
	
	public static void menuList(Connection conn, Statement stmt) throws SQLException{
		Scanner sc = new Scanner(System.in);
		int ch;
		
		while(true) {

			while(true) {
				System.out.println("\n=======================================================");
				System.out.println("Which feature do you want to Use ?");
				System.out.println("=======================================================");
				System.out.println("0. About User 1. Evaluation 2. Match 3. Players & Teams 4. Quit");
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
			case 0:
				User.userInfo(conn, stmt);
				break;
			case 1:
				Evaluation.evaluationMenu(conn, stmt);
				break;
			case 3:
				PlayerAndTeam.initialInterface(conn, stmt);
				break;
			case 4:
				return;
			default:
				return;
			}
	
		}

	}
	

}
