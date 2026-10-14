<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
  <%@ page import="com.housingsociety.model.*, com.housingsociety.dao.*, com.housingsociety.service.*"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Monthly Maintenance Receipt</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/site.css">
<link rel="stylesheet" href="../css/bill.css"/>
</head>
<body>

<%-- ============ SIDEBAR (shared include) ============ --%>
<%@ include file="../sidebar.jsp" %>

<div class="main" id="mainContent">

<%
    request.setAttribute("pageTitle", "Bill Receipt");
    request.setAttribute("pageDescription", "Monthly maintenance receipt / tax invoice for this bill.");
%>

<%-- ============ PAGE HEADER (shared include) ============ --%>
<%@ include file="../pageHeader.jsp" %>

<%
MaintenanceDao md = new MaintenanceDao();
MaintenanceService ms = new MaintenanceService();

String ownerName = request.getParameter("ownerName");
String billId = request.getParameter("billId");

MonthlyMaintenance m = md.getBillById(billId);

if (m == null) {
%>
    <div class="receipt-container">
        <div class="header">
            <h1>Green Valley Apartments Co-operative Housing Society Ltd.</h1>
            <p>Monthly Maintenance Receipt / Tax Invoice</p>
        </div>
        <p style="text-align:center;padding:30px 0;">
            No bill found for ID "<%= billId %>". It may have been deleted, or the link is out of date.
        </p>
        <div class="btn-container">
            <a href="monthlyMaintenance.jsp" class="action-btn">&larr; Back to Bills</a>
        </div>
    </div>
<%
} else {
    double netAmount = m.isPaymentStatus()?m.getNetAmount():ms.getNetAmount(m);
   
%>

<div class="receipt-container">
    <%if(m.isPaymentStatus()){ %>
    <div class="status-badge status-paid">Paid</div>
   <% }
    else{ %>
    <div class="status-badge status-unpaid">Unpaid</div>
 <%} %>
    <div class="header">
        <h1>Green Valley Apartments Co-operative Housing Society Ltd.</h1>
        <p>Monthly Maintenance Receipt / Tax Invoice</p>
    </div>

    <div class="info-section">
        <!-- Resident Details -->
        <div class="info-block">
            <h3>Resident Details</h3>
            <div class="info-row">
                <span class="label">Owner Name:</span>
                <span> <%= ownerName%></span>
            </div>
            <div class="info-row">
                <span class="label">Flat Number:</span>
                <span> <%=m.getFlatNum() %></span>
            </div>
            <div class="info-row">
                <span class="label">Resident ID:</span>
                <span> <%=m.getResidentId() %></span>
            </div>
        </div>

		
        <!-- Invoice Details -->
        <div class="info-block">
            <h3>Invoice Details</h3>
            <div class="info-row">
                <span class="label">Bill ID:</span>
                <span><%=m.getBillId() %></span>
            </div>
            <div class="info-row">
                <span class="label">Generated Date:</span>
                <span><%=m.getGeneratedDate() %></span>
            </div>
            <div class="info-row">
                <span class="label">Due Date:</span>
                <span><%= m.getDueDate() %></span>
            </div>
            <div class="info-row">
                <span class="label">Days Overdue:</span>
                <span><%= m.getDueDays() %></span>
            </div>
        </div>
    </div>

    <!-- Charges Table -->
    <table class="line-items">
        <thead>
            <tr>
                <th>Description of Charges</th>
                <th class="amount-header">Amount </th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>Maintenance Charges</td>
                <td class="amount"><%=m.getMaintenanceAmount() %></td> <!-- maintenance_amount -->
            </tr>
            <tr>
                <td>Electricity Charges (Common Area)</td>
                <td class="amount"><%=m.getElectricityCharges() %></td> <!-- electricity_charges -->
            </tr>
            <tr>
                <td>Water Charges</td>
                <td class="amount"><%=m.getWaterCharges() %></td> <!-- water_charges -->
            </tr>
            <tr>
                <td>Security Charges</td>
                <td class="amount"><%=m.getSecurityCharges() %></td> <!-- security_charges -->
            </tr>
            <tr>
                <td>Parking Charges</td>
                <td class="amount"><%=m.getParkingCharges() %></td> <!-- parking_charges -->
            </tr>
            <tr>
                <td>Other / Miscellaneous Charges</td>
                <td class="amount"><%=m.getOtherCharges() %></td> <!-- other_charges -->
            </tr>
        </tbody>
    </table>

    <!-- Totals & Taxes -->
    <div class="totals-section">
        <div class="totals-box">
            <div class="totals-row">
                <span class="label">Subtotal:</span>
                <span class="amount"><%=ms.getSubTotal(m) %></span>
            </div>
            
            <div class="totals-row">
                <span class="label">Late Fee:</span>
                <span class="amount"> <%=m.getLateFee() %></span> <!-- late_fee -->
            </div>
            
            
            <div class="totals-row">
                <span class="label">GST :</span>
                <span class="amount"> <%=m.getGST() %></span> <!-- GST -->
            </div>
            <div class="totals-row">
                <span class="label">Amount Paid:</span>
                <span class="amount"><%=m.getAmountPaid() %></span> <!-- GST -->
            </div>
            <div class="totals-row grand-total">
                <span>Net Amount:</span>
                <span><%=netAmount %></span> <!-- net_amount -->
            </div>
        </div>
        
    </div>
<% if(!m.isPaymentStatus()){ %> 
        <div class="btn-container">
        
		<a href="<%= request.getContextPath() %>/UpdateBill?billId=<%= billId %>&amount=<%=m.getNetAmount() %>&type=updateStatus"
  		 class="action-btn"> Pay</a>
        </div>
        <%} %>
    <div class="footer">
        <p>Thank you for your timely payment.</p>
        <p>This is a computer-generated receipt and does not require a physical signature.</p>
        <p>&copy; 2025 Green Valley Apartments Co-operative Housing Society Ltd.</p>
    </div>
</div>
<% } %>

</div>

</body>
</html>
