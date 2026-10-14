
package com.housingsociety.utils;

 
import java.sql.DriverManager;

public class DBConnection {
	public static java.sql.Connection getConnection() {
		java.sql.Connection conn = null;
		try {

	        Class.forName("com.mysql.cj.jdbc.Driver");

			conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/housing_society","root","root");
			 
		}
		catch (Exception e) {
			 e.printStackTrace();
		}
		return conn;
	}
}
