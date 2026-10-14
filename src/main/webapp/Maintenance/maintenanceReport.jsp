<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.housingsociety.model.*, com.housingsociety.dao.*, com.housingsociety.service.*"%>
<%
    request.setAttribute("pageTitle", "Maintenance Report");
    request.setAttribute("pageDescription", "Collection overview for monthly and occasional maintenance.");

    // ---- Demo data (swap for real DAO/service lookups later) ----
      MaintenanceService ms = new MaintenanceService();
    		ms.getTotalOccassionalBillCount();
    		ms.getTotalMonthlyBillCount();
    // Monthly Maintenance
      MaintenanceDao md = new MaintenanceDao();	
    int monthlyTotalBills =MonthlyMaintenance.getTotalBills() ;
    int monthlyPaidCount =  md.getPaidMonthlyBillCount(),  monthlyPendingCount = md.getMonthlyBillPendingCount();
    double monthlyTotalAmount = MonthlyMaintenance.getTotalAmount(), monthlyCollected =  MonthlyMaintenance.getCollectedAmount(), monthlyPending = MonthlyMaintenance.getPendingAmount();
    double monthlyRate = (monthlyCollected / monthlyTotalAmount) * 100;

    // Occasional Maintenance
    int occasionalTotalBills = OccassionalMaintenance.getTotalBills();
    int occasionalPaidCount = md.getPaidOccassionalBillCount(),  occasionalPendingCount = md.getOccassionalBillPendingCount();
    double occasionalTotalAmount =OccassionalMaintenance.getTotalAmount()  , occasionalCollected = OccassionalMaintenance.getCollectedAmount(), occasionalPending = OccassionalMaintenance.getPendingAmount();
    double occasionalRate = (occasionalCollected / occasionalTotalAmount) * 100;

    // Combined overview (top stat cards)
    int combinedTotalBills = monthlyTotalBills + occasionalTotalBills;
    double combinedTotalAmount = monthlyTotalAmount + occasionalTotalAmount;
    double combinedCollected = monthlyCollected + occasionalCollected;
    double combinedPending = monthlyPending + occasionalPending;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Maintenance Report · Society HMS</title>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/site.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/maintenance-report.css">
</head>
<body>

<%-- ============ SIDEBAR (shared include) ============ --%>
<%@ include file="../sidebar.jsp" %>

<!-- ============ MAIN ============ -->
<div class="main" id="mainContent">

  <%-- ============ PAGE HEADER (shared include) ============ --%>
  <%@ include file="../pageHeader.jsp" %>

  <!-- ---- Combined overview stat cards ---- -->
  <section class="stats">
    <div class="stat-card">
      <div class="stat-icon indigo"><i class="bi bi-receipt"></i></div>
      <div>
        <div class="stat-label">Total Bills</div>
        <div class="stat-value"><%= combinedTotalBills %></div>
      </div>
    </div>
    <div class="stat-card">
      <div class="stat-icon teal"><i class="bi bi-currency-rupee"></i></div>
      <div>
        <div class="stat-label">Total Amount</div>
        <div class="stat-value">&#8377;<%= String.format("%,.0f", combinedTotalAmount) %></div>
      </div>
    </div>
    <div class="stat-card">
      <div class="stat-icon purple"><i class="bi bi-check-circle"></i></div>
      <div>
        <div class="stat-label">Collected</div>
        <div class="stat-value">&#8377;<%= String.format("%,.0f", combinedCollected) %></div>
      </div>
    </div>
    <div class="stat-card">
      <div class="stat-icon pink"><i class="bi bi-hourglass-split"></i></div>
      <div>
        <div class="stat-label">Pending</div>
        <div class="stat-value">&#8377;<%= String.format("%,.0f", combinedPending) %></div>
      </div>
    </div>
  </section>

  <!-- ---- Report cards: Monthly + Occasional, each with a donut chart ---- -->
  <section class="report-grid">

    <!-- ================= Monthly Maintenance ================= -->
    <div class="card">
      <div class="report-card-head">
        <div class="report-card-icon indigo"><i class="bi bi-calendar2-week"></i></div>
        <div>
          <div class="report-card-title">Monthly Maintenance</div>
          <div class="report-card-sub">Collection status across <%= monthlyTotalBills %> bills this cycle</div>
        </div>
      </div>

      <div class="donut-block">
        <div class="donut-canvas-wrap">
          <canvas id="monthlyDonut" width="150" height="150"></canvas>
        </div>
        <ul class="legend" data-legend-for="monthlyDonut"></ul>
      </div>

      <div class="report-divider"></div>

      <div class="quick-stats">
        <div class="quick-stat">
          <div class="quick-stat-label">Total Billed</div>
          <div class="quick-stat-value">&#8377;<%= String.format("%,.0f", monthlyTotalAmount) %></div>
        </div>
        <div class="quick-stat">
          <div class="quick-stat-label">Collected</div>
          <div class="quick-stat-value green">&#8377;<%= String.format("%,.0f", monthlyCollected) %></div>
        </div>
        <div class="quick-stat">
          <div class="quick-stat-label">Pending</div>
          <div class="quick-stat-value red">&#8377;<%= String.format("%,.0f", monthlyPending) %></div>
        </div>
        <div class="quick-stat">
          <div class="quick-stat-label">Bills Raised</div>
          <div class="quick-stat-value"><%= monthlyTotalBills %></div>
        </div>
      </div>

      <div class="collection-rate-row">
        <span>Collection Rate</span>
        <b><%= String.format("%.1f", monthlyRate) %>%</b>
      </div>
      <div class="collection-bar-track">
        <div class="collection-bar-fill" style="width:<%= String.format("%.1f", monthlyRate) %>%;"></div>
      </div>
    </div>

    <!-- ================= Occasional Maintenance ================= -->
    <div class="card">
      <div class="report-card-head">
        <div class="report-card-icon teal"><i class="bi bi-stars"></i></div>
        <div>
          <div class="report-card-title">Occasional Maintenance</div>
          <div class="report-card-sub">Collection status across <%= occasionalTotalBills %> event bills</div>
        </div>
      </div>

      <div class="donut-block">
        <div class="donut-canvas-wrap">
          <canvas id="occasionalDonut" width="150" height="150"></canvas>
        </div>
        <ul class="legend" data-legend-for="occasionalDonut"></ul>
      </div>

      <div class="report-divider"></div>

      <div class="quick-stats">
        <div class="quick-stat">
          <div class="quick-stat-label">Total Billed</div>
          <div class="quick-stat-value">&#8377;<%= String.format("%,.0f", occasionalTotalAmount) %></div>
        </div>
        <div class="quick-stat">
          <div class="quick-stat-label">Collected</div>
          <div class="quick-stat-value green">&#8377;<%= String.format("%,.0f", occasionalCollected) %></div>
        </div>
        <div class="quick-stat">
          <div class="quick-stat-label">Pending</div>
          <div class="quick-stat-value red">&#8377;<%= String.format("%,.0f", occasionalPending) %></div>
        </div>
        <div class="quick-stat">
          <div class="quick-stat-label">Bills Raised</div>
          <div class="quick-stat-value"><%= occasionalTotalBills %></div>
        </div>
      </div>

      <div class="collection-rate-row">
        <span>Collection Rate</span>
        <b><%= String.format("%.1f", occasionalRate) %>%</b>
      </div>
      <div class="collection-bar-track">
        <div class="collection-bar-fill" style="width:<%= String.format("%.1f", occasionalRate) %>%;"></div>
      </div>
    </div>

  </section>

  <footer class="site-footer">
    <span>&copy; 2025 Green Valley Apartments Co-operative Housing Society Ltd. All rights reserved.</span>
    <span><a href="#">Help</a> &nbsp;|&nbsp; <a href="#">Privacy Policy</a> &nbsp;|&nbsp; <a href="#">Terms of Use</a></span>
  </footer>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.4/dist/chart.umd.min.js"></script>
<script src="<%=request.getContextPath()%>/js/chart-setup.js"></script>
<script>
  document.addEventListener('DOMContentLoaded', function () {

    createDonutChart('monthlyDonut', [
      { label: 'Paid',    value: <%= monthlyPaidCount %>,    color: '#22c55e' },
      { label: 'Pending', value: <%= monthlyPendingCount %>, color: '#ef4444' }
    ], { centerLabel: 'Bills', centerValue: <%= monthlyTotalBills %> });

    createDonutChart('occasionalDonut', [
      { label: 'Paid',    value: <%= occasionalPaidCount %>,    color: '#22c55e' },
      { label: 'Pending', value: <%= occasionalPendingCount %>, color: '#ef4444' }
    ], { centerLabel: 'Bills', centerValue: <%= occasionalTotalBills %> });

  });
</script>
</body>
</html>
