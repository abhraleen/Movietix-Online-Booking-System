<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Sign In — MovieTix Gold</title>
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
                    <a class="px-5 py-2 text-sm font-bold text-yellow-500 border border-yellow-500/30 hover:border-yellow-500 hover:bg-yellow-500/5 rounded-xl transition-all"
                        href="${pageContext.request.contextPath}/register">Sign Up</a>
                </div>
            </nav>

            <!-- Main Container -->
            <div class="flex-grow flex items-center justify-center px-6 py-12 relative">
                <div
                    class="absolute w-[450px] h-[450px] bg-yellow-500/5 rounded-full filter blur-[100px] top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 pointer-events-none">
                </div>

                <div
                    class="w-full max-w-md p-8 md:p-10 rounded-3xl glass-card border border-white/10 shadow-2xl relative z-10 animate-fade-in">

                    <div class="text-center mb-8">
                        <div
                            class="w-12 h-12 rounded-full bg-yellow-500/10 border border-yellow-500/30 flex items-center justify-center mx-auto text-xl text-yellow-500 text-glow-gold shadow-lg shadow-yellow-500/10 mb-4">
                            <i class="fa-solid fa-user-lock"></i>
                        </div>
                        <h1 class="text-2xl font-black text-white tracking-tight">Luxury Entryway</h1>
                        <p class="text-xs text-neutral-400 mt-2 font-light">Sign in to your premium MovieTix account</p>
                    </div>

                    <!-- Alerts -->
                    <c:if test="${not empty error or not empty param.error}">
                        <div
                            class="mb-5 p-4 rounded-2xl bg-red-950/20 border border-red-500/30 text-red-200 text-xs flex items-center gap-3 animate-pulse">
                            <i class="fa-solid fa-circle-exclamation text-red-500 text-base"></i>
                            <span>
                                <c:out value="${not empty error ? error : param.error}" />
                            </span>
                        </div>
                    </c:if>

                    <c:if test="${not empty success}">
                        <div
                            class="mb-5 p-4 rounded-2xl bg-emerald-950/20 border border-emerald-500/30 text-emerald-200 text-xs flex items-center gap-3">
                            <i class="fa-solid fa-circle-check text-emerald-500 text-base"></i>
                            <span>${success}</span>
                        </div>
                    </c:if>

                    <!-- Form -->
                    <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm"
                        class="space-y-5">
                        <div>
                            <label class="block text-[10px] font-bold uppercase tracking-widest text-neutral-400 mb-2"
                                for="email">Email Address</label>
                            <div class="relative group">
                                <span
                                    class="absolute inset-y-0 left-0 pl-4 flex items-center text-neutral-500 group-focus-within:text-yellow-500 transition-colors">
                                    <i class="fa-regular fa-envelope"></i>
                                </span>
                                <input
                                    class="w-full bg-[#0a0a14]/80 border border-white/10 rounded-xl py-3 pl-11 pr-4 text-sm text-gray-200 placeholder-neutral-600 focus:outline-none focus:border-yellow-500 focus:ring-1 focus:ring-yellow-500 transition-all font-light"
                                    type="email" id="email" name="email" placeholder="you@example.com" required
                                    autocomplete="email">
                            </div>
                        </div>

                        <div>
                            <label class="block text-[10px] font-bold uppercase tracking-widest text-neutral-400 mb-2"
                                for="password">Password</label>
                            <div class="relative group">
                                <span
                                    class="absolute inset-y-0 left-0 pl-4 flex items-center text-neutral-500 group-focus-within:text-yellow-500 transition-colors">
                                    <i class="fa-solid fa-lock"></i>
                                </span>
                                <input
                                    class="w-full bg-[#0a0a14]/80 border border-white/10 rounded-xl py-3 pl-11 pr-4 text-sm text-gray-200 placeholder-neutral-600 focus:outline-none focus:border-yellow-500 focus:ring-1 focus:ring-yellow-500 transition-all font-light"
                                    type="password" id="password" name="password" placeholder="••••••••" required
                                    autocomplete="current-password">
                            </div>
                        </div>

                        <button
                            class="w-full py-3.5 px-4 text-sm font-extrabold text-black bg-yellow-500 hover:bg-yellow-400 rounded-xl transition-all shadow-xl shadow-yellow-500/25 active:scale-[0.98] btn-gold-glow flex items-center justify-center gap-2 mt-4"
                            type="submit">
                            Unlock Access <i class="fa-solid fa-chevron-right text-xs"></i>
                        </button>
                    </form>

                    <div class="mt-6 text-center text-xs text-neutral-400 font-light">
                        New to the premium theater? <a href="${pageContext.request.contextPath}/register"
                            class="text-yellow-500 font-bold hover:underline">Register Now</a>
                    </div>

                    <!-- Demo Accounts Box -->
                    <div
                        class="mt-8 p-5 rounded-2xl bg-yellow-500/[0.02] border border-yellow-500/10 text-xs text-neutral-400 space-y-3 relative overflow-hidden">
                        <div class="absolute top-0 right-0 w-16 h-16 bg-yellow-500/[0.02] rounded-full filter blur-xl">
                        </div>
                        <div
                            class="font-bold text-yellow-500 uppercase tracking-widest text-[9px] flex items-center gap-1.5">
                            <i class="fa-solid fa-circle-info"></i> Demo Vault Credentials
                        </div>
                        <div class="flex flex-col gap-2 font-light">
                            <div class="flex justify-between items-center py-1.5 border-b border-white/[0.04]">
                                <span class="text-neutral-500">Customer Access:</span>
                                <span class="font-mono text-gray-200 text-[11px]">john@example.com <span
                                        class="text-neutral-600">/</span> password123</span>
                            </div>
                            <div class="flex justify-between items-center">
                                <span class="text-neutral-500">Administrator:</span>
                                <span class="font-mono text-gray-200 text-[11px]">admin@movietix.com <span
                                        class="text-neutral-600">/</span> admin123</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Footer -->
            <footer
                class="border-t border-white/5 py-6 px-6 text-center text-xs text-neutral-600 bg-[#07070d]/50 relative z-10">
                © 2026 MovieTix. Verified Luxury Booking Gateways.
            </footer>

            <script src="${pageContext.request.contextPath}/js/main.js"></script>
            <jsp:include page="/chatbot.jsp" />
        </body>

        </html>