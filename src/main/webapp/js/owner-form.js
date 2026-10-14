document.addEventListener('DOMContentLoaded', function () {

  var form = document.getElementById('ownerForm');
  if (!form) return;

  var resetBtn = document.getElementById('resetBtn');

  var validators = {
    firstName: function (v) { return v.trim().length > 0 || 'First name is required'; },
    lastName: function (v) { return v.trim().length > 0 || 'Last name is required'; },
    age: function (v) {
      if (!v) return 'Age is required';
      var n = Number(v);
      return (n >= 1 && n <= 120) || 'Enter a valid age (1-120)';
    },
    gender: function (v) { return v.trim().length > 0 || 'Please select a gender'; },
    mobileNumber: function (v) { return /^[6-9]\d{9}$/.test(v.trim()) || 'Enter a valid 10-digit mobile number'; },
    email: function (v) {
      if (!v.trim()) return true; // optional field
      return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v.trim()) || 'Enter a valid email address';
    },
    aadhaarNumber: function (v) { return /^\d{12}$/.test(v.trim()) || 'Aadhaar number must be exactly 12 digits'; },
    emergencyContact: function (v) { return /^[6-9]\d{9}$/.test(v.trim()) || 'Enter a valid 10-digit contact number'; },
    flatNumber: function (v) { return v.trim().length > 0 || 'Please select a flat'; },
    moveInDate: function (v) { return v.trim().length > 0 || 'Move-in date is required'; },
    status: function (v) { return v.trim().length > 0 || 'Please select a status'; }
  };

  function showError(fieldName, message) {
    var input = form.elements[fieldName];
    var field = input.closest('.field');
    var errorEl = form.querySelector('.error-msg[data-for="' + fieldName + '"]');
    if (message === true || message === undefined) {
      field.classList.remove('invalid');
      if (errorEl) errorEl.textContent = '';
      return true;
    }
    field.classList.add('invalid');
    if (errorEl) errorEl.textContent = message;
    return false;
  }

  function validateField(fieldName) {
    var input = form.elements[fieldName];
    if (!input || !validators[fieldName]) return true;
    var result = validators[fieldName](input.value);
    return showError(fieldName, result);
  }

  // Validate on blur/change for immediate feedback
  Object.keys(validators).forEach(function (fieldName) {
    var input = form.elements[fieldName];
    if (!input) return;
    var eventName = (input.tagName === 'SELECT') ? 'change' : 'blur';
    input.addEventListener(eventName, function () { validateField(fieldName); });
  });

  // Move-out date must be after move-in date, when both are set
  var moveIn = form.elements['moveInDate'];
  var moveOut = form.elements['moveOutDate'];
  function validateMoveOut() {
    if (moveIn.value && moveOut.value && moveOut.value < moveIn.value) {
      showError('moveOutDate', 'Move-out date must be after the move-in date');
      return false;
    }
    showError('moveOutDate', true);
    return true;
  }
  if (moveOut) moveOut.addEventListener('change', validateMoveOut);
  if (moveIn) moveIn.addEventListener('change', validateMoveOut);

  form.addEventListener('submit', function (e) {
    var allValid = true;
    Object.keys(validators).forEach(function (fieldName) {
      if (!validateField(fieldName)) allValid = false;
    });
    if (!validateMoveOut()) allValid = false;

    if (!allValid) {
      e.preventDefault();
      var firstInvalid = form.querySelector('.field.invalid input, .field.invalid select');
      if (firstInvalid) firstInvalid.focus();
    }
  });

  if (resetBtn) {
    resetBtn.addEventListener('click', function () {
      form.reset();
      form.querySelectorAll('.field.invalid').forEach(function (f) { f.classList.remove('invalid'); });
      form.querySelectorAll('.error-msg').forEach(function (e) { e.textContent = ''; });
    });
  }

});
