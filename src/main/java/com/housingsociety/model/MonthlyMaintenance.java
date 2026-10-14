package com.housingsociety.model;

public class MonthlyMaintenance extends Maintenance{
	 private double maintenanceAmount;
	 private double electricityCharges;
	 private double waterCharges;
	 private double parkingCharges;
	 private double otherCharges;
	 private double securityCharges;
	 private double subTotalAmount;
	 private static int totalBills = 0;
	 private static double totalAmount = 0;
	 private static double collectedAmount = 0;
	 private static double pendingAmount = 0;
	 
	public static int getTotalBills() {
		return totalBills;
	}
	public static void setTotalBills(int totalBills) {
		MonthlyMaintenance.totalBills = totalBills;
	}
	public static double getTotalAmount() {
		return totalAmount;
	}
	public static void setTotalAmount(double totalAmount) {
		MonthlyMaintenance.totalAmount = totalAmount;
	}
	public static double getCollectedAmount() {
		return collectedAmount;
	}
	public static void setCollectedAmount(double collectedAmount) {
		MonthlyMaintenance.collectedAmount = collectedAmount;
	}
	public static double getPendingAmount() {
		return pendingAmount;
	}
	public static void setPendingAmount(double pendingAmount) {
		MonthlyMaintenance.pendingAmount = pendingAmount;
	}
	public double getMaintenanceAmount() {
		return maintenanceAmount;
	}
	public void setMaintenanceAmount(double maintenanceAmount) {
		this.maintenanceAmount = maintenanceAmount;
	}
	public double getElectricityCharges() {
		return electricityCharges;
	}
	public void setElectricityCharges(double electricityCharges) {
		this.electricityCharges = electricityCharges;
	}
	public double getWaterCharges() {
		return waterCharges;
	}
	public void setWaterCharges(double waterCharges) {
		this.waterCharges = waterCharges;
	}
	public double getParkingCharges() {
		return parkingCharges;
	}
	public void setParkingCharges(double parkingCharges) {
		this.parkingCharges = parkingCharges;
	}
	public double getOtherCharges() {
		return otherCharges;
	}
	public void setOtherCharges(double otherCharges) {
		this.otherCharges = otherCharges;
	}
	public double getSecurityCharges() {
		return securityCharges;
	}
	public void setSecurityCharges(double securityCharges) {
		this.securityCharges = securityCharges;
	}
	public double getSubTotalAmount() {
		return subTotalAmount;
	}
	public void setSubTotalAmount(double subTotalAmount) {
		this.subTotalAmount = subTotalAmount;
	}
	 
}
