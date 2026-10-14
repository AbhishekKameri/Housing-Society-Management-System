package com.housingsociety.controller;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.Month;
import java.time.YearMonth;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.housingsociety.dao.FlatDao;
import com.housingsociety.dao.MaintenanceDao;
import com.housingsociety.model.Flat;
import com.housingsociety.model.MonthlyMaintenance;
import com.housingsociety.service.MaintenanceService;
import com.housingsociety.service.MaintenanceService;

/**
 * Servlet implementation class AddMonthlyBill
 */
@WebServlet("/AddMonthlyBill")
public class AddMonthlyBill extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public AddMonthlyBill() {
		super();

	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		

		if (request.getParameter("flatNumber") != null) {
			
			MaintenanceService ms = new MaintenanceService();
			String flatNumber = request.getParameter("flatNumber");
			int residentId = ms.getResidentId(flatNumber);
			Flat flat = FlatDao.getFlatByResidentID(residentId);

			try {
				if (flat != null) {
					String json = "{" + "\"ownerName\":\"" + flat.getResidentName() + "\"," + "\"residentId\":"
							+ flat.getLinkedResidentId() + "}";
					response.getWriter().write(json);

				} else {

					response.getWriter().write("{\"ownerName\":\"No owner found\",\"residentId\":-1}");
				}
			} catch (IOException e) {
				e.printStackTrace();
			}

		}

		else if (request.getParameter("billId") != null) {
			 
			getMonthlyBill(request, response);
			
		}
	

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		MaintenanceService ms = new MaintenanceService();
		MonthlyMaintenance m = new MonthlyMaintenance();
		MaintenanceDao md = new MaintenanceDao();
		String monthYear = request.getParameter("chargeDate");

		YearMonth yearMonth = YearMonth.parse(monthYear.trim());

		String lastDay = yearMonth.atEndOfMonth().toString();
		String flatNum = request.getParameter("flatNumber");

		LocalDate generatedDate = LocalDate.parse(lastDay);
		double maintenanceCh = Double.parseDouble(request.getParameter("maintenanceAmount"));
		double waterCharge = Double.parseDouble(request.getParameter("waterCharges"));
		double electricityCharge = Double.parseDouble(request.getParameter("electricityCharges"));
		double securityCharges = Double.parseDouble(request.getParameter("securityCharges"));
		double parkingCharge = Double.parseDouble(request.getParameter("parkingCharges"));
		double otherCharges = Double.parseDouble(request.getParameter("otherCharges"));
		double gstRate = Double.parseDouble(request.getParameter("gstRate"));
		double gstAmount =  Double.parseDouble(request.getParameter("gstAmount")); 
		double netAmount =  Double.parseDouble(request.getParameter("netAmount"));
		double subTotal =  Double.parseDouble(request.getParameter("subTotal"));
		int dueDays = 0;
		int lateFees = 0;

		LocalDate dueDate = null;
		String billId = ms.generateNextBillId(generatedDate);
		

		 
		int residentId = Integer.parseInt(request.getParameter("residentId"));
		 
		m.setBillId(billId);
		m.setFlatNum(flatNum);
		m.setGeneratedDate(generatedDate);
		m.setMaintenanceAmount(maintenanceCh);
		m.setWaterCharges(waterCharge);
		m.setElectricityCharges(electricityCharge);
		m.setSecurityCharges(securityCharges);
		m.setPaymentStatus(false);
		m.setParkingCharges(parkingCharge);
		m.setOtherCharges(otherCharges);
		m.setGST(gstAmount);
		m.setGSTRate(gstRate);
		m.setDueDays(dueDays);
		m.setLateFee(lateFees);
		m.setDueDate(dueDate);
		m.setNetAmount(netAmount);
		m.setResidentId(residentId);
		m.setSubTotalAmount(subTotal);
		m.setGST(gstAmount);
		

		try {
			md.insertBill(m);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		 
		request.getSession().setAttribute("popupMsg"," successfully!");
		request.getSession().setAttribute("popupType","success");
		response.sendRedirect(request.getContextPath() + "/Maintenance/monthlyMaintenance.jsp");
	}

	void getMonthlyBill(HttpServletRequest r, HttpServletResponse res) {

		String billId = r.getParameter("billId");

		MaintenanceDao md = new MaintenanceDao();

		MonthlyMaintenance m = md.getBillById(billId);

		try {
			 
		    if (m != null) {
		        String dueDate = m.getDueDate() != null ? m.getDueDate().toString() : "";
		        String generatedDate = m.getGeneratedDate() != null ? m.getGeneratedDate().toString() : "";

		        String json = "{" + "\"flatNumber\":\"" + m.getFlatNum() + "\"," 
		                + "\"generatedDate\":\"" + generatedDate + "\","
		                + "\"waterCharge\":\"" + m.getWaterCharges() + "\","
		                + "\"electricityCharge\":\"" + m.getElectricityCharges() + "\"," 
		                + "\"securityCharge\":\"" + m.getSecurityCharges() + "\"," 
		                + "\"maintenanceCharge\":\"" + m.getMaintenanceAmount() + "\","  // <-- Added missing quotes & comma here
		                + "\"parkingCharge\":\"" + m.getParkingCharges() + "\"," 
		                + "\"dueDays\":\"" + m.getDueDays() + "\","
		                + "\"lateFee\":\"" + m.getLateFee() + "\"," 
		                + "\"fine\":\"" + m.getFine() + "\"," 
		                + "\"otherCharges\":\"" + m.getOtherCharges() + "\"," 
		                + "\"dueDate\":\"" + dueDate + "\"," 
		                + "\"residentId\":" + m.getResidentId() + "}";

		        res.setContentType("application/json");
		        res.setCharacterEncoding("UTF-8");
		        res.getWriter().write(json);

		    } else {
		        res.setContentType("application/json");
		        res.getWriter().write("{\"ownerName\":\"No owner found\",\"residentId\":-1}");
		    }
		} catch (IOException e) {
		    e.printStackTrace();
		}

	}

}
