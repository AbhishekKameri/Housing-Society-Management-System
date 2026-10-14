<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="java.util.*"%>
<%@ page
	import="com.housingsociety.dao.*,com.housingsociety.model.*,com.housingsociety.service.*"%>

<%
// ---- Demo data (in a real app this would come from a DAO / Servlet request attribute) ----
FlatService fs = new FlatService();


List<Flat> flats = FlatDao.getFlatData();
int totalFlats = flats.size();
int vacant = fs.getVacantFlatCount();
int occupied = totalFlats - vacant;
int bhk1 = fs.getOneBHKCount();
int bhk2 = fs.getTwoBHKCount();
int bhk3 = fs.getThreeBHKCount();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Flat Management · Society HMS</title>
<link rel="stylesheet" href="../CSS/style.css">
<link rel="stylesheet" href="../CSS/edit-form.css">
</head>
<body>

	<!-- Overlay for mobile sidebar -->
	<div class="overlay" id="overlay"></div>

	<div class="app">

		<!-- ============ SIDEBAR ============ -->
		<aside class="sidebar" id="sidebar">
			<div class="brand">
				<span class="brand-icon" aria-hidden="true">&#9638;</span>
				<div>
					<div class="brand-title">Society HMS</div>
					<div class="brand-sub">Housing Management System</div>
				</div>
			</div>

			<nav class="nav">
				<a class="nav-item" href="#"><span class="ic">&#8962;</span>Dashboard</a>

				<button class="nav-item nav-group" data-target="residents">
					<span class="ic">&#128101;</span>Residents <span class="chev">&rsaquo;</span>
				</button>

				<a class="nav-item" href="#"><span class="ic">&#128196;</span>Share
					Certificates</a> <a class="nav-item" href="#"><span class="ic">&#128663;</span>Parking</a>

				<button class="nav-item nav-group" data-target="maintenance">
					<span class="ic">&#128295;</span>Maintenance <span class="chev">&rsaquo;</span>
				</button>

				<button class="nav-item nav-group open" data-target="flats">
					<span class="ic">&#127968;</span>Flats <span class="chev">&#8964;</span>
				</button>
				<div class="nav-sub open" id="flats">
					<a class="nav-subitem active" href="./flat-management.jsp">Flat
						Dashboard</a> <a class="nav-subitem" href="./add-owner.jsp">Add
						Owner </a> <a class="nav-subitem" href="#"> </a> <a
						class="nav-subitem" href="./edit-owner.jsp">Update Flat
						Details</a>
				</div>

				<a class="nav-item" href="#"><span class="ic">&#128172;</span>Complaints</a>

				<button class="nav-item nav-group" data-target="reports">
					<span class="ic">&#128202;</span>Reports <span class="chev">&rsaquo;</span>
				</button>

				<a class="nav-item" href="#"><span class="ic">&#9881;</span>Settings</a>
			</nav>

			<div class="sidebar-footer">
				<div class="user-chip">
					<span class="avatar">&#128100;</span>
					<div>
						<div class="user-name">Administrator</div>
						<div class="user-mail">admin@society.com</div>
					</div>
				</div>
				<a class="logout" href="#">&#8618; Logout</a>
			</div>
		</aside>

		<!-- ============ MAIN ============ -->
		<div class="main">

			<!-- Top bar (mobile) -->
			<div class="topbar">
				<button class="hamburger" id="hamburger" aria-label="Open menu">
					<span></span><span></span><span></span>
				</button>
				<span class="topbar-title">Society HMS</span>
			</div>

			<header class="page-header">
				<div>
					<h1>Flat Management</h1>
					<p>Manage all flats in the society</p>
				</div>
				<div class="header-actions">
					<button class="date-pill">&#128197; 18 May 2025</button>
					<button class="btn-primary">+ Add New Flat</button>
				</div>
			</header>

			<!-- Stat cards -->
			<section class="stats">
				<div class="stat-card">
					<div class="stat-icon blue">&#127970;</div>
					<div class="stat-body">
						<div class="stat-label">Total Flats</div>
						<div class="stat-value"><%=totalFlats%></div>
						<div class="stat-hint">All registered flats</div>
					</div>
				</div>
				<div class="stat-card">
					<div class="stat-icon green">&#127968;</div>
					<div class="stat-body">
						<div class="stat-label">Occupied</div>
						<div class="stat-value"><%=occupied%></div>
						<div class="stat-hint"><%=String.format("%.2f", occupied * 100.0 / totalFlats)%>%
							of total flats
						</div>
					</div>
				</div>
				<div class="stat-card">
					<div class="stat-icon orange">&#127969;</div>
					<div class="stat-body">
						<div class="stat-label">Vacant</div>
						<div class="stat-value"><%=vacant%></div>
						<div class="stat-hint"><%=String.format("%.2f", vacant * 100.0 / totalFlats)%>%
							of total flats
						</div>
					</div>
				</div>
				 
			</section>

			<!-- Content grid -->
			<section class="content-grid">

				<!-- All flats table card -->
				<div class="card table-card">
					<h2 class="card-title">All Flats</h2>

					<div class="table-toolbar">
						<div class="search-box">
							<span class="ic">&#128269;</span> <input type="text"
								id="searchInput"
								placeholder="Search by flat no., owner name or type...">
						</div>
						<select id="statusFilter" class="status-select">
							<option value="all">All Status</option>
							<option value="occupied">Occupied</option>
							<option value="vacant">Vacant</option>
							 
						</select>
						 
					</div>

					<div class="table-scroll">
						<table id="flatsTable">
							<thead>
								<tr>
									<th>Flat No.</th>
									<th>Owner Name</th>
									<th>Flat Type</th>
									<th>Status</th>
									<th>Floor</th>
									<th>Actions</th>
								</tr>
							</thead>
							<tbody>
								<%
								for (Flat f : flats) {
									String badgeClass = f.getStatus().equals("Occupied") ? "badge-green"
									: f.getStatus().equals("Vacant") ? "badge-orange" : "badge-red";
								%>
								<tr>
									<td data-label="Flat No."><%=f.getFlatNumber()%></td>
									<td data-label="Owner Name"><%=f.getResidentName()%></td>
									<td data-label="Flat Type"><%=f.getFlatType()%></td>
									<td data-label="Status"><span
										class="badge <%=badgeClass%>"><%=f.getStatus()%></span></td>
									<td data-label="Floor"><%=f.getFloor()%></td>
									<td data-label="Actions" class="actions-cell">
										<% if(f.getLinkedResidentId() != 0){%>
											<a href="./view-owner.jsp?id=<%=f.getLinkedResidentId()%>"> <button class="icon-btn" title="View">&#128065;</button> </a>
											<a href ="./edit-owner.jsp?id=<%=f.getLinkedResidentId()%>"> <button class="icon-btn" title="Edit">&#9998;</button> </a>
										<%} %>
										
									</td>
								</tr>
								<%
								}
								%>
							</tbody>
						</table>
					</div>

					<div class="table-footer">
						<span class="rows-info">Showing 1 to <%=flats.size()%> of
							<%=totalFlats%> flats
						</span>
						<div class="pagination">
							<button class="page-btn" aria-label="Previous">&lsaquo;</button>
							<button class="page-btn active">1</button>
							<button class="page-btn">2</button>
							<button class="page-btn">3</button>
							<button class="page-btn">4</button>
							<button class="page-btn">5</button>
							<button class="page-btn" aria-label="Next">&rsaquo;</button>
						</div>
						<label class="rows-per-page">Rows per page <select>
								<option>10</option>
								<option>25</option>
								<option>50</option>
						</select>
						</label>
					</div>
				</div>

				<!-- Right column -->
				<div class="side-col">

					<div class="card">
						<h2 class="card-title">Flats by Status</h2>



						<div class="container">


							<canvas id="flatChart"></canvas>
						</div>

					</div>


					<div class="card">
						<h2 class="card-title">Quick Actions</h2>
						<button class="quick-action">
							<span class="qa-ic blue">+</span> <span class="qa-text"> <span
								class="qa-title">Add New Flat</span> <span class="qa-sub">Register
									a new flat in the society</span>
							</span> <span class="chev">&rsaquo;</span>
						</button>
						<button class="quick-action">
							<span class="qa-ic">&#128065;</span> <span class="qa-text">
								<span class="qa-title">View All Flats</span> <span
								class="qa-sub">View and search all flats</span>
							</span> <span class="chev">&rsaquo;</span>
						</button>
						<button class="quick-action">
							<span class="qa-ic">&#9998;</span> <span class="qa-text">
								<span class="qa-title">Update Flat Details</span> <span
								class="qa-sub">Update owner or flat information</span>
							</span> <span class="chev">&rsaquo;</span>
						</button>
					</div>

					<div class="card">
						<h2 class="card-title">Flat Type Summary</h2>
						<div class="type-summary">
							<div class="type-card">
								<div class="type-label">1 BHK</div>
								<div class="type-row">
									<span class="type-value"><%=bhk1%></span><span
										class="type-ic">&#127968;</span>
								</div>
							</div>
							<div class="type-card">
								<div class="type-label">2 BHK</div>
								<div class="type-row">
									<span class="type-value"><%=bhk2%></span><span
										class="type-ic">&#127968;</span>
								</div>
							</div>
							<div class="type-card">
								<div class="type-label">3 BHK</div>
								<div class="type-row">
									<span class="type-value"><%=bhk3%></span><span
										class="type-ic">&#127968;</span>
								</div>
							</div>
						</div>
					</div>

				</div>
			</section>

			<footer class="page-footer">Made with Society HMS</footer>
		</div>
	</div>

 <script type="text/javascript">
 const occupied = <%=occupied%>;
 const vacant = <%= vacant%>;
 
 console.log(occupied,vacant);
  
 </script>
	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
	<script src="../JS/script.js?v2"></script>
</body>
</html>
