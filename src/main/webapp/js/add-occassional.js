const flatTabs = document.querySelectorAll(".flat-tab");

const singleSection =
    document.getElementById("singleFlatSection");

const rangeSection =
    document.getElementById("rangeFlatSection");

const allSection =
    document.getElementById("allFlatSection");

const selectionType =
    document.getElementById("flatSelectionType");


flatTabs.forEach(tab => {

    tab.addEventListener("click", function () {

        flatTabs.forEach(t => {
            t.classList.remove("active");
        });

        this.classList.add("active");

        const type = this.dataset.type;

        selectionType.value = type;

        singleSection.classList.add("hidden");
        rangeSection.classList.add("hidden");
        allSection.classList.add("hidden");


        if (type === "single") {

            singleSection.classList.remove("hidden");

        }

        else if (type === "range") {

            rangeSection.classList.remove("hidden");

        }

        else if (type === "all") {

            allSection.classList.remove("hidden");

        }

    });

});


/* =========================================================
   CHARGES
========================================================= */

const chargesContainer =
    document.getElementById("chargesContainer");

const addChargeBtn =
    document.getElementById("addChargeBtn");
const gstEl  =
    document.getElementById("gst-rate");

function calculateTotal() {

    let subtotal = 0;

    const amounts =
        document.querySelectorAll(".charge-amount");


    amounts.forEach(input => {

        const value = parseFloat(input.value);

        if (!isNaN(value)) {
            subtotal += value;
        }

    });
    const gstValue = gstEl.value;

    const gst = subtotal * gstValue/100;

    const netAmount = subtotal + gst;


    document.getElementById("subTotal").textContent =
        subtotal.toFixed(2);

    document.getElementById("gstAmount").textContent =
        gst.toFixed(2);

    document.getElementById("netAmount").textContent =
        netAmount.toFixed(2);


    document.getElementById("subTotalInput").value =
        subtotal.toFixed(2);

    document.getElementById("gstAmountInput").value =
        gst.toFixed(2);

    document.getElementById("netAmountInput").value =
        netAmount.toFixed(2);
}


/* ADD CHARGE */

addChargeBtn.addEventListener("click", function () {

    const row =
        document.createElement("div");

    row.className = "charge-row";

    row.innerHTML = `

        <input type="text"
               name="chargeName[]"
               placeholder="e.g. Decoration"
               class="charge-name"
               required>

        <input type="number"
               name="chargeAmount[]"
               class="charge-amount"
               placeholder="0.00"
               min="0"
               step="0.01"
               required>

        <button type="button"
                class="remove-charge"
                title="Remove charge">

            <i class="bi bi-trash3"></i>

        </button>
    `;

    chargesContainer.appendChild(row);

});


/* REMOVE CHARGE */

chargesContainer.addEventListener("click", function (e) {

    const button =
        e.target.closest(".remove-charge");

    if (!button)
        return;


    const rows =
        document.querySelectorAll(".charge-row");


    /* Keep at least one row */

    if (rows.length <= 1) {
        return;
    }


    button.closest(".charge-row").remove();

    calculateTotal();

});


/* CALCULATE WHEN AMOUNT CHANGES */

chargesContainer.addEventListener("input", function (e) {

    if (e.target.classList.contains("charge-amount")) {
        calculateTotal();
    }

});


/* =========================================================
   FLAT NUMBER FORMAT
========================================================= */

const flatNumber =
    document.getElementById("flatNumber");

const flatPattern =
    /^[A-Z]-\d{3}$/;


flatNumber.addEventListener("input", function () {

    this.value =
        this.value.toUpperCase();

});


/* =========================================================
   RESET
========================================================= */

document.getElementById("resetBtn")
    .addEventListener("click", function () {

        document.getElementById("occasionalForm").reset();


        /* Reset tabs */

        flatTabs.forEach(tab => {
            tab.classList.remove("active");
        });

        flatTabs[0].classList.add("active");

        selectionType.value = "single";


        singleSection.classList.remove("hidden");
        rangeSection.classList.add("hidden");
        allSection.classList.add("hidden");


        /* Keep only first charge */

        const rows =
            document.querySelectorAll(".charge-row");

        rows.forEach((row, index) => {

            if (index > 0) {
                row.remove();
            }

        });


        calculateTotal();

    });


/* Initial calculation */

calculateTotal();


/* =========================================================
   DATE
========================================================= */

const eventDate =
    document.getElementById("eventDate");

const today =
    new Date().toISOString().split("T")[0];

eventDate.max = today;
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
	fromFlat.addEventListener("input", () => {

		   getData(fromFlat,boxIn1);
		      
		});
	toFlat.addEventListener("input", () => {

		   getData(toFlat,boxIn2);
		      
		});

	
	
	function getData(flatInput, box) {
 

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