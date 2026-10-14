package com.housingsociety.service;

import java.util.ArrayList;
import java.util.List;

import com.housingsociety.dao.FlatDao;
import com.housingsociety.model.Flat;
import com.housingsociety.utils.*;

public class FlatService {

	public static void main(String[] agr) {
		for (Flat flat : new FlatService().getAllFlats()) {
			System.out.println(flat.getResidentName());
		}
	}

	// Get All Flats
	public List<Flat> getAllFlats() {
		return FlatDao.getFlatData();
	}

	// Search Flat
	public Flat searchFlat(String flatNumber) {
		for (Flat flat : FlatUtil.getFlatData()) {
			if (flat.getFlatNumber().equalsIgnoreCase(flatNumber)) {
				return flat;
			}
		}
		return null;
	}
	// ===========================
	// Get Only Vacant Flats FlatNumber
	// ===========================
		public String[] getVacantFlatNumbers() {
		   List<String> list = new ArrayList<String>();
		   for(Flat flat : FlatDao.getFlatData()) {
			   if(flat.getStatus().equalsIgnoreCase("Vacant")) {
				   list.add(flat.getFlatNumber());
			   }
		   }
		   return list.toArray(new String[0]);
		}
		
		// ===========================
		// Get Only Occupied Flats FlatNumber
		// ===========================
			public String[] getOccupiedFlatNumbers() {
			   List<String> list = new ArrayList<String>();
			   for(Flat flat : FlatDao.getFlatData()) {
				   if(flat.getStatus().equalsIgnoreCase("Occupied")) {
					   list.add(flat.getFlatNumber());
				   }
			   }
			   return list.toArray(new String[0]);
			}
	// ===========================
	// Get Only Vacant Flats
	// ===========================
	public List<Flat> getVacantFlats() {
		List<Flat> vacantFlats = new ArrayList<>();
		for (Flat flat : FlatDao.getFlatData()) {
			if (flat.getStatus().equalsIgnoreCase("Vacant")) {
				vacantFlats.add(flat);
			}
		}
		return vacantFlats;
	}

	// ===========================
	// Assign Resident To Flat
	// ===========================
	public boolean assignResident(String flatNumber, String residentName, String residentType, int currentResidents,
			int residentId) {
		Flat flat = searchFlat(flatNumber);
		if (flat == null) {
			return false;
		}
		// Already occupied
		if (flat.getStatus().equalsIgnoreCase("Occupied")) {
			return false;
		}
		// Validate only for Tenant
		if (residentType.equalsIgnoreCase("Tenant")) {
			if (currentResidents > flat.getMaxTenantAllowed()) {
				System.out.println("Maximum Tenant Limit Exceeded.");
				return false;
			}
		}
		flat.setResidentName(residentName);
		flat.setResidentType(residentType);
		flat.setCurrentResidents(currentResidents);
		flat.setLinkedResidentId(residentId);
		updateStatus(flat);
		return true;
	}

	// ===========================
	// Update Resident Name
	// ===========================
	public boolean updateResidentName(String flatNumber, String residentName) {
		Flat flat = searchFlat(flatNumber);
		if (flat == null) {
			return false;
		}
		flat.setResidentName(residentName);
		return true;
	}

	// ===========================
	// Update Resident Type
	// ===========================
	public boolean updateResidentType(String flatNumber, String residentType) {
		Flat flat = searchFlat(flatNumber);
		if (flat == null) {
			return false;
		}
		flat.setResidentType(residentType);
		return true;
	}

	// ===========================
	// Update Resident Count
	// ===========================
	public boolean updateResidentCount(String flatNumber, int residentCount) {
		Flat flat = searchFlat(flatNumber);
		if (flat == null) {
			return false;
		}
		if (flat.getResidentType().equalsIgnoreCase("Tenant")) {
			if (residentCount > flat.getMaxTenantAllowed()) {
				return false;
			}
		}
		flat.setCurrentResidents(residentCount);
		updateStatus(flat);
		return true;
	}

	// ===========================
	// Vacate Flat
	// ===========================
	public boolean vacateFlat(String flatNumber) {
		Flat flat = searchFlat(flatNumber);
		if (flat == null) {
			return false;
		}
		flat.setResidentName("");
		flat.setResidentType("");
		flat.setCurrentResidents(0);
		flat.setLinkedResidentId(0);
		updateStatus(flat);
		return true;
	}

	// ===========================
	// Automatic Status
	// ===========================
	private void updateStatus(Flat flat) {
		if (flat.getCurrentResidents() == 0) {
			flat.setStatus("Vacant");
		} else {
			flat.setStatus("Occupied");
		}
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

	// ===========================
	// Count Vacant Flats
	// ===========================
	public int getVacantFlatCount() {

		FlatService fs = new FlatService();

		return fs.getVacantFlats().size();
	}

	// ===========================
	// Count Occupied Flats
	// ===========================
	public int getOccupiedFlatCount() {
		int count = 0;
		for (Flat flat : FlatUtil.getFlatData()) {
			if (flat.getStatus().equalsIgnoreCase("Occupied")) {
				count++;
			}
		}
		return count;
	}

	// ===========================
	// Count Total Flats
	// ===========================
	public int getTotalFlatCount() {
		return FlatUtil.getFlatData().size();
	}

	// ===========================
	// Count 1 BHK Flats
	// ===========================
	public int getOneBHKCount() {
		int count = 0;
		for (Flat flat : FlatDao.getFlatData()) {
			if (flat.getFlatType().equalsIgnoreCase("1 BHK")) {
				count++;
			}
		}
		return count;
	}

	// ===========================
	// Count 2 BHK Flats
	// ===========================
	public int getTwoBHKCount() {
		int count = 0;
		for (Flat flat : FlatDao.getFlatData()) {
			if (flat.getFlatType().equalsIgnoreCase("2 BHK")) {
				count++;
			}
		}
		return count;
	}

	// ===========================
	// Count 3 BHK Flats
	// ===========================
	public int getThreeBHKCount() {
		int count = 0;
		for (Flat flat : FlatDao.getFlatData()) {
			if (flat.getFlatType().equalsIgnoreCase("3 BHK")) {
				count++;
			}
		}
		return count;
	}

	// ===========================
	// Search By Resident Name
	// ===========================
	public Flat searchResident(String residentName) {
		for (Flat flat : FlatUtil.getFlatData()) {
			if (flat.getResidentName() != null && flat.getResidentName().equalsIgnoreCase(residentName)) {
				return flat;
			}
		}
		return null;
	}

	// ===========================
	// Vacant Flat Available
	// ===========================
	public boolean hasVacantFlat() {
		for (Flat flat : FlatUtil.getFlatData()) {
			if (flat.getStatus().equalsIgnoreCase("Vacant")) {
				return true;
			}
		}
		return false;
	}

	// ===========================
	// Get Maximum Capacity
	// ===========================
	public int getMaximumCapacity(String flatType) {
		switch (flatType.toUpperCase()) {
		case "1 BHK":
			return 3;
		case "2 BHK":
			return 5;
		case "3 BHK":
			return 7;
		default:
			return 0;
		}
	}

	// ===========================
	// Display Vacant Flats
	// ===========================
	public void displayVacantFlats() {
		System.out.println();
		System.out.println("+-------------------------------------------------------------+");
		System.out.println("|                     VACANT FLATS                            |");
		System.out.println("+-------------------------------------------------------------+");
		System.out.printf("%-12s %-15s %-15s%n", "Flat No", "Flat Type", "Capacity");
		System.out.println("---------------------------------------------------------------");
		for (Flat flat : getVacantFlats()) {
			System.out.printf("%-12s %-15s %-15d%n", flat.getFlatNumber(), flat.getFlatType(),
					flat.getMaxTenantAllowed());
		}
		System.out.println("---------------------------------------------------------------");
	}

	// ===========================
	// Display Statistics
	// ===========================
	public void displayStatistics() {
		System.out.println();
		System.out.println("+=============================================================+");
		System.out.println("|                     FLAT STATISTICS                         |");
		System.out.println("+=============================================================+");
		System.out.printf("%-35s : %d%n", "Total Flats", getTotalFlatCount());
		System.out.printf("%-35s : %d%n", "Occupied Flats", getOccupiedFlatCount());
		System.out.printf("%-35s : %d%n", "Vacant Flats", getVacantFlatCount());
		System.out.printf("%-35s : %d%n", "1 BHK Flats", getOneBHKCount());
		System.out.printf("%-35s : %d%n", "2 BHK Flats", getTwoBHKCount());
		System.out.printf("%-35s : %d%n", "3 BHK Flats", getThreeBHKCount());
		System.out.println("+=============================================================+");
	}
}
