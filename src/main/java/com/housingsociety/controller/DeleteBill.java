package com.housingsociety.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
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
import com.housingsociety.service.MaintenanceService;
import com.housingsociety.utils.DBConnection;

/**
 * Servlet implementation class DeleteBill
 */
@WebServlet("/DeleteBill")
public class DeleteBill extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public DeleteBill() {
		super();
		// TODO Auto-generated constructor stub
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	 
		if (request.getParameter("billType") != null) {
			if (request.getParameter("billType").equals("occassional")) {
				deleteOccassionalBill(request, response);
				request.getSession().setAttribute("popupMsg", "successfully!");
				request.getSession().setAttribute("popupType","delete");
				response.sendRedirect(request.getContextPath() + "/Maintenance/occasionalMaintenance.jsp");
			} else if (request.getParameter("billType").equals("monthly")) {
				deleteMonthlyBill(request, response);
				request.getSession().setAttribute("popupMsg", "successfully!");
				request.getSession().setAttribute("popupType","delete");
				response.sendRedirect(request.getContextPath() + "/Maintenance/monthlyMaintenance.jsp");
			}
		}

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		MaintenanceDao md = new MaintenanceDao();
		MaintenanceService ms = new MaintenanceService();
		int chargeId = 0;
		String billId = request.getParameter("billId");
		Connection connection = DBConnection.getConnection();
		String billDate = md.getBillDate(billId);
		int billCounter = 0;
		String billstr = "bill";
		String billType = request.getParameter("flatsInvolvedMode");
		
		 if(billType!=null) {
			 if (billType.equals("range")) {

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
							try {
								md.deleteOccassionalBill(billId);
								billCounter++;
							} catch (SQLException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
						}
					}

				}

				else if (billType.equals("all")) {
					FlatDao fd = new FlatDao();
					ArrayList<Flat> totalFlats = fd.getFlatData();
					List<Flat> flats = ms.getOccupiedFlats(totalFlats);
				 

					for (Flat flat : flats) {

						billId = md.getBillIdByFlat(billDate, flat.getFlatNumber());
						 
						if (billId != null) {
							try {
								md.deleteOccassionalBill(billId);
								billCounter++;
							} catch (SQLException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}

						}
					}
				}
				else {
					deleteOccassionalBill(request, response);
					billCounter++;
					
				}
		 }
		
		if(billCounter > 1) {
			billstr  = "bills";
		}
		request.getSession().setAttribute("popupMsg", billCounter+" "+billstr+" successfully!");
		request.getSession().setAttribute("popupType","delete");
		response.sendRedirect(request.getContextPath() + "/Maintenance/occasionalMaintenance.jsp");
	
	}

	void deleteMonthlyBill(HttpServletRequest request, HttpServletResponse response) {
		MaintenanceDao md = new MaintenanceDao();

		try {
			md.deleteBill(request.getParameter("billId"));
			 
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	void deleteOccassionalBill(HttpServletRequest request, HttpServletResponse response) {
		MaintenanceDao md = new MaintenanceDao();

		try {
			md.deleteOccassionalBill(request.getParameter("billId"));
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
}
