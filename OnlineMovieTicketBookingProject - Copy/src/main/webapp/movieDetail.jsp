<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <% if (request.getAttribute("movie")==null) { response.sendRedirect(request.getContextPath() + "/home" );
            return; } %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>${movie.title} — Book Tickets — MovieTix Gold</title>
                <meta name="description" content="${movie.description}">
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
                    <div class="flex items-center gap-4">
                        <a class="px-4 py-2 text-sm font-semibold text-gray-400 hover:text-white transition-colors flex items-center gap-1.5"
                            href="${pageContext.request.contextPath}/home"><i
                                class="fa-solid fa-arrow-left text-xs"></i> Back</a>
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <a class="px-4 py-2 text-sm font-medium text-gray-400 hover:text-white transition-colors"
                                    href="${pageContext.request.contextPath}/history">My Bookings</a>
                                <a class="px-4 py-2 text-sm font-semibold text-gray-300 hover:text-white bg-white/5 hover:bg-white/10 rounded-xl transition-all border border-white/10"
                                    href="${pageContext.request.contextPath}/logout">Logout</a>
                            </c:when>
                            <c:otherwise>
                                <a class="px-4 py-2 text-sm font-medium text-gray-300 hover:text-white transition-colors"
                                    href="${pageContext.request.contextPath}/login">Login</a>
                                <a class="px-5 py-2.5 text-sm font-bold text-black bg-yellow-500 hover:bg-yellow-400 rounded-xl transition-all shadow-lg shadow-yellow-500/20 btn-gold-glow"
                                    href="${pageContext.request.contextPath}/register">Sign Up</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </nav>

                <!-- Movie Banner / Showcase Area -->
                <div class="relative w-full h-[350px] md:h-[450px] overflow-hidden">
                    <div class="absolute inset-0 bg-cover bg-center filter blur-xl scale-110 opacity-30 pointer-events-none"
                        style="background-image: url('${movie.posterUrl}');"></div>
                    <div class="absolute inset-0 bg-gradient-to-t from-[#030306] via-[#030306]/75 to-transparent"></div>
                    <div class="absolute inset-0 bg-gradient-to-r from-[#030306] via-transparent to-[#030306]"></div>
                </div>

                <!-- Main Movie Details Container -->
                <main class="max-w-6xl mx-auto w-full px-6 -mt-[280px] md:-mt-[320px] relative z-10 pb-20 flex-grow">
                    <div class="flex flex-col md:flex-row gap-8 md:gap-12 items-start">

                        <!-- Large Movie Poster (Left Side) -->
                        <div class="w-[260px] md:w-[300px] shrink-0 mx-auto md:mx-0">
                            <div
                                class="glass-panel p-2.5 rounded-3xl border border-white/10 shadow-2xl shadow-black relative overflow-hidden group">
                                <div
                                    class="absolute inset-0 bg-[radial-gradient(circle_at_top,rgba(212,175,55,0.15)_0%,transparent_70%)] pointer-events-none">
                                </div>
                                <img class="w-full aspect-[2/3] object-cover rounded-2xl shadow-lg transition-transform duration-500 group-hover:scale-[1.02]"
                                    src="${movie.posterUrl}" alt="${movie.title}"
                                    onerror="this.src='https://images.unsplash.com/photo-1542204113-e93a434de521?q=80&w=400&auto=format&fit=crop'">
                            </div>
                        </div>

                        <!-- Movie Details Text & Shows (Right Side) -->
                        <div class="flex-grow w-full">
                            <div class="mb-8">
                                <h1
                                    class="text-3xl md:text-5xl font-black text-white tracking-tight leading-tight text-glow-gold">
                                    ${movie.title}</h1>

                                <!-- Metadata Badges -->
                                <div class="flex flex-wrap items-center gap-2.5 mt-5">
                                    <span
                                        class="px-3.5 py-1.5 text-xs font-black bg-yellow-500 text-black rounded-lg shadow-lg flex items-center gap-1"><i
                                            class="fa-solid fa-star text-[10px]"></i> ${movie.rating} rating</span>
                                    <span
                                        class="px-3.5 py-1.5 text-xs font-bold bg-[#0a0a14] border border-white/10 text-gray-300 rounded-lg uppercase tracking-wider">${movie.genre}</span>
                                    <span
                                        class="px-3.5 py-1.5 text-xs font-semibold bg-[#0a0a14] border border-white/10 text-gray-300 rounded-lg flex items-center gap-1.5"><i
                                            class="fa-regular fa-clock text-yellow-500/70"></i>
                                        ${movie.durationFormatted}</span>
                                    <span
                                        class="px-3.5 py-1.5 text-xs font-semibold bg-[#0a0a14] border border-white/10 text-gray-300 rounded-lg flex items-center gap-1.5"><i
                                            class="fa-solid fa-globe text-yellow-500/70"></i> ${movie.language}</span>
                                </div>
                            </div>

                            <!-- Movie Description -->
                            <div class="mb-12">
                                <h3
                                    class="text-[10px] font-bold uppercase tracking-widest text-yellow-500 mb-3 flex items-center gap-1.5">
                                    <span class="h-2 w-2 rounded-full bg-yellow-500"></span> Synopsis
                                </h3>
                                <p class="text-sm md:text-base text-neutral-400 font-light leading-relaxed">
                                    ${movie.description}
                                </p>
                            </div>

                            <!-- Showtimes section -->
                            <div class="border-t border-white/10 pt-10">
                                <h2
                                    class="text-xl md:text-2xl font-extrabold text-white tracking-tight mb-8 flex items-center gap-2.5">
                                    <i
                                        class="fa-solid fa-ticket-simple text-yellow-500 text-glow-gold rotate-[-10deg]"></i>
                                    Upcoming Showtimes
                                </h2>

                                <c:choose>
                                    <c:when test="${not empty shows}">
                                        <div class="grid grid-cols-1 gap-4">
                                            <c:forEach var="show" items="${shows}">
                                                <div
                                                    class="glass-card p-6 rounded-3xl flex flex-col sm:flex-row items-start sm:items-center justify-between gap-6 hover:border-yellow-500/20 relative overflow-hidden">
                                                    <div class="absolute top-0 left-0 h-full w-1 bg-yellow-500"></div>
                                                    <div class="flex items-center gap-5">
                                                        <!-- Time Badge -->
                                                        <div
                                                            class="bg-yellow-500/10 border border-yellow-500/30 text-yellow-500 rounded-2xl px-5 py-3 text-center shrink-0 min-w-[90px]">
                                                            <span
                                                                class="block text-xl font-black tracking-tight leading-none text-glow-gold">${show.showTimeFormatted}</span>
                                                            <span
                                                                class="text-[8px] uppercase font-black tracking-widest mt-1.5 block text-yellow-500/60">Time
                                                                Slot</span>
                                                        </div>
                                                        <!-- Show Info -->
                                                        <div>
                                                            <span
                                                                class="text-[10px] font-bold text-yellow-500 uppercase tracking-widest bg-yellow-500/5 px-2 py-0.5 rounded border border-yellow-500/10">${show.hall}</span>
                                                            <h4
                                                                class="text-sm font-bold text-gray-200 mt-2 flex items-center gap-1.5">
                                                                <i class="fa-regular fa-calendar text-neutral-500"></i>
                                                                ${show.showDate}
                                                            </h4>
                                                        </div>
                                                    </div>

                                                    <div
                                                        class="flex items-center justify-between sm:justify-end gap-6 w-full sm:w-auto pt-4 sm:pt-0 border-t sm:border-t-0 border-white/5">
                                                        <!-- Price -->
                                                        <div class="text-left sm:text-right">
                                                            <span
                                                                class="block text-[9px] text-neutral-500 uppercase tracking-widest font-bold">Standard
                                                                Ticket</span>
                                                            <span
                                                                class="text-xl font-black text-yellow-500 text-glow-gold">₹${show.price}</span>
                                                        </div>

                                                        <!-- Booking trigger -->
                                                        <c:choose>
                                                            <c:when test="${not empty sessionScope.user}">
                                                                <a class="px-6 py-3 text-xs font-extrabold text-black bg-yellow-500 hover:bg-yellow-400 rounded-xl transition-all shadow-md active:scale-[0.98] btn-gold-glow flex items-center gap-2"
                                                                    href="${pageContext.request.contextPath}/seats?showId=${show.id}">
                                                                    Select Lounges <i
                                                                        class="fa-solid fa-chevron-right text-[10px]"></i>
                                                                </a>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <a class="px-6 py-3 text-xs font-bold text-gray-300 hover:text-white bg-white/5 hover:bg-white/10 border border-white/15 rounded-xl transition-all flex items-center gap-2"
                                                                    href="${pageContext.request.contextPath}/login?error=Please%20login%20to%20continue%20your%20booking.">
                                                                    Login to Unlock <i
                                                                        class="fa-solid fa-lock text-[10px] text-yellow-500"></i>
                                                                </a>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div
                                            class="p-8 rounded-3xl border border-white/5 bg-white/[0.01] text-center text-neutral-500 py-16">
                                            <span class="text-3xl text-yellow-500/40"><i
                                                    class="fa-regular fa-calendar-times"></i></span>
                                            <p class="text-sm mt-4 font-light">No upcoming active lounge bookings found
                                                for this film.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                        </div>
                    </div>
                </main>

                <!-- Footer -->
                <footer
                    class="border-t border-white/5 py-8 px-6 bg-[#07070d]/90 text-center text-xs text-neutral-600 mt-auto">
                    © 2026 MovieTix Luxury Theatre Group. Verified High-Definition Sandbox.
                </footer>

                <script src="${pageContext.request.contextPath}/js/main.js"></script>
                <jsp:include page="/chatbot.jsp" />
            </body>

            </html>