<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Add Occasional Maintenance</title>

<!-- Bootstrap Icons -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">

<!-- Your existing CSS -->

<link rel="stylesheet"
	href="<%=request.getContextPath()%>/css/sidebar.css">
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/css/pageHeader.css">
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/css/add-occassional.css">


</head>

<body>

	<!-- ================= SIDEBAR ================= -->
	<%@ include file="/sidebar.jsp"%>


	<!-- ================= MAIN CONTENT ================= -->

	<main class="main">

		<!-- If you already have header.jsp -->
		<%@ include file="/pageHeader.jsp"%>


		<div class="occasional-page">

			<!-- PAGE HEADER -->
			<div class="page-heading">

				<div>
					<h1>
						<i class="bi bi-tools"></i> Add Occasional Maintenance
					</h1>

					<p>Create a maintenance bill for special events and expenses.</p>
				</div>

				<div class="breadcrumb">
					<span>Home</span> <i class="bi bi-chevron-right"></i> <span>Maintenance</span>
					<i class="bi bi-chevron-right"></i> <span>Occasional
						Maintenance</span>
				</div>

			</div>


			<!-- ================= FORM CARD ================= -->

			<div class="occasional-card">

				<form id="occasionalForm"
					action="<%=request.getContextPath()%>/AddOccassionalBill"
					method="post">


					<!-- ================= EVENT DETAILS ================= -->

					<div class="section-heading">

						<div class="section-icon">
							<i class="bi bi-calendar-event"></i>
						</div>

						<div>
							<h2>Event Details</h2>
							<p>Enter the basic information about this event.</p>
						</div>

					</div>


					<div class="form-grid">

						<!-- EVENT NAME -->

						<div class="field">

							<label for="eventName"> Event Name <span class="required">*</span>
							</label> <input type="text" id="eventName" name="eventName"
								placeholder="e.g. Ganesh Chaturthi" maxlength="100" required>

						</div>


						<!-- EVENT DATE -->

						<div class="field">

							<label for="eventDate"> Event Date <span class="required">*</span>
							</label> <input type="date" id="eventDate" name="eventDate" required>

						</div>


						<!-- DESCRIPTION -->

						<div class="field full-width">

							<label for="description"> Description </label>

							<textarea id="description" name="description" rows="3"
								maxlength="500"
								placeholder="Enter details about the event or expense..."></textarea>

						</div>

						<div class="input">
							<label>GST Rate</label> <input type="text" value="18"
								name="gst_rate" id="gst-rate">
						</div>

					</div>


					<!-- ================= FLAT SELECTION ================= -->

					<div class="section-heading flat-heading">

						<div class="section-icon">
							<i class="bi bi-buildings"></i>
						</div>

						<div>
							<h2>Flats Involved</h2>
							<p>Select which flats should receive this bill.</p>
						</div>

					</div>


					<!-- SELECTION TABS -->

					<div class="flat-type-tabs">

						<button type="button" class="flat-tab active" data-type="single">

							<i class="bi bi-house"></i> Single Flat

						</button>


						<button type="button" class="flat-tab" data-type="range">

							<i class="bi bi-arrows-expand"></i> Flat Range

						</button>


						<button type="button" class="flat-tab" data-type="all">

							<i class="bi bi-buildings"></i> All Flats

						</button>

					</div>


					<!-- Hidden value submitted to servlet -->

					<input type="hidden" id="flatSelectionType"
						name="flatSelectionType" value="single">


					<!-- SINGLE FLAT -->

					<div id="singleFlatSection" class="flat-selection-section">

						<div class="field">

							<label for="flatNumber"> Flat Number <span
								class="required">*</span>
							</label> <input type="text" id="flatNumber" name="flatNumber"
								placeholder="e.g. A-101" maxlength="10" pattern="^[A-Z]-\d{3}$">




						</div>


						<div class="owner-box" id="ownerBox">

							<i class="bi bi-person-circle"></i> <span class="ownerText">
								Enter a valid flat number to find the resident. </span>

						</div>

					</div>


					<!-- FLAT RANGE -->

					<div id="rangeFlatSection" class="flat-selection-section hidden">

						<div class="range-grid">

							<div class="field">

								<label for="fromFlat"> From Flat <span class="required">*</span>
								</label> <input type="text" id="fromFlat" name="fromFlat"
									placeholder="e.g. A-101" pattern="^[A-Z]-\d{3}$">

								<div class="owner-box" id="ownerBox1">

									<i class="bi bi-person-circle"></i> <span class="ownerText">
										Enter a valid flat number to find the resident. </span>

								</div>

							</div>


							<div class="range-arrow">
								<i class="bi bi-arrow-right"></i>
							</div>


							<div class="field">

								<label for="toFlat"> To Flat <span class="required">*</span>
								</label> <input type="text" id="toFlat" name="toFlat"
									placeholder="e.g. A-110" pattern="^[A-Z]-\d{3}$">

								<div class="owner-box" id="ownerBox2">

									<i class="bi bi-person-circle"></i> <span class="ownerText">
										Enter a valid flat number to find the resident. </span>

								</div>

							</div>

						</div>


						<div class="selection-info">

							<i class="bi bi-info-circle"></i> <span> The bill will be
								generated for all flats between the selected range. </span>

						</div>

					</div>


					<!-- ALL FLATS -->

					<div id="allFlatSection" class="flat-selection-section hidden">

						<div class="all-flats-box">

							<div class="all-flat-icon">
								<i class="bi bi-buildings-fill"></i>
							</div>

							<div>

								<h3>All Flats</h3>

								<p>This occasional maintenance bill will be applied to all
									flats in the society.</p>

							</div>

							<i class="bi bi-check-circle-fill selected-icon"></i>

						</div>

					</div>


					<!-- ================= CHARGES ================= -->

					<div class="section-heading charges-heading">

						<div class="section-icon">
							<i class="bi bi-receipt"></i>
						</div>

						<div>
							<h2>Charges Breakdown</h2>
							<p>Add individual expenses for this event.</p>
						</div>

					</div>


					<div class="charges-card">

						<div class="charges-header">

							<span>Particulars</span> <span>Amount</span> <span></span>

						</div>


						<div id="chargesContainer">

							<!-- FIRST CHARGE -->

							<div class="charge-row">

								<input type="text" name="chargeName[]"
									placeholder="e.g. Decoration" class="charge-name" required>

								<input type="number" name="chargeAmount[]" class="charge-amount"
									placeholder="0.00" min="0" step="0.01" required>

								<button type="button" class="remove-charge"
									title="Remove charge">

									<i class="bi bi-trash3"></i>

								</button>

							</div>

						</div>


						<!-- ADD CHARGE -->

						<button type="button" id="addChargeBtn" class="add-charge-btn">

							<i class="bi bi-plus-lg"></i> Add Charge

						</button>


						<!-- SUMMARY -->



						<div class="charge-summary">

							<div class="summary-row">

								<span>Sub Total</span> <strong> ₹ <span id="subTotal">0.00</span>
								</strong>

							</div>


							<div class="summary-row">

								<span> GST <span class="gst-label"> </span>
								</span> <strong> ₹ <span id="gstAmount">0.00</span>
								</strong>

							</div>


							<div class="summary-total">

								<span> Net Amount </span> <strong> ₹ <span
									id="netAmount">0.00</span>
								</strong>

							</div>

						</div>

					</div>


					<!-- ================= HIDDEN AMOUNTS ================= -->

					<input type="hidden" name="subTotal" id="subTotalInput"> <input
						type="hidden" name="gstAmount" id="gstAmountInput"> <input
						type="hidden" name="netAmount" id="netAmountInput">




		 


					<!-- ================= ACTIONS ================= -->

					<div class="form-actions">

						<button type="button" class="btn-secondary" id="resetBtn">

							<i class="bi bi-arrow-counterclockwise"></i> Reset

						</button>


						<button type="submit" class="btn-primary">

							<i class="bi bi-floppy"></i> Save Bill

						</button>

					</div>

				</form>

			</div>

		</div>

	</main>

	<script>
	const contextPath = "${pageContext.request.contextPath}";
	
</script>
	<script src="<%=request.getContextPath()%>/js/add-occassional.js">

</script>


</body>
</html>