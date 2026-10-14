package com.housingsociety.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.housingsociety.dao.FlatDao;
import com.housingsociety.dao.MaintenanceDao;
import com.housingsociety.model.Flat;
import com.housingsociety.model.OccassionalMaintenance;
import com.housingsociety.service.FlatService;
import com.housingsociety.service.MaintenanceService;
import com.housingsociety.utils.DBConnection;

/**
 * Servlet implementation class AddOccassionalBill
 */
@WebServlet("/AddOccassionalBill")
public class AddOccassionalBill extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddOccassionalBill() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		loadDataInJson(request, response);
		
		 
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		MaintenanceDao md = new MaintenanceDao();
		FlatDao fd = new FlatDao();
		int billCounte = 0;
		Connection connection = DBConnection.getConnection();
		MaintenanceService ms = new MaintenanceService();
		String eventName = request.getParameter("eventName");
		String eventDate = request.getParameter("eventDate");
		String description = request.getParameter("description");
		double gstRate = Double.parseDouble(request.getParameter("gst_rate"));
		String flatSelectionType = request.getParameter("flatSelectionType");
		String flatNumber = request.getParameter("flatNumber");
		boolean paymentStatus = request.getParameter("paymentStatus") == "1"?true:false;
		String paymentStatusStr = request.getParameter("paymentStatus");
		String[] chargeNames =
		        request.getParameterValues("chargeName[]");
		String[] chargeAmounts =
		        request.getParameterValues("chargeAmount[]");
		 
		 
		
		 double netAmt = Double.parseDouble(request.getParameter("netAmount"));
		 double subTotal = Double.parseDouble(request.getParameter("subTotal"));
		 double gstAmt =  Double.parseDouble(request.getParameter("gstAmount"));
		 String billstr = "bill";
		  
		
		try {
			connection.setAutoCommit(false);
		} catch (SQLException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		
		
		
		if ("single".equals(flatSelectionType)) {

		   
		  int  residentId = md.getResidentId(flatNumber);
		    // find resident ID
		    // create one OccassionalMaintenance object
		    
		 // 2. Parse dates (assuming eventDate is in a standard format like "yyyy-MM-dd")
    		java.time.LocalDate parsedEventDate = (eventDate != null && !eventDate.isEmpty()) 
    		    ? java.time.LocalDate.parse(eventDate) 
    		    : java.time.LocalDate.now();

    		// 3. Instantiate the object
    		OccassionalMaintenance maintenance = new OccassionalMaintenance();
    		 
    		 
    		 
    		  OccassionalMaintenance oc = new OccassionalMaintenance();
    		  oc.setResidentId(residentId);
    		  oc.setFlatNum(flatNumber);
    		  oc.setGeneratedDate(LocalDate.now());
    		   oc.setNetAmount(netAmt);
    		   oc.setGST(gstAmt);
    		   oc.setSubTotalOccationalCharg(subTotal);
    		   oc.setDueDate(oc.getGeneratedDate());
    		   oc.setEventDescription(description);
    		   oc.setPaymentStatus(paymentStatus);
    		   oc.setOccationalEventName(eventName);
    		   oc.setGSTRate(gstRate);
    		   oc.setEventDescription(description != null ? description :eventName);
				   
    		  String billId = ms.generateNextBillId(oc.getGeneratedDate());
    		 
    		   oc.setBillId(billId);
    		   md.insertIntoOccassional(oc,connection); 
    		   
    		   int eventId = md.getEventId(billId,connection);
    		   
    		   md.insertEventCharges(eventId, chargeNames, chargeAmounts, connection);
    		   billCounte++;
    		// and save them to a related database table or collection if your class supports itemized charges.
    	




		}
		else if ("range".equals(flatSelectionType)) {

		    String fromFlat = request.getParameter("fromFlat");
		    String toFlat = request.getParameter("toFlat");
		     
		    // find all flats between fromFlat and toFlat
		    // create one object per resident
		    ArrayList<Flat> totalFlats= fd.getFlatData();
		    List<Flat> flats = ms.getOccupiedFlats(totalFlats);
			// 1. Parse numeric and boolean values safely
		   
		    List<String> flatNums = ms.getOccupiedFlatNums(totalFlats);
		    for(Flat flat:flats) {
		    	
		    	if(ms.isSmaller(fromFlat,   flat.getFlatNumber()) && ms.isSmaller(flat.getFlatNumber(), toFlat)&& flatNums.contains(flat.getFlatNumber() )) {
		    	
		    		// 2. Parse dates (assuming eventDate is in a standard format like "yyyy-MM-dd")
		    		java.time.LocalDate parsedEventDate = (eventDate != null && !eventDate.isEmpty()) 
		    		    ? java.time.LocalDate.parse(eventDate) 
		    		    : java.time.LocalDate.now();

		    		// 3. Instantiate the object
		    		OccassionalMaintenance maintenance = new OccassionalMaintenance();
		    		 
		    		 
		    		 
		    		  OccassionalMaintenance oc = new OccassionalMaintenance();
		    		  oc.setResidentId(flat.getLinkedResidentId());
		    		  oc.setFlatNum(flat.getFlatNumber());
		    		  oc.setGeneratedDate(LocalDate.now());
		    		   oc.setNetAmount(netAmt);
		    		   oc.setGST(gstAmt);
		    		   oc.setSubTotalOccationalCharg(subTotal);
		    		   oc.setDueDate(oc.getGeneratedDate());
		    		   oc.setEventDescription(description);
		    		   oc.setPaymentStatus(paymentStatus);
		    		   oc.setOccationalEventName(eventName);
		    		   oc.setGSTRate(gstRate);
		    		   oc.setEventDescription(description != null ? description :eventName);
						   
		    		  String billId = ms.generateNextBillId(oc.getGeneratedDate());
		    		 
		    		   oc.setBillId(billId);
		    		   md.insertIntoOccassional(oc,connection); 
		    		   int eventId = md.getEventId(billId,connection);
		    		   md.insertEventCharges(eventId, chargeNames, chargeAmounts, connection);
		    		   billCounte++;
		    		// and save them to a related database table or collection if your class supports itemized charges.
		    	}
		    	
		    }

		}
		else if ("all".equals(flatSelectionType)) {

		    ArrayList<Flat> totalFlats= fd.getFlatData();
		    List<Flat> flats = ms.getOccupiedFlats(totalFlats);
			// 1. Parse numeric and boolean values safely
		   
		    List<String> flatNums = ms.getOccupiedFlatNums(totalFlats);
		    for(Flat flat:flats) {
		    	
		    	 
		    	
		    		// 2. Parse dates (assuming eventDate is in a standard format like "yyyy-MM-dd")
		    		java.time.LocalDate parsedEventDate = (eventDate != null && !eventDate.isEmpty()) 
		    		    ? java.time.LocalDate.parse(eventDate) 
		    		    : java.time.LocalDate.now();

		    		// 3. Instantiate the object
		    		OccassionalMaintenance maintenance = new OccassionalMaintenance();
		    		 
		    		 
		    		 
		    		  OccassionalMaintenance oc = new OccassionalMaintenance();
		    		  oc.setResidentId(flat.getLinkedResidentId());
		    		  oc.setFlatNum(flat.getFlatNumber());
		    		  oc.setGeneratedDate(LocalDate.now());
		    		   oc.setNetAmount(netAmt);
		    		   oc.setGST(gstAmt);
		    		   oc.setSubTotalOccationalCharg(subTotal);
		    		   oc.setDueDate(oc.getGeneratedDate());
		    		   oc.setEventDescription(description);
		    		   oc.setPaymentStatus(paymentStatus);
		    		   oc.setOccationalEventName(eventName);
		    		   oc.setGSTRate(gstRate);
		    		   oc.setEventDescription(description != null ? description :eventName);
						   
		    		  String billId = ms.generateNextBillId(oc.getGeneratedDate());
		    		  
		    		   oc.setBillId(billId);
		    		   md.insertIntoOccassional(oc,connection); 
		    		   int eventId = md.getEventId(billId,connection);
		    		   md.insertEventCharges(eventId, chargeNames, chargeAmounts, connection);
		    		   billCounte++;
		    		   
		    		// and save them to a related database table or collection if your class supports itemized charges.
		    	}

		}
		try {
			connection.commit();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		if(billCounte > 1) {
			billstr = "bills";
		}
		request.getSession().setAttribute("popupMsg", billCounte+" "+billstr+" successfully!");
		request.getSession().setAttribute("popupType","success");
		response.sendRedirect(request.getContextPath()+"/Maintenance/occasionalMaintenance.jsp");
	}

	
	
	
	
//	Load data in json format
	
	void loadDataInJson(HttpServletRequest request, HttpServletResponse response) {
		 String billId = request.getParameter("billId");
		OccassionalMaintenance m = new MaintenanceDao().getOccassionalByBillId(billId);
		
		 
		
		try {
        	if (m != null) {
        		HashMap<String, Double> charges = m.getOccationalCharges();

        		StringBuilder chargesJson = new StringBuilder("{");

        		for (Map.Entry<String, Double> entry : charges.entrySet()) {

        		    chargesJson.append("\"")
        		              .append(entry.getKey())
        		              .append("\":")
        		              .append(entry.getValue())
        		              .append(",");
        		}

        		if (!charges.isEmpty()) {
        		    chargesJson.deleteCharAt(chargesJson.length() - 1);
        		}

        		chargesJson.append("}");
        		String json = "{"
        		        + "\"eventName\":\"" + m.getOccationalEventName() + "\","
        		        + "\"eventDate\":\"" + m.getGeneratedDate() + "\","
        		        + "\"eventDescription\":\"" + m.getEventDescription() + "\","
        		        + "\"gstRate\":\"" + m.getGSTRate() + "\","
        		         
        		        + "\"charges\":" + chargesJson
        		        + "}";

        	    response.getWriter().write(json);

        	} else {

        	    response.getWriter().write(
        	        "{\"OccassionalData\":\"No data found\",\"billId\":-1}"
        	    );
        	}
        } catch (IOException e) {
            e.printStackTrace();
        }
 

	}
}
