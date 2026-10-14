package com.housingsociety.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.housingsociety.dao.FlatDao;
import com.housingsociety.dao.MaintenanceDao;
import com.housingsociety.model.Flat;
import com.housingsociety.model.MonthlyMaintenance;
import com.housingsociety.model.OccassionalMaintenance;
import com.housingsociety.service.MaintenanceService;
import com.housingsociety.utils.DBConnection;

/**
 * Servlet implementation class UpdateBill
 */
@WebServlet("/UpdateBill")
public class UpdateBill extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public UpdateBill() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		MaintenanceDao md = new MaintenanceDao();
	 
		String amt = request.getParameter("amount") == null ? "0.0" : request.getParameter("amount");
		String gstRateString = request.getParameter("gst_rate") == null ? "0.0" : request.getParameter("gst_rate");
		String billId = request.getParameter("billId");
		double amount = Double.parseDouble(amt);
		 markAsPaidInMonthlyBill(billId, amount);
			response.sendRedirect(request.getContextPath() + "/Maintenance/monthly-bill.jsp?billId=" + billId);
		

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		 
		MaintenanceDao md = new MaintenanceDao();
		MaintenanceService ms = new MaintenanceService();
		String amt = request.getParameter("amount") == null ? "0.0" : request.getParameter("amount");
		String gstRateString = request.getParameter("gst_rate") == null ? "0.0" : request.getParameter("gst_rate");
		String billId = request.getParameter("billId");
		double amount = Double.parseDouble(amt);
		String type = request.getParameter("type") == null ? "" : request.getParameter("type");
		String billDate = md.getBillDate(billId);
		String billstr = "bill";
		Double gstRate = Double.parseDouble(gstRateString);
		int billCounter = 0;
		 
		
//		Update monthly bill details
		if (type.equals("monthly")) {
			updateMonthlyBill(request,billId,gstRate);
			request.getSession().setAttribute("popupMsg", "successfully!");
			request.getSession().setAttribute("popupType","update");
			response.sendRedirect(request.getContextPath() + "/Maintenance/monthlyMaintenance.jsp");
		}
//		 

 
			
//		Update OccssionalBill payment Status
		else if (type.equals("updateOccasionalPaymentStatus")) {
			 
			
			markAsPaidInOccassionalBill(billId, amount);

			response.sendRedirect(
					request.getContextPath() + "/Maintenance/occasionalBillReceipt.jsp?billId=" + billId);
		}
//		Update Occassional Bill  Details
		else if (type.equals("editOccassional")) {

			Connection connection = DBConnection.getConnection();
			int chargeId = md.getEventId(billId, connection);
			try {
				connection.setAutoCommit(false);

			} catch (SQLException e) {

				e.printStackTrace();
			}

			if (request.getParameter("flatsInvolvedMode").equals("range")) {

				FlatDao fd = new FlatDao();
				String flatString = request.getParameter("flatsInvolvedValue");

				String[] parts = flatString.split(",");
				String fromFlat = parts[0];
				String toFlat = parts[1];
				ArrayList<Flat> totalFlats = fd.getFlatData();
				List<Flat> flats = ms.getOccupiedFlats(totalFlats);
				// 1. Parse numeric and boolean values safely

				List<String> flatNums = ms.getOccupiedFlatNums(totalFlats);

				for (Flat flat : flats) {
					billId = md.getBillIdByFlat(billDate, flat.getFlatNumber());
					chargeId = md.getEventId(billId, connection);
					if (ms.isSmaller(fromFlat, flat.getFlatNumber()) && ms.isSmaller(flat.getFlatNumber(), toFlat)
							&& flatNums.contains(flat.getFlatNumber())) {
						billCounter++;
						updateOccassionalEvent(chargeId, request, connection);
						updateOccassionalBill(billId, request, connection, gstRate);
					}
				}

			}

			else if (request.getParameter("flatsInvolvedMode").equals("all")) {
				FlatDao fd = new FlatDao();
				ArrayList<Flat> totalFlats = fd.getFlatData();
				List<Flat> flats = ms.getOccupiedFlats(totalFlats);
				String eventName = request.getParameter("eventName");

				for (Flat flat : flats) {

					billId = md.getBillIdByFlat(billDate, flat.getFlatNumber());
					if (billId != null) {
						chargeId = md.getEventId(billId, connection);
						billCounter++;
						updateOccassionalEvent(chargeId, request, connection);
						updateOccassionalBill(billId, request, connection, gstRate);
					}
				}
			} else {
				billCounter++;
				updateOccassionalEvent(chargeId, request, connection);
				updateOccassionalBill(billId, request, connection, gstRate);
			}

			try {
				connection.commit();
			} catch (SQLException e) {

				e.printStackTrace();
			}
			
			if(billCounter > 1) {
				billstr  = "bills";
			}
			request.getSession().setAttribute("popupMsg", billCounter+" "+billstr+" successfully!");
			request.getSession().setAttribute("popupType","update");
			response.sendRedirect(request.getContextPath() + "/Maintenance/occasionalMaintenance.jsp");
		}
	}

// Update Occassional Bill Method
	boolean updateOccassionalBill(String billId, HttpServletRequest r, Connection connection, Double gstRate) {

		MaintenanceDao md = new MaintenanceDao();
		OccassionalMaintenance m = new OccassionalMaintenance();
		MaintenanceService ms = new MaintenanceService();
		boolean status = r.getParameter("paymentStatus").equals("0")?false:true;
		
		LocalDate date = r.getParameter("eventDate") == null ? LocalDate.now()
				: LocalDate.parse(r.getParameter("eventDate"));
		m.setOccationalEventName(r.getParameter("eventName"));
		m.setEventDescription(r.getParameter("eventDescription"));
		m.setGeneratedDate(date);
		m.setPaymentStatus(status);
		m.setDueDate(date);
		m.setBillId(billId);
		m.setOccationalCharges(ms.getEventChargeInMap(r));
		m.setGSTRate(gstRate);

		return md.updateOccasionalMaintenance(m, connection);

	}

	// mark as paid bill in Occassional Bill
	void markAsPaidInOccassionalBill(String billId, double amount) {
		MaintenanceDao md = new MaintenanceDao();
		try {
			md.markAsPaidInOccassional(billId, amount);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

//	Update Occassional Event charges
	void updateOccassionalEvent(int chargeId, HttpServletRequest r, Connection connection) {
		MaintenanceDao md = new MaintenanceDao();

		int indexNum = Integer.parseInt(r.getParameter("indexNumber"));
		String[] amounts = new String[indexNum];
		String[] names = new String[indexNum];
		String name = "na";
		String amount = "am";
		int i = 0;
		while (i < indexNum) {
			names[i] = r.getParameter(name + (i + 1));
			amounts[i] = r.getParameter(amount + (i + 1));
			i++;
		}
		md.deleteEventCharge(chargeId, connection);

		md.insertEventCharges(chargeId, names, amounts, connection);
	}

	void markAsPaidInMonthlyBill(String billId, double amount) {
		MaintenanceDao md = new MaintenanceDao();
		try {
			md.markAsPaid(billId, amount);
		} catch (NumberFormatException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
	
	
	
	
	
//	Update monthly bill details
	
	void updateMonthlyBill(HttpServletRequest r,String billId, double gstRate) {
		double waterCharge = Double.parseDouble(r.getParameter("waterCharges"));
		double electricityCharges = Double.parseDouble(r.getParameter("electricityCharges"));
		double parkingCharges = Double.parseDouble(r.getParameter("parkingCharges"));
		double securityCharges = Double.parseDouble(r.getParameter("securityCharges"));
		double otherCharges = Double.parseDouble(r.getParameter("otherCharges"));
		double fine = Double.parseDouble(r.getParameter("fine"));
		int dueDays = Integer.parseInt(r.getParameter("dueDays"));
		double lateFee = Double.parseDouble(r.getParameter("lateFee"));
		double maintenanceAmount = Double.parseDouble(r.getParameter("maintenanceAmount"));
		double netAmount = Double.parseDouble(r.getParameter("netAmount"));
		double subTotal = Double.parseDouble(r.getParameter("subTotal"));
		double gstAmount = Double.parseDouble(r.getParameter("gstAmount"));
		String generatedDate =  r.getParameter("generatedDate");
	    int residentId = Integer.parseInt(r.getParameter("residentId"));
	    String flatNumber = r.getParameter("flatNumber");
		String dueDate =  r.getParameter("dueDate")!=null?generatedDate :  r.getParameter("dueDate");
		LocalDate date = LocalDate.parse(generatedDate);
		LocalDate LocalDueDate = LocalDate.parse(dueDate);

		MonthlyMaintenance m = new MonthlyMaintenance();
		MaintenanceDao md = new MaintenanceDao();
		 
		m.setFlatNum(flatNumber);
		m.setResidentId(residentId);
		m.setWaterCharges(waterCharge);
		m.setElectricityCharges(electricityCharges);
		m.setParkingCharges(parkingCharges);
		m.setSecurityCharges(securityCharges);
		m.setOtherCharges(otherCharges);
		m.setFine(fine);
		m.setDueDays(dueDays);
		m.setLateFee(lateFee);
		m.setMaintenanceAmount(maintenanceAmount);
		m.setNetAmount(netAmount);
		m.setSubTotalAmount(subTotal);
		m.setGST(gstAmount);
		m.setGeneratedDate(date);
		m.setDueDate(LocalDueDate);
		m.setGSTRate(gstRate);
		m.setBillId(billId);
		 
		md.updateMonthlyBill(m);
	}
}
