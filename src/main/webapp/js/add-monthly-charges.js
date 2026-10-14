document.addEventListener('DOMContentLoaded', function () {

  /* ---------------------------------------------------------------
     Sidebar collapse (icon-rail toggle via the logo icon)
     --------------------------------------------------------------- */
  var sidebar = document.getElementById('sidebar');
  var mainContent = document.getElementById('mainContent');
  var logoToggle = document.getElementById('logoToggle');

  if (logoToggle) {
    logoToggle.addEventListener('click', function () {
      sidebar.classList.toggle('collapsed');
      mainContent.classList.toggle('sidebar-collapsed');
    });
  }

  /* ---------------------------------------------------------------
     Submenu toggle (Maintenance section in the sidebar)
     --------------------------------------------------------------- */
  document.querySelectorAll('[data-toggle]').forEach(function (link) {
    link.addEventListener('click', function (e) {
      e.preventDefault();
      var submenu = document.getElementById(link.getAttribute('data-toggle'));
      if (submenu) submenu.classList.toggle('show');
    });
  });

  /* ---------------------------------------------------------------
     Live GST / net-amount calculation (GST rate is a user-entered field)
     --------------------------------------------------------------- */
  var chargeFieldIds = [
    'maintenanceAmount', 'electricityCharges', 'waterCharges',
    'parkingCharges', 'securityCharges', 'otherCharges'
  ];

  function num(id) {
    var el = document.getElementById(id);
    if (!el) return 0;
    var v = parseFloat(el.value);
    return isNaN(v) ? 0 : v;
  }

  function formatMoney(n) {
    return '\u20B9' + n.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
  }

  function recalculate() {
    var subTotal = chargeFieldIds.reduce(function (sum, id) { return sum + num(id); }, 0);
    var gstRate = num('gstRate');
    
    var gst = subTotal * (gstRate / 100);
    console.log(gstRate,gst);
    var net = subTotal + gst;

    chargeFieldIds.forEach(function (id) {
      var mirror = document.querySelector('[data-mirror="' + id + '"]');
      if (mirror) mirror.textContent = num(id).toLocaleString('en-IN', { minimumFractionDigits: 2 });
    });

    var gstRowLabel = document.querySelector('#gstRow span:first-child');
    if (gstRowLabel) gstRowLabel.textContent = 'GST (' + gstRate + '%)';

    var subTotalEl = document.getElementById('breakdownSubTotal');
    var gstEl = document.getElementById('breakdownGst');
    var netEl = document.getElementById('breakdownNet');
    var netPreviewEl = document.getElementById('detailsNetPreview');

    if (subTotalEl) subTotalEl.textContent = subTotal.toLocaleString('en-IN', { minimumFractionDigits: 2 });
    if (gstEl) gstEl.textContent = gst.toLocaleString('en-IN', { minimumFractionDigits: 2 });
    if (netEl) netEl.textContent = net.toLocaleString('en-IN', { minimumFractionDigits: 2 });
    if (netPreviewEl) netPreviewEl.textContent = formatMoney(net);
  }

  chargeFieldIds.concat(['gstRate']).forEach(function (id) {
    var el = document.getElementById(id);
    if (el) el.addEventListener('input', recalculate);
  });

  recalculate(); // run once on load

  /* ---------------------------------------------------------------
     Reset / Save (demo only — no backend wired up on this page)
     --------------------------------------------------------------- */
  var resetBtn = document.getElementById('resetFormBtn');
  var chargesForm = document.getElementById('chargesForm');
  if (resetBtn && chargesForm) {
    resetBtn.addEventListener('click', function () {
      chargesForm.reset();
      recalculate();
    });
  }

  var saveBtn = document.getElementById('saveFormBtn');
  if (saveBtn) {
    saveBtn.addEventListener('click', function () {
      if (!chargesForm.reportValidity()) return;
      alert('Monthly charges saved');
    });
  }
  var flatIn = document.getElementById("flatNumber");
			 
			var boxIn =  "#ownerBox";
			var boxIn1 =  "#ownerBox1";
			var boxIn2 =  "#ownerBox2";
			var fromFlat = document.querySelector("#fromFlat");
			var toFlat = document.querySelector("#toFlat");
			var ownerIn =  document.getElementById("ownerText"); 
			let flatNum;
			const flatPatter = /^[A-Z]-\d{3}$/;
			
			
			
			


			console.log(toFlat);
			flatIn.addEventListener("input", () => {

			   getData(flatIn,boxIn);
			      
			});
		 

			
			
			function getData(flatInput, box) {

			    console.log("box:", box);

			    const boxInput = document.querySelector(box);
			    const ownerText = boxInput.querySelector(".ownerText");

			    flatNum = flatInput.value.toUpperCase();

			    if (!flatPatter.test(flatNum)) {

			        ownerText.style.color = "var(--red)";
			        boxInput.classList.remove("owner");
			        boxInput.classList.add("warning");
			        ownerText.textContent = "Invalid Flat Number";

			    } else {

			        fetch(contextPath+"/AddMonthlyBill?flatNumber="
			            + encodeURIComponent(flatNum))

			            .then(response => response.json())

			            .then(data => {

			                if (data.ownerName != "No owner found") {

			                    boxInput.classList.remove("warning");
			                    boxInput.classList.add("owner");

			                    ownerText.style.color = "var(--green)";
			                    ownerText.textContent = "Owner is " + data.ownerName;

			                } else {

			                    ownerText.style.color = "var(--red)";

			                    boxInput.classList.remove("owner");
			                    boxInput.classList.add("warning");

			                    ownerText.textContent = "No owner found";
			                }
			            })

			            .catch(error => {

			                console.error(error);

			                ownerText.style.color = "var(--red)";

			                boxInput.classList.remove("owner");
			                boxInput.classList.add("warning");

			                ownerText.textContent = "No owner found";
			            });
			    }
			}
 
	 
 

});
