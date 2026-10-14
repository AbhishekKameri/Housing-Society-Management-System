document.addEventListener('DOMContentLoaded', function() {

	/* =================================================================
	   Tabs: Maintenance Details <-> Charges Breakdown
	   ================================================================= */
	var tabButtons = document.querySelectorAll('.tab-btn');
	var tabPanels = document.querySelectorAll('.tab-panel');

	function activateTab(tabId) {
		tabButtons.forEach(function(b) { b.classList.toggle('active', b.getAttribute('data-tab') === tabId); });
		tabPanels.forEach(function(p) { p.classList.toggle('active', p.id === tabId); });
	}

	tabButtons.forEach(function(btn) {
		btn.addEventListener('click', function() { activateTab(btn.getAttribute('data-tab')); });
	});

	/* =================================================================
	   Live GST / net-amount calculation
	   ================================================================= */
	var GST_RATE = document.getElementById("gstRate");
	var chargeFieldIds = [
		'maintenanceAmount', 'electricityCharges', 'waterCharges',
		'parkingCharges', 'securityCharges', 'otherCharges', 'lateFee'
	];

	function num(id) {
		var el = document.getElementById(id);
		if (!el) return 0;
		var v = parseFloat(el.value);
		return isNaN(v) ? 0 : v;
	}

	function fmtNum(n) {
		return n.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
	}

	function setText(id, text) {
		var el = document.getElementById(id);
		if (el) el.textContent = text;
	}

	function setSummary(subTotal, gst, net) {

		setText('breakdownSubTotal', fmtNum(subTotal));
		setText('breakdownGst', fmtNum(gst));
		setText('breakdownNet', fmtNum(net));
		setText('breakdownNet2', fmtNum(net));
	}
	const netAmountEl = document.getElementById("netAmount")
	const subTotalEl = document.getElementById("subTotal")
	const gstAmountEl = document.getElementById("gstAmount")
	const gstOutEl = document.getElementById("gstRateOut");
	const gstRateOutLineEl = document.getElementById("gstRateOutLine");
	const waterchargeEl = document.getElementById("waterChargesCard");
	const maintenanceAmountEl = document.getElementById("maintenanceAmountCard");
	const electricityChargesEl = document.getElementById("electricityChargesCard");
	const securityChargesEl = document.getElementById("securityChargesCard");
	const otherChargesEl = document.getElementById("otherChargesCard");
	const parkingChargesEl = document.getElementById("parkingChargesCard");
	const lateFeeCardEl = document.getElementById("lateFeeCard");
	const generatedDate = document.getElementById("generatedDate")
	const saveFormBtn = document.getElementById("saveFormBtn");
	const dueDate = document.getElementById("dueDate")
	let days = 0;
	let fine = 0;
	let lateFeeAmount = 0;
	const lateFeeEl = document.getElementById("lateFee");
	const fineEl = document.getElementById("fine");
	const dueDaysEl = document.getElementById("dueDays");
	const dateRegex = /^\d{4}-\d{2}-\d{2}$/;


	[generatedDate, dueDate, fineEl].forEach(element => {
		element.addEventListener("input", () => {

			calculateDifferenceOfDate();
			recalculate();

		});
	});


	function calculateDifferenceOfDate() {

		if (dateRegex.test(dueDate.value) && dateRegex.test(generatedDate.value)) {

			if (calculateDifferenceOfDates(generatedDate.value, dueDate.value)) {
				days = getDateDifference(generatedDate.value, dueDate.value);
				dueDaysEl.value = days;
				lateFeeAmount = days * fineEl.value;
				lateFeeEl.value = lateFeeAmount;
			}


		}
	}


	function calculateDifferenceOfDates(generatedDate, dueDate) {

		const warning = document.getElementById("dateWarning");

		// Both dates must be entered
		 
		if (!generatedDate || !dueDate || dueDate === "") {
			warning.textContent = "";
			submitBtn.disabled = true;
			warning.textContent = "Please enter both dates.";
			return false;
		}


		const generated = new Date(generatedDate);
		const due = new Date(dueDate);

		if (due < generated) {
			warning.textContent = "Due date must be greater than generated date.";
			warning.style.display = "block";
			saveFormBtn.disabled = true;
			return false;
		}

		warning.textContent = "";
		warning.style.display = "none";
		saveFormBtn.disabled = false;
		return true;
	}




	function setHiddenInputValues(subTotal, gst, net) {

		subTotalEl.value = subTotal;
		netAmountEl.value = net;
		gstAmountEl.value = gst;

	}
	function recalculate() {
		var subTotal = chargeFieldIds.reduce(function(sum, id) { return sum + num(id); }, 0);
		 
		
		
		var gst = subTotal * (GST_RATE.value) / 100;
		gstOutEl.textContent = "GST (" + GST_RATE.value + "%)";
		gstRateOutLineEl.textContent = GST_RATE.value;

		ShowBreakDownCharges();
		setSummary(subTotal, gst, subTotal + gst);
	}

	GST_RATE.addEventListener("input", recalculate);

	function ShowBreakDownCharges() {
		waterchargeEl.textContent = num("waterCharges");

		maintenanceAmountEl.textContent = num("maintenanceAmount");
		electricityChargesEl.textContent = num("electricityCharges");
		otherChargesEl.textContent = num("otherCharges");
		securityChargesEl.textContent = num("securityCharges");
		securityChargesEl.textContent = num("securityCharges");
		parkingChargesEl.textContent = num("parkingCharges")
		lateFeeCardEl.textContent = lateFeeAmount;

	}
	function getDateDifference(dateStr1, dateStr2) {

		const date1 = new Date(dateStr1);
		const date2 = new Date(dateStr2);

		// 2. Subtracting dates automatically converts them to timestamps (milliseconds)
		const differenceInMilliseconds = date2 - date1;

		// 3. Convert milliseconds to days (1000 ms * 60 sec * 60 min * 24 hours)
		const millisecondsPerDay = 1000 * 60 * 60 * 24;
		const differenceInDays = Math.floor(differenceInMilliseconds / millisecondsPerDay);

		return differenceInDays;
	}



	// Used when a bill has no per-charge data: show totals derived from its net amount
	function showSummaryFromNet(net) {
		var subTotal = net / (1 + GST_RATE.value);
		chargeFieldIds.forEach(function(id) {
			var mirror = document.querySelector('[data-mirror="' + id + '"]');

		});
		setSummary(subTotal, net - subTotal, net);
	}

	chargeFieldIds.forEach(function(id) {
		var el = document.getElementById(id);
		if (el) el.addEventListener('input', recalculate);
	});
	recalculate();

	/* =================================================================
	   Create / View panel: view mode (a bill is selected) vs create mode
	   ================================================================= */
	var maintenanceForm = document.getElementById('maintenanceForm');
	var billPanel = maintenanceForm ? maintenanceForm.closest('.card') : null;
	var billIdInput = document.getElementById('billId');
	var selectedBar = document.getElementById('selectedBillBar');


	// Every form field that a bill row can supply through a data-* attribute.
	// Attribute name = kebab-case of the id, e.g. flatNumber <- data-flat-number
	var FORM_FIELDS = [
		'residentId', 'flatNumber', 'generatedDate', 'dueDate',
		'maintenanceAmount', 'electricityCharges', 'waterCharges',
		'parkingCharges', 'securityCharges', 'otherCharges',
		'dueDays', 'lateFee', 'fine'
	];

	var allRows = Array.prototype.slice.call(document.querySelectorAll('#billsTable tbody tr'));

	function loadBill(row) {
		var d = row.dataset;

		if (billIdInput) billIdInput.value = d.billId || '';

		// Fields the row doesn't provide are cleared, so nothing stale/default is shown as if it were this bill's data
		FORM_FIELDS.forEach(function(id) {
			var el = document.getElementById(id);
			if (el) el.value = (d[id] !== undefined) ? d[id] : 'hj';
		});

		if (d.maintenanceAmount !== undefined) {
			recalculate();
		} else {
			showSummaryFromNet(parseFloat(d.netAmount) || 0);
		}

		var isPaid = d.paid === 'true';
		if (markPaidBox) markPaidBox.checked = isPaid;

		if (selectedBar) {
			selectedBar.style.display = 'flex';
			setText('selectedBillId', d.billId || '');
			setText('selectedBillOwner', (d.residentName || '') + (d.flatNumber ? ' \u00B7 ' + d.flatNumber : ''));
			var badge = document.getElementById('selectedBillStatus');
			if (badge) {
				badge.textContent = isPaid ? 'Paid' : 'Pending';
				badge.className = 'badge ' + (isPaid ? 'badge-green' : 'badge-red');
			}
		}

		allRows.forEach(function(r) { r.classList.remove('selected'); });
		row.classList.add('selected');

		activateTab('detailsTab');

		// On stacked (tablet/mobile) layouts the panel sits below the table, so bring it into view
		if (window.innerWidth <= 1200 && billPanel) {
			billPanel.scrollIntoView({ behavior: 'smooth', block: 'start' });
		}
	}









	/* =================================================================
	   Bills table: filters + pagination (7 rows per page)
  
	   Flow:  all rows -> filter (search/status/flat) -> paginate -> show
	   Changing any filter resets to page 1.
	   ================================================================= */
	var billsTable = document.getElementById('billsTable');
	var PAGE_SIZE = parseInt(billsTable && billsTable.getAttribute('data-page-size'), 10) || 9;

	var searchInput = document.getElementById('billSearch');
	var statusFilter = document.getElementById('statusFilter');
	var flatFilter = document.getElementById('flatFilter');
	var rowsInfo = document.getElementById('rowsInfo');
	var paginationEl = document.getElementById('pagination');

	var filteredRows = allRows.slice();
	var currentPage = 1;

	function applyFilters() {
		var term = (searchInput && searchInput.value || '').trim().toLowerCase();
		var status = (statusFilter && statusFilter.value || 'all').toLowerCase();
		var flat = (flatFilter && flatFilter.value || 'all').toLowerCase();

		filteredRows = allRows.filter(function(row) {
			var billId = row.children[0].textContent.toLowerCase();
			var flatNo = row.children[1].textContent.toLowerCase();
			var name = row.children[2].textContent.toLowerCase();
			var rowStatus = row.children[5].textContent.trim().toLowerCase();

			var matchesTerm = !term || billId.indexOf(term) !== -1 || flatNo.indexOf(term) !== -1 || name.indexOf(term) !== -1;
			var matchesStatus = status === 'all' || rowStatus === status;
			var matchesFlat = flat === 'all' || flatNo === flat;

			return matchesTerm && matchesStatus && matchesFlat;
		});

		currentPage = 1;
		renderTable();
	}

	function renderTable() {
		var total = filteredRows.length;
		var totalPages = Math.max(1, Math.ceil(total / PAGE_SIZE));
		if (currentPage > totalPages) currentPage = totalPages;

		var start = (currentPage - 1) * PAGE_SIZE;
		var end = Math.min(start + PAGE_SIZE, total);

		allRows.forEach(function(row) { row.style.display = 'none'; });
		filteredRows.slice(start, end).forEach(function(row) { row.style.display = ''; });

		if (rowsInfo) {
			rowsInfo.textContent = total === 0
				? 'No entries found'
				: 'Showing ' + (start + 1) + ' to ' + end + ' of ' + total + ' entries';
		}

		renderPagination(totalPages);
	}

	// Which page numbers to show: 1 ... (current-1) current (current+1) ... last
	function getPageList(current, total) {
		if (total <= 5) {
			var all = [];
			for (var i = 1; i <= total; i++) all.push(i);
			return all;
		}
		var pages = [1];
		var from = Math.max(2, current - 1);
		var to = Math.min(total - 1, current + 1);
		if (from > 2) pages.push('...');
		for (var p = from; p <= to; p++) pages.push(p);
		if (to < total - 1) pages.push('...');
		pages.push(total);
		return pages;
	}

	function makePageButton(label, page, opts) {
		opts = opts || {};
		var btn = document.createElement('button');
		btn.type = 'button';
		btn.className = 'page-btn' + (opts.active ? ' active' : '');
		btn.innerHTML = label;
		btn.disabled = !!opts.disabled;
		if (!opts.disabled && !opts.active) {
			btn.addEventListener('click', function() {
				currentPage = page;
				renderTable();
			});
		}
		return btn;
	}

	function renderPagination(totalPages) {
		if (!paginationEl) return;
		paginationEl.innerHTML = '';

		paginationEl.style.display = totalPages <= 1 ? 'none' : 'flex';
		if (totalPages <= 1) return;

		paginationEl.appendChild(makePageButton('&lsaquo;', currentPage - 1, { disabled: currentPage === 1 }));

		getPageList(currentPage, totalPages).forEach(function(p) {
			if (p === '...') {
				var dots = document.createElement('span');
				dots.className = 'page-ellipsis';
				dots.textContent = '\u2026';
				paginationEl.appendChild(dots);
			} else {
				paginationEl.appendChild(makePageButton(String(p), p, { active: p === currentPage }));
			}
		});

		paginationEl.appendChild(makePageButton('&rsaquo;', currentPage + 1, { disabled: currentPage === totalPages }));
	}

	if (searchInput) searchInput.addEventListener('input', applyFilters);
	if (statusFilter) statusFilter.addEventListener('change', applyFilters);
	if (flatFilter) flatFilter.addEventListener('change', applyFilters);

	renderTable(); // initial render: page 1 of all bills

	/* =================================================================
	   Row click -> load that bill into the right-hand panel.
	   Clicks on the row's own buttons/links/forms (View, Delete) are ignored.*/



	const breakdownSubTotalEl = document.getElementById("breakdownSubTotal");
	const breakdownGstEl = document.getElementById("breakdownGst");
	const breakdownNetEl = document.getElementById("breakdownNet");
	const detailsNetPreviewEl = document.getElementById("breakdownNet2");
	const getBillIdInputEl = document.getElementById("billId");
	const hiddenNetEl = document.getElementById("netAmount");


	var subTotal;
	var netAmount;
	var gstAmount;
	var currentBillid;


	allRows.forEach(function(row) {

		row.addEventListener("click", function(e) {

			if (e.target.closest("a, button, form")) {
				return;
			}
			calculateDifferenceOfDate();
			const billId = row.dataset.billId;

			currentBillid = billId;
			getData(billId);

		});
	});



	function getData(billId) {
		fetch(contextPath + "/AddMonthlyBill?billId="
			+ encodeURIComponent(billId))
			.then(response => {
				if (!response.ok) {
					throw new Error("HTTP error: " + response.status);
				}

				return response.json();
			})
			.then(data => {



				flatNumber.value = data.flatNumber;
				residentId.value = data.residentId;
				waterCharges.value = data.waterCharge;
				electricityCharges.value = data.electricityCharge;
				parkingCharges.value = data.parkingCharge;
				otherCharges.value = data.otherCharges;
				lateFee.value = data.lateFee;
				generatedDate.value = data.generatedDate;
				securityCharges.value = data.securityCharge;
				dueDays.value = data.dueDays;
				fine.value = data.fine;
				maintenanceAmount.value = data.maintenanceCharge;
				dueDate.value = data.dueDate;

				waterchargeEl.textContent = data.waterCharge;
				electricityChargesEl.textContent = data.electricityCharge;
				maintenanceAmountEl.textContent = data.maintenanceCharge;
				otherChargesEl.textContent = data.otherCharges;
				securityChargesEl.textContent = data.securityCharge;
				parkingChargesEl.textContent = data.parkingCharge;







				subTotal = parseFloat(data.waterCharge) + parseFloat(data.electricityCharge) + parseFloat(data.maintenanceCharge)
					+ parseFloat(data.otherCharges) + parseFloat(data.securityCharge) + parseFloat(data.parkingCharge);

				gstAmount = parseFloat(subTotal * (parseFloat(GST_RATE.value) / 100));
				netAmount = gstAmount + subTotal;


				breakdownSubTotalEl.textContent = subTotal;
				breakdownGstEl.textContent = gstAmount;
				breakdownNetEl.textContent = netAmount;
				detailsNetPreviewEl.textContent = netAmount;
				hiddenNetEl.value = netAmount;

				setHiddenInputValues(subTotal, gstAmount, netAmount)
				getBillIdInputEl.value = billId;


			})
			.catch(error => {
				console.error("Failed to fetch bill:", error);
			});
	}



	var resetBtn = document.getElementById('resetFormBtn');
	if (resetBtn) resetBtn.addEventListener('click', () => {


		getData(currentBillid)
	});



});
function showPopup(message, type) {
    var popup = document.getElementById("popupBox");
    
    
    

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

