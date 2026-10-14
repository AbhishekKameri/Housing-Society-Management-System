 

function toggleSocietyMenu(event) {

    event.preventDefault();

    const submenu =
        document.getElementById("societySubmenu");

    const menu =
        document.getElementById("societyMenu");

    if (!submenu || !menu) {
        return;
    }

    const icon =
        menu.querySelector(".submenu-arrow");

    submenu.classList.toggle("show");

    /*
     * Keep Society active when inside
     * Society section.
     */
    if (!menu.classList.contains("active")) {
        menu.classList.add("active");
    }

    /* Change arrow */

    if (submenu.classList.contains("show")) {

        if (icon) {

            icon.classList.remove(
                "bi-chevron-down"
            );

            icon.classList.add(
                "bi-chevron-up"
            );
        }

    } else {

        if (icon) {

            icon.classList.remove(
                "bi-chevron-up"
            );

            icon.classList.add(
                "bi-chevron-down"
            );
        }
    }
}


/* =========================================================
   CHAIRMAN MENU
========================================================= */

function toggleChairmanMenu(event) {

    event.preventDefault();

    const submenu =
        document.getElementById("chairmanSubmenu");

    const menu =
        document.getElementById("chairmanMenu");

    if (!submenu || !menu) {
        return;
    }

    const icon =
        menu.querySelector(".submenu-arrow");

    submenu.classList.toggle("show");

    /*
     * Keep Chairman active when inside
     * Chairman section.
     */
    if (!menu.classList.contains("active")) {
        menu.classList.add("active");
    }

    /* Change arrow */

    if (submenu.classList.contains("show")) {

        if (icon) {

            icon.classList.remove(
                "bi-chevron-down"
            );

            icon.classList.add(
                "bi-chevron-up"
            );
        }

    } else {

        if (icon) {

            icon.classList.remove(
                "bi-chevron-up"
            );

            icon.classList.add(
                "bi-chevron-down"
            );
        }
    }
}


/* =========================================================
   DOM CONTENT LOADED
========================================================= */

document.addEventListener(
    "DOMContentLoaded",
    function () {


        /* =====================================================
           SIDEBAR COLLAPSE
        ====================================================== */

        const sidebarToggle =
            document.getElementById("sidebarToggle");

        const sidebar =
            document.querySelector(".sidebar");

        const main =
            document.querySelector(".main");


        if (sidebarToggle && sidebar) {

            const icon =
                sidebarToggle.querySelector("i");


            /* =================================================
               HOVER → SHOW SIDEBAR ICON
            ================================================== */

            sidebarToggle.addEventListener(
                "mouseenter",
                function () {

                    if (
                        !sidebar.classList.contains(
                            "collapsed"
                        )
                    ) {

                        icon.classList.remove(
                            "bi-buildings"
                        );

                        icon.classList.add(
                            "bi-layout-sidebar"
                        );
                    }
                }
            );


            /* =================================================
               MOUSE LEAVE → RESTORE BUILDING ICON
            ================================================== */

            sidebarToggle.addEventListener(
                "mouseleave",
                function () {

                    if (
                        !sidebar.classList.contains(
                            "collapsed"
                        )
                    ) {

                        icon.classList.remove(
                            "bi-layout-sidebar"
                        );

                        icon.classList.add(
                            "bi-buildings"
                        );
                    }
                }
            );


            /* =================================================
               CLICK → COLLAPSE / EXPAND
            ================================================== */

            sidebarToggle.addEventListener(
                "click",
                function () {

                    sidebar.classList.toggle(
                        "collapsed"
                    );


                    if (main) {

                        main.classList.toggle(
                            "sidebar-collapsed"
                        );
                    }


                    /* SIDEBAR COLLAPSED */

                    if (
                        sidebar.classList.contains(
                            "collapsed"
                        )
                    ) {

                        icon.classList.remove(
                            "bi-buildings"
                        );

                        icon.classList.remove(
                            "bi-layout-sidebar"
                        );

                        icon.classList.add(
                            "bi-layout-sidebar"
                        );

                    }


                    /* SIDEBAR EXPANDED */

                    else {

                        icon.classList.remove(
                            "bi-layout-sidebar"
                        );

                        icon.classList.add(
                            "bi-buildings"
                        );
                    }
                }
            );
        }


        /* =====================================================
           SOCIETY MENU CLICK
        ====================================================== */

        const societyMenu =
            document.getElementById(
                "societyMenu"
            );

        if (societyMenu) {

            societyMenu.addEventListener(
                "click",
                toggleSocietyMenu
            );
        }


        /* =====================================================
           CHAIRMAN MENU CLICK
        ====================================================== */

        const chairmanMenu =
            document.getElementById(
                "chairmanMenu"
            );

        if (chairmanMenu) {

            chairmanMenu.addEventListener(
                "click",
                toggleChairmanMenu
            );
        }


        /* =====================================================
           CURRENT PAGE ACTIVE INDICATOR
        ====================================================== */

        const currentPath =
            window.location.pathname;

        const currentURL =
            new URL(
                window.location.href
            );

        const currentAction =
            currentURL.searchParams.get(
                "action"
            );


        /* =====================================================
           ALL SUBMENU LINKS
        ====================================================== */

        const submenuLinks =
            document.querySelectorAll(
                ".submenu-link"
            );


        submenuLinks.forEach(
            function (link) {

                const href =
                    link.getAttribute(
                        "href"
                    );

                if (!href) {
                    return;
                }


                const linkURL =
                    new URL(
                        href,
                        window.location.origin
                    );


                const linkPath =
                    linkURL.pathname;

                const linkAction =
                    linkURL.searchParams.get(
                        "action"
                    );


                let isActive = false;


                /* =================================================
                   NORMAL JSP PAGE
                ================================================== */

                if (
                    linkPath === currentPath
                    &&
                    !linkAction
                ) {

                    isActive = true;
                }


                /* =================================================
                   SERVLET + ACTION
                ================================================== */

                if (
                    linkPath === currentPath
                    &&
                    linkAction
                    &&
                    linkAction === currentAction
                ) {

                    isActive = true;
                }


                if (!isActive) {
                    return;
                }


                /* =================================================
                   ACTIVE SUBMENU
                ================================================== */

                link.classList.add(
                    "active"
                );


                const submenu =
                    link.closest(
                        ".submenu"
                    );


                if (!submenu) {
                    return;
                }


                /* Open submenu */

                submenu.classList.add(
                    "show"
                );


                /* =================================================
                   FIND PARENT MENU
                ================================================== */

                const parent =
                    submenu.parentElement;


                if (!parent) {
                    return;
                }


                /*
                 * Because both Society and Chairman
                 * use .society-menu structure,
                 * find the direct .menu-link.
                 */

                const parentMenu =
                    parent.querySelector(
                        ":scope > .menu-link"
                    );


                if (!parentMenu) {
                    return;
                }


                /* Activate parent */

                parentMenu.classList.add(
                    "active"
                );


                /* =================================================
                   CHANGE ARROW
                ================================================== */

                const arrow =
                    parentMenu.querySelector(
                        ".submenu-arrow"
                    );


                if (arrow) {

                    arrow.classList.remove(
                        "bi-chevron-down"
                    );

                    arrow.classList.add(
                        "bi-chevron-up"
                    );
                }

            }
        );

    }
);

document.addEventListener('DOMContentLoaded', function () {

  /* ---------------------------------------------------------------
     Mobile  drawer
     --------------------------------------------------------------- */
  
  var overlay = document.getElementById('overlay');
  var sidebar =
            document.querySelector(".sidebar");
  var hamburger = document.getElementById('hamburger');

 

  /* ---------------------------------------------------------------
     Row action dropdowns (the "..." menu per bill)
     --------------------------------------------------------------- */
document.querySelectorAll(".action-toggle").forEach(toggle => {

    toggle.addEventListener("click", function (event) {

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
document.addEventListener("click", function () {

    document.querySelectorAll(".action-dropdown").forEach(menu => {
        menu.classList.remove("show");
    });

});
 

  /* ---------------------------------------------------------------
     Tabs: Maintenance Details <-> Charges Breakdown
     --------------------------------------------------------------- */
  var tabButtons = document.querySelectorAll('.tab-btn');
  var tabPanels = document.querySelectorAll('.tab-panel');
  tabButtons.forEach(function (btn) {
    btn.addEventListener('click', function () {
      tabButtons.forEach(function (b) { b.classList.remove('active'); });
      tabPanels.forEach(function (p) { p.classList.remove('active'); });
      btn.classList.add('active');
      document.getElementById(btn.getAttribute('data-tab')).classList.add('active');
    });
  });

  /* ---------------------------------------------------------------
     Live GST / net-amount calculation
     Reads the six charge inputs on the Maintenance Details tab and
     mirrors the totals into both the details-tab summary bar and the
     Charges Breakdown tab's table + summary.
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
  function num(id) {
    var el = document.getElementById(id);
    if (!el) return 0;
    var v = parseFloat(el.value);
    return isNaN(v) ? 0 : v;
  }
  
  function recalculate() {
	var gstRate = num('gstRate');
    var subTotal = chargeFieldIds.reduce(function (sum, id) { return sum + num(id); }, 0);
    var gst = subTotal * gstRate/100;
    var net =( subTotal + gst);
    console.log(net,gst,subTotal)

    // Mirror each charge amount into the breakdown table's read-only cells
    chargeFieldIds.forEach(function (id) {
      var mirror = document.querySelector('[data-mirror="' + id + '"]');
      if (mirror) mirror.textContent = num(id).toLocaleString('en-IN', { minimumFractionDigits: 2 });
    });

    var subTotalEl = document.getElementById('breakdownSubTotal');
    var gstEl = document.getElementById('breakdownGst');
    var netEl = document.getElementById('breakdownNet');
    var netPreviewEl = document.getElementById('detailsNetPreview');

    if (subTotalEl) subTotalEl.textContent = subTotal.toLocaleString('en-IN', { minimumFractionDigits: 2 });
    if (gstEl) gstEl.textContent = gst.toLocaleString('en-IN', { minimumFractionDigits: 2 });
    if (netEl) netEl.textContent = net.toLocaleString('en-IN', { minimumFractionDigits: 2 });
    
 
    
    if (netPreviewEl) netPreviewEl.textContent = formatMoney(net);

    // Keep hidden inputs in sync so the posted form carries the computed totals
    setHidden('subTotal', subTotal.toFixed(2));
    setHidden('gstAmount', gst.toFixed(2));
    setHidden('netAmount', net.toFixed(2));
  }

  function setHidden(id, value) {
    var el = document.getElementById(id);
    if (el) el.value = value;
  }

  chargeFieldIds.forEach(function (id) {
    var el = document.getElementById(id);
    if (el) el.addEventListener('input', recalculate);
  });

  recalculate(); // run once on load so the panel isn't blank

  /* ---------------------------------------------------------------
     Mark as Paid checkbox — reflected into the hidden status field
     --------------------------------------------------------------- */
  var markPaidCheckbox = document.getElementById('markAsPaid');
  if (markPaidCheckbox) {
    markPaidCheckbox.addEventListener('change', function () {
      var statusHidden = document.getElementById('statusOverride');
      if (statusHidden) statusHidden.value = markPaidCheckbox.checked ? 'Paid' : '';
    });
  }

  /* ---------------------------------------------------------------
     Reset button — also resets the live totals back to zero
     --------------------------------------------------------------- */
  var resetBtn = document.getElementById('resetFormBtn');
  var maintenanceForm = document.getElementById('maintenanceForm');
  if (resetBtn && maintenanceForm) {
    resetBtn.addEventListener('click', function () {
      maintenanceForm.reset();
      recalculate();
    });
  }

  /* ---------------------------------------------------------------
     Save button — demo only (no backend wired up on this page)
     --------------------------------------------------------------- */
  var saveBtn = document.getElementById('saveFormBtn');
 

  /* ---------------------------------------------------------------
     Bills table: search + status filter + flat filter (client-side)
     --------------------------------------------------------------- */
  var searchInput = document.getElementById('billSearch');
  var statusFilter = document.getElementById('statusFilter');
  var flatFilter = document.getElementById('flatFilter');
  var rows = document.querySelectorAll('#billsTable tbody tr');

  function applyFilters() {
    var term = (searchInput && searchInput.value || '').trim().toLowerCase();
    var status = (statusFilter && statusFilter.value || 'all').toLowerCase();
    var flat = (flatFilter && flatFilter.value || 'all').toLowerCase();

    rows.forEach(function (row) {
      var billId = row.children[0].textContent.toLowerCase();
      var flatNo = row.children[1].textContent.toLowerCase();
      var name = row.children[2].textContent.toLowerCase();
      var rowStatus = row.children[6].textContent.trim().toLowerCase();

      var matchesTerm = !term || billId.indexOf(term) !== -1 || flatNo.indexOf(term) !== -1 || name.indexOf(term) !== -1;
      var matchesStatus = status === 'all' || rowStatus === status;
      var matchesFlat = flat === 'all' || flatNo === flat;

      row.style.display = (matchesTerm && matchesStatus && matchesFlat) ? '' : 'none';
    });
  }

  if (searchInput) searchInput.addEventListener('input', applyFilters);
  if (statusFilter) statusFilter.addEventListener('change', applyFilters);
  if (flatFilter) flatFilter.addEventListener('change', applyFilters);

  /* ---------------------------------------------------------------
     Pagination buttons (visual state only in this demo)
     --------------------------------------------------------------- */
  document.querySelectorAll('.page-btn').forEach(function (btn) {
    btn.addEventListener('click', function () {
      if (isNaN(parseInt(btn.textContent, 10))) return;
      document.querySelectorAll('.page-btn').forEach(function (b) { b.classList.remove('active'); });
      btn.classList.add('active');
    });
  });

});
