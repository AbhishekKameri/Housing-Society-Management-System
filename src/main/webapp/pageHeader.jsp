 
	<%
    String pageTitle = (String) request.getAttribute("pageTitle");
    String pageDescription = (String) request.getAttribute("pageDescription");

    if (pageTitle == null) {
        pageTitle = "View Society";
    }

    if (pageDescription == null) {
        pageDescription = "View and manage society information";
    }
%>

<!-- ================= TOP BAR ================= -->

<div class="topbar">

    <div class="top-left">

        <!-- Back Button -->
        <a href="<%=request.getContextPath()%>/index.jsp"
           class="back-button"
           title="Back">

            <i class="bi bi-chevron-left"></i>

        </a>

        <!-- Page Title -->
        <div>

            <div class="page-title">
                <%=pageTitle%>
            </div>

            <div class="page-description">
                <%=pageDescription%>
            </div>

        </div>

    </div>


    <!-- ================= TOP RIGHT ================= -->

    <div class="top-right">

        <!-- Date -->
        <div class="date-box">

            <i class="bi bi-calendar3"></i>

            <span id="currentDate"></span>

        </div>


        <!-- Admin -->
        <div class="admin">

            <div class="admin-avatar">
                SA
            </div>

            <div>

                <div class="admin-name">
                    Super Admin
                </div>

                <div class="admin-role">
                    Chairman
                </div>

            </div>

        </div>

    </div>

</div>


<!-- ================= DATE SCRIPT ================= -->

<script>

document.addEventListener("DOMContentLoaded", function () {

    const dateElement =
        document.getElementById("currentDate");

    if (dateElement) {

        const today = new Date();

        const options = {
            weekday: "long",
            day: "2-digit",
            month: "short",
            year: "numeric"
        };

        dateElement.textContent =
            today.toLocaleDateString("en-IN", options);
    }

});

</script>
 