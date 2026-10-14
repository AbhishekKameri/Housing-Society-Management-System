package com.housingsociety.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.housingsociety.dao.FlatDao;

 
@WebServlet("/DeleteOwner")
public class DeleteOwner extends HttpServlet {
	private static final long serialVersionUID = 1L;
  
 
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		 
		
		
	}

	 
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		if(FlatDao.deletOwner(Integer.parseInt(request.getParameter("ownerId"))) > 0) {
			 request.getRequestDispatcher(request.getContextPath()+"/Flat/flat-management.jsp").forward(request, response);
		 }
	}

}
