<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Manage Catalog — Admin Desk — MovieTix Gold</title>
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
                    <a class="flex items-center gap-3.5 px-4 py-3 rounded-2xl bg-yellow-500 text-black font-extrabold shadow-lg shadow-yellow-500/10 active:scale-[0.98] transition-all"
                        href="${pageContext.request.contextPath}/admin/movies">
                        <span class="text-sm"><i class="fa-solid fa-clapperboard"></i></span>
                        <span class="text-sm">Manage Catalog</span>
                    </a>
                    <a class="flex items-center gap-3.5 px-4 py-3 rounded-2xl hover:bg-white/5 text-neutral-300 hover:text-white font-semibold transition-all group"
                        href="${pageContext.request.contextPath}/admin/shows">
                        <span class="text-sm text-neutral-500 group-hover:text-yellow-500 transition-colors"><i
                                class="fa-solid fa-calendar-days"></i></span>
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
                                <span class="h-8 w-1.5 bg-yellow-500 rounded-full text-glow-gold"></span> Manage Movies
                            </h1>
                            <p class="text-xs text-neutral-400 mt-2.5 font-light">Add, edit, or release film posters
                                screening on the platform</p>
                        </div>

                        <button
                            class="px-5 py-3 text-xs font-extrabold text-black bg-yellow-500 hover:bg-yellow-400 rounded-xl transition-all shadow-md active:scale-[0.98] btn-gold-glow flex items-center gap-1.5 self-start sm:self-auto uppercase tracking-wider"
                            id="openAddModal">
                            <i class="fa-solid fa-circle-plus text-sm"></i> Add Movie
                        </button>
                    </div>

                    <!-- Catalog List Container -->
                    <div class="glass-panel border border-white/5 rounded-3xl overflow-hidden shadow-2xl">
                        <div class="overflow-x-auto">
                            <table class="w-full text-left border-collapse">
                                <thead>
                                    <tr
                                        class="border-b border-white/5 text-[9px] uppercase font-black tracking-widest text-neutral-500 bg-white/[0.01]">
                                        <th class="py-4.5 px-6">Poster</th>
                                        <th class="py-4.5 px-6">Title</th>
                                        <th class="py-4.5 px-6">Genre</th>
                                        <th class="py-4.5 px-6">Duration</th>
                                        <th class="py-4.5 px-6">Language</th>
                                        <th class="py-4.5 px-6">Rating</th>
                                        <th class="py-4.5 px-6 text-right font-black">Operations</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-white/5 text-xs font-light">
                                    <c:forEach var="movie" items="${movies}">
                                        <tr class="hover:bg-white/[0.01] transition-colors">
                                            <td class="py-4 px-6">
                                                <img src="${movie.posterUrl}" alt="${movie.title}"
                                                    class="w-10 h-14 object-cover rounded-xl border border-white/10 shadow-md"
                                                    onerror="this.src='https://images.unsplash.com/photo-1542204113-e93a434de521?q=80&w=200&auto=format&fit=crop'">
                                            </td>
                                            <td class="py-4 px-6 text-white font-extrabold text-sm">${movie.title}</td>
                                            <td class="py-4 px-6">
                                                <span
                                                    class="px-2.5 py-1 rounded-md bg-[#0a0a14] border border-white/5 text-neutral-300 font-bold uppercase tracking-wider text-[9px]">${movie.genre}</span>
                                            </td>
                                            <td class="py-4 px-6 text-neutral-400 font-medium">
                                                ${movie.durationFormatted}</td>
                                            <td class="py-4 px-6 text-neutral-400 font-medium">${movie.language}</td>
                                            <td class="py-4 px-6">
                                                <span
                                                    class="px-2 py-0.5 rounded bg-yellow-500/10 border border-yellow-500/30 text-yellow-500 font-black uppercase tracking-wider text-[9px]"><i
                                                        class="fa-solid fa-star text-[8px] mr-0.5 text-glow-gold"></i>
                                                    ${movie.rating}</span>
                                            </td>
                                            <td class="py-4 px-6 text-right font-medium">
                                                <div class="flex gap-2 justify-end">
                                                    <button
                                                        class="px-3.5 py-1.5 text-xs font-bold text-yellow-500 hover:text-black hover:bg-yellow-500 border border-yellow-500/30 rounded-lg transition-all active:scale-[0.98] edit-movie-btn"
                                                        data-id="${movie.id}" data-title="${movie.title}"
                                                        data-genre="${movie.genre}"
                                                        data-description="${movie.description}"
                                                        data-duration="${movie.duration}"
                                                        data-language="${movie.language}" data-rating="${movie.rating}"
                                                        data-posterurl="${movie.posterUrl}">Edit</button>

                                                    <a class="px-3.5 py-1.5 text-xs font-bold text-red-400 hover:text-white bg-red-950/20 hover:bg-red-500 border border-red-500/30 rounded-lg transition-all active:scale-[0.98]"
                                                        href="${pageContext.request.contextPath}/admin/movies?action=delete&id=${movie.id}"
                                                        onclick="return confirm('Delete ${movie.title}? This will permanently remove its associated show schedules.')">Delete</a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty movies}">
                                        <tr>
                                            <td colspan="7" class="py-16 text-center text-neutral-500 font-light">No
                                                movies in the catalog yet. Click Add Movie to get started!</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </main>
            </div>

            <!-- Add / Edit Movie Modal overlay -->
            <div class="fixed inset-0 z-50 hidden items-center justify-center bg-black/70 backdrop-blur-md px-6"
                id="movieModal">
                <div
                    class="w-full max-w-lg p-6 md:p-8 bg-[#0a0a14] border border-white/10 rounded-3xl shadow-2xl relative flex flex-col max-h-[90vh] animate-fade-in">
                    <h2 class="text-lg font-black text-white tracking-tight border-b border-white/5 pb-4 mb-4"
                        id="modalTitle">Add Movie</h2>

                    <form action="${pageContext.request.contextPath}/admin/movies" method="post" id="movieForm"
                        class="space-y-4 overflow-y-auto pr-1 flex-grow font-light">
                        <input type="hidden" name="action" id="formAction" value="add">
                        <input type="hidden" name="id" id="editMovieId" value="">

                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                            <div class="sm:col-span-2">
                                <label
                                    class="block text-[9px] font-bold uppercase tracking-widest text-neutral-400 mb-1.5">Movie
                                    Title *</label>
                                <input
                                    class="w-full bg-[#030306] border border-white/10 rounded-xl py-2.5 px-3.5 text-xs text-gray-200 focus:outline-none focus:border-yellow-500 focus:ring-1 focus:ring-yellow-500 transition-all placeholder:text-neutral-700"
                                    type="text" name="title" id="mTitle" required placeholder="Enter movie title">
                            </div>

                            <div>
                                <label
                                    class="block text-[9px] font-bold uppercase tracking-widest text-neutral-400 mb-1.5">Genre</label>
                                <select
                                    class="w-full bg-[#030306] border border-white/10 rounded-xl py-2.5 px-3.5 text-xs text-gray-200 focus:outline-none focus:border-yellow-500 focus:ring-1 focus:ring-yellow-500 transition-all"
                                    name="genre" id="mGenre">
                                    <option value="Action">Action</option>
                                    <option value="Sci-Fi">Sci-Fi</option>
                                    <option value="Drama">Drama</option>
                                    <option value="Comedy">Comedy</option>
                                    <option value="Thriller">Thriller</option>
                                    <option value="Horror">Horror</option>
                                    <option value="Romance">Romance</option>
                                    <option value="Animation">Animation</option>
                                </select>
                            </div>

                            <div>
                                <label
                                    class="block text-[9px] font-bold uppercase tracking-widest text-neutral-400 mb-1.5">Language</label>
                                <input
                                    class="w-full bg-[#030306] border border-white/10 rounded-xl py-2.5 px-3.5 text-xs text-gray-200 focus:outline-none focus:border-yellow-500 focus:ring-1 focus:ring-yellow-500 transition-all placeholder:text-neutral-700"
                                    type="text" name="language" id="mLanguage" placeholder="English">
                            </div>

                            <div>
                                <label
                                    class="block text-[9px] font-bold uppercase tracking-widest text-neutral-400 mb-1.5">Duration
                                    (minutes)</label>
                                <input
                                    class="w-full bg-[#030306] border border-white/10 rounded-xl py-2.5 px-3.5 text-xs text-gray-200 focus:outline-none focus:border-yellow-500 focus:ring-1 focus:ring-yellow-500 transition-all placeholder:text-neutral-700"
                                    type="number" name="duration" id="mDuration" min="1" placeholder="120">
                            </div>

                            <div>
                                <label
                                    class="block text-[9px] font-bold uppercase tracking-widest text-neutral-400 mb-1.5">Rating
                                    (0-10)</label>
                                <input
                                    class="w-full bg-[#030306] border border-white/10 rounded-xl py-2.5 px-3.5 text-xs text-gray-200 focus:outline-none focus:border-yellow-500 focus:ring-1 focus:ring-yellow-500 transition-all placeholder:text-neutral-700"
                                    type="number" name="rating" id="mRating" min="0" max="10" step="0.1"
                                    placeholder="8.5">
                            </div>

                            <div class="sm:col-span-2">
                                <label
                                    class="block text-[9px] font-bold uppercase tracking-widest text-neutral-400 mb-1.5">Poster
                                    Image URL</label>
                                <input
                                    class="w-full bg-[#030306] border border-white/10 rounded-xl py-2.5 px-3.5 text-xs text-gray-200 focus:outline-none focus:border-yellow-500 focus:ring-1 focus:ring-yellow-500 transition-all placeholder:text-neutral-700"
                                    type="text" name="posterUrl" id="mPosterUrl"
                                    placeholder="https://images.unsplash.com/...">
                            </div>

                            <div class="sm:col-span-2">
                                <label
                                    class="block text-[9px] font-bold uppercase tracking-widest text-neutral-400 mb-1.5">Synopsis
                                    / Description</label>
                                <textarea
                                    class="w-full bg-[#030306] border border-white/10 rounded-xl py-2.5 px-3.5 text-xs text-gray-200 focus:outline-none focus:border-yellow-500 focus:ring-1 focus:ring-yellow-500 transition-all placeholder:text-neutral-700"
                                    name="description" id="mDescription" rows="3"
                                    placeholder="Brief details about the movie storyline..."></textarea>
                            </div>
                        </div>

                        <div class="border-t border-white/5 pt-4 mt-6 flex justify-end gap-3">
                            <button type="button"
                                class="px-5 py-2.5 text-xs font-bold text-gray-400 hover:text-white bg-white/5 border border-white/10 rounded-xl transition-all"
                                id="closeModal">Cancel</button>
                            <button type="submit"
                                class="px-6 py-3 text-xs font-extrabold text-black bg-yellow-500 hover:bg-yellow-400 rounded-xl transition-all shadow-md btn-gold-glow uppercase tracking-wider">Save
                                Movie</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Footer -->
            <footer
                class="border-t border-white/5 py-6 px-6 text-center text-xs text-neutral-600 bg-[#07070d]/50 w-full mt-auto">
                © 2026 MovieTix Administration Desk. Secure Sandbox.
            </footer>

            <script src="${pageContext.request.contextPath}/js/main.js"></script>
            <jsp:include page="/chatbot.jsp" />
        </body>

        </html>