document.addEventListener('DOMContentLoaded', function() {

	/* =================================================================
	   Tabs: Event Details <-> Charges Breakdown
	   ================================================================= */
	var tabButtons = document.querySelectorAll('.tab-btn');
	var tabPanels = document.querySelectorAll('.tab-panel');
	tabButtons.forEach(function(btn) {
		btn.addEventListener('click', function() {
			tabButtons.forEach(function(b) { b.classList.remove('active'); });
			tabPanels.forEach(function(p) { p.classList.remove('active'); });
			btn.classList.add('active');
			document.getElementById(btn.getAttribute('data-tab')).classList.add('active');
		});
	});
	
	let warningMessage="Want to delete bill?";

	/* =================================================================
	   Bills table row action dropdowns (the "..." menu)
	   ================================================================= */
	document.querySelectorAll(".action-toggle").forEach(toggle => {

		toggle.addEventListener("click", function(event) {

			// Prevent the row's click event from firing
			event.stopPropagation();

			const dropdown = this.nextElementSibling;

			// Close other open dropdowns
			document.querySelectorAll(".action-dropdown").forEach(menu => {
				if (menu !== dropdown) {
					menu.classList.remove("show");
				}
			});

			// Toggle this dropdown
			dropdown.classList.toggle("show");
		});
	});


	// Close dropdown when clicking anywhere outside
	document.addEventListener("click", function() {

		document.querySelectorAll(".action-dropdown").forEach(menu => {
			menu.classList.remove("show");
		});

	});
	/* =================================================================
	   Bills table: search + status + event filters
	   ================================================================= */
	var searchInput = document.getElementById('billSearch');
	var statusFilter = document.getElementById('statusFilter');
	var eventFilter = document.getElementById('eventFilter');
	var rows = document.querySelectorAll('#billsTable tbody tr');

	function applyTableFilters() {
		var term = (searchInput && searchInput.value || '').trim().toLowerCase();
		var status = (statusFilter && statusFilter.value || 'all').toLowerCase();
		var event = (eventFilter && eventFilter.value || 'all').toLowerCase();

		rows.forEach(function(row) {
			var billId = row.children[0].textContent.toLowerCase();
			var eventName = row.children[1].textContent.toLowerCase();
			var rowStatus = row.children[5].textContent.trim().toLowerCase();

			var matchesTerm = !term || billId.indexOf(term) !== -1 || eventName.indexOf(term) !== -1;
			var matchesStatus = status === 'all' || rowStatus === status;
			var matchesEvent = event === 'all' || eventName === event;

			row.style.display = (matchesTerm && matchesStatus && matchesEvent) ? '' : 'none';
		});
	}
	if (searchInput) searchInput.addEventListener('input', applyTableFilters);
	if (statusFilter) statusFilter.addEventListener('change', applyTableFilters);
	if (eventFilter) eventFilter.addEventListener('change', applyTableFilters);

	document.querySelectorAll('.page-btn').forEach(function(btn) {
		btn.addEventListener('click', function() {
			if (isNaN(parseInt(btn.textContent, 10))) return;
			document.querySelectorAll('.page-btn').forEach(function(b) { b.classList.remove('active'); });
			btn.classList.add('active');
		});
	});

	/* =================================================================
	   "Flats Involved" dropdown (All Flats / Single Flat / Flat Range)
	   ================================================================= */
	var flatsInvolvedBtn = document.getElementById('flatsInvolvedBtn');
	var flatsInvolvedMenu = document.getElementById('flatsInvolvedMenu');
	var flatsInvolvedLabel = document.getElementById('flatsInvolvedLabel');
	var flatsInvolvedModeInput = document.getElementById('flatsInvolvedMode');
	var flatsInvolvedValueInput = document.getElementById('flatsInvolvedValue');

	var flatChip = document.getElementById('flatChip');
	var flatChipIcon = document.getElementById('flatChipIcon');
	var flatChipText = document.getElementById('flatChipText');
	var flatChipSub = document.getElementById('flatChipSub');
	var flatChipRemove = document.getElementById('flatChipRemove');

	if (flatsInvolvedBtn) {
		flatsInvolvedBtn.addEventListener('click', function(e) {
			e.stopPropagation();
			flatsInvolvedMenu.classList.toggle('open');
		});
	}

	flatsInvolvedMenu.querySelectorAll('button[data-mode]').forEach(function(opt) {
		opt.addEventListener('click', function() {
			var mode = opt.getAttribute('data-mode');
			flatsInvolvedMenu.classList.remove('open');

			if (mode === 'all') {
				setFlatsInvolved('all', '', 'All Flats', '');
				return;
			}
			else if (mode === 'single') {
				setFlatsInvolved('single', '', 'Current Flat', '');
				return;
			}
			openFlatModal(mode);
		});
	});

	function setFlatsInvolved(mode, value, label, sub) {
		flatsInvolvedModeInput.value = mode;
		flatsInvolvedValueInput.value = value;
		flatsInvolvedLabel.textContent = label;

		if (mode === 'all') {
			warningMessage = "Delete all bills containing this event.";
			flatChip.style.display = 'none';
		} else {
			flatChip.style.display = 'inline-flex';
			flatChipIcon.innerHTML = mode === 'single' ? '<i class="bi bi-house"></i>' : '<i class="bi bi-buildings"></i>';
			flatChipText.textContent = label;
			flatChipSub.textContent = sub;
		}
	}

	if (flatChipRemove) {
		flatChipRemove.addEventListener('click', function() {
			setFlatsInvolved('all', '', 'All Flats', '');
		});
	}

	/* =================================================================
	   Modal: Select Specific Flat(s)
	   ================================================================= */
	var flatModalOverlay = document.getElementById('flatModalOverlay');
	var flatModalClose = document.getElementById('flatModalClose');
	var flatModalCancel = document.getElementById('flatModalCancel');
	var flatModalApply = document.getElementById('flatModalApply');


	var modeRangeRadio = document.getElementById('modeRange');


	var rangeFlatPanel = document.getElementById('rangeFlatPanel');





	var rangeFrom = document.getElementById('rangeFrom');
	var rangeTo = document.getElementById('rangeTo');
	var rangePreviewText = document.getElementById('rangePreviewText');
	var rangePreviewCount = document.getElementById('rangePreviewCount');

	function openFlatModal(mode) {
		flatModalOverlay.classList.add('open');
		if (mode === 'range') {
			modeRangeRadio.checked = true;

		}
		updateModePanels();
		updateRangePreview();

	}

	function closeFlatModal() {
		flatModalOverlay.classList.remove('open');
	}

	function updateModePanels() {
		var isRange = modeRangeRadio.checked;
		rangeFlatPanel.classList.toggle('active', isRange);
	}

	[modeRangeRadio].forEach(function(radio) {
		radio.addEventListener('change', updateModePanels);
	});

	if (flatModalClose) flatModalClose.addEventListener('click', closeFlatModal);
	if (flatModalCancel) flatModalCancel.addEventListener('click', closeFlatModal);
	flatModalOverlay.addEventListener('click', function(e) {
		if (e.target === flatModalOverlay) closeFlatModal();
	});
	document.addEventListener('keydown', function(e) {
		if (e.key === 'Escape') closeFlatModal();
	});





	// Flat-range preview (uses ALL_FLATS defined inline in the JSP)
	function updateRangePreview() {
		var fromIdx = ALL_FLATS.indexOf(rangeFrom.value);
		var toIdx = ALL_FLATS.indexOf(rangeTo.value);
		var lo = Math.min(fromIdx, toIdx);
		var hi = Math.max(fromIdx, toIdx);
		var count = (lo === -1 || hi === -1) ? 0 : (hi - lo + 1);

		rangePreviewText.innerHTML = 'Flats from <b>' + ALL_FLATS[lo] + '</b> to <b>' + ALL_FLATS[hi] + '</b> will be included.';
		rangePreviewCount.textContent = count;
		warningMessage ="Delete "+count+" bills.";
	}
	if (rangeFrom) rangeFrom.addEventListener('change', updateRangePreview);
	if (rangeTo) rangeTo.addEventListener('change', updateRangePreview);

	// Apply
	if (flatModalApply) {
		flatModalApply.addEventListener('click', function() {

			var fromIdx = ALL_FLATS.indexOf(rangeFrom.value);
			var toIdx = ALL_FLATS.indexOf(rangeTo.value);
			var lo = Math.min(fromIdx, toIdx);
			var hi = Math.max(fromIdx, toIdx);
			var count = hi - lo + 1;
			var label = ALL_FLATS[lo] + ' to ' + ALL_FLATS[hi];
			setFlatsInvolved('range', ALL_FLATS[lo] + ',' + ALL_FLATS[hi], label, '(' + count + ' flats)');

			closeFlatModal();
		});
	}

	/* =================================================================
	   Charges Breakdown — editable, addable/removable rows
	   ================================================================= */
	var GST_RATE = 0.18;


	var chargesTableBody = document.getElementById('chargesTableBody');
	var addChargeBtn = document.getElementById('addChargeBtn');
	var eventNameEl = document.getElementById("eventName");
	var eventDateEl = document.getElementById("eventDate");
	var eventDescriptionEl = document.getElementById("eventDescription");
	var subTotalEl = document.getElementById("breakdownSubTotal");
	var breakdownGstEl = document.getElementById("breakdownGst");
	var breakdownNet = document.getElementById("breakdownNet");
	let chargeInputs =document.querySelectorAll(".amount-input");
	const gstRateInput = document.getElementById("gst-rate");

	var subTotal = 0;
	var gstAmount = 0;
	var total = 0;
	console.log("rung");
	
	function escapeHtml(str) {
		var div = document.createElement('div');
		div.textContent = str;
		return div.innerHTML;
	}

	//reder live data

	document.querySelectorAll("tr").forEach(row => {

		row.addEventListener("click", function() {

			const billIdCell = this.querySelector("#bill-id");
			const billId = billIdCell.textContent.trim();
			const gstEl = document.getElementById("gst-rate");
			const billIdEl = document.getElementById("hidden-bill");
			const indexEl = document.getElementById("index-number");

			fetch(contextPath + "/AddOccassionalBill?billId="
				+ encodeURIComponent(billId))
				.then(response => response.json())
				.then(data => {


					eventNameEl.value = data.eventName;
					eventDateEl.value = data.eventDate;
					billIdEl.value = billId;

					eventDescriptionEl.textContent = data.eventDescription;
					gstEl.value = data.gstRate;

					chargesTableBody.innerHTML = '';
					var index = 0;
					subTotal = 0;

					Object.entries(data.charges).forEach(([name, amount]) => {
						index++;
						var tr = document.createElement('tr');
						var chIndex = "am" + index;
						var naIndex = "na" + index;
						tr.innerHTML =
							'<td>' + (index) + '</td>' +
							'<td><input type="text" class="particular-input" data-index="' + index + '" name="' + naIndex + '" placeholder="Enter description" value="' + name + '"></td>' +
							'<td class="num"><input type="number" step="0.01" min="0" class="amount-input" name="' + chIndex + '" data-index="' + index + '" value="' + amount + '"></td>';

						chargesTableBody.appendChild(tr);

						subTotal += amount;
					});
					indexEl.value = index;
					 
					subTotalEl.textContent = subTotal;
					gstAmount = subTotal * (gstRateInput.value / 100);
					breakdownGstEl.textContent = gstAmount.toFixed(2);
					breakdownNet.textContent = gstAmount + subTotal;


					 

				})
				.catch(error => {
					console.error(error);
				});
		});

	});


	chargesTableBody.addEventListener("input", function(e) {

		if (e.target.classList.contains("amount-input")) {
			chargeInputs = document.querySelectorAll(".amount-input");
			 
			calculateAmount();
		}

	});
	//Live charges calculation  

;
let markAsPaidEl =  document.getElementById("markAsPaid");

markAsPaidEl.addEventListener("click", setHiddenInputOfPaymentStatus);

function setHiddenInputOfPaymentStatus(){
	const paymentStatus =
   markAsPaidEl.checked ? 1 : 0;
 

 document.getElementById("paymentStatus").value = paymentStatus

}

	function calculateAmount() {
		let subTotal = 0;
 		chargeInputs = document.querySelectorAll(".amount-input");
		// Add all charges
		chargeInputs.forEach(input => {
			const value = parseFloat(input.value) || 0;
			
			subTotal += value;
		});
		console.log(subTotal);

		// Get GST rate
		const gstRate = parseFloat(gstRateInput.value) || 0;

		// Calculate GST
		const gstAmount = subTotal * gstRate / 100;
		console.log("chrges", gstAmount, gstRate, subTotal)
		// Calculate net amount
		const netAmount = subTotal + gstAmount;

		// Display values
		subTotalEl.textContent = subTotal.toFixed(2);
		breakdownGstEl.textContent = gstAmount.toFixed(2); 
		breakdownNet.textContent = netAmount.toFixed(2);
		console.log(netAmount);
	}

	// Listen to all charge inputs
	 

	// Also recalculate when GST rate changes
	gstRateInput.addEventListener("input", calculateAmount);








	chargesTableBody.addEventListener('click', function(e) {
		var btn = e.target.closest('.row-delete-btn');
		if (!btn) return;
		var index = parseInt(btn.getAttribute('data-index'), 10);
		charges.splice(index, 1);
setHiddenInputOfPaymentStatus();

	});

	if (addChargeBtn) {
		addChargeBtn.addEventListener('click', function() {
			charges.push({ particulars: '', amount: 0 });
			renderCharges();

			var inputs = chargesTableBody.querySelectorAll('.particular-input');
			var last = inputs[inputs.length - 1];
			if (last) last.focus();
		});
	}

var occasionalForm = document.getElementById('occasionalForm');
let deleteBtnEl = document.getElementById("deletbtn");
 
let saveBtn = document.getElementById("saveFormBtn");

saveBtn.addEventListener("click", () => {

    let choice = confirm("Save changes?");

    if (choice) {
        occasionalForm.action = contextPath + "/UpdateBill";
         
    }

});


 deleteBtnEl.addEventListener("click",()=>{
	 
	let choice = confirm(warningMessage);
	  if (choice) {
    	occasionalForm.action=contextPath+"/DeleteBill";
         
    }
	
	
});



	/* =================================================================
	   Reset / Save (demo only — no backend wired up on this page)
	   ================================================================= */
	var resetBtn = document.getElementById('resetFormBtn');
	
	if (resetBtn && occasionalForm) {
		resetBtn.addEventListener('click', function() {
			occasionalForm.reset();
			setFlatsInvolved('all', '', 'All Flats', '');
			charges = [
				{ particulars: 'Decoration', amount: 5000 },
				{ particulars: 'Pooja Materials', amount: 2500 },
				{ particulars: 'Cultural Program', amount: 3000 },
				{ particulars: 'Refreshments', amount: 1500 }
			];
			renderCharges();

		});
	}



});
const rows = document.querySelectorAll(".bill-row");

const rowsPerPage = 7;

let currentPage = 1;

const totalPages = Math.ceil(rows.length / rowsPerPage);

const prevBtn = document.getElementById("prevBtn");
const nextBtn = document.getElementById("nextBtn");
const pageNumbers = document.getElementById("pageNumbers");
const rowsInfo = document.getElementById("rowsInfo");


function showPage(page) {

	currentPage = page;

	const start = (page - 1) * rowsPerPage;
	const end = start + rowsPerPage;

	// Hide all rows
	rows.forEach(row => {
		row.style.display = "none";
	});

	// Show only current 7 rows
	for (let i = start; i < end && i < rows.length; i++) {
		rows[i].style.display = "";
	}

	updatePagination();

	// Update "Showing 1 to 7 of 20 entries"
	const firstRow = rows.length === 0 ? 0 : start + 1;
	const lastRow = Math.min(end, rows.length);

	rowsInfo.textContent =
		`Showing ${firstRow} to ${lastRow} of ${rows.length} entries`;
}


function updatePagination() {

	pageNumbers.innerHTML = "";

	for (let i = 1; i <= totalPages; i++) {

		const button = document.createElement("button");

		button.classList.add("page-btn");

		button.textContent = i;

		if (i === currentPage) {
			button.classList.add("active");
		}

		button.addEventListener("click", () => {
			showPage(i);
		});

		pageNumbers.appendChild(button);
	}

	prevBtn.disabled = currentPage === 1;
	nextBtn.disabled = currentPage === totalPages;
}


prevBtn.addEventListener("click", () => {

	if (currentPage > 1) {
		showPage(currentPage - 1);
	}

});


nextBtn.addEventListener("click", () => {

	if (currentPage < totalPages) {
		showPage(currentPage + 1);
	}

});

function showPopup(message, type) {
    var popup = document.getElementById("popupBox");
    
    console.log(message,type);

    if (!message) return;

    var title = "Notice";
    if (type === "success") title = "Added";
    else if (type === "update") title = "Updated";
    else if (type === "delete") title = "Deleted";

    popup.innerHTML = "<span class='popup-title'>" + title + "</span>" + message;
    popup.className = "popup-box " + type;

    // trigger show
    setTimeout(function () {
        popup.classList.add("show");
    }, 100);

    // auto-hide after 3 seconds
    setTimeout(function () {
        popup.classList.remove("show");
    }, 3100);
}

showPage(1);
 
