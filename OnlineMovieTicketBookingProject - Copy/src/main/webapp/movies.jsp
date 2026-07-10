<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <%@ page import="com.movietix.dao.MovieDAO, com.movietix.model.Movie, java.util.List" %>
            <% if (request.getAttribute("movies")==null) { com.movietix.dao.MovieDAO dao=new
                com.movietix.dao.MovieDAO(); List<Movie> list = dao.getAllMovies();
                request.setAttribute("movies", list);
                }
                %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Browse Movies — MovieTix Gold</title>
                    <script src="https://cdn.tailwindcss.com"></script>
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
                            <a class="px-4 py-2 text-sm font-semibold text-gray-400 hover:text-white transition-colors"
                                href="${pageContext.request.contextPath}/home">Home</a>
                            <a class="px-4 py-2 text-sm font-semibold text-yellow-500 border-b-2 border-yellow-500"
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
                                            class="fa-solid fa-user-circle mr-1"></i> Hi,
                                        ${sessionScope.user.name}</span>
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

                    <main class="flex-grow max-w-7xl mx-auto w-full px-6 py-12 md:py-16">
                        <!-- Header -->
                        <div class="mb-12 text-center md:text-left">
                            <h1
                                class="text-3xl font-black text-white tracking-tight flex items-center justify-center md:justify-start gap-3">
                                <span class="h-8 w-1.5 bg-yellow-500 rounded-full text-glow-gold"></span>
                                Browse <span class="text-yellow-500">Movies</span>
                            </h1>
                            <p class="text-xs text-neutral-400 mt-2.5 font-light">Explore, search and select from our
                                complete luxury cinematic lineup</p>
                        </div>

                        <!-- Search Box -->
                        <div
                            class="glass-panel p-6 rounded-3xl border border-white/10 mb-12 flex flex-col md:flex-row gap-4 items-center justify-between shadow-2xl relative overflow-hidden">
                            <div
                                class="absolute top-0 right-0 w-32 h-32 bg-yellow-500/[0.01] rounded-full filter blur-2xl">
                            </div>

                            <!-- Search Input -->
                            <div class="relative w-full md:max-w-md group">
                                <span
                                    class="absolute inset-y-0 left-0 pl-4 flex items-center text-neutral-500 group-focus-within:text-yellow-500 transition-colors">
                                    <i class="fa-solid fa-magnifying-glass text-sm"></i>
                                </span>
                                <input type="text" id="searchInput" placeholder="Search films by title..."
                                    class="w-full bg-[#0a0a14]/80 border border-white/10 rounded-2xl py-3.5 pl-11 pr-4 text-sm text-gray-200 placeholder-neutral-500 focus:outline-none focus:border-yellow-500 focus:ring-1 focus:ring-yellow-500 transition-all font-light">
                            </div>

                            <!-- Filter info -->
                            <div
                                class="text-xs text-neutral-400 font-light flex items-center gap-3 self-center md:self-auto pt-2 md:pt-0">
                                <span
                                    class="bg-yellow-500/10 border border-yellow-500/20 px-3 py-1.5 rounded-xl text-yellow-400 font-bold">
                                    Showing <strong class="text-white text-glow-gold"
                                        id="movieCount">${movies.size()}</strong> Movies
                                </span>
                                <span class="h-1.5 w-1.5 rounded-full bg-white/20"></span>
                                <span class="text-neutral-500">Instant database searches</span>
                            </div>
                        </div>

                        <!-- Movies Catalog Grid -->
                        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-8"
                            id="catalogGrid">
                            <c:forEach var="movie" items="${movies}">
                                <a class="catalog-card group glass-card rounded-3xl overflow-hidden flex flex-col hover:border-yellow-500/40"
                                    href="${pageContext.request.contextPath}/movie?id=${movie.id}"
                                    data-title="${movie.title.toLowerCase()}" data-genre="${movie.genre}">
                                    <!-- Poster -->
                                    <div class="relative overflow-hidden aspect-[2/3] bg-neutral-950">
                                        <img class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110"
                                            src="${movie.posterUrl}" alt="${movie.title}" loading="lazy"
                                            onerror="this.src='https://images.unsplash.com/photo-1542204113-e93a434de521?q=80&w=400&auto=format&fit=crop'">
                                        <div
                                            class="absolute inset-0 bg-gradient-to-t from-[#030306] via-transparent to-transparent opacity-90">
                                        </div>

                                        <div class="absolute top-4 left-4 flex flex-wrap gap-1.5">
                                            <span
                                                class="px-2.5 py-1 text-[10px] font-extrabold uppercase rounded-lg bg-yellow-500 text-black shadow-lg flex items-center gap-1"><i
                                                    class="fa-solid fa-star text-[9px]"></i> ${movie.rating}</span>
                                        </div>
                                    </div>

                                    <!-- Info -->
                                    <div class="p-6 flex-grow flex flex-col justify-between">
                                        <div>
                                            <span
                                                class="text-[10px] font-extrabold text-yellow-500 uppercase tracking-widest block mb-1">${movie.genre}</span>
                                            <h3
                                                class="font-extrabold text-base text-white group-hover:text-yellow-400 transition-colors line-clamp-1">
                                                ${movie.title}</h3>
                                            <div
                                                class="flex items-center gap-2 mt-2 text-xs text-neutral-400 font-light">
                                                <span><i class="fa-regular fa-clock mr-1 text-yellow-500/60"></i>
                                                    ${movie.durationFormatted}</span>
                                                <span class="h-1 w-1 bg-white/10 rounded-full"></span>
                                                <span><i class="fa-solid fa-globe mr-1 text-yellow-500/60"></i>
                                                    ${movie.language}</span>
                                            </div>
                                        </div>

                                        <div
                                            class="mt-5 pt-4 border-t border-white/5 flex items-center justify-between">
                                            <span
                                                class="text-xs font-bold text-yellow-500 uppercase tracking-wider group-hover:text-yellow-400 transition-colors">Showtimes</span>
                                            <span
                                                class="text-xs text-neutral-400 group-hover:translate-x-2 transition-transform duration-300"><i
                                                    class="fa-solid fa-arrow-right text-yellow-500"></i></span>
                                        </div>
                                    </div>
                                </a>
                            </c:forEach>
                        </div>

                        <!-- Empty State -->
                        <div id="emptyState"
                            class="hidden py-24 px-6 text-center glass-card rounded-3xl max-w-md mx-auto">
                            <span class="text-5xl text-yellow-500"><i class="fa-solid fa-magnifying-glass"></i></span>
                            <h3 class="text-xl font-extrabold text-white mt-6">No Matching Movies</h3>
                            <p class="text-sm text-neutral-400 mt-2 font-light">Try adjusting your search terms or
                                keywords.</p>
                        </div>
                    </main>

                    <!-- Footer -->
                    <footer class="border-t border-white/5 py-10 px-6 md:px-12 bg-[#07070d]/90 backdrop-blur-md">
                        <div class="max-w-7xl mx-auto flex flex-col md:flex-row items-center justify-between gap-6">
                            <a class="text-xl font-black text-white flex items-center gap-2"
                                href="${pageContext.request.contextPath}/home">
                                <span class="text-yellow-500"><i
                                        class="fa-solid fa-ticket-simple rotate-[-10deg] text-glow-gold"></i></span>
                                <span class="font-extrabold tracking-widest text-base uppercase">Movie<span
                                        class="text-yellow-500">Tix</span></span>
                            </a>
                            <p class="text-xs text-neutral-500 font-light">
                                © 2026 MovieTix Luxury Theatre Group. All rights reserved.
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

                    <script>
                        // Live Search Logic
                        document.addEventListener('DOMContentLoaded', () => {
                            const searchInput = document.getElementById('searchInput');
                            const cards = document.querySelectorAll('.catalog-card');
                            const emptyState = document.getElementById('emptyState');
                            const countEl = document.getElementById('movieCount');

                            searchInput.addEventListener('input', () => {
                                const query = searchInput.value.toLowerCase().trim();
                                let visibleCount = 0;

                                cards.forEach(card => {
                                    const title = card.dataset.title || '';
                                    const match = title.includes(query);
                                    card.style.display = match ? '' : 'none';
                                    if (match) visibleCount++;
                                });

                                countEl.textContent = visibleCount;
                                if (visibleCount === 0) {
                                    emptyState.classList.remove('hidden');
                                    document.getElementById('catalogGrid').classList.add('hidden');
                                } else {
                                    emptyState.classList.add('hidden');
                                    document.getElementById('catalogGrid').classList.remove('hidden');
                                }
                            });
                        });
                    </script>
                    <jsp:include page="/chatbot.jsp" />
                </body>

                </html>