<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Manage Receipts — Operator Desk — MovieTix Gold</title>
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
                    <a class="flex items-center gap-3.5 px-4 py-3 rounded-2xl hover:bg-white/5 text-neutral-300 hover:text-white font-semibold transition-all group"
                        href="${pageContext.request.contextPath}/admin/shows">
                        <span class="text-sm text-neutral-500 group-hover:text-yellow-500 transition-colors"><i
                                class="fa-solid fa-calendar-days"></i></span>
                        <span class="text-sm">Manage Shows</span>
                    </a>
                    <a class="flex items-center gap-3.5 px-4 py-3 rounded-2xl bg-yellow-500 text-black font-extrabold shadow-lg shadow-yellow-500/10 active:scale-[0.98] transition-all"
                        href="${pageContext.request.contextPath}/admin/bookings">
                        <span class="text-sm"><i class="fa-solid fa-receipt"></i></span>
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
                <main class="lg:col-span-9 space-y-6 animate-fade-in">
                    <div>
                        <h1 class="text-2xl font-black text-white tracking-tight flex items-center gap-3">
                            <span class="h-8 w-1.5 bg-yellow-500 rounded-full text-glow-gold"></span> Manage Bookings
                        </h1>
                        <p class="text-xs text-neutral-400 mt-2.5 font-light">Monitor booking receipts and process
                            platform level cancellations</p>
                    </div>

                    <!-- Filters -->
                    <div
                        class="flex flex-col sm:flex-row gap-4 items-center justify-between bg-white/[0.02] border border-white/5 rounded-2xl p-4 mb-4">
                        <div class="flex items-center gap-2">
                            <span class="text-xs font-semibold text-neutral-400"><i
                                    class="fa-solid fa-filter text-yellow-500/70 mr-1"></i> Filter by Status:</span>
                            <select id="statusFilter"
                                class="bg-[#030306] border border-white/10 rounded-xl px-3 py-1.5 text-xs text-gray-200 focus:outline-none focus:border-yellow-500 font-semibold">
                                <option value="ALL">All Statuses</option>
                                <option value="confirmed">Approved</option>
                                <option value="PAYMENT_SUBMITTED">Pending Verify</option>
                                <option value="rejected">Rejected</option>
                                <option value="cancelled">Cancelled</option>
                            </select>
                        </div>
                        <div id="bookingCounter" class="text-xs text-neutral-400 font-light">
                            Showing <span id="visibleCount" class="font-bold text-white">0</span> of <span
                                id="totalCount" class="font-bold text-white">0</span> bookings
                        </div>
                    </div>

                    <!-- Bookings table log -->
                    <div class="glass-panel border border-white/5 rounded-3xl overflow-hidden shadow-2xl">
                        <div class="overflow-x-auto">
                            <table class="w-full text-left border-collapse">
                                <thead>
                                    <tr
                                        class="border-b border-white/5 text-[9px] uppercase font-black tracking-widest text-neutral-500 bg-white/[0.01]">
                                        <th class="py-4.5 px-6">ID #</th>
                                        <th class="py-4.5 px-6">Client</th>
                                        <th class="py-4.5 px-6">Feature Film</th>
                                        <th class="py-4.5 px-6">Date & Time</th>
                                        <th class="py-4.5 px-6">Theater</th>
                                        <th class="py-4.5 px-6">Allocations</th>
                                        <th class="py-4.5 px-6">Subtotal</th>
                                        <th class="py-4.5 px-6">Status Badge</th>
                                        <th class="py-4.5 px-6 text-right">Operations</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-white/5 text-xs font-light">
                                    <c:forEach var="booking" items="${bookings}">
                                        <tr class="hover:bg-white/[0.01] transition-colors"
                                            data-status="${booking.status}">
                                            <td class="py-5 px-6 font-mono text-neutral-500 font-bold">
                                                #MTX-${booking.id}</td>
                                            <td class="py-5 px-6 font-bold text-gray-200">${booking.userName}</td>
                                            <td class="py-5 px-6 font-extrabold text-white text-sm">
                                                ${booking.movieTitle}</td>
                                            <td class="py-5 px-6">
                                                <span class="block font-medium">${booking.showDate}</span>
                                                <span
                                                    class="block text-[10px] text-neutral-500 font-light mt-0.5">${booking.showTimeShort}</span>
                                            </td>
                                            <td class="py-5 px-6 text-neutral-400 font-bold uppercase tracking-wider">
                                                ${booking.hall}</td>
                                            <td class="py-5 px-6">
                                                <div class="flex flex-wrap gap-0.5">
                                                    <c:forEach var="seat" items="${booking.seatNumbers}">
                                                        <span
                                                            class="inline-block px-1.5 py-0.5 rounded bg-yellow-500/10 border border-yellow-500/20 font-bold text-yellow-500 font-mono text-[10px] mr-0.5">${seat}</span>
                                                    </c:forEach>
                                                </div>
                                            </td>
                                            <td class="py-5 px-6 font-extrabold text-yellow-500">₹${booking.totalAmount}
                                            </td>
                                            <td class="py-5 px-6">
                                                <c:choose>
                                                    <c:when test="${booking.status eq 'confirmed'}">
                                                        <span
                                                            class="px-2.5 py-1 rounded-lg text-[9px] font-black uppercase tracking-wider bg-emerald-500/10 border border-emerald-500/30 text-emerald-400"><i
                                                                class="fa-solid fa-circle-check text-[8px] mr-1"></i>
                                                            Approved</span>
                                                    </c:when>
                                                    <c:when test="${booking.status eq 'PAYMENT_SUBMITTED'}">
                                                        <span
                                                            class="px-2.5 py-1 rounded-lg text-[9px] font-black uppercase tracking-wider bg-amber-500/10 border border-amber-500/30 text-amber-400"><i
                                                                class="fa-solid fa-clock-rotate-left text-[8px] mr-1 animate-spin"></i>
                                                            Pending Verify</span>
                                                    </c:when>
                                                    <c:when test="${booking.status eq 'rejected'}">
                                                        <span
                                                            class="px-2.5 py-1 rounded-lg text-[9px] font-black uppercase tracking-wider bg-red-500/10 border border-red-500/30 text-red-500"><i
                                                                class="fa-solid fa-rectangle-xmark text-[8px] mr-1"></i>
                                                            Rejected</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span
                                                            class="px-2.5 py-1 rounded-lg text-[9px] font-black uppercase tracking-wider bg-neutral-500/10 border border-neutral-500/30 text-neutral-400"><i
                                                                class="fa-solid fa-ban text-[8px] mr-1"></i>
                                                            ${booking.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="py-5 px-6 text-right">
                                                <c:choose>
                                                    <c:when test="${booking.status eq 'PAYMENT_SUBMITTED'}">
                                                        <form action="${pageContext.request.contextPath}/admin/bookings"
                                                            method="post" class="inline"
                                                            onsubmit="return confirm('Approve Booking #MTX-${booking.id}? This confirms the payment.')">
                                                            <input type="hidden" name="bookingId" value="${booking.id}">
                                                            <input type="hidden" name="action" value="approve">
                                                            <button
                                                                class="px-2.5 py-1.5 text-[10px] font-bold text-emerald-400 hover:text-white bg-emerald-950/20 hover:bg-emerald-600 border border-emerald-500/30 rounded-lg transition-all active:scale-[0.98] mr-1.5"
                                                                type="submit">Approve</button>
                                                        </form>
                                                        <form action="${pageContext.request.contextPath}/admin/bookings"
                                                            method="post" class="inline"
                                                            onsubmit="return confirm('Reject Booking #MTX-${booking.id}? This releases/frees the selected seats.')">
                                                            <input type="hidden" name="bookingId" value="${booking.id}">
                                                            <input type="hidden" name="action" value="reject">
                                                            <button
                                                                class="px-2.5 py-1.5 text-[10px] font-bold text-red-400 hover:text-white bg-red-950/20 hover:bg-red-600 border border-red-500/30 rounded-lg transition-all active:scale-[0.98]"
                                                                type="submit">Reject</button>
                                                        </form>
                                                    </c:when>
                                                    <c:when test="${booking.status eq 'confirmed'}">
                                                        <form action="${pageContext.request.contextPath}/admin/bookings"
                                                            method="post" class="inline"
                                                            onsubmit="return confirm('Cancel Booking #MTX-${booking.id}? This releases all booked seat allocations.')">
                                                            <input type="hidden" name="bookingId" value="${booking.id}">
                                                            <button
                                                                class="px-3 py-1.5 text-[10px] font-bold text-red-400 hover:text-white bg-red-950/20 hover:bg-red-500 border border-red-500/30 rounded-lg transition-all active:scale-[0.98]"
                                                                type="submit">Cancel</button>
                                                        </form>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-neutral-600 font-light">—</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty bookings}">
                                        <tr>
                                            <td colspan="9" class="py-16 text-center text-neutral-500 font-light">No
                                                platform booking logs recorded yet.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </main>
            </div>

            <!-- Footer -->
            <footer
                class="border-t border-white/5 py-6 px-6 text-center text-xs text-neutral-600 bg-[#07070d]/50 w-full mt-auto">
                © 2026 MovieTix Administration Desk. Secure Sandbox.
            </footer>

            <script>
                document.addEventListener("DOMContentLoaded", function () {
                    const filter = document.getElementById("statusFilter");
                    const rows = document.querySelectorAll("tbody tr");
                    const totalSpan = document.getElementById("totalCount");
                    const visibleSpan = document.getElementById("visibleCount");

                    function applyFilter() {
                        const val = filter.value;
                        let visible = 0;
                        let total = 0;

                        rows.forEach(row => {
                            if (row.querySelector("td[colspan]")) {
                                return;
                            }
                            total++;
                            const statusAttr = row.getAttribute("data-status");
                            if (val === "ALL" || statusAttr === val) {
                                row.style.display = "";
                                visible++;
                            } else {
                                row.style.display = "none";
                            }
                        });

                        if (totalSpan) totalSpan.textContent = total;
                        if (visibleSpan) visibleSpan.textContent = visible;
                    }

                    if (filter) {
                        filter.addEventListener("change", applyFilter);
                        applyFilter();
                    }
                });
            </script>
            <script src="${pageContext.request.contextPath}/js/main.js"></script>
            <jsp:include page="/chatbot.jsp" />
        </body>

        </html>