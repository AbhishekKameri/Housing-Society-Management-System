package com.housingsociety.model;

public class Flat {
	private String flatNumber;
	private String flatType;
	// Resident Details
	private String residentName;
	private String residentType; // Owner / Tenant
	private int currentResidents;
	private int maxTenantAllowed;
	private int linkedResidentId;
	private int floor;
	private String status; // Occupied / Vacant
	
	
	
	public Flat() {
		
	}
	public Flat(String flatNumber, String flatType, String residentName, String residentType, int currentResidents,
			int maxTenantAllowed, int linkedResidentId, String status) {
		 
		this.flatNumber = flatNumber;
		this.flatType = flatType;
		this.residentName = residentName;
		this.residentType = residentType;
		this.currentResidents = currentResidents;
		this.maxTenantAllowed = maxTenantAllowed;
		this.linkedResidentId = linkedResidentId;
		this.status = status;
	}
	public Flat(String flatNumber, String flatType, String residentName,
			  int linkedResidentId, String status, int floor) {
		 
		this.flatNumber = flatNumber;
		this.flatType = flatType;
		this.residentName = residentName;
		this.linkedResidentId = linkedResidentId;
		this.status = status;
		this.floor = floor;
		
	}
	
	
	public String getFlatNumber() {
		return flatNumber;
	}
	public void setFlatNumber(String flatNumber) {
		this.flatNumber = flatNumber;
	}
	public String getFlatType() {
		return flatType;
	}
	public void setFlatType(String flatType) {
		this.flatType = flatType;
	}
	public String getResidentName() {
		return residentName;
	}
	public void setResidentName(String residentName) {
		this.residentName = residentName;
	}
	public String getResidentType() {
		return residentType;
	}
	public void setResidentType(String residentType) {
		this.residentType = residentType;
	}
	public int getCurrentResidents() {
		return currentResidents;
	}
	public void setCurrentResidents(int currentResidents) {
		this.currentResidents = currentResidents;
	}
	public int getMaxTenantAllowed() {
		return maxTenantAllowed;
	}
	public void setMaxTenantAllowed(int maxTenantAllowed) {
		this.maxTenantAllowed = maxTenantAllowed;
	}
	public int getLinkedResidentId() {
		return linkedResidentId;
	}
	public void setLinkedResidentId(int linkedResidentId) {
		this.linkedResidentId = linkedResidentId;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public int getFloor() {
		return floor;
	}
	public void setFloor(int floor) {
		this.floor = floor;
	}
	
	

}
