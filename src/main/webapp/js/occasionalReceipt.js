document.addEventListener('DOMContentLoaded', function () {

  var printBtn = document.getElementById('printBtn');
  if (printBtn) {
    printBtn.addEventListener('click', function () {
      window.print();
    });
  }

  // No PDF library wired up here — this just triggers the browser's own
  // print dialog, where "Save as PDF" produces a clean PDF using the
  // @media print rules in receipt.css. Swap this for a real PDF export
  // endpoint if you want a one-click download instead.
  var downloadBtn = document.getElementById('downloadBtn');
  if (downloadBtn) {
    downloadBtn.addEventListener('click', function () {
      window.print();
    });
  }

});
