document.addEventListener('DOMContentLoaded', function () {

  /* ---------------------------------------------------------------
     Collapse sidebar to icon rail (click the logo icon)
     --------------------------------------------------------------- */
  var sidebarToggle = document.getElementById('sidebarToggle');
  var sidebar = document.querySelector('.sidebar');
  var main = document.querySelector('.main');

  if (sidebarToggle && sidebar) {
    sidebarToggle.addEventListener('click', function () {
      sidebar.classList.toggle('collapsed');
      if (main) main.classList.toggle('sidebar-collapsed');
    });
  }

  /* ---------------------------------------------------------------
     Submenu accordion — works for Society, Chairman, Maintenance,
     and any future .menu-link + .submenu pair without extra wiring.
     Each menu-link's submenu is the next <ul class="submenu"> in its
     parent <li>.
     --------------------------------------------------------------- */
  document.querySelectorAll('.society-menu > .menu-link').forEach(function (link) {
    link.addEventListener('click', function (e) {
      e.preventDefault();
      var submenu = link.parentElement.querySelector('.submenu');
      if (!submenu) return;

      var wasOpen = submenu.classList.contains('show');

      // Close every other open submenu (accordion behaviour)
      document.querySelectorAll('.submenu.show').forEach(function (open) {
        if (open !== submenu) open.classList.remove('show');
      });

      submenu.classList.toggle('show', !wasOpen);
    });
  });

});
