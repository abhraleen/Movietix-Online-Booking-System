<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!-- Fast check to prevent flicker on refreshed page loads -->
    <script>
        try {
            if (sessionStorage.getItem('movietix_welcome_played')) {
                document.write('<style>#movietix-welcome-overlay { display: none !important; }</style>');
            }
        } catch (e) {
            console.warn("sessionStorage is unavailable:", e);
        }
    </script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/welcome.css">

    <!-- MovieTix Cinematic Intro Backdrop Overlay -->
    <div id="movietix-welcome-overlay">
        <!-- Particle Canvas background -->
        <canvas id="welcome-particle-canvas" class="welcome-canvas"></canvas>

        <!-- Moving Gold Projector Spotlights -->
        <div class="ambient-glow"></div>

        <div class="welcome-content">
            <!-- Logo Wrapper with Metallic Shine -->
            <div class="logo-container shine-overlay">
                <span class="logo-letter">M</span>
                <span class="logo-letter">o</span>
                <span class="logo-letter">v</span>
                <span class="logo-letter">i</span>
                <span class="logo-letter">e</span>
                <span class="logo-letter gold-brand">T</span>
                <span class="logo-letter gold-brand">i</span>
                <span class="logo-letter gold-brand">x</span>
            </div>

            <!-- Luxury Brand Description Subtitle -->
            <div class="welcome-subtitle">
                Premium Movie Ticket Booking Experience
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/welcome.js"></script>