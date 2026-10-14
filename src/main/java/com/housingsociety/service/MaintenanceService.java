package com.housingsociety.service;

import com.housingsociety.dao.*;
import com.housingsociety.model.*;

import java.sql.SQLException;
import java.time.DateTimeException;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.apache.tomcat.util.security.MD5Encoder;

import com.housingsociety.model.*;

import com.housingsociety.utils.*;

public class MaintenanceService {

	static Scanner sc = new Scanner(System.in);
	FlatService fs = new FlatService();
	MaintenanceDao md = new MaintenanceDao();
	
	
	
	
 
	
//	Update Duedate
	public void updateDueDate(String billId) {
		MonthlyMaintenance m = md.getBillById(billId);
		LocalDate date = LocalDate.now();
		m.setDueDate(date);

		double lateFee = calculateLateFee(m);
		int dueDays = m.getDueDays();
		double netAmount = getNetAmount(m);
		try {
			md.updateDueDateLateFee(billId, date, dueDays, lateFee, netAmount);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

//	
//	 calculate late fee 
	public double calculateLateFee(MonthlyMaintenance m) {
		int dueDays = calculateDueDays(m);

		double lateFee = dueDays * m.getFine();
		m.setLateFee(lateFee);

		return lateFee;
	}

//calculate Due Days
	public int calculateDueDays(MonthlyMaintenance m) {
		LocalDate date2 = m.getGeneratedDate();
//		LocalDate date1 = m.getDueDate()== null ;
//				
//		int days = (int) ChronoUnit.DAYS.between(date2, );
		int days = 0;
		m.setDueDays(days);
		return days;
	}

//	 Compare flat Numbers
	public boolean isSmaller(String flat1, String flat2) {
		// Split by hyphen '-' (e.g., "A-101" becomes ["A", "101"])
		String[] parts1 = flat1.split("-");
		String[] parts2 = flat2.split("-");

		String block1 = parts1[0].toUpperCase();
		String block2 = parts2[0].toUpperCase();

		int room1 = Integer.parseInt(parts1[1]);
		int room2 = Integer.parseInt(parts2[1]);

		// 1. Compare blocks first (e.g., 'A' is smaller than 'C')
		if (!block1.equals(block2)) {
			return block1.compareTo(block2) < 0;
		}

		// 2. If blocks are the same, compare room numbers numerically
		return room1 <= room2;
	}

	// Validate flatNuber
	public int getResidentId(String flatNum) {
		int result = -1;
		for (Flat flat : fs.getAllFlats()) {
			if (flat.getFlatNumber().equals(flatNum)) {
				result = flat.getLinkedResidentId();
			}
		}
		return result;
	}
//	 Find Maintenance of a flat based on date 
//

// Caluculate total Monthly bills count
	public int getTotalMonthlyBillCount() {

		double totalAmount = 0;
		double collectedAmount = 0;
		double pendingAmount = 0;
		int totalEntries = 0;
		for (MonthlyMaintenance m : md.getAllMonthlyData()) {
			totalEntries++;
			collectedAmount += m.getAmountPaid();

			if (!m.isPaymentStatus()) {
				pendingAmount += m.getNetAmount();
			}
			totalAmount += m.getNetAmount();

		}

		MonthlyMaintenance.setCollectedAmount(collectedAmount);
		MonthlyMaintenance.setPendingAmount(pendingAmount);
		MonthlyMaintenance.setTotalAmount(totalAmount);
		MonthlyMaintenance.setTotalBills(totalEntries);

		return totalEntries;
	}

	// ===========================
	// Get Occupied Flats
	// ===========================
	public List<Flat> getOccupiedFlats() {
		List<Flat> occupied = new ArrayList<>();
		for (Flat flat : FlatUtil.getFlatData()) {
			if (flat.getStatus().equalsIgnoreCase("Occupied")) {
				occupied.add(flat);
			}
		}
		return occupied;
	}

//	Generate Bill Id

	/** Builds the next sequential bill id for a month, e.g. "MB202505011". */
	public String generateNextBillId(LocalDate date) {
		String compact = date.format(DateTimeFormatter.ofPattern("yyyy-MM"));
		String uniqueSuffix = UUID.randomUUID().toString().substring(0, 4).toUpperCase();

		return String.format("MB%s-%s", compact, uniqueSuffix);
	}

//	Check whether the bill ID Already exists .

//	calculate gst using object

	public double calculateGST(MonthlyMaintenance m) {
		double gstAmount = getSubTotal(m) * (m.getGSTRate() / 100)*100;
		 gstAmount /= 100;
		m.setGST(gstAmount);
		return gstAmount;
	}

//	Calculate subtotal using object
	public double getSubTotal(MonthlyMaintenance m) {
		double subTotal = m.getElectricityCharges() + m.getOtherCharges() + m.getSecurityCharges() + m.getMaintenanceAmount()
		+ m.getWaterCharges() + m.getParkingCharges();
		m.setSubTotalAmount(subTotal);
		m.setSubTotalAmount(subTotal);
		return subTotal;
	}

//	Calculate net amount using object
	public double getNetAmount(MonthlyMaintenance m) {
		 calculateGST(m);
		 calculateLateFee(m);
		 getSubTotal(m);

		return  m.getSubTotalAmount() + m.getGST() + m.getLateFee();
	}

	public double calculateGstOfOccassional(double subAmt, double gstRate) {
		double gstAmt =( subAmt * gstRate/100)/100;
		
		return gstAmt*100 ;
	}

//Calculate gst amount using fields
	public double calculateGSTAmt(double waterCh, double electricityCh, double OtherCh, double maintCh,
			double parkingCh, double securityCh, double gstRate) {

		double total = waterCh + electricityCh + OtherCh + maintCh + parkingCh + securityCh;

		return (total * gstRate / 100);
	}

//	    Calculate net amount using fields
	public double getNetAmount(double waterCh, double electricityCh, double OtherCh, double maintCh, double parkingCh,
			double securityCh, double fineAmount, double gstRate) {

		double gstAmount = calculateGSTAmt(waterCh, electricityCh, OtherCh, maintCh, parkingCh, securityCh, gstRate);

		double total = waterCh + electricityCh + OtherCh + maintCh + parkingCh + securityCh + gstAmount + fineAmount;
		total = Math.round(total * 100);
		return total / 100;
	}

//	     
	public double subTotalOfOccationalCharges(int eventId) {
		HashMap<String, Double> map = md.getEventCharges(eventId);
		int result = 0;
		for (String ch : md.getEventCharges(eventId).keySet()) {
			result += map.get(ch);
		}
		return result;
	}

	public double subTotalOfOccationalCharges(Map<String, Double> map) {

		int result = 0;
		for (String ch : map.keySet()) {
			result += map.get(ch);
		}
		return result;
	}

	
//	Get map of a event Charges
	public HashMap<String, Double> getEventChargeInMap(HttpServletRequest r) {
		HashMap<String , Double> map  = new HashMap<>();
		
		String name = "na";
		String amount = "am";
		int indexNum = Integer.parseInt(r.getParameter("indexNumber"));
		int i = 0;
		while(i < indexNum) {
			 map.put( r.getParameter(name+(i+1)), Double.parseDouble(r.getParameter(amount+(i+1))));
			 
			 i++;
		}
		return map;
	}
// Generate Next Event Id
	public int generateNextEventId() {

		int previousId = md.getLastEventId();

		return previousId + 1;
	}

//	Calculat net amoun for occassional 
	public double netAmountOfOccassional(int eventId, double gstRate) {
		double subTotal = subTotalOfOccationalCharges(eventId);
		double netAmount = subTotal + calculateGstOfOccassional(subTotal, gstRate)*100;
		return netAmount/100;
	}
//Calculate new Amount for occassional using Object
	public double netAmountOfOccassional(OccassionalMaintenance m) {
		double subTotal = subTotalOfOccationalCharges(m.getOccationalCharges());
		double gstAmount =calculateGstOfOccassional(subTotal, m.getGSTRate()) ;
		m.setSubTotalOccationalCharg(subTotal);
		double netAmount = subTotal + gstAmount;
		return netAmount;
	} 

//	calculate gst for occassional 
	public double calculateGSTOfOccassional(OccassionalMaintenance o) {

		double gstRate = o.getGSTRate() / 100;
		double gstAmount = 0;
		double totalAmt = 0;
		for (String c : o.getOccationalCharges().keySet()) {
			totalAmt += o.getOccationalCharges().get(c);
		}
		 gstAmount = totalAmt * gstRate*100;
		 gstAmount/=100;
		o.setGST(gstAmount);
		return gstAmount;
	}

//	get all Flat numbers
	public String[] getFlatNumbers() {
		ArrayList<Flat> fl = FlatDao.getFlatData();
		String[] flats = new String[fl.size()];
		int i = 0;
		for (Flat f : fl) {
			flats[i] = f.getFlatNumber();
			i++;
		}
		return flats;
	}
	
	public String[] getOccupiedFlatNumbers() {
		ArrayList<Flat> fl = FlatDao.getFlatData();
		 ArrayList<String> flats = new ArrayList<>() ;
	 
		for (Flat f : fl) {
			if(f.getStatus().equalsIgnoreCase("Occupied")) {
				flats.add( f.getFlatNumber());
			}
		 
		}
		return   flats.toArray(new String[0]);
	}

//	get Object[][] data
	public Object[][] getOccassionalData() {
		int billcount = getTotalOccassionalBillCount();
		Object[][] bills = new Object[billcount][6];
		int i = 0;

		for (OccassionalMaintenance m : md.getAllOccassionalData()) {

			bills[i][0] = m.getBillId();
			bills[i][1] = m.getOccationalEventName();
			bills[i][2] = m.getDueDate().toString();
			bills[i][3] = m.getNetAmount();
			bills[i][4] = m.getAmountPaid();
			bills[i][5] = m.isPaymentStatus() == false ? "Pending" : "Paid";

			i++;
		}
		return bills;
	}

	public int getTotalOccassionalBillCount() {

		double totalAmount = 0;
		double collectedAmount = 0;
		double pendingAmount = 0;
		int totalEntries = 0;
		for (OccassionalMaintenance m : md.getAllOccassionalData()) {
			totalEntries++;
			collectedAmount += m.getAmountPaid();

			if (!m.isPaymentStatus()) {
				pendingAmount += m.getNetAmount();
			}
			totalAmount += m.getNetAmount();

		}

		OccassionalMaintenance.setCollectedAmount(collectedAmount);
		OccassionalMaintenance.setPendingAmount(pendingAmount);
		OccassionalMaintenance.setTotalAmount(totalAmount);
		OccassionalMaintenance.setTotalBills(totalEntries);

		return totalEntries;
	}

	public List<String> getOccupiedFlatNums(List<Flat> flats) {
		List<String> list = new ArrayList<>();
		for (Flat flat : flats) {
			if (flat.getStatus().equalsIgnoreCase("Occupied")) {
				list.add(flat.getFlatNumber());
			}
		}
		return list;
	}

	public List<Flat> getOccupiedFlats(List<Flat> flats) {
		List<Flat> list = new ArrayList<>();
		for (Flat flat : flats) {
			if (flat.getStatus().equalsIgnoreCase("Occupied")) {
				list.add(flat);
			}
		}
		return list;
	}

	public Map<String, String> getOccassionalBillData(String billId) {

		String residentName = "Rahul Sharma";

		String residentId;

		Map<String, String> map = md.getResidentDetailsByBillId(billId);

		residentId = map.get("residentId");

		residentName = md.getResidentNameByResidentId(residentId);
		map.put("residentName", residentName);
		return map;
	}

	public Object[][] getEventChargesObject(String billId) {

		Map<String, Double> dataMap = md.getEventChargesByBillId(billId);
		Object[][] result = dataMap.entrySet().stream().map(entry -> new Object[] { entry.getKey(), entry.getValue() })
				.toArray(Object[][]::new);

		return result;
	}
	
 

	public static void main(String[] arg) {

		MaintenanceService ms = new MaintenanceService();
		MaintenanceDao md = new MaintenanceDao();
		System.out.println(ms.getOccassionalBillData("OM-BILL-004"));
		ms.updateDueDate(null);
	}
 



}
