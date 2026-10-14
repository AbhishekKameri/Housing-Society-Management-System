package com.housingsociety.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.util.ArrayList;
import java.util.List;
import com.housingsociety.model.Flat;

public class FlatUtil {
	private static List<Flat> flatData = new ArrayList<>();
	static {
		// ==================== A Wing ====================
		flatData.add(new Flat("A101", "2 BHK", "Rahul Sharma", "Owner", 4, 5, 101, "Occupied"));
		flatData.add(new Flat("A102", "1 BHK", "Priya Patil", "Tenant", 2, 3, 102, "Occupied"));
		flatData.add(new Flat("A103", "3 BHK", "", "", 0, 7, 0, "Vacant"));
		// ==================== B Wing ====================
		flatData.add(new Flat("B201", "2 BHK", "Sneha Kulkarni", "Owner", 5, 5, 103, "Occupied"));
		flatData.add(new Flat("B202", "1 BHK", "", "", 0, 3, 0, "Vacant"));
		flatData.add(new Flat("B203", "3 BHK", "", "", 0, 7, 0, "Vacant"));
		// ==================== C Wing ====================
		flatData.add(new Flat("C301", "2 BHK", "Ajay Deshmukh", "Tenant", 4, 5, 104, "Occupied"));
		flatData.add(new Flat("C302", "1 BHK", "", "", 0, 3, 0, "Vacant"));
		flatData.add(new Flat("C303", "3 BHK", "", "", 0, 7, 0, "Vacant"));
	}
	public static List<Flat> getFlatData() {
		return flatData;
	}
	
	public static Connection getConnection() {
		Connection conn = null;
		try {

	        Class.forName("com.mysql.cj.jdbc.Driver");

			conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/housing_society","root","root");
			 
		}
		catch (Exception e) {
			 e.printStackTrace();
		}
		return conn;
	}
	
	public static void main(String[] arg) {
		System.out.println(FlatUtil.getConnection());
	}
}


