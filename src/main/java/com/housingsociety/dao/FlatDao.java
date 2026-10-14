package com.housingsociety.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;

import com.housingsociety.model.Flat;
import com.housingsociety.model.Owner;
import com.housingsociety.model.Resident;
import com.housingsociety.utils.FlatUtil;

public class FlatDao {
  // get all flat data
	public static ArrayList<Flat> getFlatData() {
		Connection connection = FlatUtil.getConnection();
		PreparedStatement ps = null;
		ArrayList<Flat> list = new ArrayList<Flat>();

		try {
			ps = connection.prepareStatement("SELECT * FROM flat");

			ResultSet rs = ps.executeQuery();
			while (rs.next()) {

				Flat flat = new Flat(rs.getString("flat_number"), rs.getString("flat_type"), rs.getString("owner_name"),
						rs.getInt("linked_resident_id"), rs.getString("status"), rs.getInt("floor"));
				list.add(flat);

			}
		} catch (SQLException e) {

			e.printStackTrace();
		}
		return list;
	}
	
// Get flat by resident ID
	
	public static Flat getFlatByResidentID(int id) {
		Flat flat = null;
		try {
			Connection connection = FlatUtil.getConnection();
			String sql = "select * from flat where linked_resident_id=?";
			PreparedStatement ps = connection.prepareStatement(sql);
			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				flat = new Flat(rs.getString("flat_number"), rs.getString("flat_type"), rs.getString("owner_name"), id,
						rs.getString("status"), rs.getInt("floor"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return flat;
	}

//	Get Owner By Id
	
	public static Owner getOwnerByID(int id) {
		Owner owner = null;
		try {

			Flat flat = FlatDao.getFlatByResidentID(id);
			Connection connection = FlatUtil.getConnection();
			String sql = "select * from residents where resident_id=?";
			PreparedStatement ps = connection.prepareStatement(sql);
			ps.setInt(1, id);
			ResultSet s = ps.executeQuery();

			if (s.next()) {
				LocalDate moveInDate = null;
				LocalDate moveOutDate = null;
				if (s.getString("move_in_date") != null) {
					try {
						moveInDate = LocalDate.parse(s.getString("move_in_date"));
					} catch (Exception e) {

					}
				}

				if (s.getString("move_out_date") != null) {
					try {
						moveOutDate = LocalDate.parse(s.getString("move_out_date"));
					} catch (Exception e) {

					}
				}
				owner = new Owner(s.getInt("resident_id"), s.getString("first_name"), s.getString("last_name"),
						s.getInt("age"), s.getString("gender"), s.getString("blood_group"), s.getString("email"),
						s.getString("aadhaar_number"),

						s.getString("occupation"), s.getString("mobile_number"),

						flat.getFlatNumber(), moveInDate, moveOutDate, s.getString("emergency_contact"),
						s.getString("status"));

			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return owner;
	}
	
	
	
/// Update Owner 
	
	public static int updateOwner(Resident resident) {
		Connection connection = FlatUtil.getConnection();
		String moveOutDate = null;
		String moveInDate = null;
		if(resident.getMoveOutDate()!= null) {
			moveOutDate = resident.getMoveOutDate().toString();
		}
		if(resident.getMoveInDate() != null) {
			moveInDate = resident.getMoveInDate().toString();
		}
		 int result = 0;
		String flatSQL = "update flat set owner_name = ? where linked_resident_id = ?";
		
		String sql = "update residents set first_name = ?, last_name = ?, age = ?,gender = ?,blood_group  = ?, email = ?,"
				+ "aadhaar_number = ?,occupation  = ?,mobile_number = ?,move_in_date = ?, move_out_date = ?, emergency_contact = ?, status = ? where resident_id = ?";
		try {
			PreparedStatement ps = connection.prepareStatement(sql);
			
			 
			ps.setString(1, resident.getFirstName());
			ps.setString(2, resident.getLastName());
			ps.setInt(3, resident.getAge());
			ps.setString(4,resident.getGender());
			ps.setString(5, resident.getBloodGroup());
			ps.setString(6, resident.getEmail());
			ps.setString(7, resident.getOccupation());
			ps.setString(8, resident.getMobileNumber());
			ps.setString(9, resident.getMobileNumber());
			ps.setString(10,moveInDate);
			ps.setString(11,moveOutDate );
			ps.setString(12, resident.getEmergencyContact());
			ps.setString(13,resident.getStatus());
			ps.setInt(14, resident.getResidentId());
			
			result = ps.executeUpdate();
			
			PreparedStatement prs = connection.prepareStatement(flatSQL);
			
			prs.setString(1, resident.getFirstName()+" "+resident.getLastName());
			prs.setInt(2, resident.getResidentId());
			
			result += prs.executeUpdate();
			
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	public static int updateFlatStatus(int id) {
		int result = 0;
		try {
			Connection connection = FlatUtil.getConnection();
			 
			String sql2 = " update flat set status=?, owner_name = ? where linked_resident_id = ?";
			 
			PreparedStatement ps1 = connection.prepareStatement(sql2);
			
			ps1.setString(1, "Vacant");
			ps1.setString(2,null);
			ps1.setInt(3, id);
			result = ps1.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	public static int deletOwner(int id) {
		int result =0;
		try {
			FlatDao.updateFlatStatus(id);
			Connection connection = FlatUtil.getConnection();
			String sql = "delete from residents where resident_id = ? ";
			 
			PreparedStatement ps = connection.prepareStatement(sql);
		 
			ps.setInt(1, id);
		 
			result = ps.executeUpdate();
		 
		}catch(Exception e) {
			
		}
		return result;
	}
	
	public static void main(String[] arg) {
		Resident rs = FlatDao.getOwnerByID(113);
		rs.setFirstName("nothing");
		 
		
		
		System.out.println(FlatDao.updateOwner(rs));

	}
}


















