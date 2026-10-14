package com.housingsociety.model;

import java.time.LocalDate;
 

public abstract class Resident {

	private int residentId;
	private String firstName;
	private String lastName;
	private int age;
	private String gender;
	private String bloodGroup;  //(optional) i will change it is future
	
	private String email;
	private String aadhaarNumber;
	private String occupation;
	private String mobileNumber;
	
	private String flatNumber;
	private LocalDate moveInDate;
	private LocalDate moveOutDate;
	
	
	private String emergencyContact;
	private String status;
	
	public Resident() {
		
	}
	
	
	public Resident(int residentId, String firstName, String lastName, int age, String gender, String bloodGroup,
			String email, String aadhaarNumber, String occupation, String mobileNumber, String flatNumber, LocalDate moveInDate,
			LocalDate moveOutDate, String emergencyContact, String status) 
	{
		super();
		this.residentId = residentId;
		this.firstName = firstName;
		this.lastName = lastName;
		this.age = age;
		this.gender = gender;
		this.bloodGroup = bloodGroup;
		this.email = email;
		this.mobileNumber = mobileNumber;
		this.aadhaarNumber = aadhaarNumber;
		this.occupation = occupation;
		this.flatNumber = flatNumber;
		this.moveInDate = moveInDate;
		this.moveOutDate = moveOutDate;
		this.emergencyContact = emergencyContact;
		this.status = status;
	}
	
	public abstract void displayResidentType();
	 
	public void residentBasicInfo() {
		
		System.out.println("Resident ID         : " + residentId);
		System.out.println("First Name          : " + firstName);
		System.out.println("Last Name           : " + lastName);
		System.out.println("Age                 : " + age); 
		System.out.println("Gender              : " + gender);
		System.out.println("BloodGroup          : " + bloodGroup);
		System.out.println("Email               : " + email);
		System.out.println("Mobile Number       : " + mobileNumber);
		System.out.println("Occupation          : " + occupation);
		System.out.println("Flat Number         : " + flatNumber);
		System.out.println("Move In Date        : " + moveInDate);
		System.out.println("Move Out Date       : " + moveOutDate);
		System.out.println("Status              : " + status);
		
	}
	
	// Getters and setters

	public int getResidentId() {
		return residentId;
	}

	public void setResidentId(int residentId) {
		this.residentId = residentId;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}

	public String getGender() {
		return gender;
	}

	public void setGender(String gender) {
		this.gender = gender;
	}

	public String getBloodGroup() {
		return bloodGroup;
	}

	public void setBloodGroup(String bloodGroup) {
		this.bloodGroup = bloodGroup;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getAadhaarNumber() {
		return aadhaarNumber;
	}

	public void setAadhaarNumber(String aadhaarNumber) {
		this.aadhaarNumber = aadhaarNumber;
	}

	public String getOccupation() {
		return occupation;
	}

	public void setOccupation(String occupation) {
		this.occupation = occupation;
	}

	public String getMobileNumber() {
		return mobileNumber;
	}

	public void setMobileNumber(String mobileNumber) {
		this.mobileNumber = mobileNumber;
	}

	public String getFlatNumber() {
		return flatNumber;
	}

	public void setFlatNumber(String flatNumber) {
		this.flatNumber = flatNumber;
	}

	public LocalDate getMoveInDate() {
		return moveInDate;
	}

	public void setMoveInDate(LocalDate moveInDate) {
		this.moveInDate = moveInDate;
	}

	public LocalDate getMoveOutDate() {
		return moveOutDate;
	}

	public void setMoveOutDate(LocalDate moveOutDate) {
		this.moveOutDate = moveOutDate;
	}

	public String getEmergencyContact() {
		return emergencyContact;
	}

	public void setEmergencyContact(String emergencyContact) {
		this.emergencyContact = emergencyContact;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
}

