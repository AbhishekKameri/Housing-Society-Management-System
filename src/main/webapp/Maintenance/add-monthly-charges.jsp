<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.time.LocalDate, java.time.format.DateTimeFormatter"%>
<%@ page
	import="com.housingsociety.model.*, com.housingsociety.dao.*, com.housingsociety.service.*"%>

<%
String today = LocalDate.now().format(DateTimeFormatter.ofPattern("dd MMM yyyy"));
String todayIso = LocalDate.now().toString();
MaintenanceService ms = new MaintenanceService();
MaintenanceDao md = new MaintenanceDao();
FlatService fs = new FlatService();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Add Monthly Charges · Society HMS</title>
<link rel="stylesheet" href="../css/add.css">

<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head>
<body>

	<!-- ============ SIDEBAR ============ -->
	<div class="overlay" id="overlay"></div>

	<div class="app">

		<!-- ============ SIDEBAR ============ -->


		<%
/* =========================================================
   CURRENT PAGE DETECTION
========================================================= */

String currentPage = request.getRequestURI();

String currentAction = request.getParameter("action");

/* =========================================================
   SOCIETY
========================================================= */

boolean isViewSociety = currentPage.endsWith("/Society/viewSociety.jsp");

boolean isAddSociety = currentPage.endsWith("/Society/addSociety.jsp");

boolean isUpdateSociety = currentPage.endsWith("/Society/updateSociety.jsp")
		|| (currentPage.endsWith("/SocietyServlet") && "edit".equals(currentAction));

boolean isSocietyPage = isViewSociety || isAddSociety || isUpdateSociety;

/* =========================================================
   CHAIRMAN
========================================================= */

boolean isAllChairman = currentPage.endsWith("/Chairman/allChairman.jsp");

boolean isAddChairman = currentPage.endsWith("/Chairman/addChairman.jsp");

boolean isViewChairman = currentPage.endsWith("/Chairman/viewChairman.jsp")
		|| (currentPage.endsWith("/ChairmanServlet") && "view".equals(currentAction));

boolean isUpdateChairman = currentPage.endsWith("/Chairman/updateChairman.jsp")
		|| (currentPage.endsWith("/ChairmanServlet") && "edit".equals(currentAction));

boolean isChairmanPage = isAllChairman || isAddChairman || isViewChairman || isUpdateChairman;
boolean isMonthlyMaintenance = true;
%>






		<!-- =====================================================
         BOOTSTRAP ICONS
    ====================================================== -->









		<!-- =========================================================
     SIDEBAR
========================================================= -->

		<div class="sidebar">


			<!-- =====================================================
         LOGO
    ====================================================== -->

			<div class="logo-area">

				<div class="logo-title">

					<span class="logo-icon" id="sidebarToggle"> <i
						class="bi bi-buildings"></i>

					</span> <span> Society HMS </span>

				</div>


				<div class="logo-subtitle">Housing Management System</div>

			</div>



			<!-- =====================================================
         MENU
    ====================================================== -->

			<div class="menu">


				<!-- =================================================
             DASHBOARD
        ================================================== -->

				<a href="<%=request.getContextPath()%>/index.jsp" class="menu-item">

					<div class="menu-left">

						<span class="menu-icon"> <i class="bi bi-house-door"></i>

						</span> <span> Dashboard </span>

					</div>

				</a>



				<!-- =================================================
             SOCIETY
        ================================================== -->

				<li class="society-menu"><a href="#" id="societyMenu"
					class="menu-link <%=isSocietyPage ? "active" : ""%>"> <i
						class="bi bi-buildings"></i> <span> Society </span> <i
						class="bi bi-chevron-down submenu-arrow"></i>

				</a> <!-- =================================================
                 SOCIETY SUBMENU
            ================================================== -->

					<ul id="societySubmenu"
						class="submenu <%=isSocietyPage ? "show" : ""%>">


						<!-- VIEW SOCIETY -->

						<li><a
							href="<%=request.getContextPath()%>/Society/viewSociety.jsp"
							class="submenu-link <%=isViewSociety ? "active" : ""%>"> <i
								class="bi bi-eye"></i> <span> View Society </span>

						</a></li>



						<!-- ADD SOCIETY -->

						<li><a
							href="<%=request.getContextPath()%>/Society/addSociety.jsp"
							class="submenu-link <%=isAddSociety ? "active" : ""%>"> <i
								class="bi bi-plus-circle"></i> <span> Add Society </span>

						</a></li>



						<!-- UPDATE SOCIETY -->

						<li><a
							href="<%=request.getContextPath()%>/SocietyServlet?action=edit"
							class="submenu-link <%=isUpdateSociety ? "active" : ""%>"> <i
								class="bi bi-pencil-square"></i> <span> Update Society </span>

						</a></li>

					</ul></li>



				<!-- =================================================
             CHAIRMAN
        ================================================== -->

				<li class="society-menu"><a href="#" id="chairmanMenu"
					class="menu-link <%=isChairmanPage ? "active" : ""%>"> <i
						class="bi bi-person-badge"></i> <span> Chairman </span> <i
						class="bi bi-chevron-down submenu-arrow"></i>

				</a> <!-- =================================================
                 CHAIRMAN SUBMENU
            ================================================== -->

					<ul id="chairmanSubmenu"
						class="submenu <%=isChairmanPage ? "show" : ""%>">


						<!-- ALL CHAIRMEN -->

						<!--                 <li> -->

						<!--                     <a -->
						<%--                         href="<%=request.getContextPath()%>/Chairman/allChairman.jsp" --%>
						<%--                         class="submenu-link <%=isAllChairman ? "active" : ""%>"> --%>

						<!--                         <i class="bi bi-people"></i> -->

						<!--                         <span> -->
						<!--                             All Chairmen -->
						<!--                         </span> -->

						<!--                     </a> -->

						<!--                 </li> -->



						<!-- ADD CHAIRMAN -->

						<li><a
							href="<%=request.getContextPath()%>/Chairman/addChairman.jsp"
							class="submenu-link <%=isAddChairman ? "active" : ""%>"> <i
								class="bi bi-plus-circle"></i> <span> Add Chairman </span>

						</a></li>



						<!-- VIEW CHAIRMAN -->

						<li><a
							href="<%=request.getContextPath()%>/ChairmanServlet?action=view"
							class="submenu-link <%=isViewChairman ? "active" : ""%>"> <i
								class="bi bi-eye"></i> <span> View Chairman </span>

						</a></li>



						<!-- UPDATE CHAIRMAN -->

						<li><a
							href="<%=request.getContextPath()%>/ChairmanServlet?action=edit"
							class="submenu-link <%=isUpdateChairman ? "active" : ""%>"> <i
								class="bi bi-pencil-square"></i> <span>Update Chairman</span>

						</a></li>

					</ul></li>



				<!-- =================================================
             RESIDENTS
        ================================================== -->

				<a href="#" class="menu-item">

					<div class="menu-left">

						<span class="menu-icon"> <i class="bi bi-people"></i>

						</span> <span> Residents </span>

					</div> <span> <i class="bi bi-chevron-down"></i>
				</span>

				</a>



				<!-- =================================================
             SHARE CERTIFICATES
        ================================================== -->

				<a href="#" class="menu-item">

					<div class="menu-left">

						<span class="menu-icon"> <i class="bi bi-file-earmark-text"></i>

						</span> <span> Share Certificates </span>

					</div>

				</a>



				<!-- =================================================
             PARKING
        ================================================== -->

				<a href="#" class="menu-item">

					<div class="menu-left">

						<span class="menu-icon"> <i class="bi bi-car-front"></i>

						</span> <span> Parking </span>

					</div> <span> <i class="bi bi-chevron-down"></i>
				</span>

				</a>



				<!-- =================================================
             MAINTENANCE
        ================================================== -->
				<li class="society-menu"><a href="#" id="societyMenu"
					class="menu-link <%=isMonthlyMaintenance ? "active" : ""%>"> <i
						class="bi bi bi-tools""></i> <span> Monthly Maintenance </span> <i
						class="bi bi-chevron-down submenu-arrow"></i>

				</a> <!-- =================================================
                 SOCIETY SUBMENU
            ================================================== -->

					<ul id="societySubmenu"
						class="submenu <%=isMonthlyMaintenance ? "show" : ""%>">


						<!-- VIEW SOCIETY -->

						<li><a
							href="<%=request.getContextPath()%>/Society/viewSociety.jsp"
							class="submenu-link <%=isViewSociety ? "active" : ""%>"> <i
								class="bi bi-eye"></i> <span> View Society </span>

						</a></li>


						<!-- =================================================
             FLATS
        ================================================== -->

						<a href="#" class="menu-item">

							<div class="menu-left">

								<span class="menu-icon"> <i class="bi bi-grid-3x3-gap"></i>

								</span> <span> Flats </span>

							</div>

						</a>



						<!-- =================================================
             COMPLAINTS
        ================================================== -->

						<a href="#" class="menu-item">

							<div class="menu-left">

								<span class="menu-icon"> <i class="bi bi-chat-left-text"></i>

								</span> <span> Complaints </span>

							</div>

						</a>



						<!-- =================================================
             REPORTS
        ================================================== -->

						<a href="#" class="menu-item">

							<div class="menu-left">

								<span class="menu-icon"> <i class="bi bi-bar-chart"></i>

								</span> <span> Reports </span>

							</div>

						</a>



						<!-- =================================================
             SETTINGS
        ================================================== -->

						<a href="#" class="menu-item">

							<div class="menu-left">

								<span class="menu-icon"> <i class="bi bi-gear"></i>

								</span> <span> Settings </span>

							</div>

						</a>
			</div>



			<!-- =====================================================
         USER AREA
    ====================================================== -->

			<div class="user-area">

				<div class="user">

					<div class="avatar">SA</div>


					<div class="user-info">

						<div class="user-name">Super Admin</div>

						<div class="user-role">Chairman</div>

					</div>


					<span> <i class="bi bi-chevron-down"></i>

					</span>

				</div>


				<div class="logout">

					<i class="bi bi-box-arrow-right"></i> &nbsp; Logout

				</div>

			</div>


		</div>







		<!-- ============ MAIN ============ -->
		<div class="main">

			<!-- ---- Top bar ---- -->

			<%
			String pageTitle = (String) request.getAttribute("pageTitle");
			String pageDescription = (String) request.getAttribute("pageDescription");

			if (pageTitle == null) {
				pageTitle = "Add Monthly Charges";
			}

			if (pageDescription == null) {
				pageDescription = " Add monthly charges and manage society information";
			}
			%>

			<!-- ================= TOP BAR ================= -->

			<div class="topbar">

				<div class="top-left">

					<!-- Back Button -->
					<a
						href="<%=request.getContextPath()%>/Maintenance/monthlyMaintenance.jsp"
						class="back-button" title="Back"> <i
						class="bi bi-chevron-left"></i>

					</a>

					<!-- Page Title -->
					<div>

						<div class="page-title">
							<%=pageTitle%>
						</div>

						<div class="page-description">
							<%=pageDescription%>
						</div>

					</div>

				</div>


				<!-- ================= TOP RIGHT ================= -->

				<div class="top-right">

					<!-- Date -->
					<div class="date-box">

						<i class="bi bi-calendar3"></i> <span id="currentDate"></span>

					</div>


					<!-- Admin -->
					<div class="admin">

						<div class="admin-avatar">SA</div>

						<div>

							<div class="admin-name">Super Admin</div>

							<div class="admin-role">Chairman</div>

						</div>

					</div>

				</div>

			</div>

			<div class="container">

				<section class="content-grid monthly-charge-page">

					<div class="card">

						<h2 class="card-title">Monthly Charges Details</h2>

						<form id="chargesForm"
							action="${pageContext.request.contextPath}/AddMonthlyBill"
							method="post">

							<!-- ================= FORM FIELDS ================= -->

							<div class="form-grid">
								<input type="hidden" id="resident-id" name="residentId"
									value="111"> <input type="hidden" id="netAmount"
									name="netAmount"> <input type="hidden" id="subTotal"
									name="subTotal"> <input type="hidden" id="gstAmount"
									name="gstAmount">


								<div class="field">
									<label for="flatNumber"> Flat Number <span class="req">*</span>
									</label> <input type="text" id="flatNumber" name="flatNumber"
										placeholder="e.g. A-101" maxlength="5" required>
									<div class="owner-box" id="ownerBox">

										<i class="bi bi-person-circle"></i> <span class="ownerText">
											Enter a valid flat number to find the resident. </span>

									</div>
								</div>


								<div class="field">
									<label for="chargeDate"> Date <span class="req">*</span>
									</label> <input type="month" id="chargeDate" name="chargeDate" required
										pattern="\d{4}-\d{2}" placeholder="YYYY-MM"
										title="Please enter a date in YYYY-MM format">



								</div>



								<div class="field">
									<label for="gstRate"> GST Rate (%) <span class="req">*</span>
									</label> <input type="number" step="0.01" min="0" max="100"
										id="gstRate" name="gstRate" value="18" required>
								</div>


								<div class="field">
									<label for="maintenanceAmount"> Maintenance Amount <span
										class="req">*</span>
									</label> <input type="number" step="0.01" min="0"
										id="maintenanceAmount" name="maintenanceAmount" value="0"
										required>
								</div>


								<div class="field">
									<label for="electricityCharges"> Electricity Charges <span
										class="req">*</span>
									</label> <input type="number" step="0.01" min="0"
										id="electricityCharges" name="electricityCharges" value="0"
										required>
								</div>


								<div class="field">
									<label for="waterCharges"> Water Charges <span
										class="req">*</span>
									</label> <input type="number" step="0.01" min="0" id="waterCharges"
										name="waterCharges" value="0" required>
								</div>


								<div class="field">
									<label for="parkingCharges"> Parking Charges <span
										class="req">*</span>
									</label> <input type="number" step="0.01" min="0" id="parkingCharges"
										name="parkingCharges" value="0" required>
								</div>


								<div class="field">
									<label for="securityCharges"> Security Charges <span
										class="req">*</span>
									</label> <input type="number" step="0.01" min="0" id="securityCharges"
										name="securityCharges" value="0" required>
								</div>


								<div class="field">
									<label for="otherCharges"> Other Charges </label> <input
										type="number" step="0.01" min="0" id="otherCharges"
										name="otherCharges" value="0">
								</div>

							</div>


							<!-- ================= NET AMOUNT ================= -->

							<div class="net-amount-bar solid">

								<span class="net-amount-label"> <span class="rupee-chip">&#8377;</span>
									Net Amount (with GST)
								</span> <span class="net-amount-value" id="detailsNetPreview">
									&#8377;0.00 </span>

							</div>


							<!-- ================= BREAKDOWN ================= -->

							<div class="panel-intro">

								<div class="panel-intro-icon">&#128196;</div>

								<div>
									<div class="panel-intro-title">Charges Breakdown</div>

									<div class="panel-intro-sub">Detailed breakup of all
										monthly charges.</div>
								</div>

							</div>


							<div class="table-scroll">

								<table class="breakdown-table">

									<thead>
										<tr>
											<th>Sr. No.</th>
											<th>Particulars</th>
											<th class="num">Amount (&#8377;)</th>
										</tr>
									</thead>

									<tbody>

										<tr>
											<td>1</td>
											<td><span class="breakdown-particular"> <span
													class="breakdown-ic breakdown-ic-indigo"> &#127968;
												</span> Base Maintenance
											</span></td>

											<td class="num" data-mirror="maintenanceAmount">0.00</td>
										</tr>


										<tr>
											<td>2</td>
											<td><span class="breakdown-particular"> <span
													class="breakdown-ic breakdown-ic-orange"> &#9889; </span>
													Electricity Charges
											</span></td>

											<td class="num" data-mirror="electricityCharges">0.00</td>
										</tr>


										<tr>
											<td>3</td>
											<td><span class="breakdown-particular"> <span
													class="breakdown-ic breakdown-ic-blue"> &#128167; </span>
													Water Charges
											</span></td>

											<td class="num" data-mirror="waterCharges">0.00</td>
										</tr>


										<tr>
											<td>4</td>
											<td><span class="breakdown-particular"> <span
													class="breakdown-ic breakdown-ic-green"> &#128663; </span>
													Parking Charges
											</span></td>

											<td class="num" data-mirror="parkingCharges">0.00</td>
										</tr>


										<tr>
											<td>5</td>
											<td><span class="breakdown-particular"> <span
													class="breakdown-ic breakdown-ic-red"> &#128737; </span>
													Security Charges
											</span></td>

											<td class="num" data-mirror="securityCharges">0.00</td>
										</tr>


										<tr>
											<td>6</td>
											<td><span class="breakdown-particular"> <span
													class="breakdown-ic breakdown-ic-gray"> &#8943; </span>
													Other Charges
											</span></td>

											<td class="num" data-mirror="otherCharges">0.00</td>
										</tr>

									</tbody>

								</table>

							</div>


							<!-- ================= SUMMARY ================= -->

							<div class="breakdown-summary">

								<div class="breakdown-summary-row">
									<span>Sub Total</span> <span id="breakdownSubTotal">0.00</span>
								</div>

								<div class="breakdown-summary-row" id="gstRow">

									<span>GST </span> <span id="breakdownGst"> 0.00 </span>

								</div>

							</div>


							<!-- ================= FINAL TOTAL ================= -->

							<div class="net-amount-bar solid">

								<span class="net-amount-label"> Net Amount (with GST) </span> <span
									class="net-amount-value"> <span id="breakdownNet">0.00</span>
								</span>

							</div>


							<!-- ================= INFO ================= -->

							<div class="info-note">

								<span class="ic">&#8505;</span> <span> GST is calculated
									on the subtotal amount using the GST rate entered above. </span>

							</div>


							<!-- ================= ACTIONS ================= -->

							<div class="form-actions">

								<button type="button" class="btn-secondary" id="resetFormBtn">
									&#8635; Reset</button>

								<button type="submit" class="btn-primary" id="saveFormBtn">
									&#128190; Save</button>

							</div>

						</form>

					</div>

				</section>

			</div>
			<script type="text/javascript">
				const contextPath = "${pageContext.request.contextPath}";
			</script>
			<script src="../js/add-monthly-charges.js"></script>
			<script src="../js/maintenance.js"></script>
</body>
</html>
