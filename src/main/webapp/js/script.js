document.addEventListener('DOMContentLoaded', function () {

  /* ---------- Mobile sidebar toggle sidjkli slfkkdiim ---------- */
  var sidebar = document.getElementById('sidebar');
  var overlay = document.getElementById('overlay');
  var hamburger = document.getElementById('hamburger');

  function openSidebar() {
    sidebar.classList.add('open');
    overlay.classList.add('show');
  }
  function closeSidebar() {
    sidebar.classList.remove('open');
    overlay.classList.remove('show');
  }

  if (hamburger) hamburger.addEventListener('click', openSidebar);
  if (overlay) overlay.addEventListener('click', closeSidebar);

  // Close the drawer automatically if the viewport grows past the mobile breakpoint
  window.addEventListener('resize', function () {
    if (window.innerWidth > 900) closeSidebar();
  });

  /* ---------- Collapsible nav groups (Residents, Maintenance, Flats, Reports) ---------- */
  var groups = document.querySelectorAll('.nav-group');
  groups.forEach(function (btn) {
    btn.addEventListener('click', function () {
      var targetId = btn.getAttribute('data-target');
      var sub = document.getElementById(targetId);
      btn.classList.toggle('open');
      if (sub) sub.classList.toggle('open');
    });
  });

  /* ---------- Table search + status filter ---------- */
  var searchInput = document.getElementById('searchInput');
  var statusFilter = document.getElementById('statusFilter');
  var rows = document.querySelectorAll('#flatsTable tbody tr');

  function applyFilters() {
    var term = (searchInput && searchInput.value || '').trim().toLowerCase();
    var status = (statusFilter && statusFilter.value || 'all').toLowerCase();

    rows.forEach(function (row) {
      var flatNo = row.children[0].textContent.toLowerCase();
      var owner = row.children[1].textContent.toLowerCase();
      var type = row.children[2].textContent.toLowerCase();
      var rowStatus = row.children[3].textContent.trim().toLowerCase();

      var matchesTerm = !term ||
        flatNo.indexOf(term) !== -1 ||
        owner.indexOf(term) !== -1 ||
        type.indexOf(term) !== -1;

      var matchesStatus = status === 'all' || rowStatus === status;

      row.style.display = (matchesTerm && matchesStatus) ? '' : 'none';
    });
  }

  if (searchInput) searchInput.addEventListener('input', applyFilters);
  if (statusFilter) statusFilter.addEventListener('change', applyFilters);

  /* ---------- Pagination buttons (visual state only in this demo) ---------- */
  var pageButtons = document.querySelectorAll('.page-btn');
  pageButtons.forEach(function (btn) {
    btn.addEventListener('click', function () {
      if (isNaN(parseInt(btn.textContent, 10))) return; // ignore prev/next arrows here
      pageButtons.forEach(function (b) { b.classList.remove('active'); });
      btn.classList.add('active');
    });
  });

});

// Data

 console.log("js",occupied,vacant);
const total = occupied + vacant;


// Custom plugin
const centerText = {
    id: 'centerText',

    beforeDraw(chart) {

        const { ctx } = chart;

        const width = chart.width;
        const height = chart.height;

        ctx.save();

        // Total number
        ctx.font = 'bold 32px Arial';
        ctx.fillStyle = '#666';
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';

        ctx.fillText(
            total,
            width / 2,
            height / 2 - 10
        );


        // Text below total
        ctx.font = '14px Arial';
        ctx.fillStyle = '#777';

        ctx.fillText(
            'Total Flats',
            width / 2,
            height / 2 + 20
        );

        ctx.restore();
    }
};


// Create chart
const ctx = document.getElementById('flatChart');

new Chart(ctx, {

    type: 'doughnut',

    data: {

        labels: [
            'Occupied',
            'Vacant',
             
        ],

        datasets: [{

            data: [
                occupied,
                vacant,
                
            ],

            backgroundColor: [
                '#4CAF50',
                '#2196F3',
                 
            ],

            borderWidth: 0
        }]
    },

    options: {

        responsive: true,

        maintainAspectRatio: false,

        cutout: '70%',

        plugins: {

            legend: {
                position: 'bottom'
            }
        }
    },

    plugins: [centerText]
});