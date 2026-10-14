package com.housingsociety.controller;

import java.io.IOException;
import java.time.LocalDate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.housingsociety.dao.FlatDao;
import com.housingsociety.model.Owner;
import com.housingsociety.model.Resident;

 
@WebServlet("/UpdateOwner")
public class UpdateOwner extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
     
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 Resident resident = null;
 
		 int residentId = Integer.parseInt(request.getParameter("residentId"));
		 
		 int age = Integer.parseInt(request.getParameter("age"));
		 LocalDate moveInDate = null;
		 LocalDate moveOutDate = null;
				 
				 if(request.getParameter("moveOutDate").toString().length() > 6) {
					 moveInDate = LocalDate.parse(request.getParameter("moveOutDate"));
				 }
				 if(request.getParameter("moveInDate").toString().length() > 6) {
					 moveOutDate = LocalDate.parse(request.getParameter("moveInDate"));
				 }
		 resident = new Owner(residentId,request.getParameter("firstName"),
				 request.getParameter("lastName"),age,request.getParameter("gender"),request.getParameter("bloodGroup"),
				 request.getParameter("email"),request.getParameter("aadharNumber"),request.getParameter("occupation"),request.getParameter("mobileNumber"),
				 request.getParameter("flatNumber") , moveInDate,moveOutDate,request.getParameter("emergencyContact"),request.getParameter("status"));
		int result = FlatDao.updateOwner(resident);
		
		if(result > 0) {
			response.sendRedirect(request.getContextPath()+"/Flat/view-owner.jsp?id="+resident.getResidentId());
		}
	}

	
	
	
	
	
	
	
	
	
	
	
	
	
}
