<%@page import="com.housingsociety.dao.FlatDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDate, java.time.format.DateTimeFormatter, java.time.Period" %>
<%@ page import = "com.housingsociety.model.*" %>
<%!
   
%>

<%  
int residentId =0;
if(Integer.parseInt(request.getParameter("id"))== 0 ){
	 request.getRequestDispatcher("flat-management.jsp").forward(request, response);
	
}

 
	residentId = Integer.parseInt(request.getParameter("id"));

	 residentId = 111;
     
    Owner owner = FlatDao.getOwnerByID(residentId);
  
	Flat flat = FlatDao.getFlatByResidentID(residentId);

    // ---- Demo fallback so the page renders standalone ----
    

    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd MMM yyyy");
    String fullName = owner.getFirstName() + " " + owner.getLastName();
    String badgeClass = "Active".equals(owner.getStatus()) ? "badge-green"
                         : "Inactive".equals(owner.getStatus()) ? "badge-orange"
                         : "badge-red";

    String moveInDisplay = owner.getMoveInDate() != null ? owner.getMoveInDate().format(fmt) : "--";
    String moveOutDisplay = owner.getMoveOutDate() != null ? owner.getMoveOutDate().format(fmt) : "Currently residing";

    String tenureDisplay;
    if (owner.getMoveInDate() != null) {
        LocalDate end = owner.getMoveOutDate() != null ? owner.getMoveOutDate() : LocalDate.now();
        Period p = Period.between(owner.getMoveInDate(), end);
        tenureDisplay = p.getYears() + "y " + p.getMonths() + "m";
    } else {
        tenureDisplay = "--";
    }

    // Mask Aadhaar for on-screen display; only the last 4 digits are shown
    String aadhaarMasked = owner.getAadhaarNumber() != null && owner.getAadhaarNumber().length() == 12
        ? "XXXX XXXX " + owner.getAadhaarNumber().substring(8)
        : owner.getAadhaarNumber();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><%= fullName %> · Owner Details · Society HMS</title>
<link rel="stylesheet" href="../CSS/style.css">
<link rel="stylesheet" href="../CSS/form.css">
<link rel="stylesheet" href="../CSS/view.css">

<link rel="stylesheet" href="../CSS/edit-form.css">
</head>
<body>

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

      <button class="nav-item nav-group open" data-target="residents">
        <span class="ic">&#128101;</span>Residents <span class="chev">&#8964;</span>
      </button>
      <div class="nav-sub open" id="residents">
        <a class="nav-subitem" href="add-owner.jsp">Add New Owner</a>
        <a class="nav-subitem active" href="#">All Residents</a>
        <a class="nav-subitem" href="#">Tenants</a>
      </div>

      <a class="nav-item" href="#"><span class="ic">&#128196;</span>Share Certificates</a>
      <a class="nav-item" href="#"><span class="ic">&#128663;</span>Parking</a>

      <button class="nav-item nav-group" data-target="maintenance">
        <span class="ic">&#128295;</span>Maintenance <span class="chev">&rsaquo;</span>
      </button>

      <button class="nav-item nav-group" data-target="flats">
        <span class="ic">&#127968;</span>Flats <span class="chev">&rsaquo;</span>
      </button>
      <div class="nav-sub" id="flats">
        <a class="nav-subitem" href="flat-management.jsp">Flat Dashboard</a>
        <a class="nav-subitem" href="#">Add New Flat</a>
        <a class="nav-subitem" href="#">View All Flats</a>
        <a class="nav-subitem" href="#">Update Flat Details</a>
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

    <div class="topbar">
      <button class="hamburger" id="hamburger" aria-label="Open menu">
        <span></span><span></span><span></span>
      </button>
      <span class="topbar-title">Society HMS</span>
    </div>

    <header class="page-header">
      <div>
        <h1>Owner Details</h1>
        <p>Read-only summary of the resident's record</p>
      </div>
      <div class="header-actions">
        <a href="flat-management.jsp" class="date-pill">&#8592; Back to Flats</a>
        <a href="edit-owner.jsp?id=<%=residentId %>" class="btn-primary">&#9998; Edit Owner</a>
      </div>
    </header>

    <!-- Profile header -->
    <div class="card owner-summary">
      <div class="owner-avatar"><%= owner.getFirstName().substring(0,1) %><%= owner.getLastName().substring(0,1) %></div>
      <div class="owner-summary-body">
        <div class="owner-summary-name"><%= fullName %>
          <span class="badge <%= badgeClass %>"><%= owner.getStatus() %></span>
        </div>
        <div class="owner-summary-meta">
          Flat <%= owner.getFlatNumber() %> &nbsp;&middot;&nbsp;
          Owner ID <%= owner.getResidentId() %> &nbsp;&middot;&nbsp;
          Resident for <%= tenureDisplay %>
        </div>
      </div>
      <div class="owner-summary-stats">
        <div class="mini-stat">
          <span class="mini-stat-label">Age</span>
          <span class="mini-stat-value"><%= owner.getAge() %></span>
        </div>
        <div class="mini-stat">
          <span class="mini-stat-label">Blood Group</span>
          <span class="mini-stat-value"><%= owner.getBloodGroup() != null && !owner.getBloodGroup().isEmpty() ? owner.getBloodGroup() : "--" %></span>
        </div>
        <div class="mini-stat">
          <span class="mini-stat-label">Gender</span>
          <span class="mini-stat-value"><%= owner.getGender() %></span>
        </div>
      </div>
    </div>

    <!-- ================= Personal Details ================= -->
    <section class="card view-section">
      <h2 class="card-title">Personal Details</h2>
      <div class="info-grid cols-3">
        <div class="info-item">
          <span class="info-label">First Name</span>
          <span class="info-value"><%= owner.getFirstName() %></span>
        </div>
        <div class="info-item">
          <span class="info-label">Last Name</span>
          <span class="info-value"><%= owner.getLastName() %></span>
        </div>
        <div class="info-item">
          <span class="info-label">Age</span>
          <span class="info-value"><%= owner.getAge() %> years</span>
        </div>
        <div class="info-item">
          <span class="info-label">Gender</span>
          <span class="info-value"><%= owner.getGender() %></span>
        </div>
        <div class="info-item">
          <span class="info-label">Blood Group</span>
          <span class="info-value"><%= owner.getBloodGroup() != null && !owner.getBloodGroup().isEmpty() ? owner.getBloodGroup() : "--" %></span>
        </div>
        <div class="info-item">
          <span class="info-label">Occupation</span>
          <span class="info-value"><%= owner.getOccupation() != null && !owner.getOccupation().isEmpty() ? owner.getOccupation() : "--" %></span>
        </div>
      </div>
    </section>

    <!-- ================= Contact Details ================= -->
    <section class="card view-section">
      <h2 class="card-title">Contact Details</h2>
      <div class="info-grid cols-3">
        <div class="info-item">
          <span class="info-label">Mobile Number</span>
          <span class="info-value">+91 <%= owner.getMobileNumber() %></span>
        </div>
        <div class="info-item">
          <span class="info-label">Email Address</span>
          <span class="info-value"><%= owner.getEmail() != null && !owner.getEmail().isEmpty() ? owner.getEmail() : "--" %></span>
        </div>
        <div class="info-item">
          <span class="info-label">Aadhaar Number</span>
          <span class="info-value"><%= aadhaarMasked != null ? aadhaarMasked : "--" %></span>
        </div>
        <div class="info-item">
          <span class="info-label">Emergency Contact</span>
          <span class="info-value">+91 <%= owner.getEmergencyContact() %></span>
        </div>
      </div>
    </section>

    <!-- ================= Flat Assignment ================= -->
    <section class="card view-section">
      <h2 class="card-title">Flat Assignment</h2>
      <div class="info-grid cols-3">
        <div class="info-item">
          <span class="info-label">Flat Number</span>
          <span class="info-value"><%= owner.getFlatNumber() %></span>
        </div>
        <div class="info-item">
          <span class="info-label">Flat Type</span>
          <span class="info-value"><%= flat.getFlatType()%></span>
        </div>
        <div class="info-item">
          <span class="info-label">Move-in Date</span>
          <span class="info-value"><%= moveInDisplay %></span>
        </div>
        <div class="info-item">
          <span class="info-label">Move-out Date</span>
          <span class="info-value"><%= moveOutDisplay %></span>
        </div>
        <div class="info-item">
          <span class="info-label">Status</span>
          <span class="info-value"><span class="badge <%= badgeClass %>"><%= owner.getStatus() %></span></span>
        </div>
      </div>
    </section>

    <div class="form-actions form-actions-split">
      <button type="button" class="btn-danger" id="deleteOwnerBtn">Delete Owner</button>
      <div class="form-actions-right">
        <a href='edit-owner.jsp?id=<%= residentId %>' class="btn-primary">&#9998; Edit Owner</a>
      </div>
    </div>

    <footer class="page-footer">Made with Society HMS</footer>
  </div>
</div>

<!-- Delete confirmation dialog -->
<div class="modal-overlay" id="deleteModalOverlay"  >
  <div class="modal-box">
    <h3>Remove this owner?</h3>
    <p>This will unlink <strong><%= fullName %></strong> from flat <strong><%= owner.getFlatNumber() %></strong>Type <strong><%=flat.getFlatType() %></strong>. This action cannot be undone.</p>
    <div class="modal-actions">
      <button type="button" class="btn-secondary" id="cancelDeleteBtn">Cancel</button>
      <form action="DeleteOwner" method="post" style="display:inline;">
        <input type="hidden" name="ownerId" value="<%= owner.getResidentId() %>">
        <button type="submit" class="btn-danger">Yes, Delete</button>
      </form>
    </div>
  </div>
</div>
 
<script src="js/script.js"></script>
<script src="js/edit-owner.js"></script>
</body>
</html>
