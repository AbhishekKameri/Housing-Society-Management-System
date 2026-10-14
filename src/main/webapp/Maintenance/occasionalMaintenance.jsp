<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.time.LocalDate, java.time.format.DateTimeFormatter"%>
<%@ page
	import="com.housingsociety.model.*, com.housingsociety.dao.*, com.housingsociety.service.*"%>
<%@ page import="java.util.*"%>
<%
request.setAttribute("pageTitle", "Occasional Maintenance");
request.setAttribute("pageDescription", "Manage occasional maintenance bills for special events and expenses.");

// ---- Demo bill rows: {billId, eventName, date, totalAmount, paid, status} ----
MaintenanceDao md = new MaintenanceDao();
MaintenanceService ms = new MaintenanceService();
// ms.getTotalOccassionalBillCount(); 
Object[][] bills = ms.getOccassionalData();

int totalBills = OccassionalMaintenance.getTotalBills();
double totalAmount = OccassionalMaintenance.getTotalAmount();
double collectedAmount = OccassionalMaintenance.getCollectedAmount();
double pendingAmount = OccassionalMaintenance.getPendingAmount();

// Flats available for the "Select Specific Flat(s)" picker
String[] allFlats = ms.getOccupiedFlatNumbers();
		
		 
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Occasional Maintenance · Society HMS</title>

<!-- Bootstrap Icons — used throughout sidebar.jsp / pageHeader.jsp -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">

<link rel="stylesheet" href="<%=request.getContextPath()%>/css/site.css">
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/css/occasional-maintenance.css">
</head>
<body>

	<%-- ============ SIDEBAR (shared include) ============ --%>
	<%@ include file="../sidebar.jsp"%>

	<!-- ============ MAIN ============ -->
	<div class="main" id="mainContent">

		<%-- ============ PAGE HEADER (shared include — reads pageTitle/pageDescription set above) ============ --%>
		<%@ include file="../pageHeader.jsp"%>

			<div class="header-right"
			style="align-items: flex-end; margin-bottom: 16px;">
			<a
				href="<%=request.getContextPath()%>/Maintenance/add-occassional.jsp"><button
					type="button" class="btn-primary" id="createBillBtn">
					<i class="bi bi-plus-lg"></i> Add Event
				</button></a>
		</div>
		<!-- ---- Stat cards ---- -->
		<section class="stats">
			<div class="stat-card">
				<div class="stat-icon indigo">
					<i class="bi bi-calendar2-event"></i>
				</div>
				<div>
					<div class="stat-label">Total Bills</div>
					<div class="stat-value"><%=totalBills%></div>
				</div>
			</div>
			<div class="stat-card">
				<div class="stat-icon teal">
					<i class="bi bi-currency-rupee"></i>
				</div>
				<div>
					<div class="stat-label">Total Amount</div>
					<div class="stat-value">
						&#8377;<%=String.format("%,.0f", totalAmount)%></div>
				</div>
			</div>
			<div class="stat-card">
				<div class="stat-icon purple">
					<i class="bi bi-check-circle"></i>
				</div>
				<div>
					<div class="stat-label">Collected</div>
					<div class="stat-value">
						&#8377;<%=String.format("%,.0f", collectedAmount)%></div>
				</div>
			</div>
			<div class="stat-card">
				<div class="stat-icon pink">
					<i class="bi bi-hourglass-split"></i>
				</div>
				<div>
					<div class="stat-label">Pending</div>
					<div class="stat-value">
						&#8377;<%=String.format("%,.0f", pendingAmount)%></div>
				</div>
			</div>
		</section>

		<!-- ---- Header action ---- -->
	

		<!-- ---- Content grid: bills table + create/view panel ---- -->
		<section class="content-grid">

			<!-- ================= Bills table ================= -->
			<div class="card">
				<div class="card-title-row">
					<h2 class="card-title" style="margin: 0;">Occasional
						Maintenance Bills</h2>
				 
				</div>

				<div class="table-toolbar">
					<div class="search-box">
						<i class="bi bi-search"></i> <input type="text" id="billSearch"
							placeholder="Search by event name, bill ID or flat number...">
					</div>
					<select id="statusFilter" class="select-field">
						<option value="all">All Status</option>
						<option value="paid">Paid</option>
						<option value="pending">Pending</option>

					</select> <select id="eventFilter" class="select-field">
						<option value="all">All Events</option>
						<%
						for (Object[] b : bills) {
						%>
						<option value="<%=((String) b[1]).toLowerCase()%>"><%=b[1]%></option>
						<%
						}
						%>
					</select>
				</div>

				<div class="table-scroll">
					<table id="billsTable">
						<thead>
							<tr>
								<th>Bill ID</th>
								<th>Event Name</th>
								<th>Date</th>
								<th>Total Amount</th>
								<th>Paid</th>
								<th>Status</th>
								<th>Action</th>
							</tr>
						</thead>
						<tbody>
							<%
							for (Object[] b : bills) {
								String billId = (String) b[0];
								String eventName = (String) b[1];
								String date = (String) b[2];
								double amount = (Double) b[3];
								double paid = (Double) b[4];
								String status = (String) b[5];
								int index = 1;
								String badgeClass = "Paid".equals(status) ? "badge-green" : "badge-red";
							%>
							<tr class="bill-row">

								<td data-label="Bill ID" id="bill-id"><%=billId%></td>
								<td data-label="Event Name"><%=eventName%></td>
								<td data-label="Date"><%=date%></td>
								<td data-label="Total Amount">&#8377;<%=String.format("%,.0f", amount)%></td>
								<td data-label="Paid">&#8377;<%=String.format("%,.0f", paid)%></td>
								<td data-label="Status"><span class="badge <%=badgeClass%>"><%=status%></span></td>
								 
								<td class="btn-container"><a
									href="<%=request.getContextPath()%>/Maintenance/occasionalBillReceipt.jsp?billId=<%=billId%>"><button
											type="button" class="view">
											<i class="bi bi-eye"></i> View
										</button></a> 
										
									<form action="<%=request.getContextPath()%>/DeleteBill"
										method="get"
										onsubmit="return confirm('Are you sure you want to delete this bill?');">
										<input type="hidden" value="<%=billId%>" name="billId">
										<input type="hidden" value="occassional" name="billType">
										<button type="submit" class="danger">
											<i class="bi bi-trash3"></i> Delete
										</button>

									</form>
								</td>  
								 

								</div>
								</div>
								</td>
							</tr>
							<%
							}
							%>
						</tbody>
					</table>
				</div>

				<div class="table-footer">

					<span class="rows-info" id="rowsInfo"> Showing 1 to <%=Math.min(7, bills.length)%>
						of <%=bills.length%> entries
					</span>

					<div class="pagination">

						<button class="page-btn" id="prevBtn">&lsaquo;</button>

						<div id="pageNumbers"></div>

						<button class="page-btn" id="nextBtn">&rsaquo;</button>

					</div>

				</div>
			</div>

			<!-- ================= Create / View panel ================= -->
			<div class="card">
				<h2 class="card-title">View / Edit Occasional Maintenance</h2>

				<div class="tabs">
					<button type="button" class="tab-btn active" data-tab="eventTab">Event
						Details</button>
					<button type="button" class="tab-btn" data-tab="chargesTab">Charges
						Breakdown</button>
				</div>

				<form id="occasionalForm"
					action="<%=request.getContextPath()%>/UpdateBill" method="post">
					<input type="hidden"  id="typeOf" value="editOccassional" name="type">
					<input type="hidden"   id="hidden-bill" name="billId">
					<input type ="hidden" id="index-number" name="indexNumber">
					<input type="hidden" id="paymentStatus" name="paymentStatus">
				 
					<!-- ======== Tab 1: Event Details ======== -->
					<div class="tab-panel active" id="eventTab">

						<div class="form-grid">
							<div class="field">
								<label for="eventName">Event Name <span class="req">*</span></label>
								<input type="text" id="eventName" name="eventName"
									placeholder="e.g. Ganesh Chaturthi" 
									required>
							</div>
							<div class="field">
								<label for="eventDate">Event Date <span class="req">*</span></label>
								<input type="date" id="eventDate" name="eventDate"
									value="2025-09-12" required>
							</div>

							<div class="field full">
								<label for="eventDescription">Description</label>
								<textarea id="eventDescription" name="eventDescription" rows="2"
									placeholder="e.g. Decoration, Pooja arrangement, Cultural programs"
									style="background: var(--panel-2); border: 1px solid var(--border);
									 color: var(--text); border-radius: var(--radius-sm); padding: 9px 11px; font-size: 13.5px; 
									 width: 100%; outline: none; resize: vertical;"> </textarea>
							</div>

							<div class="field full">
								<label>Flats Involved <span class="req">*</span></label>
								<div class="flats-involved-field">
									<button type="button" class="flats-involved-btn"
										id="flatsInvolvedBtn">
										<span class="fi-left"><i class="bi bi-grid-3x3-gap"></i>
											<span id="flatsInvolvedLabel">Current Flat</span></span> <i
											class="bi bi-chevron-down"></i>
									</button>
									
									
								 
									
									
									<div class="flats-involved-menu" id="flatsInvolvedMenu">
										<button type="button" data-mode="all">
											<i class="bi bi-grid-3x3-gap"></i> <span><span
												class="fi-option-title">All Flats</span><span
												class="fi-option-sub">Apply to every flat in the
													society</span></span>
										</button>
										<div class="divider"></div>
										<div class="group-label">Current Flat</div>
										<button type="button" data-mode="single" >
											<i class="bi bi-house"></i> <span><span
												class="fi-option-title">Current Flat</span>
												 
										</button>
										<div class="divider"></div>
										<div class="group-label">Flat Range</div>
										<button type="button" data-mode="range">
											<i class="bi bi-buildings"></i> <span><span
												class="fi-option-title">Flat Range</span><span
												class="fi-option-sub">e.g. A-101 to A-110</span></span>
										</button>
									</div>
								</div>

								<!-- Chip shown once Single Flat / Flat Range is applied -->
								<div class="flat-chip" id="flatChip" style="display: none;">
									<span class="chip-icon" id="flatChipIcon"><i
										class="bi bi-house"></i></span> <span class="chip-text"> <span
										id="flatChipText">A-101</span> <span class="chip-sub"
										id="flatChipSub"></span>
									</span>
									<button type="button" class="chip-remove" id="flatChipRemove">&times;</button>
								</div>
								

								<input type="hidden" id="flatsInvolvedMode"
									name="flatsInvolvedMode" value="single"> <input
									type="hidden" id="flatsInvolvedValue" name="flatsInvolvedValue"
									value="">
							</div>
						</div>

					</div>

					<!-- ======== Tab 2: Charges Breakdown ======== -->
					<div class="tab-panel" id="chargesTab">
						<div class="panel-intro">
							<div class="panel-intro-icon">
								<i class="bi bi-file-earmark-text"></i>
							</div>
							<div>
								<div class="panel-intro-title">Charges Breakdown</div>
								<div class="panel-intro-sub">Detailed breakup of all
									occasional charges.</div>
							</div>
						</div>

						<table class="breakdown-table charges-table">
							<thead>
								<tr>
									<th>Sr. No.</th>
									<th>Particulars</th>
									<th class="num">Amount (&#8377;)</th>
									<th></th>
								</tr>
							</thead>
							<tbody id="chargesTableBody">
								<!-- rows rendered by JS (see js/occasional-maintenance.js) -->
							</tbody>
						</table>

						 
						 <div class="input">
                         <label>GST Rate</label>
                        <input type="text" value="18" name="gst_rate" id="gst-rate">
                        </div>
						<div class="breakdown-summary">
							<div class="breakdown-summary-row">
								<span>Sub Total</span><span id="breakdownSubTotal">0.00</span>
							</div>
							<div class="breakdown-summary-row">
								<span>GST (18%)</span><span id="breakdownGst">0.00</span>
							</div>
						</div>

						<div class="net-amount-bar solid">
							<span class="net-amount-label">Net Amount (with GST)</span> <span
								class="net-amount-value">&#8377;<span id="breakdownNet">0.00</span></span>
						</div>

						<label class="paid-check-row" for="markAsPaid"
							style="cursor: pointer;"> <input type="checkbox"
							id="markAsPaid" checked> <span> <span
								class="paid-check-title">Mark as Paid</span> <span
								class="paid-check-sub" style="display: block;">This will
									update the payment status for this bill.</span>
						</span>
						</label>
					</div>

					<div class="form-actions">
					 <button type="submit"  id="deletbtn" class="danger">
					      <i class="bi bi-trash3"></i> Delete
					 </button>
						<button type="button" class="btn-secondary" id="resetFormBtn">
							<i class="bi bi-arrow-counterclockwise"></i> Reset
						</button>
 					<button type="submit" class="btn-primary" id="saveFormBtn">
							<i class="bi bi-save"></i> Save
						</button>
					</div>
				</form>
			</div>

		</section>

		<footer class="site-footer">
			<span>&copy; 2025 Green Valley Apartments Co-operative Housing
				Society Ltd. All rights reserved.</span> <span><a href="#">Help</a>
				&nbsp;|&nbsp; <a href="#">Privacy Policy</a> &nbsp;|&nbsp; <a
				href="#">Terms of Use</a></span>
		</footer>
	</div>

	<!-- ============ Modal: Select Specific Flat(s) ============ -->
	<div class="modal-overlay" id="flatModalOverlay">
		<div class="modal-box">
			<div class="modal-header">
				<h3>Select Specific Flat(s)</h3>
				<button type="button" class="modal-close" id="flatModalClose">&times;</button>
			</div>

			<div class="mode-toggle">
				 
				 <label class="mode-option"> <input type="radio"
					name="flatPickMode" value="range" id="modeRange"> Flat
					Range
				</label>
			</div>

			 

			<!-- Flat range picker -->
			<div class="mode-panel  active" id="rangeFlatPanel">
				<div class="range-fields">
					<div class="field">
						<label for="rangeFrom">From Flat <span class="req">*</span></label>
						<select id="rangeFrom">
							<%
							 
							for (String fn : allFlats) {
							%><option value="<%=fn%>"><%=fn%> </option>
							<%
						 
							}
							%>
						</select>
					</div>
					<div class="field">
						<label for="rangeTo">To Flat <span class="req">*</span></label> <select
							id="rangeTo">
							<%
							for (String fn : allFlats) {
							%><option value="<%=fn%>"><%=fn%></option>
							<%
							}
							%>
						</select>
					</div>
				</div>

				<div class="range-preview">
					<i class="bi bi-info-circle"></i>
					<div>
						<div class="range-preview-title">Selected Range Preview</div>
						<div class="range-preview-text" id="rangePreviewText">
							Flats from <b>A-101</b> to <b>A-101</b> will be included.
						</div>
						<div class="range-preview-text">
							Total flats: <b id="rangePreviewCount">1</b>
						</div>
					</div>
				</div>
			</div>

			<div class="modal-actions">
				<button type="button" class="btn-secondary" id="flatModalCancel">Cancel</button>
				<button type="button" class="btn-primary" id="flatModalApply">Apply</button>
			</div>
		</div>
	</div>
   <div id="popupBox" class="popup-box"></div> 
       

</body>
</html>
	<script>
  // All flats, shared with the modal's range-count logic
  var ALL_FLATS = [<%for (int i = 0; i < allFlats.length; i++) {%>"<%=allFlats[i]%>"<%=i < allFlats.length - 1 ? "," : ""%><%}%>];
  
  
  var contextPath = "${pageContext.request.contextPath}";
 

 
  
 
 
  
</script>
	<script
		src="<%=request.getContextPath()%>/js/occasional-maintenance.js">
		
		</script>
		
		<%
       
        String msg = (String) session.getAttribute("popupMsg");
        String type = (String) session.getAttribute("popupType");
        if (msg != null) {
            session.removeAttribute("popupMsg");
            session.removeAttribute("popupType");
    %>
        <script>
            showPopup("<%= msg %>", "<%= type %>");
        </script>
    <%
        }
    %>
</body>
</html>
