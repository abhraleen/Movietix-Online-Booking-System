<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <% // Fallback if booking isn't set (e.g. page refreshed) if (request.getAttribute("booking")==null) {
            response.sendRedirect(request.getContextPath() + "/history" ); return; } %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Booking Success — MovieTix Gold</title>
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
                        <a class="px-4 py-2 text-sm font-semibold text-gray-400 hover:text-white transition-colors"
                            href="${pageContext.request.contextPath}/home">Home</a>
                        <a class="px-4 py-2 text-sm font-semibold text-gray-400 hover:text-white transition-colors"
                            href="${pageContext.request.contextPath}/history">My Bookings</a>
                    </div>
                </nav>

                <main
                    class="flex-grow max-w-xl mx-auto w-full px-6 py-12 md:py-16 flex flex-col items-center justify-center">

                    <!-- Success Badge -->
                    <div class="text-center mb-8">
                        <div
                            class="h-16 w-16 bg-emerald-500/10 border border-emerald-500/30 rounded-full flex items-center justify-center text-emerald-400 text-3xl mx-auto mb-4 shadow-lg shadow-emerald-500/20">
                            <i class="fa-solid fa-circle-check text-glow-emerald"></i>
                        </div>
                        <h1 class="text-2xl md:text-3xl font-black text-white tracking-tight">Purchase Successful</h1>
                        <p class="text-xs text-neutral-400 mt-2 font-light">Congratulations! Your premium lounge seats
                            are successfully reserved.</p>
                    </div>

                    <!-- Luxury Ticket -->
                    <div
                        class="w-full bg-[#0a0a14] border border-white/10 rounded-3xl overflow-hidden shadow-2xl relative ticket-container">
                        <!-- Details -->
                        <div class="p-8">
                            <div class="flex justify-between items-start gap-4">
                                <div>
                                    <span
                                        class="text-[9px] text-yellow-500 font-extrabold uppercase tracking-widest flex items-center gap-1.5"><i
                                            class="fa-solid fa-circle text-[7px] animate-pulse"></i> VIP Luxury Seat
                                        Pass</span>
                                    <h2 class="text-2xl font-black text-white mt-2 leading-tight">${booking.movieTitle}
                                    </h2>
                                </div>
                                <span
                                    class="px-3 py-1.5 rounded-lg bg-emerald-500/10 border border-emerald-500/30 text-emerald-400 text-[10px] font-black uppercase tracking-wider shrink-0">${booking.status}</span>
                            </div>

                            <div class="grid grid-cols-2 gap-y-5 gap-x-4 mt-8 pt-6 border-t border-white/5 font-light">
                                <div>
                                    <span
                                        class="text-[9px] text-neutral-500 uppercase font-bold tracking-widest block">Reference
                                        Receipt</span>
                                    <span
                                        class="text-xs font-mono font-bold text-gray-200 mt-1 block">#MTX-${booking.id}</span>
                                </div>
                                <div>
                                    <span
                                        class="text-[9px] text-neutral-500 uppercase font-bold tracking-widest block">Cinema
                                        Theatre</span>
                                    <span class="text-xs font-bold text-gray-200 mt-1 block">${booking.hall}</span>
                                </div>
                                <div>
                                    <span
                                        class="text-[9px] text-neutral-500 uppercase font-bold tracking-widest block">Schedule
                                        Date</span>
                                    <span class="text-xs font-bold text-gray-200 mt-1 block">${booking.showDate}</span>
                                </div>
                                <div>
                                    <span
                                        class="text-[9px] text-neutral-500 uppercase font-bold tracking-widest block">Schedule
                                        Time</span>
                                    <span
                                        class="text-xs font-bold text-gray-200 mt-1 block">${booking.showTime.toString().substring(0,
                                        5)}</span>
                                </div>
                                <div class="col-span-2 bg-[#0c0c1a] border border-white/5 rounded-2xl p-4 mt-2">
                                    <span
                                        class="text-[9px] text-neutral-500 uppercase font-bold tracking-widest block">Lounge
                                        Row & Seats</span>
                                    <span class="text-base font-extrabold text-yellow-500 tracking-wide mt-1 block">
                                        <c:forEach var="seat" items="${booking.seatNumbers}" varStatus="st">
                                            <span
                                                class="inline-block px-2.5 py-1 text-xs font-mono font-bold bg-yellow-500/10 border border-yellow-500/25 rounded-md mr-1">${seat}</span>
                                        </c:forEach>
                                    </span>
                                </div>
                            </div>
                        </div>

                        <!-- Notches Divider -->
                        <div class="ticket-divider"></div>

                        <!-- Total & Barcode -->
                        <div class="p-8 pt-6 flex flex-col items-center">
                            <div class="flex justify-between items-center w-full mb-6 text-sm">
                                <span class="text-neutral-400 font-bold uppercase tracking-wider text-xs">Total Amount
                                    Paid</span>
                                <strong
                                    class="text-2xl font-black text-white text-glow-gold">₹${booking.totalAmount}</strong>
                            </div>

                            <!-- Barcode -->
                            <div
                                class="w-full py-4 bg-[#05050a] border border-white/5 rounded-2xl flex flex-col items-center justify-center gap-2">
                                <span class="text-5xl text-neutral-400 font-light tracking-widest"><i
                                        class="fa-solid fa-barcode"></i></span>
                                <span
                                    class="text-[9px] font-mono tracking-[0.25em] text-neutral-500 uppercase font-bold">MTX-BK-${booking.id}-${booking.showDate.replace("-","")}</span>
                            </div>
                        </div>
                    </div>

                    <!-- Actions -->
                    <div class="flex gap-4 mt-10 w-full">
                        <a class="flex-grow py-4 px-4 text-center text-sm font-extrabold text-black bg-yellow-500 hover:bg-yellow-400 rounded-xl transition-all shadow-lg active:scale-[0.98] btn-gold-glow flex items-center justify-center gap-2"
                            href="${pageContext.request.contextPath}/home">
                            Book Another Movie
                        </a>
                    </div>
                </main>

                <script src="${pageContext.request.contextPath}/js/main.js"></script>
                <jsp:include page="/chatbot.jsp" />
            </body>

            </html>