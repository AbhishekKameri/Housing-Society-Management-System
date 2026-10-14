package com.housingsociety.model;

import java.time.LocalDate;
import java.time.temporal.Temporal;
import java.util.HashMap;

public  class Maintenance {
	 
	private int residentId;
	private String flatNum;
	private double fine = 20;
	private double netAmount;
	private double amountPaid;
	private boolean paymentStatus;
	private LocalDate generatedDate;
	private LocalDate dueDate;
	private String billId;
	private String billNumber;
	private double GST;
	private static double GSTRate = 18;
	private int dueDays;
	private double lateFee;
	 
	
	 public static double getTotal_bills() {
		return total_bills;
	}

	public static void setTotal_bills(double total_bills) {
		Maintenance.total_bills = total_bills;
	}

	public static double getTotal_amount() {
		return total_amount;
	}

	public static void setTotal_amount(double total_amount) {
		Maintenance.total_amount = total_amount;
	}

	public static double getCollected() {
		return collected;
	}

	public static void setCollected(double collected) {
		Maintenance.collected = collected;
	}

	public static double getPending() {
		return pending;
	}

	public static void setPending(double pending) {
		Maintenance.pending = pending;
	}

	static private double total_bills;
	 static private double total_amount;
	 static private double collected;
	 static private double pending;

	
	
	public int getResidentId() {
		return residentId;
	}

	public void setResidentId(int residentId) {
		this.residentId = residentId;
	}

	public String getFlatNum() {
		return flatNum;
	}

	public void setFlatNum(String flatNum) {
		this.flatNum = flatNum;
	}

	public double getFine() {
		return fine;
	}

	public void setFine(double fine) {
		this.fine = fine;
	}

	public double getNetAmount() {
		return netAmount;
	}

	public void setNetAmount(double netAmount) {
		this.netAmount = netAmount;
	}

	public boolean isPaymentStatus() {
		return paymentStatus;
	}

	public void setPaymentStatus(boolean paymentStatus) {
		this.paymentStatus = paymentStatus;
	}

	public LocalDate getGeneratedDate() {
		return generatedDate;
	}

	public void setGeneratedDate(LocalDate generatedDate) {
		this.generatedDate = generatedDate;
	}

	public LocalDate getDueDate() {
		return dueDate;
	}

	public void setDueDate(LocalDate dueDate) {
		this.dueDate = dueDate;
	}

	 

	public double getGST() {
		return GST;
	}

	public void setGST(double gST) {
		GST = gST;
	}

	public double getGSTRate() {
		return GSTRate;
	}

	public void setGSTRate(double gSTRate) {
		GSTRate = gSTRate;
	}

	public int getDueDays() {
		return dueDays;
	}

	public void setDueDays(int dueDays) {
		this.dueDays = dueDays;
	}

	public double getLateFee() {
		return lateFee;
	}

	public void setLateFee(double lateFee) {
		this.lateFee = lateFee;
	}

	public double getAmountPaid() {
		return amountPaid;
	}

	public void setAmountPaid(double amountPaid) {
		this.amountPaid = amountPaid;
	}

	public String getBillNumber() {
		return billNumber;
	}

	public void setBillNumber(String billNumber) {
		this.billNumber = billNumber;
	}

	public String getBillId() {
		return billId;
	}

	public void setBillId(String billId) {
		this.billId = billId;
	}

}
