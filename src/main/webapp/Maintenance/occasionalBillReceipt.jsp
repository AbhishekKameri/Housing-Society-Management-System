<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.time.LocalDate, java.time.format.DateTimeFormatter"%>
<%@ page import="com.housingsociety.service.*,com.housingsociety.dao.*"%>
<%@ page import="java.util.*"%>
<%
request.setAttribute("pageTitle", "Occasional Bill");
request.setAttribute("pageDescription", "Itemised occasional maintenance bill for a resident.");
String billId = request.getParameter("billId");
MaintenanceService ms = new MaintenanceService();
MaintenanceDao md = new MaintenanceDao();
Map<String, String> billData = ms.getOccassionalBillData(billId);
// ---- Demo bill data (swap this block for a real DAO lookup / request params) ----
Map<String, String> data = ms.getOccassionalBillData(billId);
String eventName = data.get("eventName");
String residentName = data.get("residentName");
String residentId = data.get("residentId");
String flatNumber = data.get("flatNumber");
String generatedDate = data.get("generatedDate");
String paymentStatus = data.get("paymentStatus").equals("0") ? "Unpaid" : "Paid";
String payment=null;
double gstRate =  Double.parseDouble(data.get("gstRate"));
// Charge breakdown — same shape as the Occasional Maintenance "Charges Breakdown" tab
Object[][] charges = ms.getEventChargesObject(billId);



double subTotal =  Double.parseDouble(data.get("subTotal"));
 
double gstAmount = subTotal * (gstRate / 100);
double netAmount = subTotal + gstAmount;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Occasional Bill · <%=eventName%> · Society HMS
</title>

<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/site.css">
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/css/receipt.css">
</head>
<body>

	<%-- ============ SIDEBAR (shared include) ============ --%>
	<%@ include file="../sidebar.jsp"%>

	<!-- ============ MAIN ============ -->
	<div class="main" id="mainContent">

		<%-- ============ PAGE HEADER (shared include) ============ --%>
		<%@ include file="../pageHeader.jsp"%>

		<!-- ---- Action bar (hidden on print) ---- -->
		<div class="receipt-actions no-print">
			<button type="button" class="btn-secondary"
				onclick="location.href='occasionalMaintenance.jsp'">
				<i class="bi bi-arrow-left"></i> Back to Bills
			</button>
			<div style="display: flex; gap: 10px;">
				<button type="button" class="btn-secondary" id="downloadBtn">
					<i class="bi bi-download"></i> Download PDF
				</button>
				<button type="button" class="btn-primary" id="printBtn">
					<i class="bi bi-printer"></i> Print Bill
				</button>
			</div>
		</div>

		<!-- ================= Bill card ================= -->
		<section class="receipt-wrap">
			<div class="receipt-card" id="billCard">

				<div class="receipt-head">
					<div class="receipt-brand">
						<span class="receipt-brand-icon"><i class="bi bi-buildings"></i></span>
						<div>
							<div class="receipt-brand-name">Green Valley Apartments</div>
							<div class="receipt-brand-sub">Co-operative Housing Society
								Ltd.</div>
						</div>
					</div>
					<div class="receipt-meta">
						<div class="receipt-title">OCCASIONAL BILL</div>
						<div class="receipt-meta-row">
							<span>Event</span><b><%=eventName%></b>
						</div>
						<div class="receipt-meta-row">
							<span>Generated Date</span><b><%=generatedDate%></b>
						</div>
					</div>
				</div>

				<div class="receipt-divider"></div>

				<div class="receipt-parties">
					<div>
						<div class="receipt-label">Resident Name</div>
						<div class="receipt-value-lg"><%=residentName%></div>
						 
					</div>
					<div class="container-btn">
					<div>
						<div class="receipt-label">Resident Id</div>
						<div class="receipt-value-lg"><%=residentId%></div>
					</div>
					<div>
						<div class="receipt-label">Flat Number</div>
						<div class="receipt-value-lg"><%=flatNumber%></div>
					</div>
					<div class="status">
						<div class="receipt-label">Status</div>
						<div class="<%=paymentStatus%>"><%=paymentStatus%></div>
					</div>
					</div>
					
				</div>

				<div class="receipt-divider"></div>

				<table class="breakdown-table receipt-table">
					<thead>
						<tr>
							<th>Sr. No.</th>
							<th>Particulars</th>
							<th class="num">Amount (&#8377;)</th>
						</tr>
					</thead>
					<tbody>
						<%
						for (int i = 0; i < charges.length; i++) {
						%>
						<tr>
							<td><%=i + 1%></td>
							<td><%=charges[i][0]%></td>
							<td class="num"><%=String.format("%,.2f", (Double) charges[i][1])%></td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>

				<div class="receipt-summary">
					<div class="receipt-summary-row">
						<span>Sub Total</span><span>&#8377;<%=String.format("%,.2f", subTotal)%></span>
					</div>
					<div class="receipt-summary-row">
						<span>GST (<%=(int) gstRate%>%)
						</span><span>&#8377;<%=String.format("%,.2f", gstAmount)%></span>
					</div>
					<div class="receipt-summary-row total">
						<span>Net Amount</span><span>&#8377;<%=String.format("%,.2f", netAmount)%></span>
					</div>
				</div>
			
				<div class="receipt-net-bar">
				 
				<%if(paymentStatus.equalsIgnoreCase("Paid")){
					   payment="Paid";
					%>
				<%}else{ 
				   payment="Payable" ;
				} %>
			<span> Amount <%=payment %></span> 		<%
				if (paymentStatus.equalsIgnoreCase("Unpaid")) {
				%>
				 
				<form action="<%=request.getContextPath()%>/UpdateBill"
						method="post" onsubmit="return confirm('Confirm Payment. ');">
						<input type="hidden" value="<%=billId%>" name="billId"> <input
							type="hidden" value="updateOccasionalPaymentStatus"
							name="type">
						<input type = "hidden" value="<%=netAmount %>" name="amount">
						<button type="submit" class="btn">
							<i class="bi bi-check-circle"></i>Pay

						</button>
					</form> <%
				}
				%><span>&#8377;<%=String.format("%,.2f", netAmount)%></span>
				</div>

				<div class="receipt-footer">
					<p>This is a computer-generated bill and does not require a
						physical signature.</p>
					<p>For questions about this bill, contact the society office at
						admin@society.com.</p>
				</div>
			</div>
		</section>

		<footer class="site-footer no-print">
			<span>&copy; 2025 Green Valley Apartments Co-operative Housing
				Society Ltd. All rights reserved.</span> <span><a href="#">Help</a>
				&nbsp;|&nbsp; <a href="#">Privacy Policy</a> &nbsp;|&nbsp; <a
				href="#">Terms of Use</a></span>
		</footer>
	</div>

	<script src="<%=request.getContextPath()%>/js/receipt.js"></script>
</body>
</html>
