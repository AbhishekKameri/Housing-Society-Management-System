<%@page import="com.housingsociety.service.FlatService"%>
<%@page import="com.housingsociety.dao.FlatDao,com.housingsociety.model.*,com.housingsociety.service.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDate, java.util.*" %>
<%!
    // Mirrors the Owner model supplied by the caller
  
%>
<%
    // In a real app a servlet would look this owner up (by id/flat) and
    // set it as a request attribute before forwarding to this JSP, e.g.:
    //   request.setAttribute("owner", ownerDao.findById(ownerId));
    //   request.getRequestDispatcher("edit-owner.jsp").forward(request, response);
    Owner owner =  FlatDao.getOwnerByID(Integer.parseInt(request.getParameter("id")));

   
 FlatService fs = new FlatService();
    String[] availableFlats = fs.getVacantFlatNumbers();
    
    String[] bloodGroups = {"A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"};
    String fullName = owner.getFirstName() + " " + owner.getLastName();
    String badgeClass = "Active".equals(owner.getStatus()) ? "badge-green"
                         : "Inactive".equals(owner.getStatus()) ? "badge-orange"
                         : "badge-red";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Edit Owner · Society HMS</title>
<link rel="stylesheet" href="../CSS/style.css">
<link rel="stylesheet" href="../CSS/form.css">
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
        <a class="nav-subitem" href="./flat-management.jsp">Flat Dashboard</a>
        <a class="nav-subitem" href="./add-owner.jsp">Add Owner</a>
        <a class="nav-subitem" href="#">View All Flats</a>
        <a class="nav-subitem" href="./edit-owner.jsp">Update Flat Details</a>
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
        <h1>Edit Owner</h1>
        <p>Update resident and flat assignment details</p>
      </div>
      <div class="header-actions">
        <a href="flat-management.jsp" class="date-pill">&#8592; Back to Flats</a>
      </div>
    </header>

    <!-- Owner summary strip -->
    <div class="card owner-summary">
      <div class="owner-avatar"><%= owner.getFirstName().substring(0,1) %><%= owner.getLastName().substring(0,1) %></div>
      <div class="owner-summary-body">
        <div class="owner-summary-name"><%= fullName %>
          <span class="badge <%= badgeClass %>"><%= owner.getLastName() %></span>
        </div>
        <div class="owner-summary-meta">
          Flat <%= owner.getFlatNumber() %> &nbsp;&middot;&nbsp;
          Owner ID <%= owner.getResidentId() %> &nbsp;&middot;&nbsp;
          Resident since <%= owner.getMoveInDate() %>
        </div>
      </div>
    </div>

    <form class="owner-form" id="ownerForm" action="${pageContext.request.contextPath}/UpdateOwner" method="post" novalidate>
       

      <!-- ================= Personal Details ================= -->
      <section class="card form-section">
        <h2 class="card-title">Personal Details</h2>
        <div class="form-grid cols-3">

          <div class="field">
          <input type="hidden" value="<%=owner.getResidentId()%>" name="residentId">
            <label for="firstName">First Name <span class="req">*</span></label>
            <input type="text" id="firstName" name="firstName" placeholder="e.g. Rahul"
                   value="<%= owner.getFirstName() %>" required>
            <span class="error-msg" data-for="firstName"></span>
          </div>

          <div class="field">
            <label for="lastName">Last Name <span class="req">*</span></label>
            <input type="text" id="lastName" name="lastName" placeholder="e.g. Sharma"
                   value="<%= owner.getLastName() %>" required>
            <span class="error-msg" data-for="lastName"></span>
          </div>

          <div class="field">
            <label for="age">Age <span class="req">*</span></label>
            <input type="number" id="age" name="age" placeholder="e.g. 34" min="1" max="120"
                   value="<%= owner.getAge() %>" required>
            <span class="error-msg" data-for="age"></span>
          </div>

          <div class="field">
            <label for="gender">Gender <span class="req">*</span></label>
            <select id="gender" name="gender" required>
              <option value="" disabled>Select gender</option>
              <option value="Male" <%= "Male".equals(owner.getGender()) ? "selected" : "" %>>Male</option>
              <option value="Female" <%= "Female".equals(owner.getGender()) ? "selected" : "" %>>Female</option>
              <option value="Other" <%= "Other".equals(owner.getGender()) ? "selected" : "" %>>Other</option>
            </select>
            <span class="error-msg" data-for="gender"></span>
          </div>

          <div class="field">
            <label for="bloodGroup">Blood Group</label>
            <select id="bloodGroup" name="bloodGroup">
              <option value="">Select blood group</option>
              <% for (String bg : bloodGroups) { %>
                <option value="<%= bg %>" <%= bg.equals(owner.getBloodGroup()) ? "selected" : "" %>><%= bg %></option>
              <% } %>
            </select>
          </div>

          <div class="field">
            <label for="occupation">Occupation</label>
            <input type="text" id="occupation" name="occupation" placeholder="e.g. Software Engineer"
                   value="<%= owner.getOccupation() %>">
          </div>

        </div>
      </section>

      <!-- ================= Contact Details ================= -->
      <section class="card form-section">
        <h2 class="card-title">Contact Details</h2>
        <div class="form-grid cols-3">

          <div class="field">
            <label for="mobileNumber">Mobile Number <span class="req">*</span></label>
            <div class="input-affix">
              <span class="affix">+91</span>
              <input type="tel" id="mobileNumber" name="mobileNumber" placeholder="98765 43210"
                     maxlength="10" value="<%= owner.getMobileNumber() %>" required>
            </div>
            <span class="error-msg" data-for="mobileNumber"></span>
          </div>

          <div class="field">
            <label for="email">Email Address</label>
            <input type="email" id="email" name="email" placeholder="name@example.com"
                   value="<%= owner.getEmail() %>">
            <span class="error-msg" data-for="email"></span>
          </div>

          <div class="field">
            <label for="aadhaarNumber">Aadhaar Number <span class="req">*</span></label>
            <input type="text" id="aadhaarNumber" name="aadhaarNumber" placeholder="XXXX XXXX XXXX"
                   maxlength="12" inputmode="numeric"
                   value="<%= owner.getAadhaarNumber() %>" required>
            <span class="error-msg" data-for="aadhaarNumber"></span>
          </div>

          <div class="field">
            <label for="emergencyContact">Emergency Contact <span class="req">*</span></label>
            <input type="tel" id="emergencyContact" name="emergencyContact" placeholder="Alternate contact number"
                   maxlength="10" value="<%= owner.getEmergencyContact() %>" required>
            <span class="error-msg" data-for="emergencyContact"></span>
          </div>

        </div>
      </section>

      <!-- ================= Flat Assignment ================= -->
      <section class="card form-section">
        <h2 class="card-title">Flat Assignment</h2>
        <div class="form-grid cols-3">

          <div class="field">
            <label for="flatNumber">Flat Number <span class="req">*</span></label>
            <select id="flatNumber" name="flatNumber" required>
              <% for (String fn : availableFlats) { %>
                <option value="<%= fn %>" <%= fn.equals(owner.getFlatNumber()) ? "selected" : "" %>><%= fn %></option>
              <% } %>
            </select>
            <span class="error-msg" data-for="flatNumber"></span>
          </div>

          <div class="field">
            <label for="moveInDate">Move-in Date <span class="req">*</span></label>
            <input type="date" id="moveInDate" name="moveInDate"
                   value="<%= owner.getMoveInDate() != null ? owner.getMoveInDate().toString() : "" %>" required>
            <span class="error-msg" data-for="moveInDate"></span>
          </div>

          <div class="field">
            <label for="moveOutDate">Move-out Date</label>
            <input type="date" id="moveOutDate" name="moveOutDate"
                   value="<%= owner.getMoveOutDate() != null ? owner.getMoveOutDate().toString() : "" %>">
            <span class="error-msg" data-for="moveOutDate"></span>
            <span class="hint">Leave blank if currently residing</span>
          </div>

          <div class="field">
            <label for="status">Status <span class="req">*</span></label>
            <select id="status" name="status" required>
              <option value="Active" <%= "Active".equals(owner.getStatus()) ? "selected" : "" %>>Active</option>
              <option value="Inactive" <%= "Inactive".equals(owner.getStatus()) ? "selected" : "" %>>Inactive</option>
              <option value="Moved Out" <%= "Moved Out".equals(owner.getStatus()) ? "selected" : "" %>>Moved Out</option>
            </select>
            <span class="error-msg" data-for="status"></span>
          </div>

        </div>
      </section>

      <!-- ================= Actions ================= -->
      <div class="form-actions form-actions-split">
        <button type="button" class="btn-danger" id="deleteOwnerBtn">Delete Owner</button>
        <div class="form-actions-right">
          <button type="button" class="btn-secondary" id="resetBtn">Discard Changes</button>
           <button type="submit" class="btn-primary">Save Changes</button>
        </div>
      </div>

    </form>

    <footer class="page-footer">Made with Society HMS</footer>
  </div>
</div>

<!-- Delete confirmation dialog -->
<div class="modal-overlay" id="deleteModalOverlay">
  <div class="modal-box">
    <h3>Remove this owner?</h3>
    <p>This will unlink <strong><%= fullName %></strong> from flat <strong><%= owner.getFlatNumber() %></strong>. This action cannot be undone.</p>
    <div class="modal-actions">
      <button type="button" class="btn-secondary" id="cancelDeleteBtn">Cancel</button>
      <form action="${pageContext.request.contextPath}/DeleteOwner" method="post" style="display:inline;">
        <input type="hidden" name="ownerId" value="<%= owner.getResidentId() %>">
        <button type="submit" class="btn-danger">Yes, Delete</button> 
      </form>
       
    </div>
  </div>
</div>

<div class="modal-overlay" id="reset">
<div class="modal-box">
<div class="modal-actions">
<h3>Want to Reset All Fields?</h3>
 <button type="button" class="btn-primary" id="cancelReset">Cancel</button>
 <a href="view-owner.jsp?id=<%=owner.getResidentId()%>"> <button type="button" class="btn-danger" >Reset</button></a>
</div>
</div>


</div>
<script>
var modelContainer = document.getElementById("deleteModalOverlay");
var delteBtn = document.getElementById("deleteOwnerBtn");
var cancelBtn = document.getElementById("cancelDeleteBtn");

var resetBtn = document.getElementById("resetBtn");
var resetContainer = document.getElementById("reset");
var cancelReset = document.getElementById("cancelReset"); 




resetBtn.addEventListener("click",()=>{
	resetContainer.classList.add("show");
})

 cancelReset.addEventListener("click",()=>{
	 resetContainer.classList.remove("show");
})
cancelBtn.addEventListener("click",()=>{
	modelContainer.classList.remove("show");
})

delteBtn.addEventListener("click",function(){
	modelContainer.classList.add("show");
});

</script>
<script src="js/script.js"></script>
<script src="js/owner-form.js"></script>
<script src="js/edit-owner.js"></script>
</body>
</html>
