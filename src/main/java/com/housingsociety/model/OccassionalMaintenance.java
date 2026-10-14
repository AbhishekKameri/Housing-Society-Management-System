package com.housingsociety.model;

import java.util.HashMap;

public class OccassionalMaintenance extends Maintenance {
	 private String occationalEventName;
	 private HashMap<String, Double> occationalCharges = new HashMap<>();
	 private double AmountPaid;
	 private int eventId;
	 
	 private double subTotalOccationalCharg;
	 private String eventDescription;
	 private static int totalBills = 0;
	 private static double totalAmount = 0;
	 private static double collectedAmount = 0;
	 private static double pendingAmount = 0;
	 
	 
	public static int getTotalBills() {
		return totalBills;
	}
	public static void setTotalBills(int totalBills) {
		OccassionalMaintenance.totalBills = totalBills;
	}
	public static double getTotalAmount() {
		return totalAmount;
	}
	public static void setTotalAmount(double totalAmount) {
		OccassionalMaintenance.totalAmount = totalAmount;
	}
	public static double getCollectedAmount() {
		return collectedAmount;
	}
	public static void setCollectedAmount(double collectedAmount) {
		OccassionalMaintenance.collectedAmount = collectedAmount;
	}
	public static double getPendingAmount() {
		return pendingAmount;
	}
	public static void setPendingAmount(double pendingAmount) {
		OccassionalMaintenance.pendingAmount = pendingAmount;
	}
	public String getOccationalEventName() {
		return occationalEventName;
	}
	public void setOccationalEventName(String occationalEventName) {
		this.occationalEventName = occationalEventName;
	}
	public HashMap<String, Double> getOccationalCharges() {
		return occationalCharges;
	}
	public void setOccationalCharges(HashMap<String, Double> occationalCharges) {
		this.occationalCharges = occationalCharges;
	}
	public double getAmountPaid() {
		return AmountPaid;
	}
	public void setAmountPaid(double amountPaid) {
		AmountPaid = amountPaid;
	}
	public double getSubTotalOccationalCharg() {
		return subTotalOccationalCharg;
	}
	public void setSubTotalOccationalCharg(double subTotalOccationalCharg) {
		this.subTotalOccationalCharg = subTotalOccationalCharg;
	}
	public int getEventId() {
		return eventId;
	}
	public void setEventId(int eventId) {
		this.eventId = eventId;
	}
	public String getEventDescription() {
		return eventDescription;
	}
	public void setEventDescription(String eventDescription) {
		this.eventDescription = eventDescription;
	}
	 
}
