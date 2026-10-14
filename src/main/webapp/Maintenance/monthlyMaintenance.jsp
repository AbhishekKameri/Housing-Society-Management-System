<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDate, java.time.format.DateTimeFormatter"%>
<%@ page import="com.housingsociety.model.*, com.housingsociety.dao.*"%>
<%@ page import="java.util.*"%>
<%
    request.setAttribute("pageTitle", "Monthly Maintenance");
    request.setAttribute("pageDescription", "Manage monthly maintenance bills, charges and payments.");

    // ---- Selected billing month (UI only for now — see note below) ----
    String monthParam = request.getParameter("month"); // expected "yyyy-MM"
    LocalDate monthDate = LocalDate.now().withDayOfMonth(1);
    if (monthParam != null && !monthParam.trim().isEmpty()) {
        try { monthDate = LocalDate.parse(monthParam + "-01"); } catch (Exception ignored) { }
    }
    String monthYear = monthDate.format(DateTimeFormatter.ofPattern("yyyy-MM"));
    // NOTE: MaintenanceDao.getAllMonthlyData() has no month parameter, so the
    // dropdown below doesn't actually filter the query yet. If you have (or add)
    // a month-scoped DAO method, swap the call below for that.

    MaintenanceDao maintenanceDao = new MaintenanceDao();
    List<MonthlyMaintenance> monthlyBills = maintenanceDao.getAllMonthlyData();
    if (monthlyBills == null) monthlyBills = new ArrayList<MonthlyMaintenance>();

    // ---- Stat cards, computed from the real data (not hardcoded) ----
    int totalBills = monthlyBills.size();
    double totalAmount = 0, collectedAmount = 0;
    for (MonthlyMaintenance b : monthlyBills) {
        totalAmount += b.getNetAmount();
        if (b.isPaymentStatus()) collectedAmount += b.getNetAmount();
    }
    double pendingAmount = totalAmount - collectedAmount;

    // ---- Flat numbers for the filter dropdown, derived from the real data ----
    Set<String> flatNumbers = new LinkedHashSet<String>();
    for (MonthlyMaintenance b : monthlyBills) flatNumbers.add(b.getFlatNum());
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Monthly Maintenance · Society HMS</title>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/site.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/monthly-maintenance.css">
</head>
<body>

<%-- ============ SIDEBAR (shared include) ============ --%>
<%@ include file="../sidebar.jsp" %>

<!-- ============ MAIN ============ -->
<div class="main" id="mainContent">

  <%-- ============ PAGE HEADER (shared include — reads pageTitle/pageDescription set above) ============ --%>
  <%@ include file="../pageHeader.jsp" %>

  <!-- ---- Breadcrumb + page actions ---- -->
  <div class="page-actions-row">
   
    <div class="action-buttons-row">
      <a href="add-monthly-charges.jsp">
        <button type="button" class="btn-primary"><i class="bi bi-plus-lg"></i> Add Monthly Charges</button>
      </a>
      
    </div>
  </div>

  <!-- ---- Stat cards ---- -->
  <section class="stats">
    <div class="stat-card">
      <div class="stat-icon indigo"><i class="bi bi-receipt"></i></div>
      <div>
        <div class="stat-label">Total Bills</div>
        <div class="stat-value"><%= totalBills %></div>
      </div>
    </div>
    <div class="stat-card">
      <div class="stat-icon teal"><i class="bi bi-currency-rupee"></i></div>
      <div>
        <div class="stat-label">Total Amount</div>
        <div class="stat-value">&#8377;<%= String.format("%,.0f", totalAmount) %></div>
      </div>
    </div>
    <div class="stat-card">
      <div class="stat-icon purple"><i class="bi bi-check-circle"></i></div>
      <div>
        <div class="stat-label">Collected</div>
        <div class="stat-value">&#8377;<%= String.format("%,.0f", collectedAmount) %></div>
      </div>
    </div>
    <div class="stat-card">
      <div class="stat-icon pink"><i class="bi bi-hourglass-split"></i></div>
      <div>
        <div class="stat-label">Pending</div>
        <div class="stat-value">&#8377;<%= String.format("%,.0f", pendingAmount) %></div>
      </div>
    </div>
  </section>

  <!-- ---- Content grid: bills table + create/view panel ---- -->
  <section class="content-grid">

    <!-- ================= Bills table ================= -->
    <div class="card">
      <div class="card-title-row">
        <h2 class="card-title" style="margin:0;">Monthly Maintenance Bills</h2>
        
      </div>

      <div class="table-toolbar">
        <div class="search-box">
          <i class="bi bi-search"></i>
          <input type="text" id="billSearch" placeholder="Search by flat number, resident name or bill ID...">
        </div>
        <select id="statusFilter" class="select-field">
          <option value="all">All Status</option>
          <option value="paid">Paid</option>
          <option value="pending">Pending</option>
        </select>
        <select id="flatFilter" class="select-field">
          <option value="all">All Flats</option>
          <% for (String fn : flatNumbers) { %>
            <option value="<%= fn.toLowerCase() %>"><%= fn %></option>
          <% } %>
        </select>
      </div>

      <div class="table-scroll">
        <table id="billsTable" data-page-size="9">
          <thead>
            <tr>
              <th>Bill ID</th><th>Flat No.</th><th>Resident Name</th>
              <th> Date</th><th>Amount</th><th>Status</th><th>Action</th>
            </tr>
          </thead>
          <tbody>
            <%
              for (MonthlyMaintenance b : monthlyBills) {
                String billId = b.getBillId();
                String flatNo = b.getFlatNum();

                Owner o = FlatDao.getOwnerByID(b.getResidentId());
                String residentName = (o != null) ? (o.getFirstName() + " " + o.getLastName()) : "Unknown Resident";

                // NOTE: due-date/late-fee recalculation used to run here on every
                // page view (ms.updateDueDate(billId)) — removed. Mutating the
                // database as a side effect of rendering a page means every
                // refresh, prefetch, or crawler hit silently changes bill data.
                // That recalculation belongs in an explicit action (a scheduled
                // job, or a button the admin clicks), not in the render loop.

                String Date = (b.getGeneratedDate() != null) ? b.getGeneratedDate().toString() : "-";
                double amount = b.getNetAmount();
                boolean isPaid = b.isPaymentStatus();
                String status = isPaid ? "Paid" : "Pending";
                String badgeClass = isPaid ? "badge-green" : "badge-red";
            %>
            <tr class="bill-row"
                data-bill-id="<%= billId %>"
                data-resident-name="<%= residentName %>"
                data-resident-id="<%= b.getResidentId() %>"
                data-flat-number="<%= flatNo %>"
                data-due-date="<%= b.getDueDate() != null ? b.getDueDate().toString() : "" %>"
                data-net-amount="<%= amount %>"
                data-paid="<%= isPaid %>">
         
              <td data-label="Bill ID"><%= billId %></td>
              <td data-label="Flat No."><%= flatNo %></td>
              <td data-label="Resident Name"><%= residentName %></td>
              <td data-label="Due Date"><%= Date %></td>
              <td data-label="Amount">&#8377;<%= String.format("%,.0f", amount) %></td>
              <td data-label="Status"><span class="badge <%= badgeClass %>"><%= status %></span></td>
              <td data-label="Action" class="action-menu">
                <a href="monthly-bill.jsp?ownerName=<%= java.net.URLEncoder.encode(residentName, "UTF-8") %>&billId=<%= billId %>">
                  <button type="button" class="icon-btn" title="View"><i class="bi bi-eye"></i>View</button>
                </a>

                <% if (!isPaid) {  
               
                } %>

                <form action="<%=request.getContextPath()%>/DeleteBill" method="get" style="display:inline;"
                      onsubmit="return confirm('Delete bill <%= billId %>? This cannot be undone.');">
                  <input type="hidden"   name="billId" value="<%= billId %>">
                  <input type="hidden" name="billType" value="monthly">
                  <button type="submit" class="icon-btn" title="Delete" style="color:var(--red);"><i class="bi bi-trash3"></i>Delete</button>
                </form>
              </td>
            </tr>
            <% } %>
          </tbody>
        </table>
      </div>

      <div class="table-footer">
        <span class="rows-info" id="rowsInfo"></span>
        <div class="pagination" id="pagination"></div>
      </div>
    </div>

    <!-- ================= Create / View panel ================= -->
    <div class="card">
      <h2 class="card-title">Create / View Monthly Maintenance</h2>

      <div class="selected-bill-bar" id="selectedBillBar">
        <div class="selected-bill-info">
          <span>Viewing bill</span> <b id="selectedBillId"></b>
          <span class="badge" id="selectedBillStatus"></span>
          <span id="selectedBillOwner"></span>
        </div>
        <button type="button" class="btn-secondary" id="newBillBtn"><i class="bi bi-plus-lg"></i> New Bill</button>
      </div>

      <div class="tabs">
        <button type="button" class="tab-btn active" data-tab="detailsTab">Maintenance Details</button>
        <button type="button" class="tab-btn" data-tab="breakdownTab">Charges Breakdown</button>
      </div>

      <form id="maintenanceForm" action="<%=request.getContextPath()%>/UpdateBill" method="post">
        <input type="hidden" id="billId" name="billId" value="">
        <input type="hidden" id="netAmount" name="netAmount">
		<input type="hidden" id="subTotal" name = "subTotal" >
		<input type ="hidden" id="gstAmount" name="gstAmount">
		<input type ="hidden"   name="type" value="monthly">

        <!-- ======== Tab 1: Maintenance Details ======== -->
        <div class="tab-panel active" id="detailsTab">
          <div class="form-grid">
            <div class="field">
              <label for="residentId">Resident ID <span class="req">*</span></label>
              <div class="input-icon-field">
                <input type="text" id="residentId" name="residentId" placeholder="e.g. R001"   required readonly>
                 </div>
            </div>
            <div class="field">
              <label for="flatNumber">Flat Number <span class="req">*</span></label>
              <input type="text" id="flatNumber" name="flatNumber" placeholder="e.g. A-101" value="A-101" required readonly>
            </div>

            <div class="field">
              <label for="generatedDate">Generated Date <span class="req">*</span></label>
              <input type="date" id="generatedDate" name="generatedDate" value="" required pattern="^\d{2}\d{2}\d{4}$">            </div>
            <div class="field">
              <label for="dueDate">Due Date <span class="req">*</span></label>
              <input type="date" id="dueDate" name="dueDate" value=""  pattern="^\d{2}\d{2}\d{4}$" >
               <span id="dateWarning" class="date-warning"></span>
            </div>

            <div class="field">
              <label for="maintenanceAmount">Maintenance Amount <span class="req">*</span></label>
              <input type="number" step="0.01" min="0" id="maintenanceAmount" name="maintenanceAmount" value="2500" required>
            </div>
            <div class="field">
              <label for="electricityCharges">Electricity Charges <span class="req">*</span></label>
              <input type="number" step="0.01" min="0" id="electricityCharges" name="electricityCharges" value="300" required>
            </div>

            <div class="field">
              <label for="waterCharges">Water Charges <span class="req">*</span></label>
              <input type="number" step="0.01" min="0" id="waterCharges" name="waterCharges" value="200" required>
            </div>
            <div class="field">
              <label for="parkingCharges">Parking Charges <span class="req">*</span></label>
              <input type="number" step="0.01" min="0" id="parkingCharges" name="parkingCharges" value="150" required>
            </div>

            <div class="field">
              <label for="securityCharges">Security Charges <span class="req">*</span></label>
              <input type="number" step="0.01" min="0" id="securityCharges" name="securityCharges" value="100" required>
            </div>
            <div class="field">
              <label for="otherCharges">Other Charges <span class="req">*</span></label>
              <input type="number" step="0.01" min="0" id="otherCharges" name="otherCharges" value="100" required>
            </div>

            <div class="field">
              <label for="dueDays">Due Days <span class="req">*</span></label>
              <input type="number" min="0" id="dueDays" name="dueDays" value="15" required readonly>
            </div>
            <div class="field">
              <label for="lateFee">Late Fee <span class="req">*</span></label>
              <input type="number" step="0.01" min="0" id="lateFee" name="lateFee" value="50" required readonly>
            </div>

            <div class="field">
              <label for="fine">Fine <span class="req">*</span></label>
              <input type="number" step="0.01" min="0" id="fine" name="fine" value="40" required>
            </div>
            
             <div class="field">
              <label for="lateFee">GST Rate<span class="req">*</span></label>
              <input type="number" step="0.01" min="0" id="gstRate" name="gstRate" value="18" required>
          </div>
          </div>
          
		  
           <div class="net-amount-bar solid">
            <span class="net-amount-label">Net Amount (with GST)</span>
            <span class="net-amount-value">&#8377;<span id="breakdownNet">0.00</span></span>
          </div>
        </div>

        <!-- ======== Tab 2: Charges Breakdown ======== -->
        <div class="tab-panel" id="breakdownTab">
          <div class="panel-intro">
            <div class="panel-intro-icon"><i class="bi bi-file-earmark-text"></i></div>
            <div>
              <div class="panel-intro-title">Charges Breakdown</div>
              <div class="panel-intro-sub">Detailed breakup of all maintenance charges.</div>
            </div>
          </div>

          <table class="breakdown-table">
            <thead>
              <tr><th>Sr. No.</th><th>Particulars</th><th class="num">Amount (&#8377;)</th></tr>
            </thead>
            <tbody>
              <tr>
                <td>1</td>
                <td><span class="breakdown-particular"><span class="breakdown-ic breakdown-ic-indigo"><i class="bi bi-house"></i></span>Base Maintenance</span></td>
                <td class="num" id="maintenanceAmountCard" data-mirror="maintenanceAmount">0.00</td>
              </tr>
              <tr>
                <td>2</td>
                <td><span class="breakdown-particular"><span class="breakdown-ic breakdown-ic-orange"><i class="bi bi-lightning-charge"></i></span>Electricity Charges</span></td>
                <td class="num" id="electricityChargesCard" data-mirror="electricityCharges">0.00</td>
              </tr>
              <tr>
                <td>3</td>
                <td><span class="breakdown-particular"><span class="breakdown-ic breakdown-ic-blue"><i class="bi bi-droplet"></i></span>Water Charges</span></td>
                <td class="num" id="waterChargesCard" data-mirror="waterCharges">0.00</td>
              </tr>
              <tr>
                <td>4</td>
                <td><span class="breakdown-particular"><span class="breakdown-ic breakdown-ic-green"><i class="bi bi-car-front"></i></span>Parking Charges</span></td>
                <td class="num" id="parkingChargesCard" data-mirror="parkingCharges">0.00</td>
              </tr>
              <tr>
                <td>5</td>
                <td><span class="breakdown-particular"><span class="breakdown-ic breakdown-ic-red"><i class="bi bi-shield-check"></i></span>Security Charges</span></td>
                <td class="num" id="securityChargesCard" data-mirror="securityCharges">0.00</td>
              </tr>
              <tr>
                <td>6</td>
                <td><span class="breakdown-particular"><span class="breakdown-ic breakdown-ic-gray"><i class="bi bi-three-dots"></i></span>Other Charges</span></td>
                <td class="num" id="otherChargesCard" data-mirror="otherCharges">0.00</td>
              </tr>
                 <tr>
                <td>7</td>
                <td><span class="breakdown-particular"><span class="breakdown-ic breakdown-ic-red"><i class="bi bi-clock-history"></i></span> Late Fee</span></td>
                <td class="num" id="lateFeeCard" data-mirror="lateFee">0.00</td>
           </tr>
            </tbody>
          </table>
        

          <div class="breakdown-summary">
            <div class="breakdown-summary-row"><span>Sub Total</span><span id="breakdownSubTotal">0.00</span></div>
            <div class="breakdown-summary-row"><span id="gstRateOut">GST </span><span id="breakdownGst">0.00</span></div>
          </div>

          <div class="net-amount-bar solid">
            <span class="net-amount-label">Net Amount (with GST)</span>
            <span class="net-amount-value">&#8377;<span id="breakdownNet2">0.00</span></span>
          </div>

          <div class="info-note">
            <i class="bi bi-info-circle"></i>
            <span >GST is calculated at <span id="gstRateOutLine">34</span>% on the subtotal amount.</span>
          </div>

         
        </div>

        <div class="form-actions">
          <button type="button" class="btn-secondary" id="resetFormBtn"><i class="bi bi-arrow-counterclockwise"></i> Reset</button>
          <button type="submit" class="btn-primary" id="saveFormBtn"><i class="bi bi-save"></i> Save</button>
        </div>
      </form>
    </div>

  </section>

  <footer class="site-footer">
    <span>&copy; 2025 Green Valley Apartments Co-operative Housing Society Ltd. All rights reserved.</span>
    <span><a href="#">Help</a> &nbsp;|&nbsp; <a href="#">Privacy Policy</a> &nbsp;|&nbsp; <a href="#">Terms of Use</a></span>
  </footer>
</div>
<div id="popupBox" class="popup-box"></div> 
<script>const contextPath ="<%=request.getContextPath()%>"</script>

<script src="<%=request.getContextPath()%>/js/monthly-maintenance.js"></script>
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
