document.addEventListener('DOMContentLoaded', function () {

  var deleteBtn = document.getElementById('deleteOwnerBtn');
  var cancelBtn = document.getElementById('cancelDeleteBtn');
  var overlay = document.getElementById('deleteModalOverlay');

  if (!deleteBtn || !overlay) return;

  function openModal() { overlay.classList.add('show'); }
  function closeModal() { overlay.classList.remove('show'); }

  deleteBtn.addEventListener('click', openModal);
  if (cancelBtn) cancelBtn.addEventListener('click', closeModal);

  // Close when clicking the dark backdrop, but not the box itself
  overlay.addEventListener('click', function (e) {
    if (e.target === overlay) closeModal();
  });

  document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') closeModal();
  });

});
