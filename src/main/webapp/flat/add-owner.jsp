<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDate, java.util.*" %>
<%!
    // Mirrors the Owner model supplied by the caller
    class Owner {
        String firstName, lastName;
        int age;
        String gender, bloodGroup;
        String email, aadhaarNumber, occupation, mobileNumber;
        String flatNumber;
        LocalDate moveInDate, moveOutDate;
        String emergencyContact, status;
    }
%>
<%
    // Flats available for assignment (would normally come from a DAO / request attribute)
    String[] availableFlats = {
        "A-101", "A-102", "A-103", "B-201", "B-202", "B-203",
        "C-301", "C-302", "D-401", "D-402"
    };
    String[] bloodGroups = {"A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"};
    // If editing an existing owner, a servlet would set this attribute; null here means "Add" mode
    Owner owner = (Owner) request.getAttribute("owner");
    boolean isEdit = (owner != null);
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><%= isEdit ? "Edit Owner" : "Add New Owner" %> · Society HMS</title>
<link rel="stylesheet" href="../CSS/style.css">
<link rel="stylesheet" href="../CSS/form.css">
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
        <a class="nav-subitem active" href="#">Add New Owner</a>
        <a class="nav-subitem" href="#">All Residents</a>
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
        <h1><%= isEdit ? "Edit Owner" : "Add New Owner" %></h1>
        <p>Register a resident and assign them to a flat</p>
      </div>
      <div class="header-actions">
        <a href="flat-management.jsp" class="date-pill">&#8592; Back to Flats</a>
      </div>
    </header>

    <form class="owner-form" id="ownerForm" action="SaveOwnerServlet" method="post" novalidate>

      <!-- ================= Personal Details ================= -->
      <section class="card form-section">
        <h2 class="card-title">Personal Details</h2>
        <div class="form-grid cols-3">

          <div class="field">
            <label for="firstName">First Name <span class="req">*</span></label>
            <input type="text" id="firstName" name="firstName" placeholder="e.g. Rahul"
                   value="<%= isEdit ? owner.firstName : "" %>" required>
            <span class="error-msg" data-for="firstName"></span>
          </div>

          <div class="field">
            <label for="lastName">Last Name <span class="req">*</span></label>
            <input type="text" id="lastName" name="lastName" placeholder="e.g. Sharma"
                   value="<%= isEdit ? owner.lastName : "" %>" required>
            <span class="error-msg" data-for="lastName"></span>
          </div>

          <div class="field">
            <label for="age">Age <span class="req">*</span></label>
            <input type="number" id="age" name="age" placeholder="e.g. 34" min="1" max="120"
                   value="<%= isEdit ? owner.age : "" %>" required>
            <span class="error-msg" data-for="age"></span>
          </div>

          <div class="field">
            <label for="gender">Gender <span class="req">*</span></label>
            <select id="gender" name="gender" required>
              <option value="" disabled <%= !isEdit ? "selected" : "" %>>Select gender</option>
              <option value="Male" <%= isEdit && "Male".equals(owner.gender) ? "selected" : "" %>>Male</option>
              <option value="Female" <%= isEdit && "Female".equals(owner.gender) ? "selected" : "" %>>Female</option>
              <option value="Other" <%= isEdit && "Other".equals(owner.gender) ? "selected" : "" %>>Other</option>
            </select>
            <span class="error-msg" data-for="gender"></span>
          </div>

          <div class="field">
            <label for="bloodGroup">Blood Group</label>
            <select id="bloodGroup" name="bloodGroup">
              <option value="" <%= !isEdit ? "selected" : "" %>>Select blood group</option>
              <% for (String bg : bloodGroups) { %>
                <option value="<%= bg %>" <%= isEdit && bg.equals(owner.bloodGroup) ? "selected" : "" %>><%= bg %></option>
              <% } %>
            </select>
          </div>

          <div class="field">
            <label for="occupation">Occupation</label>
            <input type="text" id="occupation" name="occupation" placeholder="e.g. Software Engineer"
                   value="<%= isEdit ? owner.occupation : "" %>">
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
                     maxlength="10" value="<%= isEdit ? owner.mobileNumber : "" %>" required>
            </div>
            <span class="error-msg" data-for="mobileNumber"></span>
          </div>

          <div class="field">
            <label for="email">Email Address</label>
            <input type="email" id="email" name="email" placeholder="name@example.com"
                   value="<%= isEdit ? owner.email : "" %>">
            <span class="error-msg" data-for="email"></span>
          </div>

          <div class="field">
            <label for="aadhaarNumber">Aadhaar Number <span class="req">*</span></label>
            <input type="text" id="aadhaarNumber" name="aadhaarNumber" placeholder="XXXX XXXX XXXX"
                   maxlength="12" inputmode="numeric"
                   value="<%= isEdit ? owner.aadhaarNumber : "" %>" required>
            <span class="error-msg" data-for="aadhaarNumber"></span>
          </div>

          <div class="field">
            <label for="emergencyContact">Emergency Contact <span class="req">*</span></label>
            <input type="tel" id="emergencyContact" name="emergencyContact" placeholder="Alternate contact number"
                   maxlength="10" value="<%= isEdit ? owner.emergencyContact : "" %>" required>
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
              <option value="" disabled <%= !isEdit ? "selected" : "" %>>Select a flat</option>
              <% for (String fn : availableFlats) { %>
                <option value="<%= fn %>" <%= isEdit && fn.equals(owner.flatNumber) ? "selected" : "" %>><%= fn %></option>
              <% } %>
            </select>
            <span class="error-msg" data-for="flatNumber"></span>
          </div>

          <div class="field">
            <label for="moveInDate">Move-in Date <span class="req">*</span></label>
            <input type="date" id="moveInDate" name="moveInDate"
                   value="<%= isEdit && owner.moveInDate != null ? owner.moveInDate.toString() : "" %>" required>
            <span class="error-msg" data-for="moveInDate"></span>
          </div>

          <div class="field">
            <label for="moveOutDate">Move-out Date</label>
            <input type="date" id="moveOutDate" name="moveOutDate"
                   value="<%= isEdit && owner.moveOutDate != null ? owner.moveOutDate.toString() : "" %>">
            <span class="error-msg" data-for="moveOutDate"></span>
            <span class="hint">Leave blank if currently residing</span>
          </div>

          <div class="field">
            <label for="status">Status <span class="req">*</span></label>
            <select id="status" name="status" required>
              <option value="" disabled <%= !isEdit ? "selected" : "" %>>Select status</option>
              <option value="Active" <%= isEdit && "Active".equals(owner.status) ? "selected" : "" %>>Active</option>
              <option value="Inactive" <%= isEdit && "Inactive".equals(owner.status) ? "selected" : "" %>>Inactive</option>
              <option value="Moved Out" <%= isEdit && "Moved Out".equals(owner.status) ? "selected" : "" %>>Moved Out</option>
            </select>
            <span class="error-msg" data-for="status"></span>
          </div>

        </div>
      </section>

      <!-- ================= Actions ================= -->
      <div class="form-actions">
        <button type="button" class="btn-secondary" id="resetBtn">Reset</button>
        <button type="submit" class="btn-primary">
          <%= isEdit ? "Save Changes" : "Add Owner" %>
        </button>
      </div>

    </form>

    <footer class="page-footer">Made with Society HMS</footer>
  </div>
</div>

<script src="../JS/script.js"></script>
<script src="../JS/owner-form.js"></script>
</body>
</html>
