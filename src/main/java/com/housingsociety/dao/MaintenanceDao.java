package com.housingsociety.dao;

import com.housingsociety.model.Flat;
import com.housingsociety.model.MonthlyMaintenance;
import com.housingsociety.model.OccassionalMaintenance;
import com.housingsociety.model.Resident;
import com.housingsociety.service.MaintenanceService;
import com.housingsociety.service.MaintenanceService;
import com.housingsociety.utils.*;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MaintenanceDao {

	public MonthlyMaintenance getBillById(String billId) {
		String sql = "SELECT * FROM monthly_maintenance WHERE bill_id = ?";
		MonthlyMaintenance m = null;
		try {
			Connection conn = DBConnection.getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, billId);
			try (ResultSet rs = ps.executeQuery()) {
				m = rs.next() ? mapRow(rs) : null;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return m;
	}

//	Get Monthly Maintenance data
	public List<MonthlyMaintenance> getAllMonthlyData() {
		String sql = "SELECT * FROM monthly_maintenance ";
		List<MonthlyMaintenance> li = new ArrayList<>();
		try {
			Connection conn = DBConnection.getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);

			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				li.add(mapRow(rs));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return li;

	}

	
//	get monthly bill count 
	public int getPaidMonthlyBillCount() {

	    String sql = """
	            SELECT COUNT(*)
	            FROM monthly_maintenance
	            WHERE payment_status = 1
	            """;

	    try (Connection con = FlatUtil.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        if (rs.next()) {
	            return rs.getInt(1);
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return 0;
	}
	/**
	 * Looks up whether this resident already has a bill for the given month (avoids
	 * duplicates).
	 */
	public MonthlyMaintenance getBillByFlatAndMonth(String flatNumber, String monthYear) throws SQLException {
		String sql = "SELECT * FROM monthly_maintenance WHERE flat_number = ? AND generated_date = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, flatNumber);
			ps.setString(2, monthYear + "-" + "01");
			try (ResultSet rs = ps.executeQuery()) {
				return rs.next() ? mapRow(rs) : null;
			}
		}
	}

	//	get monthly bill pending count 
	public int getMonthlyBillPendingCount() {

	    String sql = """
	            SELECT COUNT(*)
	            FROM monthly_maintenance
	            WHERE payment_status = 0
	            """;

	    try (Connection con = FlatUtil.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        if (rs.next()) {
	            return rs.getInt(1);
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return 0;
	}
	 
//	Get Pending Occssional count
	public int getOccassionalBillPendingCount() {

	    String sql = """
	            SELECT COUNT(*)
	            FROM  occasional_maintenance
	            WHERE payment_status = 0
	            """;

	    try (Connection con = FlatUtil.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        if (rs.next()) {
	            return rs.getInt(1);
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return 0;
	}
	
//	Get paid Occssional count
	public int getPaidOccassionalBillCount() {

	    String sql = """
	            SELECT COUNT(*)
	            FROM  occasional_maintenance
	            WHERE payment_status = 1
	            """;

	    try (Connection con = FlatUtil.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        if (rs.next()) {
	            return rs.getInt(1);
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return 0;
	}
	/**
	 * Highest existing sequence number for a month, used to build the next bill_id
	 * (MB202505001, ...).
	 */
	public int getMaxSequenceForMonth(String monthYearCompact) {
		String sql = "SELECT MAX(CAST(RIGHT(bill_id, 3) AS UNSIGNED)) " + "FROM monthly_maintenance "
				+ "WHERE bill_id LIKE ?";
		int result = 0;
		try {
			Connection conn = DBConnection.getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, "MB" + monthYearCompact + "%");
			try (ResultSet rs = ps.executeQuery()) {
				result = rs.next() ? rs.getInt(1) : 0;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	public void insertBill(MonthlyMaintenance bill) throws SQLException {

		String sql = "INSERT INTO monthly_maintenance (\n" + "        	    resident_id,\n"
				+ "        	    flat_number,\n" + "        	    fine,\n" + "        	    net_amount,\n"
				+ "        	    payment_status,\n" + "        	    generated_date,\n" + "        	    due_date,\n"
				+ "        	    GST,\n" + "        	    GST_rate,\n" + "        	    due_days,\n"
				+ "        	    late_fee,\n" + "        	    maintenance_amount,\n"
				+ "        	    electricity_charges,\n" + "        	    water_charges,\n"
				+ "        	    parking_charges,\n" + "        	    other_charges,\n"
				+ "        	    security_charges,\n" + " 			bill_id" + "        	)\n"
				+ "        	VALUES (\n" + "        	    ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?\n"
				+ "        	)";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			bindBill(ps, bill);
			 
			ps.executeUpdate();

		}
	}

	public boolean updateMonthlyBill(MonthlyMaintenance bill) {
		boolean result = false;

		String sql = """
				UPDATE monthly_maintenance
				SET
				     resident_id = ?,
				     flat_number = ?,
				    fine = ?,
				    net_amount = ?,
				    payment_status = ?,
				    generated_date = ?,
				    due_date = ?,
				    GST = ?,
				    GST_rate = ?,
				    due_days = ?,
				    late_fee = ?,
				    maintenance_amount = ?,
				    electricity_charges = ?,
				    water_charges = ?,
				    parking_charges = ?,
				    other_charges = ?,
				    security_charges = ?
					 
				WHERE bill_id = ?
				""";
		try {
			Connection conn = DBConnection.getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);
			bindBill(ps, bill);
			 
			result = ps.executeUpdate() > 0;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/** Marks a bill as fully paid and updates the collected amount. */
	public boolean markAsPaid(String billId, double paidAmount) throws SQLException {
		String sql = "UPDATE monthly_maintenance  SET amount_paid = ?, payment_status = ? WHERE bill_id = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setDouble(1, paidAmount);
			ps.setInt(2, 1);
			ps.setString(3, billId);
			return ps.executeUpdate() > 0;
		}
	}

	public boolean markAsPaidInOccassional(String billId, double paidAmount) throws SQLException {
		String sql = "UPDATE occasional_maintenance  SET amount_paid = ?, payment_status = ? WHERE bill_id = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setDouble(1, paidAmount);
			ps.setInt(2, 1);
			ps.setString(3, billId);
			return ps.executeUpdate() > 0;
		}
	}

//    Update Due date
	public boolean updateDueDateLateFee(String billId, LocalDate dueDate, int dueDays, double lateFee, double netAmount)
			throws SQLException {
		String sql = "UPDATE monthly_maintenance  SET due_date = ?, due_days = ?,late_fee = ?,net_amount = ? WHERE bill_id = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setDate(1, Date.valueOf(dueDate));
			ps.setInt(2, dueDays);
			ps.setDouble(3, lateFee);
			ps.setDouble(4, netAmount);
			ps.setString(5, billId);
			return ps.executeUpdate() > 0;
		}
	}

	public boolean deleteBill(String billId) throws SQLException {
		
		
		String sql = "DELETE FROM monthly_maintenance  WHERE bill_id = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, billId);
			return ps.executeUpdate() > 0;
		}
	}

//    delete occassional bill
	public boolean deleteOccassionalBill(String billId) throws SQLException {
		
		
		
		
		String sql = "DELETE FROM occasional_maintenance  WHERE bill_id = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, billId);
			int eventId = getEventId(billId,conn);
			deleteEventCharge(eventId, conn);
			return ps.executeUpdate() > 0;
		}
	}

	// ---------------------------------------------------------------
	// Helpers
	// ---------------------------------------------------------------

	private void bindBill(PreparedStatement ps, MonthlyMaintenance b) throws SQLException {
		int i = 1;
		int paymentStatus = b.isPaymentStatus() ? 1 : 0;
		ps.setInt(i++, b.getResidentId());
		ps.setString(i++, b.getFlatNum());
		ps.setDouble(i++, b.getFine());
		ps.setDouble(i++, b.getNetAmount());
		ps.setInt(i++, paymentStatus);
		ps.setDate(i++, b.getGeneratedDate() != null ? Date.valueOf(b.getGeneratedDate()) : null);
		ps.setDate(i++, b.getDueDate() != null ? Date.valueOf(b.getDueDate()) : null);
		ps.setDouble(i++, b.getGST());
		ps.setDouble(i++, b.getGSTRate());
		
		ps.setInt(i++, b.getDueDays());
		ps.setDouble(i++, b.getLateFee());
		ps.setDouble(i++, b.getMaintenanceAmount());
		ps.setDouble(i++, b.getElectricityCharges());
		ps.setDouble(i++, b.getWaterCharges());
		ps.setDouble(i++, b.getParkingCharges());
		ps.setDouble(i++, b.getOtherCharges());
		ps.setDouble(i++, b.getSecurityCharges());
		ps.setString(i++, b.getBillId());
	}

	private MonthlyMaintenance mapRow(ResultSet rs) throws SQLException {
		MonthlyMaintenance b = new MonthlyMaintenance();

		b.setBillId(rs.getString("bill_id"));
		b.setResidentId(Integer.parseInt(rs.getString("resident_id")));

		b.setFlatNum(rs.getString("flat_number"));

		b.setAmountPaid(rs.getDouble("amount_paid"));
		Date generated = rs.getDate("generated_date");
		b.setGeneratedDate(generated != null ? generated.toLocalDate() : null);

		Date due = rs.getDate("due_date");
		b.setDueDate(due != null ? due.toLocalDate() : null);

		b.setMaintenanceAmount(rs.getDouble("maintenance_amount"));
		b.setElectricityCharges(rs.getDouble("electricity_charges"));
		b.setWaterCharges(rs.getDouble("water_charges"));
		b.setParkingCharges(rs.getDouble("parking_charges"));
		b.setSecurityCharges(rs.getDouble("security_charges"));
		b.setOtherCharges(rs.getDouble("other_charges"));
		b.setDueDays(rs.getInt("due_days"));
		b.setLateFee(rs.getDouble("late_fee"));
		b.setFine(rs.getDouble("fine"));

		b.setGST(rs.getDouble("GST"));
		b.setNetAmount(rs.getDouble("net_amount"));

		b.setPaymentStatus(rs.getInt("payment_status") == 1 ? true : false);
		return b;
	}

	// Gte All Event Charges
	public static HashMap<String, Double> getEventCharges(int eventId) {
		HashMap<String, Double> eventCh = new HashMap<String, Double>();
		String sql = """
				SELECT * from event_charge where event_id=? """;

		try {
			Connection connection = DBConnection.getConnection();
			PreparedStatement ps = connection.prepareStatement(sql);
			ps.setInt(1, eventId);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				eventCh.put(rs.getString("charge_name"), rs.getDouble("amount"));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return eventCh;
	}

	public HashMap<String, Double> getEventChargesByBillId(String billId) {
		String sql = """
				SELECT event_id from occasional_maintenance where bill_id=? """;

		int chargeId = 0;

		try {
			Connection connection = DBConnection.getConnection();
			PreparedStatement ps = connection.prepareStatement(sql);
			ps.setString(1, billId);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				chargeId = rs.getInt("event_id");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return getEventCharges(chargeId);
	}

	public OccassionalMaintenance getOccassionalById(int eventId) {
		String sql = """
				SELECT * from occasional_maintenance where event_id=?""";
		OccassionalMaintenance maintenance = null;

		try {
			Connection connection = DBConnection.getConnection();
			PreparedStatement ps = connection.prepareStatement(sql);
			ps.setInt(1, eventId);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				 
				maintenance = new OccassionalMaintenance();
				maintenance.setOccationalCharges(MaintenanceDao.getEventCharges(eventId));
				maintenance.setEventId(eventId);
				maintenance.setResidentId(rs.getInt("resident_id"));
				maintenance.setFlatNum(rs.getString("flat_number"));

				maintenance.setFine(rs.getDouble("fine"));
				maintenance.setNetAmount(rs.getDouble("net_amount"));
				maintenance.setAmountPaid(rs.getDouble("amount_paid"));

				maintenance.setPaymentStatus(rs.getBoolean("payment_status"));

				// DATE
				Date generatedDate = rs.getDate("generated_date");
				if (generatedDate != null) {
					maintenance.setGeneratedDate(generatedDate.toLocalDate());
				}

				Date dueDate = rs.getDate("due_date");
				if (dueDate != null) {
					maintenance.setDueDate(dueDate.toLocalDate());
				}

				maintenance.setBillId(rs.getString("bill_id"));

				maintenance.setGST(rs.getDouble("GST"));
				maintenance.setGSTRate(rs.getDouble("GST_rate"));

				maintenance.setOccationalEventName(rs.getString("occasional_event_name"));

				maintenance.setSubTotalOccationalCharg(rs.getDouble("subtotal_occasional_charge"));
				maintenance.setEventDescription(rs.getString("even_description"));

				// Create HashMap for charges

			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return maintenance;
	}

//  Get all data from occassionalmaintenance based on billId

	public OccassionalMaintenance getOccassionalByBillId(String BillId) {
		String sql = """
				SELECT * from occasional_maintenance where bill_id=?""";
		OccassionalMaintenance maintenance = null;

		try {
			Connection connection = DBConnection.getConnection();
			PreparedStatement ps = connection.prepareStatement(sql);
			ps.setString(1, BillId);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				 
				maintenance = new OccassionalMaintenance();
				maintenance.setEventId(rs.getInt("event_id"));
				maintenance.setOccationalCharges(MaintenanceDao.getEventCharges(rs.getInt("event_id")));
				

				maintenance.setResidentId(rs.getInt("resident_id"));
				maintenance.setFlatNum(rs.getString("flat_number"));

				maintenance.setFine(rs.getDouble("fine"));
				maintenance.setNetAmount(rs.getDouble("net_amount"));
				maintenance.setAmountPaid(rs.getDouble("amount_paid"));

				maintenance.setPaymentStatus(rs.getBoolean("payment_status"));

				// DATE
				Date generatedDate = rs.getDate("generated_date");
				if (generatedDate != null) {
					maintenance.setGeneratedDate(generatedDate.toLocalDate());
				}

				Date dueDate = rs.getDate("due_date");
				if (dueDate != null) {
					maintenance.setDueDate(dueDate.toLocalDate());
				}

				maintenance.setBillId(rs.getString("bill_id"));

				maintenance.setGST(rs.getDouble("GST"));
				maintenance.setGSTRate(rs.getDouble("GST_rate"));

				maintenance.setOccationalEventName(rs.getString("occasional_event_name"));

				maintenance.setSubTotalOccationalCharg(rs.getDouble("subtotal_occasional_charge"));
				maintenance.setEventDescription(rs.getString("even_description"));

				// Create HashMap for charges

			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return maintenance;
	}

	// Get All Data from Occasional Maintenance
	public static List<OccassionalMaintenance> getAllOccassionalData() {

		List<OccassionalMaintenance> list = new ArrayList<>();

		String sql = """
				SELECT * from occasional_maintenance""";

		try (Connection connection = DBConnection.getConnection();
				PreparedStatement ps = connection.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			OccassionalMaintenance maintenance = null;

			while (rs.next()) {

				int eventId = rs.getInt("event_id");

				/*
				 * Create OccationalMaintenance object only once for each event.
				 */

				maintenance = new OccassionalMaintenance();
				maintenance.setOccationalCharges(MaintenanceDao.getEventCharges(eventId));
				maintenance.setEventId(eventId);
				maintenance.setResidentId(rs.getInt("resident_id"));
				maintenance.setFlatNum(rs.getString("flat_number"));

				maintenance.setFine(rs.getDouble("fine"));
				maintenance.setNetAmount(rs.getDouble("net_amount"));
				maintenance.setAmountPaid(rs.getDouble("amount_paid"));

				maintenance.setPaymentStatus(rs.getBoolean("payment_status"));

				// DATE
				Date generatedDate = rs.getDate("generated_date");
				if (generatedDate != null) {
					maintenance.setGeneratedDate(generatedDate.toLocalDate());
				}

				Date dueDate = rs.getDate("due_date");
				if (dueDate != null) {
					maintenance.setDueDate(dueDate.toLocalDate());
				}

				maintenance.setBillId(rs.getString("bill_id"));

				maintenance.setGST(rs.getDouble("GST"));
				maintenance.setGSTRate(rs.getDouble("GST_rate"));
				maintenance.setDueDays(rs.getInt("due_days"));
				maintenance.setLateFee(rs.getDouble("late_fee"));

				maintenance.setOccationalEventName(rs.getString("occasional_event_name"));

				maintenance.setSubTotalOccationalCharg(rs.getDouble("subtotal_occasional_charge"));
				maintenance.setEventDescription(rs.getString("even_description"));

				// Create HashMap for charges

				list.add(maintenance);

			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return list;
	}

	public boolean updateOccasionalMaintenance(OccassionalMaintenance m, Connection connection) {

	    MaintenanceService ms = new MaintenanceService();

	    int paymentStatus = m.isPaymentStatus() ? 1 : 0;

	    double netAmount = ms.netAmountOfOccassional(m);
	    double subtotalOccasionalCharge = m.getSubTotalOccationalCharg();

	    String sql = """
	            UPDATE occasional_maintenance
	            SET
	                 
	                net_amount = ?,
	                payment_status = ?,
	                generated_date = ?,
	                due_date = ?,
	                GST = ?,
	                GST_rate = ?,
	                occasional_event_name = ?,
	                subtotal_occasional_charge = ?,
	                payment_status = ?,
	                amount_paid = ?
	            WHERE bill_id = ?
	            """;

	    try ( PreparedStatement ps = connection.prepareStatement(sql)) {

	      int   i  = 1;
	        ps.setDouble(i++, netAmount);
	        ps.setInt(i++, paymentStatus);

	        if (m.getGeneratedDate() != null) {
	            ps.setDate(i++, Date.valueOf(m.getGeneratedDate()));
	        } else {
	            ps.setNull(i++, java.sql.Types.DATE);
	        }

	        if (m.getDueDate() != null) {
	            ps.setDate(i++, Date.valueOf(m.getDueDate()));
	        } else {
	            ps.setNull(i++, java.sql.Types.DATE);
	        }

	        ps.setDouble(i++, m.getGST());
	        ps.setDouble(i++, m.getGSTRate());
	        ps.setString(i++, m.getOccationalEventName());
	        ps.setDouble(i++, subtotalOccasionalCharge);
	        ps.setInt(i++, m.isPaymentStatus()==false?0:1);
	        ps.setDouble(i++,netAmount);
	        ps.setString(i++, m.getBillId());
	         
  
	        return ps.executeUpdate() > 0;

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return false;
	}

	public static boolean insertIntoOccassional(OccassionalMaintenance maintenance, Connection connection) {

		boolean status = false;
		

		String sql = "INSERT INTO occasional_maintenance " + "(event_id, resident_id, flat_number, fine, net_amount, "
				+ "amount_paid, payment_status, generated_date, due_date, "
				+ "bill_id, GST, GST_rate, due_days, late_fee, " + "occasional_event_name, subtotal_occasional_charge, "
				+ "even_description ) " + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

		try ( 
				PreparedStatement ps = connection.prepareStatement(sql)) {

			ps.setInt(1, maintenance.getEventId());

			ps.setInt(2, maintenance.getResidentId());

			ps.setString(3, maintenance.getFlatNum());

			ps.setDouble(4, maintenance.getFine());

			ps.setDouble(5, maintenance.getNetAmount());

			ps.setDouble(6, maintenance.getAmountPaid());

			ps.setBoolean(7, maintenance.isPaymentStatus());

			ps.setDate(8, java.sql.Date.valueOf(maintenance.getGeneratedDate()));

			ps.setDate(9, java.sql.Date.valueOf(maintenance.getGeneratedDate()));

			ps.setString(10, maintenance.getBillId());

			ps.setDouble(11, maintenance.getGST());

			ps.setDouble(12, maintenance.getGSTRate());

			ps.setInt(13, maintenance.getDueDays());

			ps.setDouble(14, maintenance.getLateFee());

			ps.setString(15, maintenance.getOccationalEventName());

			ps.setDouble(16, maintenance.getSubTotalOccationalCharg());

			ps.setString(17, maintenance.getEventDescription());
			 

			int rows = ps.executeUpdate();

			if (rows > 0) {
				status = true;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return status;
	}
	
 
	
//	Get billId by flatNumbe and chargeId
	public String getBillIdByFlat(String billDate,String flatNum) {

		 String count = null;

		String sql ="SELECT bill_id \n"
				+ "	FROM occasional_maintenance \n"
				+ "	WHERE flat_number = ? \n"
				+ "	  AND  generated_date = ?";
		try {
			
			Connection connection = FlatUtil.getConnection();
				PreparedStatement ps = connection.prepareStatement(sql);
				ps.setString(1,flatNum);
				ps.setDate(2, java.sql.Date.valueOf(billDate));
				ResultSet rs = ps.executeQuery();

			if (rs.next()) {
			  count = rs.getString("bill_id");
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return count;
	}
	

	public boolean insertEventCharges(int eventId, String[] chargeNames, String[] chargeAmounts,  Connection connection) {
		String sql = "INSERT INTO event_charge (event_id, charge_name, amount) VALUES (?, ?, ?)";
		 
		 boolean result = false;
		try (PreparedStatement pstmt = connection.prepareStatement(sql)) {

			// Check if arrays are valid and have matching lengths
			if (chargeNames != null && chargeAmounts != null && chargeNames.length == chargeAmounts.length) {

				for (int i = 0; i < chargeNames.length; i++) {
					// Skip empty rows if any are submitted accidentally
					if (chargeNames[i] == null || chargeNames[i].trim().isEmpty()) {
						continue;
					}
					
					pstmt.setInt(1, eventId);
					pstmt.setString(2, chargeNames[i]);
					 
					pstmt.setDouble(3, Double.parseDouble(chargeAmounts[i]));

					// Add to batch for bulk execution
					pstmt.addBatch();
				}

				// Execute all inserts in a single database round-trip
			result =	pstmt.executeBatch().length > 0;
				 
			}

		} catch (SQLException e) {
			System.err.println("Database error while inserting event charges: " + e.getMessage());
			e.printStackTrace();
		} catch (NumberFormatException e) {
			System.err.println("Error parsing charge amount to double: " + e.getMessage());
		}
		return result;
	}

	public int getLastEventId() {

		int lastEventId = 0;

		String sql = "SELECT MAX(event_id) FROM occasional_maintenance";

		try (Connection connection = FlatUtil.getConnection();
				PreparedStatement ps = connection.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			if (rs.next()) {
				lastEventId = rs.getInt(1);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return lastEventId;
	}

	public int getEventId(String billId, Connection connection) {

		int lastEventId = 0;

		String sql = "SELECT event_id FROM occasional_maintenance where bill_Id = ?";

		try { 
				PreparedStatement ps = connection.prepareStatement(sql);
				ps.setString(1, billId);
				ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				lastEventId = rs.getInt(1);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return lastEventId;
	}
	
	public int getResidentId(String flatNum) {

		int lastEventId = 0;

		String sql = "SELECT linked_resident_id FROM flat where flat_number = ?";

		try {Connection connection = FlatUtil.getConnection();
				PreparedStatement ps = connection.prepareStatement(sql);
				ps.setString(1, flatNum);
				ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				lastEventId = rs.getInt("linked_resident_id");
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return lastEventId;
	}
	public boolean updateEventCharge(int eventChargeId, String chargeName, double amount) {
		String sql = "UPDATE event_charge SET charge_name = ?, amount = ? WHERE event_id = ?";
		Connection connection = DBConnection.getConnection();
		try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
			pstmt.setString(1, chargeName);
			pstmt.setDouble(2, amount);
			pstmt.setInt(3, eventChargeId);

			int rowsAffected = pstmt.executeUpdate();
			return rowsAffected > 0; // Returns true if the update was successful

		} catch (SQLException e) {
			System.err.println("Error updating event charge: " + e.getMessage());
			e.printStackTrace();
			return false;
		}
	}

	public boolean deleteEventCharge(int eventChargeId, Connection connection) {
		String sql = "DELETE FROM event_charge WHERE event_id = ?";
		 
		try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
			pstmt.setInt(1, eventChargeId);

			int rowsAffected = pstmt.executeUpdate();
			if(rowsAffected >0) {
		 
				return true;
			}
		 

		} catch (SQLException e) {
			System.err.println("Error deleting event charge: " + e.getMessage());
			e.printStackTrace();
			return false;
		}
		return false;
	}

	public Map<String, String> getResidentDetailsByBillId(String billId) {
		String sql = "select * from Occasional_maintenance where bill_id=?";
		String reId = null;
		String date = null;

		Map<String, String> map = new HashMap<>();
		Connection connection = DBConnection.getConnection();
		try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
			pstmt.setString(1, billId);

			ResultSet set = pstmt.executeQuery();
			if (set.next()) {
				reId = set.getInt("resident_id") + "";
				map.put("residentId", reId);
				map.put("flatNumber", set.getString("flat_number"));
				map.put("eventName", set.getString("occasional_event_name"));

				date = set.getDate("generated_date") + "";
				map.put("paymentStatus", set.getInt("payment_status") + "");
				map.put("generatedDate", date);
				map.put("gstRate", set.getDouble("gst_rate")+"");
				map.put("subTotal", set.getDouble("subtotal_occasional_charge")+"");
				 
			}

		} catch (SQLException e) {
			System.err.println(" Erro getting resident Id: " + e.getMessage());
			e.printStackTrace();

		}
		return map;
	}

	public String getResidentNameByResidentId(String residentId) {
		String sql = "select * from residents where resident_id=?";
		String name = null;
		Connection connection = DBConnection.getConnection();
		try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
			pstmt.setString(1, residentId);

			ResultSet set = pstmt.executeQuery();
			if (set.next()) {
				String firstName = set.getString("first_name");
				String lastName = set.getString("last_name");
				name = firstName + " " + lastName;
			}

			return name;

		} catch (SQLException e) {
			System.err.println(" Erro getting resident Id: " + e.getMessage());
			e.printStackTrace();
			return name;
		}
	}
	
	public String getBillDate(String billId) {
		String sql = "select generated_date from occasional_maintenance where bill_id=?";
		String billDate = null;
		Connection connection = DBConnection.getConnection();
		try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
			pstmt.setString(1, billId);

			ResultSet set = pstmt.executeQuery();
			if (set.next()) {
				 billDate = set.getDate("generated_date").toString();
			}

			return billDate;

		} catch (SQLException e) {
			System.err.println(" Erro getting billDate : " + e.getMessage());
			e.printStackTrace();
			return billDate;
		}
	}

 
	 
		
 
		 
		
		
		 

	

	 
}
