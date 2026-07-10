<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <% if (request.getAttribute("movies")==null) { response.sendRedirect(request.getContextPath() + "/home" );
            return; } %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>MovieTix — Premium Cinema Ticket Booking</title>
                <meta name="description"
                    content="Book movie tickets online instantly. Experience absolute luxury in IMAX, Dolby Cinema, and premier lounges.">
                <script src="https://cdn.tailwindcss.com"></script>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                <script>
                    tailwind.config = {
                        theme: {
                            extend: {
                                colors: {
                                    gold: {
                                        DEFAULT: '#D4AF37',
                                        hover: '#E5C158',
                                        glow: 'rgba(212, 175, 55, 0.2)',
                                    },
                                    dark: {
                                        base: '#030306',
                                        surface: '#07070d',
                                        card: 'rgba(255, 255, 255, 0.02)',
                                    }
                                }
                            }
                        }
                    }
                </script>
            </head>

            <body
                class="bg-[#030306] text-gray-100 min-h-screen flex flex-col antialiased selection:bg-yellow-500 selection:text-black">

                <jsp:include page="/welcome.jsp" />

                <!-- Navbar -->
                <nav
                    class="sticky top-0 z-50 w-full glass-panel border-b border-white/5 py-4 px-6 md:px-12 flex items-center justify-between">
                    <a class="text-2xl font-black tracking-tight text-white flex items-center gap-2 hover:opacity-90 transition-opacity"
                        href="${pageContext.request.contextPath}/home">
                        <span class="text-yellow-500"><i
                                class="fa-solid fa-ticket-simple rotate-[-10deg] text-glow-gold"></i></span>
                        <span class="font-extrabold tracking-widest text-lg md:text-xl uppercase">Movie<span
                                class="text-yellow-500">Tix</span></span>
                    </a>

                    <div class="flex items-center gap-1 md:gap-4">
                        <a class="hidden sm:inline-block px-4 py-2 text-sm font-semibold text-yellow-500 border-b-2 border-yellow-500"
                            href="${pageContext.request.contextPath}/home">Home</a>
                        <a class="hidden sm:inline-block px-4 py-2 text-sm font-medium text-gray-400 hover:text-white transition-colors"
                            href="${pageContext.request.contextPath}/movies.jsp">Catalog</a>

                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <a class="px-4 py-2 text-sm font-medium text-gray-400 hover:text-white transition-colors"
                                    href="${pageContext.request.contextPath}/history">My Bookings</a>
                                <c:if test="${sessionScope.user.admin}">
                                    <a class="px-3 py-1.5 text-xs font-semibold text-yellow-500 bg-yellow-500/10 border border-yellow-500/30 rounded-md hover:bg-yellow-500/20 transition-all"
                                        href="${pageContext.request.contextPath}/admin/dashboard">Admin Desk</a>
                                </c:if>
                                <div class="h-6 w-px bg-white/10 hidden md:block"></div>
                                <span class="hidden md:inline-block text-sm font-semibold text-yellow-500"><i
                                        class="fa-solid fa-user-circle mr-1"></i> Hi, ${sessionScope.user.name}</span>
                                <a class="px-4 py-2 text-sm font-semibold text-gray-300 hover:text-white bg-white/5 hover:bg-white/10 rounded-xl transition-all border border-white/10"
                                    href="${pageContext.request.contextPath}/logout">Logout</a>
                            </c:when>
                            <c:otherwise>
                                <a class="px-4 py-2 text-sm font-medium text-gray-300 hover:text-white transition-colors"
                                    href="${pageContext.request.contextPath}/login">Login</a>
                                <a class="px-5 py-2.5 text-sm font-bold text-black bg-yellow-500 hover:bg-yellow-400 rounded-xl transition-all shadow-lg shadow-yellow-500/20 active:scale-[0.98] btn-gold-glow"
                                    href="${pageContext.request.contextPath}/register">Sign Up</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </nav>

                <!-- Hero Section -->
                <header
                    class="relative min-h-[620px] flex items-center justify-center text-center px-6 overflow-hidden bg-cover bg-center"
                    style="background-image: linear-gradient(180deg, rgba(3,3,6,0.5) 0%, rgba(3,3,6,0.98) 100%), url('https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?q=80&w=1920&auto=format&fit=crop');">
                    <!-- Spotlight Gold Radial Overlay -->
                    <div
                        class="absolute inset-0 bg-[radial-gradient(circle_at_center,rgba(212,175,55,0.14)_0%,transparent_60%)] pointer-events-none">
                    </div>

                    <div class="relative z-10 max-w-4xl animate-fade-in">
                        <span
                            class="px-4 py-2 rounded-full bg-yellow-500/10 border border-yellow-500/30 text-yellow-500 text-xs font-semibold uppercase tracking-widest mb-6 inline-block"><i
                                class="fa-solid fa-fire mr-1 text-glow-gold"></i> Live Premium Showings</span>
                        <h1 class="text-4xl md:text-7xl font-extrabold tracking-tight text-white leading-[1.05] mb-6">
                            Luxury Cinema, <br><span
                                class="text-transparent bg-clip-text bg-gradient-to-r from-yellow-300 via-yellow-500 to-yellow-600 text-glow-gold">Tailored
                                For Connoisseurs.</span>
                        </h1>
                        <p
                            class="text-base md:text-lg text-gray-400 max-w-2xl mx-auto mb-10 font-light leading-relaxed">
                            Browse the latest blockbusters, select your private leather recliner seats, and book tickets
                            instantly for the ultimate theater experience.
                        </p>
                        <div class="flex flex-col sm:flex-row gap-4 justify-center">
                            <a href="#movies"
                                class="px-8 py-4 text-sm font-extrabold text-black bg-yellow-500 hover:bg-yellow-400 rounded-xl transition-all shadow-xl shadow-yellow-500/25 flex items-center justify-center gap-2 btn-gold-glow">
                                <i class="fa-solid fa-ticket text-base"></i> Book Premium Seat
                            </a>
                            <a href="${pageContext.request.contextPath}/movies.jsp"
                                class="px-8 py-4 text-sm font-semibold text-white bg-white/5 hover:bg-white/10 border border-white/10 rounded-xl transition-all flex items-center justify-center gap-2">
                                Explore All Movies <i class="fa-solid fa-arrow-right text-xs"></i>
                            </a>
                        </div>
                    </div>
                </header>

                <jsp:include page="/components/regionalSpotlight.jsp" />

                <!-- Main Movies Catalog Section -->
                <main class="flex-grow max-w-7xl mx-auto w-full px-6 py-16 md:py-24" id="movies">
                    <div class="flex flex-col md:flex-row md:items-end justify-between mb-12 gap-6">
                        <div>
                            <h2
                                class="text-2xl md:text-4xl font-extrabold text-white tracking-tight flex items-center gap-3">
                                <span class="h-10 w-1.5 bg-yellow-500 rounded-full text-glow-gold"></span>
                                Now <span class="text-yellow-500">Showing</span>
                            </h2>
                            <p class="text-sm text-gray-400 mt-2 font-light">Select a film to view active schedules and
                                book VIP lounges</p>
                        </div>

                        <!-- Genre Filtering Controls -->
                        <div class="flex flex-wrap gap-2">
                            <button
                                class="filter-btn px-5 py-2 text-xs font-bold rounded-full bg-yellow-500 text-black transition-all active:scale-[0.97] hover:scale-105"
                                data-genre="All">All</button>
                            <button
                                class="filter-btn px-5 py-2 text-xs font-bold rounded-full bg-neutral-900 border border-white/5 text-neutral-400 hover:text-white transition-all active:scale-[0.97] hover:scale-105"
                                data-genre="Action">Action</button>
                            <button
                                class="filter-btn px-5 py-2 text-xs font-bold rounded-full bg-neutral-900 border border-white/5 text-neutral-400 hover:text-white transition-all active:scale-[0.97] hover:scale-105"
                                data-genre="Sci-Fi">Sci-Fi</button>
                            <button
                                class="filter-btn px-5 py-2 text-xs font-bold rounded-full bg-neutral-900 border border-white/5 text-neutral-400 hover:text-white transition-all active:scale-[0.97] hover:scale-105"
                                data-genre="Drama">Drama</button>
                            <button
                                class="filter-btn px-5 py-2 text-xs font-bold rounded-full bg-neutral-900 border border-white/5 text-neutral-400 hover:text-white transition-all active:scale-[0.97] hover:scale-105"
                                data-genre="Comedy">Comedy</button>
                            <button
                                class="filter-btn px-5 py-2 text-xs font-bold rounded-full bg-neutral-900 border border-white/5 text-neutral-400 hover:text-white transition-all active:scale-[0.97] hover:scale-105"
                                data-genre="Thriller">Thriller</button>
                        </div>
                    </div>

                    <!-- Movies Grid Layout -->
                    <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-8">
                        <c:forEach var="movie" items="${movies}">
                            <a class="movie-card group glass-card rounded-3xl overflow-hidden flex flex-col hover:border-yellow-500/40"
                                href="${pageContext.request.contextPath}/movie?id=${movie.id}"
                                data-genre="${movie.genre}">
                                <!-- Poster Wrapper with Zoom effect -->
                                <div class="relative overflow-hidden aspect-[2/3] bg-neutral-950">
                                    <img class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110"
                                        src="${movie.posterUrl}" alt="${movie.title}" loading="lazy"
                                        onerror="this.src='https://images.unsplash.com/photo-1542204113-e93a434de521?q=80&w=400&auto=format&fit=crop'">

                                    <!-- Gradient overlay on hover -->
                                    <div
                                        class="absolute inset-0 bg-gradient-to-t from-[#030306] via-transparent to-transparent opacity-90 transition-opacity">
                                    </div>

                                    <!-- Tags -->
                                    <div class="absolute top-4 left-4 flex flex-wrap gap-2">
                                        <span
                                            class="px-2.5 py-1 text-[10px] font-extrabold uppercase rounded-lg bg-yellow-500 text-black shadow-lg flex items-center gap-1"><i
                                                class="fa-solid fa-star text-[9px]"></i> ${movie.rating}</span>
                                        <span
                                            class="px-2.5 py-1 text-[10px] font-extrabold uppercase rounded-lg bg-black/80 text-gray-300 border border-white/10 backdrop-blur-md">${movie.genre}</span>
                                    </div>
                                </div>

                                <!-- Card details body -->
                                <div class="p-6 flex-grow flex flex-col justify-between">
                                    <div>
                                        <h3
                                            class="font-extrabold text-lg text-white group-hover:text-yellow-400 transition-colors line-clamp-1">
                                            ${movie.title}</h3>
                                        <div class="flex items-center gap-2 mt-2.5 text-xs text-neutral-400 font-light">
                                            <span><i class="fa-regular fa-clock mr-1 text-yellow-500/70"></i>
                                                ${movie.durationFormatted}</span>
                                            <span class="h-1 w-1 bg-white/10 rounded-full"></span>
                                            <span><i class="fa-solid fa-earth-americas mr-1 text-yellow-500/70"></i>
                                                ${movie.language}</span>
                                        </div>
                                    </div>

                                    <div class="mt-5 pt-4 border-t border-white/5 flex items-center justify-between">
                                        <span
                                            class="text-xs font-bold text-yellow-500 tracking-wider uppercase group-hover:text-yellow-400 transition-colors">Select
                                            Tickets</span>
                                        <span
                                            class="text-xs text-neutral-400 group-hover:translate-x-2 transition-transform duration-300"><i
                                                class="fa-solid fa-arrow-right text-yellow-500"></i></span>
                                    </div>
                                </div>
                            </a>
                        </c:forEach>

                        <c:if test="${empty movies}">
                            <div class="col-span-full py-20 px-6 text-center glass-card rounded-3xl">
                                <span class="text-5xl text-yellow-500"><i class="fa-solid fa-clapperboard"></i></span>
                                <h3 class="text-xl font-extrabold text-white mt-6">No Movies Currently Screening</h3>
                                <p class="text-sm text-neutral-400 mt-2 font-light">We are curating upcoming high-end
                                    listings. Check back shortly!</p>
                            </div>
                        </c:if>
                    </div>
                </main>

                <!-- Footer -->
                <footer class="mt-auto border-t border-white/5 py-12 px-6 md:px-12 bg-[#07070d]/90 backdrop-blur-md">
                    <div class="max-w-7xl mx-auto flex flex-col md:flex-row items-center justify-between gap-6">
                        <a class="text-xl font-black text-white flex items-center gap-2"
                            href="${pageContext.request.contextPath}/home">
                            <span class="text-yellow-500"><i
                                    class="fa-solid fa-ticket-simple rotate-[-10deg] text-glow-gold"></i></span>
                            <span class="font-extrabold tracking-widest text-base uppercase">Movie<span
                                    class="text-yellow-500">Tix</span></span>
                        </a>
                        <p class="text-xs text-neutral-500 font-light">
                            © 2026 MovieTix Luxury Theatre Group. All rights reserved. Powered by Jakarta EE 10 &
                            Tailwind.
                        </p>
                        <div class="flex gap-4 text-neutral-400 text-sm">
                            <a href="#" class="hover:text-yellow-500 transition-colors"><i
                                    class="fa-brands fa-facebook-f"></i></a>
                            <a href="#" class="hover:text-yellow-500 transition-colors"><i
                                    class="fa-brands fa-twitter"></i></a>
                            <a href="#" class="hover:text-yellow-500 transition-colors"><i
                                    class="fa-brands fa-instagram"></i></a>
                        </div>
                    </div>
                </footer>

                <script src="${pageContext.request.contextPath}/js/main.js"></script>
                <jsp:include page="/chatbot.jsp" />
            </body>

            </html>