package com.housingsociety.model;

import java.time.LocalDate;

public class Owner extends Resident {

	@Override
	public void displayResidentType() {
		// TODO Auto-generated method stub
		
	}

	public Owner() {
		super();
		// TODO Auto-generated constructor stub
	}

	public Owner(int residentId, String firstName, String lastName, int age, String gender, String bloodGroup,
			String email, String aadhaarNumber, String occupation, String mobileNumber, String flatNumber,
			LocalDate moveInDate, LocalDate moveOutDate, String emergencyContact, String status) {
		super(residentId, firstName, lastName, age, gender, bloodGroup, email, aadhaarNumber, occupation, mobileNumber,
				flatNumber, moveInDate, moveOutDate, emergencyContact, status);
		// TODO Auto-generated constructor stub
	}

 
	

}
