/**
 * Chart.js-powered donut chart with:
 *  - real load-in animation (Chart.js's built-in animateRotate)
 *  - real hover tooltips (Chart.js's built-in tooltip, styled to match the dark theme)
 *  - a custom center-text plugin (Chart.js doesn't draw this natively)
 *  - a custom HTML legend synced to the chart, with click-to-toggle segments
 *
 * Requires Chart.js (UMD build) to be loaded on the page BEFORE this file.
 *
 * Usage:
 *   createDonutChart('myCanvasId', [
 *     { label: 'Paid',    value: 180, color: '#22c55e' },
 *     { label: 'Partial', value: 28,  color: '#f59e0b' },
 *     { label: 'Pending', value: 40,  color: '#ef4444' }
 *   ], { centerLabel: 'Bills', centerValue: 248 });
 */

// ---- Plugin: draws the total/label text in the donut's hollow center ----
var centerTextPlugin = {
  id: 'centerText',
  afterDraw: function (chart) {
    var opts = chart.config.options.plugins && chart.config.options.plugins.centerText;
    if (!opts) return;

    var ctx = chart.ctx;
    var area = chart.chartArea;
    var cx = (area.left + area.right) / 2;
    var cy = (area.top + area.bottom) / 2;
    var size = Math.min(area.right - area.left, area.bottom - area.top);

    ctx.save();
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';

    ctx.fillStyle = opts.valueColor || '#eef0f6';
    ctx.font = '700 ' + Math.round(size * 0.19) + 'px "Segoe UI", Arial, sans-serif';
    ctx.fillText(String(opts.centerValue), cx, cy - (opts.centerLabel ? size * 0.07 : 0));

    if (opts.centerLabel) {
      ctx.fillStyle = opts.labelColor || '#9aa0b4';
      ctx.font = '600 ' + Math.round(size * 0.08) + 'px "Segoe UI", Arial, sans-serif';
      ctx.fillText(opts.centerLabel, cx, cy + size * 0.13);
    }
    ctx.restore();
  }
};

function createDonutChart(canvasId, segments, options) {
  options = options || {};
  var canvas = document.getElementById(canvasId);
  if (!canvas || typeof Chart === 'undefined') return null;

  var chart = new Chart(canvas.getContext('2d'), {
    type: 'doughnut',
    data: {
      labels: segments.map(function (s) { return s.label; }),
      datasets: [{
        data: segments.map(function (s) { return s.value; }),
        backgroundColor: segments.map(function (s) { return s.color; }),
        borderWidth: 0,
        hoverOffset: 6
      }]
    },
    plugins: [centerTextPlugin],
    options: {
      responsive: true,
      maintainAspectRatio: false,
      cutout: '68%',
      animation: {
        animateRotate: true,
        animateScale: false,
        duration: 900,
        easing: 'easeOutQuart'
      },
      plugins: {
        legend: { display: false }, // we render our own legend below, synced via legendItemClick
        centerText: {
          centerValue: options.centerValue != null ? options.centerValue : segments.reduce(function (s, x) { return s + x.value; }, 0),
          centerLabel: options.centerLabel || ''
        },
        tooltip: {
          backgroundColor: '#1c2030',
          borderColor: '#232636',
          borderWidth: 1,
          titleColor: '#eef0f6',
          bodyColor: '#eef0f6',
          padding: 10,
          cornerRadius: 8,
          displayColors: true,
          callbacks: {
            label: function (ctx) {
              var total = ctx.dataset.data.reduce(function (a, b) { return a + b; }, 0);
              var pct = total > 0 ? ((ctx.parsed / total) * 100).toFixed(1) : '0.0';
              return ' ' + ctx.label + ': ' + ctx.parsed.toLocaleString('en-IN') + ' (' + pct + '%)';
            }
          }
        }
      }
    }
  });

  buildLegend(canvasId, chart, segments);
  return chart;
}

// ---- Custom HTML legend, click-to-toggle a segment (like Chart.js's built-in legend) ----
function buildLegend(canvasId, chart, segments) {
  var legendEl = document.querySelector('[data-legend-for="' + canvasId + '"]');
  if (!legendEl) return;

  legendEl.innerHTML = '';
  var total = segments.reduce(function (s, x) { return s + x.value; }, 0);

  segments.forEach(function (seg, index) {
    var pct = total > 0 ? ((seg.value / total) * 100).toFixed(1) : '0.0';
    var li = document.createElement('li');
    li.className = 'legend-item';
    li.innerHTML =
      '<span class="legend-dot" style="background:' + seg.color + '"></span>' +
      '<span class="legend-label">' + seg.label + '</span>' +
      '<b class="legend-value">' + seg.value.toLocaleString('en-IN') + ' (' + pct + '%)</b>';

    li.addEventListener('click', function () {
      var meta = chart.getDatasetMeta(0);
      var point = meta.data[index];
      point.hidden = !point.hidden;
      li.classList.toggle('legend-inactive', !!point.hidden);
      chart.update();
    });

    legendEl.appendChild(li);
  });
}
