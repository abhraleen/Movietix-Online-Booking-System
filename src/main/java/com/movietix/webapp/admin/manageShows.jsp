<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Manage Shows — Admin Desk — MovieTix Gold</title>
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
            class="bg-[#030306] text-gray-100 min-h-screen flex flex-col antialiased selection:bg-yellow-500 selection:text-black font-light">

            <!-- Navbar -->
            <nav
                class="sticky top-0 z-50 w-full glass-panel border-b border-white/5 py-4 px-6 md:px-12 flex items-center justify-between">
                <a class="text-2xl font-black tracking-tight text-white flex items-center gap-2 hover:opacity-90 transition-opacity"
                    href="${pageContext.request.contextPath}/admin/dashboard">
                    <span class="text-yellow-500"><i
                            class="fa-solid fa-ticket-simple rotate-[-10deg] text-glow-gold"></i></span>
                    <span class="font-extrabold tracking-widest text-lg uppercase">Movie<span
                            class="text-yellow-500">Tix</span></span>
                    <span
                        class="text-[9px] font-black text-yellow-500 bg-yellow-500/10 px-2.5 py-0.5 rounded-lg border border-yellow-500/30 tracking-widest uppercase">Admin
                        Panel</span>
                </a>
                <div class="flex items-center gap-4">
                    <span class="text-xs text-neutral-400 font-semibold hidden md:inline-block"><i
                            class="fa-solid fa-user-shield text-yellow-500 mr-1.5"></i> Operator:
                        ${sessionScope.user.name}</span>
                    <a class="px-4 py-2 text-sm font-semibold text-gray-300 hover:text-white bg-white/5 hover:bg-white/10 rounded-xl transition-all border border-white/10"
                        href="${pageContext.request.contextPath}/logout">Logout</a>
                </div>
            </nav>

            <!-- Admin Layout grid -->
            <div
                class="flex-grow max-w-7xl mx-auto w-full px-6 py-10 grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">

                <!-- Sidebar Menu (Col 3) -->
                <aside class="lg:col-span-3 space-y-2.5">
                    <span class="text-[9px] font-bold text-neutral-500 uppercase tracking-widest px-4 mb-2 block">Global
                        Desk</span>

                    <a class="flex items-center gap-3.5 px-4 py-3 rounded-2xl hover:bg-white/5 text-neutral-300 hover:text-white font-semibold transition-all group"
                        href="${pageContext.request.contextPath}/admin/dashboard">
                        <span class="text-sm text-neutral-500 group-hover:text-yellow-500 transition-colors"><i
                                class="fa-solid fa-chart-line"></i></span>
                        <span class="text-sm">Platform Stats</span>
                    </a>
                    <a class="flex items-center gap-3.5 px-4 py-3 rounded-2xl hover:bg-white/5 text-neutral-300 hover:text-white font-semibold transition-all group"
                        href="${pageContext.request.contextPath}/admin/movies">
                        <span class="text-sm text-neutral-500 group-hover:text-yellow-500 transition-colors"><i
                                class="fa-solid fa-clapperboard"></i></span>
                        <span class="text-sm">Manage Catalog</span>
                    </a>
                    <a class="flex items-center gap-3.5 px-4 py-3 rounded-2xl bg-yellow-500 text-black font-extrabold shadow-lg shadow-yellow-500/10 active:scale-[0.98] transition-all"
                        href="${pageContext.request.contextPath}/admin/shows">
                        <span class="text-sm"><i class="fa-solid fa-calendar-days"></i></span>
                        <span class="text-sm">Manage Shows</span>
                    </a>
                    <a class="flex items-center gap-3.5 px-4 py-3 rounded-2xl hover:bg-white/5 text-neutral-300 hover:text-white font-semibold transition-all group"
                        href="${pageContext.request.contextPath}/admin/bookings">
                        <span class="text-sm text-neutral-500 group-hover:text-yellow-500 transition-colors"><i
                                class="fa-solid fa-receipt"></i></span>
                        <span class="text-sm">Manage Bookings</span>
                    </a>

                    <div class="pt-6 mt-6 border-t border-white/5 space-y-2">
                        <span
                            class="text-[9px] font-bold text-neutral-500 uppercase tracking-widest px-4 block">Navigation</span>
                        <a class="flex items-center gap-3.5 px-4 py-3 rounded-2xl hover:bg-white/5 text-neutral-400 hover:text-white font-semibold transition-all"
                            href="${pageContext.request.contextPath}/home">
                            <span class="text-sm"><i class="fa-solid fa-globe text-yellow-500/70"></i></span>
                            <span class="text-sm">View Client Site</span>
                        </a>
                    </div>
                </aside>

                <!-- Main Content (Col 9) -->
                <main class="lg:col-span-9 space-y-6 animate-fade-in font-light">

                    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                        <div>
                            <h1 class="text-2xl font-black text-white tracking-tight flex items-center gap-3">
                                <span class="h-8 w-1.5 bg-yellow-500 rounded-full text-glow-gold"></span> Manage
                                Showtimes
                            </h1>
                            <p class="text-xs text-neutral-400 mt-2.5 font-light">Add or schedule cinematic screenings,
                                auditoriums, fees, and seat grids</p>
                        </div>

                        <button
                            class="px-5 py-3 text-xs font-extrabold text-black bg-yellow-500 hover:bg-yellow-400 rounded-xl transition-all shadow-md active:scale-[0.98] btn-gold-glow flex items-center gap-1.5 self-start sm:self-auto uppercase tracking-wider"
                            id="openAddShowModal">
                            <i class="fa-solid fa-circle-plus text-sm"></i> Add Showtime
                        </button>
                    </div>

                    <!-- Feedback Messages -->
                    <c:if test="${not empty successMsg}">
                        <div
                            class="p-4 rounded-xl border border-emerald-500/30 bg-emerald-500/10 text-emerald-400 text-sm font-semibold flex items-center gap-2.5">
                            <i class="fa-solid fa-circle-check"></i>
                            <span>${successMsg}</span>
                        </div>
                    </c:if>
                    <c:if test="${not empty errorMsg}">
                        <div
                            class="p-4 rounded-xl border border-red-500/30 bg-red-500/10 text-red-400 text-sm font-semibold flex items-center gap-2.5">
                            <i class="fa-solid fa-triangle-exclamation"></i>
                            <span>${errorMsg}</span>
                        </div>
                    </c:if>

                    <!-- Shows List Container -->
                    <div class="glass-panel border border-white/5 rounded-3xl overflow-hidden shadow-2xl">
                        <div class="overflow-x-auto">
                            <table class="w-full text-left border-collapse">
                                <thead>
                                    <tr
                                        class="border-b border-white/5 text-[9px] uppercase font-black tracking-widest text-neutral-500 bg-white/[0.01]">
                                        <th class="py-4.5 px-6">ID #</th>
                                        <th class="py-4.5 px-6">Feature Film</th>
                                        <th class="py-4.5 px-6">Theatre</th>
                                        <th class="py-4.5 px-6">Screening Date</th>
                                        <th class="py-4.5 px-6">Screening Time</th>
                                        <th class="py-4.5 px-6">Capacity</th>
                                        <th class="py-4.5 px-6">Seat Price</th>
                                        <th class="py-4.5 px-6 text-right font-black">Operations</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-white/5 text-xs font-light">
                                    <c:forEach var="show" items="${shows}">
                                        <tr class="hover:bg-white/[0.01] transition-colors">
                                            <td class="py-4 px-6 font-mono text-neutral-400 font-bold">#SHW-${show.id}
                                            </td>
                                            <td class="py-4 px-6 text-white font-extrabold text-sm">${show.movieTitle}
                                            </td>
                                            <td class="py-4 px-6 font-bold text-gray-300">${show.hall}</td>
                                            <td class="py-4 px-6 text-neutral-400 font-medium">${show.showDate}</td>
                                            <td class="py-4 px-6 text-neutral-400 font-medium">${show.showTimeFormatted}
                                            </td>
                                            <td class="py-4 px-6 font-medium text-neutral-400">${show.totalSeats} seats
                                            </td>
                                            <td class="py-4 px-6 font-extrabold text-yellow-500">₹${show.price}</td>
                                            <td class="py-4 px-6 text-right font-medium">
                                                <form action="${pageContext.request.contextPath}/admin/shows"
                                                    method="post" class="inline">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="showId" value="${show.id}">
                                                    <button
                                                        class="px-3.5 py-1.5 text-xs font-bold text-red-400 hover:text-white bg-red-950/20 hover:bg-red-500 border border-red-500/30 rounded-lg transition-all active:scale-[0.98]"
                                                        type="submit"
                                                        onclick="return confirm('Warning: Deleting show #${show.id} will permanently delete all allocations, tickets and seats associated with it. Continue?')">
                                                        Delete
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty shows}">
                                        <tr>
                                            <td colspan="8" class="py-16 text-center text-neutral-500 font-light">No
                                                show screenings scheduled yet. Click Add Showtime to configure one!</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </main>
            </div>

            <!-- Add Show Modal Overlay -->
            <div class="fixed inset-0 z-50 hidden items-center justify-center bg-black/70 backdrop-blur-md px-6"
                id="showModal">
                <div
                    class="w-full max-w-lg p-6 md:p-8 bg-[#0a0a14] border border-white/10 rounded-3xl shadow-2xl relative flex flex-col max-h-[90vh] animate-fade-in">
                    <h2 class="text-lg font-black text-white tracking-tight border-b border-white/5 pb-4 mb-4">Add
                        Showtime</h2>

                    <form action="${pageContext.request.contextPath}/admin/shows" method="post"
                        class="space-y-4 overflow-y-auto pr-1 flex-grow font-light">
                        <input type="hidden" name="action" value="add">

                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                            <div class="sm:col-span-2">
                                <label
                                    class="block text-[9px] font-bold uppercase tracking-widest text-neutral-400 mb-1.5">Select
                                    Catalog Movie *</label>
                                <select name="movieId" required
                                    class="w-full bg-[#030306] border border-white/10 rounded-xl py-2.5 px-3.5 text-xs text-gray-200 focus:outline-none focus:border-yellow-500 focus:ring-1 focus:ring-yellow-500 transition-all font-semibold">
                                    <c:forEach var="movie" items="${movies}">
                                        <option value="${movie.id}">${movie.title} (${movie.language})</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div>
                                <label
                                    class="block text-[9px] font-bold uppercase tracking-widest text-neutral-400 mb-1.5">Screening
                                    Date *</label>
                                <input
                                    class="w-full bg-[#030306] border border-white/10 rounded-xl py-2.5 px-3.5 text-xs text-gray-200 focus:outline-none focus:border-yellow-500 focus:ring-1 focus:ring-yellow-500 transition-all"
                                    type="date" name="showDate" required>
                            </div>

                            <div>
                                <label
                                    class="block text-[9px] font-bold uppercase tracking-widest text-neutral-400 mb-1.5">Screening
                                    Time *</label>
                                <input
                                    class="w-full bg-[#030306] border border-white/10 rounded-xl py-2.5 px-3.5 text-xs text-gray-200 focus:outline-none focus:border-yellow-500 focus:ring-1 focus:ring-yellow-500 transition-all"
                                    type="time" name="showTime" required>
                            </div>

                            <div>
                                <label
                                    class="block text-[9px] font-bold uppercase tracking-widest text-neutral-400 mb-1.5">Cinema
                                    Hall/Auditorium *</label>
                                <select name="hall" required
                                    class="w-full bg-[#030306] border border-white/10 rounded-xl py-2.5 px-3.5 text-xs text-gray-200 focus:outline-none focus:border-yellow-500 focus:ring-1 focus:ring-yellow-500 transition-all">
                                    <option value="Hall Alpha">Hall Alpha</option>
                                    <option value="Hall Beta">Hall Beta</option>
                                    <option value="Lounge Special">Lounge Special</option>
                                    <option value="IMAX Gold">IMAX Gold</option>
                                </select>
                            </div>

                            <div>
                                <label
                                    class="block text-[9px] font-bold uppercase tracking-widest text-neutral-400 mb-1.5">Seat
                                    Base Price (₹) *</label>
                                <input
                                    class="w-full bg-[#030306] border border-white/10 rounded-xl py-2.5 px-3.5 text-xs text-gray-200 focus:outline-none focus:border-yellow-500 focus:ring-1 focus:ring-yellow-500 transition-all placeholder:text-neutral-700 font-semibold text-yellow-500"
                                    type="number" name="price" min="50" max="5000" step="1" required placeholder="500">
                            </div>

                            <div class="sm:col-span-2">
                                <label
                                    class="block text-[9px] font-bold uppercase tracking-widest text-neutral-400 mb-1.5">Hall
                                    Capacity Configuration</label>
                                <input
                                    class="w-full bg-[#030306]/60 border border-white/5 rounded-xl py-2.5 px-3.5 text-xs text-neutral-500 cursor-not-allowed"
                                    type="number" name="totalSeats" value="60" readonly>
                                <p class="text-[9px] text-neutral-500 mt-1">Our dynamic VIP seat mapping automatically
                                    creates a structure of 60 premium loungers (Row A through F, columns 1 to 10).</p>
                            </div>
                        </div>

                        <div class="border-t border-white/5 pt-4 mt-6 flex justify-end gap-3">
                            <button type="button"
                                class="px-5 py-2.5 text-xs font-bold text-gray-400 hover:text-white bg-white/5 border border-white/10 rounded-xl transition-all"
                                id="closeShowModal">Cancel</button>
                            <button type="submit"
                                class="px-6 py-3 text-xs font-extrabold text-black bg-yellow-500 hover:bg-yellow-400 rounded-xl transition-all shadow-md btn-gold-glow uppercase tracking-wider">Save
                                Schedule</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Modal Toggle Javascipt -->
            <script>
                const openBtn = document.getElementById("openAddShowModal");
                const closeBtn = document.getElementById("closeShowModal");
                const modal = document.getElementById("showModal");

                if (openBtn && modal) {
                    openBtn.addEventListener("click", () => {
                        modal.classList.remove("hidden");
                        modal.classList.add("flex");
                    });
                }

                if (closeBtn && modal) {
                    closeBtn.addEventListener("click", () => {
                        modal.classList.add("hidden");
                        modal.classList.remove("flex");
                    });
                }

                // Close when clicking backdrop
                if (modal) {
                    modal.addEventListener("click", (e) => {
                        if (e.target === modal) {
                            modal.classList.add("hidden");
                            modal.classList.remove("flex");
                        }
                    });
                }
            </script>

            <!-- Footer -->
            <footer
                class="border-t border-white/5 py-6 px-6 text-center text-xs text-neutral-600 bg-[#07070d]/50 w-full mt-auto">
                © 2026 MovieTix Administration Desk. Secure Sandbox.
            </footer>

            <script src="${pageContext.request.contextPath}/js/main.js"></script>
            <jsp:include page="/chatbot.jsp" />
        </body>

        </html>