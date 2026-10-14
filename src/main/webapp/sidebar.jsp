 

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

/* =========================================================
   MAINTENANCE   (NEW)
========================================================= */

boolean isMonthlyMaintenance = currentPage.endsWith("/Maintenance/Maintenance.jsp");

boolean isOccasionalMaintenance = currentPage.endsWith("/Maintenance/Maintenance.jsp");

boolean isMaintenancePage = isMonthlyMaintenance || isOccasionalMaintenance;
%>

 

<title>Housing Society Management System</title>


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
             MAINTENANCE   (NEW — now expandable, same pattern as Society/Chairman)
        ================================================== -->

			<li class="society-menu"><a href="#" id="maintenanceMenu"
				class="menu-link <%=isMaintenancePage ? "active" : ""%>"> <i
					class="bi bi-tools"></i> <span> Maintenance </span> <i
					class="bi bi-chevron-down submenu-arrow"></i>

			</a>

				<ul id="maintenanceSubmenu"
					class="submenu <%=isMaintenancePage ? "show" : ""%>">

					<!-- MONTHLY MAINTENANCE -->

					<li><a
						href="<%=request.getContextPath()%>/Maintenance/monthlyMaintenance.jsp"
						class="submenu-link <%=isMonthlyMaintenance ? "active" : ""%>"> <i
							class="bi bi-calendar2-week"></i> <span> Monthly Maintenance </span>

					</a></li>

					<!-- OCCASIONAL MAINTENANCE -->

					<li><a
						href="<%=request.getContextPath()%>/Maintenance/occasionalMaintenance.jsp"
						class="submenu-link <%=isOccasionalMaintenance ? "active" : ""%>"> <i
							class="bi bi-stars"></i> <span> Occasional Maintenance </span>

					</a></li>
					
					<!-- Maintenance report -->
					<li><a
						href="<%=request.getContextPath()%>/Maintenance/maintenanceReport.jsp"
						class="submenu-link <%=isOccasionalMaintenance ? "active" : ""%>"> <i
							class="bi bi-stars"></i> <span>  Maintenance Report</span>

					</a></li>
				</ul></li>



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



	<!-- =========================================================
     SIDEBAR JAVASCRIPT  (see /js/sidebar.js — collapse toggle +
     submenu accordion for Society / Chairman / Maintenance)
========================================================= -->
<script src="<%=request.getContextPath()%>/js/sidebar.js"></script>
