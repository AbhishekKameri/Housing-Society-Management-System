package com.housingsociety.ui;

import java.util.List;
import java.util.Scanner;
import com.housingsociety.model.Flat;
import com.housingsociety.service.FlatService;

public class FlatUI {
	private Scanner sc = new Scanner(System.in);
	private FlatService flatService = new FlatService();
	// ==============================================================
	// Dashboard
	// ==============================================================
	public  void flatDashboard() {
		while (true) {
			System.out.print("\033[H\033[2J");
			System.out.flush();
			System.out.println("+=======================================================================+");
			System.out.println("|                                                                       |");
			System.out.println("|                   FLAT  MANAGEMENT MODULE                             |");
			System.out.println("|                                                                       |");
			System.out.println("+=======================================================================+");
			System.out.println();
			System.out.println("                 1. Assign Resident To Vacant Flat");
			System.out.println();
			System.out.println("                 2. View All Flats");
			System.out.println();
			System.out.println("                 3. Search Flat");
			System.out.println();
			System.out.println("                 4. Update Flat Details");
			System.out.println();
			System.out.println("                 5. Flat Statistics");
			System.out.println();
			System.out.println("                 6. Back");
			System.out.println();
			System.out.println("-----------------------------------------------------------------------");
			System.out.print("Enter Choice : ");
			int choice;
			try {
				choice = Integer.parseInt(sc.nextLine());
			} catch (NumberFormatException e) {
				System.out.println("\nInvalid Input.");
				pause();
				continue;
			}
			switch (choice) {
			case 1:
				assignResidentUI();
				break;
			case 2:
				viewAllFlatsUI();
				break;
			case 3:
				searchFlatUI();
				break;
			case 4:
				updateFlatUI();
				break;
			case 5:
				statisticsUI();
				break;
			case 6:
				return;
			default:
				System.out.println("\nInvalid Choice.");
				pause();
			}
		}
	}
	// ==============================================================
	// Assign Resident
	// ==============================================================
	private void assignResidentUI() {
		System.out.print("\033[H\033[2J");
		System.out.flush();
		if (!flatService.hasVacantFlat()) {
			System.out.println("\nNo Vacant Flats Available.");
			pause();
			return;
		}
		flatService.displayVacantFlats();
		System.out.println();
		System.out.print("Enter Flat Number : ");
		String flatNo = sc.nextLine().trim();
		Flat flat = flatService.searchFlat(flatNo);
		if (flat == null) {
			System.out.println("\nFlat Not Found.");
			pause();
			return;
		}
		if (flat.getStatus().equalsIgnoreCase("Occupied")) {
			System.out.println("\nFlat is already Occupied.");
			pause();
			return;
		}
		System.out.println();
		System.out.print("Resident Name : ");
		String residentName = sc.nextLine().trim();
		System.out.println();
		System.out.println("Resident Type");
		System.out.println("1. Owner");
		System.out.println("2. Tenant");
		int type;
		try {
			type = Integer.parseInt(sc.nextLine());
		} catch (Exception e) {
			System.out.println("Invalid Input");
			pause();
			return;
		}
		String residentType = "";
		if (type == 1)
			residentType = "Owner";
		else if (type == 2)
			residentType = "Tenant";
		else {
			System.out.println("Invalid Choice");
			pause();
			return;
		}
		System.out.println();
		System.out.print("Current Number Of Residents : ");
		int members;
		try {
			members = Integer.parseInt(sc.nextLine());
		} catch (Exception e) {
			System.out.println("Invalid Input");
			pause();
			return;
		}
		if (residentType.equalsIgnoreCase("Tenant")
		        && members > flat.getMaxTenantAllowed()) {
		    System.out.println("Maximum Tenant Limit Exceeded.");
		    pause();
		    return;
		}
		boolean status = flatService.assignResident(
				flatNo,
				residentName,
				residentType,
				members,
				0);
		if (status)
			System.out.println("\nResident Assigned Successfully.");
		else
			System.out.println("\nUnable To Assign Resident.");
		pause();
	}
	// View All Flats
	private void viewAllFlatsUI() {
		System.out.print("\033[H\033[2J");
		System.out.flush();
		List<Flat> flats = flatService.getAllFlats();
		if (flats.isEmpty()) {
			System.out.println("\nNo Flat Records Found.");
			pause();
			return;
		}
		System.out.println(
				"+==============================================================================================================================+");
		System.out.println(
				"|                                                ALL FLAT DETAILS                                                             |");
		System.out.println(
				"+==============================================================================================================================+");
		System.out.printf("%-10s %-10s %-20s %-12s %-10s %-10s %-12s%n",
				"Flat No",
				"Type",
				"Resident",
				"Category",
				"Members",
				"Tenant Limit",
				"Status");
		System.out.println(
				"------------------------------------------------------------------------------------------------------------------------------");
		for (Flat flat : flats) {
			System.out.printf("%-10s %-10s %-20s %-12s %-10d %-12s %-12s%n",
					flat.getFlatNumber(),
					flat.getFlatType(),
					flat.getResidentName().isEmpty() ? "-" : flat.getResidentName(),
					flat.getResidentType().isEmpty() ? "-" : flat.getResidentType(),
					flat.getCurrentResidents(),
					flat.getResidentType().equalsIgnoreCase("Tenant")
			        ? flat.getMaxTenantAllowed()
			        : "-",
					flat.getStatus());
		}
		System.out.println(
				"------------------------------------------------------------------------------------------------------------------------------");
		pause();
	}
	// ==============================================================
	// Search Flat
	// ==============================================================
	private void searchFlatUI() {
		System.out.print("\033[H\033[2J");
		System.out.flush();
		System.out.print("Enter Flat Number : ");
		String flatNo = sc.nextLine().trim();
		Flat flat = flatService.searchFlat(flatNo);
		if (flat == null) {
			System.out.println("\nFlat Not Found.");
			pause();
			return;
		}
		System.out.println();
		System.out.println("+==============================================================+");
		System.out.println("|                        FLAT DETAILS                          |");
		System.out.println("+==============================================================+");
		System.out.println("Flat Number        : " + flat.getFlatNumber());
		System.out.println("Flat Type          : " + flat.getFlatType());
		System.out.println("Resident Name      : " + (flat.getResidentName().isEmpty() ? "-" : flat.getResidentName()));
		System.out.println("Resident Type      : " + (flat.getResidentType().isEmpty() ? "-" : flat.getResidentType()));
		System.out.println("Current Residents  : " + flat.getCurrentResidents());
		if (flat.getResidentType().equalsIgnoreCase("Tenant")) {
		    System.out.println("Maximum Tenants Allowed : "
		            + flat.getMaxTenantAllowed());
		}
		System.out.println("Status             : " + flat.getStatus());
		pause();
	}
	// ==============================================================
	// Statistics
	// ==============================================================
	private void statisticsUI() {
		System.out.print("\033[H\033[2J");
		System.out.flush();
		flatService.displayStatistics();
		pause();
	}
	// ==============================================================
	// Update Flat Details
	// ==============================================================
	private void updateFlatUI() {
		System.out.print("\033[H\033[2J");
		System.out.flush();
		System.out.print("Enter Flat Number : ");
		String flatNo = sc.nextLine().trim();
		Flat flat = flatService.searchFlat(flatNo);
		if (flat == null) {
			System.out.println("\nFlat Not Found.");
			pause();
			return;
		}
		while (true) {
			System.out.print("\033[H\033[2J");
			System.out.flush();
			printFlatDetails(flat);
			int choice;
			try {
				choice = Integer.parseInt(sc.nextLine());
			} catch (Exception e) {
				System.out.println("\nInvalid Input.");
				pause();
				continue;
			}
			switch (choice) {
			case 1:
				System.out.print("\nEnter New Resident Name : ");
				String name = sc.nextLine().trim();
				if (flatService.updateResidentName(flatNo, name)) {
					System.out.println("\nResident Name Updated Successfully.");
				} else {
					System.out.println("\nUnable To Update.");
				}
				pause();
				break;
			case 2:
				System.out.println();
				System.out.println("1. Owner");
				System.out.println("2. Tenant");
				System.out.print("\nEnter Choice : ");
				int type;
				try {
					type = Integer.parseInt(sc.nextLine());
				} catch (Exception e) {
					System.out.println("Invalid Input");
					pause();
					continue;
				}
				String residentType = "";
				if (type == 1)
					residentType = "Owner";
				else if (type == 2)
					residentType = "Tenant";
				else {
					System.out.println("Invalid Choice");
					pause();
					continue;
				}
				flatService.updateResidentType(flatNo, residentType);
				System.out.println("\nResident Type Updated Successfully.");
				pause();
				break;
			case 3:
				System.out.print("\nEnter Current Residents : ");
				int count;
				try {
					count = Integer.parseInt(sc.nextLine());
				} catch (Exception e) {
					System.out.println("Invalid Input");
					pause();
					continue;
				}
				if (flat.getResidentType().equalsIgnoreCase("Tenant")) {
				    if (flatService.updateResidentCount(flatNo, count)) {
				        System.out.println("\nResident Count Updated Successfully.");
				    } else {
				        System.out.println("\nMaximum Tenant Limit Exceeded.");
				    }
				} else {
				    flat.setCurrentResidents(count);
				    System.out.println("\nResident Count Updated Successfully.");
				}
				pause();
				break;
			case 4:
				if (flatService.vacateFlat(flatNo)) {
					System.out.println("\nFlat Vacated Successfully.");
				} else {
					System.out.println("\nUnable To Vacate Flat.");
				}
				pause();
				return;
			case 0:
				return;
			default:
				System.out.println("\nInvalid Choice.");
				pause();
			}
		}
	}
	// ==============================================================
	// Print Flat Details
	// ==============================================================
	private void printFlatDetails(Flat flat) {
		System.out.println("+==============================================================+");
		System.out.println("|                     UPDATE FLAT DETAILS                      |");
		System.out.println("+==============================================================+");
		System.out.println("Flat Number        : " + flat.getFlatNumber());
		System.out.println("Flat Type          : " + flat.getFlatType());
		System.out.println("Resident Name      : " + (flat.getResidentName().isEmpty() ? "-" : flat.getResidentName()));
		System.out.println("Resident Type      : " + (flat.getResidentType().isEmpty() ? "-" : flat.getResidentType()));
		System.out.println("Current Residents  : " + flat.getCurrentResidents());
		if (flat.getResidentType().equalsIgnoreCase("Tenant")) {
		    System.out.println("Maximum Tenants Allowed : "
		            + flat.getMaxTenantAllowed());
		}
		System.out.println("Status             : " + flat.getStatus());
		System.out.println();
		System.out.println("1. Change Resident Name");
		System.out.println("2. Change Resident Type");
		System.out.println("3. Change Resident Count");
		System.out.println("4. Vacate Flat");
		System.out.println("0. Back");
		System.out.println();
		System.out.print("Enter Choice : ");
	}
	// ==============================================================
	// Pause
	// ==============================================================
	private void pause() {
		System.out.println();
		System.out.print("Press Enter to continue...");
		sc.nextLine();
	}
}


