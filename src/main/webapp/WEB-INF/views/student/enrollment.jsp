<%-- 
    Document   : enrollment
    Created on : 25 Jun 2026, 3:36:38 pm
    Author     : User
--%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>

<%
    List<Map<String, String>> palettes = new ArrayList<>();

    Map<String, String> p1 = new HashMap<>();
    p1.put("badge", "bg-emerald-100 text-emerald-800");
    p1.put("bar", "bg-emerald-500");
    p1.put("icon", "bg-emerald-50 text-emerald-600");
    palettes.add(p1);

    Map<String, String> p2 = new HashMap<>();
    p2.put("badge", "bg-violet-100 text-violet-800");
    p2.put("bar", "bg-violet-500");
    p2.put("icon", "bg-violet-50 text-violet-600");
    palettes.add(p2);

    Map<String, String> p3 = new HashMap<>();
    p3.put("badge", "bg-amber-100 text-amber-800");
    p3.put("bar", "bg-amber-500");
    p3.put("icon", "bg-amber-50 text-amber-600");
    palettes.add(p3);
    
    Map<String, String> p4 = new HashMap<>();
    p4.put("badge", "bg-blue-100 text-blue-800");
    p4.put("bar", "bg-blue-500");
    p4.put("icon", "bg-blue-50 text-blue-600");
    palettes.add(p4);

    Map<String, String> p5 = new HashMap<>();
    p5.put("badge", "bg-rose-100 text-rose-800");
    p5.put("bar", "bg-rose-500");
    p5.put("icon", "bg-rose-50 text-rose-600");
    palettes.add(p5);

    Map<String, String> p6 = new HashMap<>();
    p6.put("badge", "bg-teal-100 text-teal-800");
    p6.put("bar", "bg-teal-500");
    p6.put("icon", "bg-teal-50 text-teal-600");
    palettes.add(p6);
    
    request.setAttribute("palettes", palettes);
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Enroll - MyStudyZone</title>
        
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css"/>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <style>
            body { font-family: 'Inter', ui-sans-serif, system-ui, sans-serif; }
        </style>
    </head>
    <body class="bg-slate-50 text-slate-900 antialiased">

        <!-- Mobile top bar -->
        <div class="lg:hidden sticky top-0 z-40 flex items-center justify-between bg-white border-b border-slate-200 px-4 py-3">
            <div class="flex items-center gap-2">
                <div class="w-8 h-8 rounded-lg bg-indigo-600 flex items-center justify-center">
                    <i class="fa-solid fa-graduation-cap text-white text-sm"></i>
                </div>
                <span class="text-base font-bold text-slate-900">MyStudyZone</span>
            </div>
            <button id="menu-toggle" type="button" class="w-9 h-9 flex items-center justify-center rounded-lg text-slate-500 hover:bg-slate-100 transition">
                <i class="fa-solid fa-bars text-lg"></i>
            </button>
        </div>

        <!-- Sidebar overlay (mobile) -->
        <div id="sidebar-overlay" class="hidden fixed inset-0 bg-slate-900/40 z-30 lg:hidden"></div>
        
        <aside id="sidebar" class="w-64 bg-white border-r border-slate-100 flex flex-col py-6 fixed h-full z-40 -translate-x-full lg:translate-x-0 transition-transform duration-200 ease-in-out">
            <div class="px-6 mb-8 hidden lg:flex items-center gap-2.5">
                <div class="w-9 h-9 rounded-xl bg-indigo-600 flex items-center justify-center shadow-sm shadow-indigo-200">
                    <i class="fa-solid fa-graduation-cap text-white text-sm"></i>
                </div>
                <div>
                    <span class="block text-base font-bold text-slate-900 leading-tight">MyStudyZone</span>
                    <span class="block text-xs text-slate-400">Student portal</span>
                </div>
            </div>
            <nav class="flex flex-col gap-1 flex-1 px-3">
                <a href="${pageContext.request.contextPath}/dashboard"
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-500 hover:bg-slate-50 hover:text-slate-900 transition">
                    <i class="fa-solid fa-gauge-high w-4 text-center"></i>
                    Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/enrollment"
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-semibold bg-indigo-50 text-indigo-700 transition">
                    <i class="fa-solid fa-pen-to-square w-4 text-center"></i>
                    Enroll
                </a>
                <a href="${pageContext.request.contextPath}/course"
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-500 hover:bg-slate-50 hover:text-slate-900 transition">
                    <i class="fa-solid fa-book-open w-4 text-center"></i>
                    My Courses
                </a>
                <a href="${pageContext.request.contextPath}/assignment"
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-500 hover:bg-slate-50 hover:text-slate-900 transition">
                    <i class="fa-solid fa-file-lines w-4 text-center"></i>
                    Assignments
                </a>
                <a href="${pageContext.request.contextPath}/quiz"
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-500 hover:bg-slate-50 hover:text-slate-900 transition">
                    <i class="fa-solid fa-square-poll-vertical w-4 text-center"></i>
                    Quiz
                </a>
                <a href="${pageContext.request.contextPath}/discussion"
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-500 hover:bg-slate-50 hover:text-slate-900 transition">
                    <i class="fa-solid fa-comments w-4 text-center"></i>
                    Discussion
                </a>
            </nav>
            <div class="px-3 mt-auto">
                <a href="${pageContext.request.contextPath}/logout"
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-medium text-red-500 hover:bg-red-50 transition">
                    <i class="fa-solid fa-arrow-right-from-bracket w-4 text-center"></i>
                    Logout
                </a>
            </div>
        </aside>
        
        <main class="lg:ml-64 min-h-screen p-5 sm:p-8">

            <!-- Header -->
            <div class="mb-6">
                <h1 class="text-2xl font-bold text-slate-900 tracking-tight">Course catalog</h1>
                <p class="text-sm text-slate-400 mt-1.5">Browse and enroll in available courses</p>
            </div>
            
            <!-- Toast -->
            <%-- Success / Error messages --%>
            <c:if test="${not empty sessionScope.success}">
                <div id="taostMsg" class="flex items-center gap-2.5 bg-emerald-50 border border-emerald-100 text-emerald-700 text-sm rounded-xl px-4 py-3 mb-5">
                    <i class="fa-solid fa-circle-check text-emerald-500"></i>
                    ${sessionScope.success}
                </div>
                <c:remove var="success" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.info}">
                <div id="taostMsg" class="flex items-center gap-2.5 bg-blue-50 border border-blue-200 text-blue-700 text-sm rounded-xl px-4 py-3 mb-5">
                    <i class="fa-solid fa-circle-info text-blue-500"></i>
                    ${sessionScope.info}
                </div>
                <c:remove var="info" scope="session"/>
            </c:if>

            <!-- Search + filter bar -->
            <div class="flex flex-col sm:flex-row gap-3 mb-6">
                <div class="relative flex-1">
                    <svg class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <circle cx="11" cy="11" r="7"/><path stroke-linecap="round" d="M21 21l-4.35-4.35"/>
                    </svg>
                    <input id="search-input" type="text" placeholder="Search courses or lecturers..."
                           oninput="filterCourses()"
                           class="w-full pl-9 pr-4 py-2.5 text-sm border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-indigo-100 focus:border-indigo-400 bg-white transition"/>
                </div>
                <div class="flex gap-2 flex-wrap">
                    <button onclick="setFilter('all',this)"
                        class="filter-btn px-4 py-2 text-xs rounded-full border border-indigo-600 bg-indigo-600 text-white font-medium transition">
                        All
                    </button>
                    <button onclick="setFilter('enrolled',this)"
                        class="filter-btn px-4 py-2 text-xs rounded-full border border-slate-200 text-slate-500 hover:border-indigo-300 font-medium transition">
                        Enrolled
                    </button>
                    <button onclick="setFilter('available',this)"
                        class="filter-btn px-4 py-2 text-xs rounded-full border border-slate-200 text-slate-500 hover:border-indigo-300 font-medium transition">
                        Available
                    </button>
                </div>
            </div>

            <!-- Stats summary -->
            <c:set var="enrolledCount" value="0" />
            <c:forEach var="course" items="${courses}">
                <c:if test="${course.enrolled}">
                    <c:set var="enrolledCount" value="${enrolledCount + 1}" />
                </c:if>
            </c:forEach>
            <div class="flex items-center gap-6 mb-6 text-sm text-slate-500">
                <span id="count-label">${fn:length(courses)} courses</span>
                <span class="text-slate-300">|</span>
                <span class="text-emerald-600 font-medium">${enrolledCount} enrolled</span>
            </div>
            
            <!-- Course grid -->
            <div id="course-grid" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
                <c:forEach var="course" items="${courses}" varStatus="status">
                    
                    <c:set var="palette" value="${palettes[status.index % fn:length(palettes)]}" />

                    <c:set var="lecs" value="No lecturer assigned" />
                    <c:forEach var="lectName" items="${lectNames}">
                        <c:if test="${lectName.id == course.id}">
                            <c:set var="lecs" value="${lectName.lecturerNames}" />
                        </c:if>
                    </c:forEach>
                    
                     <c:set var="enrolled" value="${course.enrolled}" />

                    <div class="course-card bg-white border rounded-2xl p-5 flex flex-col transition hover:shadow-md ${enrolled ? 'border-emerald-300' : 'border-slate-100 hover:border-indigo-200'}"
                        data-enrolled="${enrolled ? '1' : '0'}"
                        data-title="${course.title}"
                        data-lec="${lecs}">

                        <!-- Top row -->
                        <div class="flex items-start justify-between mb-4">
                            <div class="w-10 h-10 rounded-xl flex items-center justify-center flex-shrink-0 ${palette.icon}">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                          d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/>
                                </svg>
                            </div>
                            <c:if test="${enrolled}">
                                <span class="text-xs font-medium px-2.5 py-1 rounded-full bg-emerald-100 text-emerald-700 flex items-center gap-1">
                                    <i class="fa-solid fa-check text-[10px]"></i> Enrolled
                                </span>
                            </c:if>
                        </div>

                        <!-- Course title -->
                        <h3 class="text-sm font-bold text-slate-900 mb-1 leading-snug">
                            ${course.title}
                        </h3>

                        <!-- Lecturers -->
                        <p class="text-xs text-slate-400 mb-3">${lecs}</p>

                        <!-- Description -->
                        <c:if test="${not empty course.description}">
                            <p class="text-xs text-slate-500 leading-relaxed mb-4 line-clamp-2">
                                ${course.description}
                            </p>
                        </c:if>

                        <!-- Stats row -->
                        <div class="flex gap-3 mb-4 mt-auto pt-3 border-t border-slate-50">
                            <div class="text-center flex-1">
                                <div class="text-sm font-bold text-slate-900">${course.noteCount}</div>
                                <div class="text-xs text-slate-400">Notes</div>
                            </div>
                            <div class="w-px bg-slate-100"></div>
                            <div class="text-center flex-1">
                                <div class="text-sm font-bold text-slate-900">${course.assignmentCount}</div>
                                <div class="text-xs text-slate-400">Assignments</div>
                            </div>
                            <div class="w-px bg-slate-100"></div>
                            <div class="text-center flex-1">
                                <div class="text-sm font-bold text-slate-900">${course.quizCount}</div>
                                <div class="text-xs text-slate-400">Quizzes</div>
                            </div>
                            <div class="w-px bg-slate-100"></div>
                            <div class="text-center flex-1">
                                <div class="text-sm font-bold text-slate-900">${course.enrollmentCount}</div>
                                <div class="text-xs text-slate-400">Students</div>
                            </div>
                        </div>
                                
                        <button
                            type="button"
                            onclick="openCourseModal(
                                '${fn:escapeXml(course.title)}',
                                '${fn:escapeXml(lecs)}',
                                `${fn:escapeXml(course.description)}`,
                                '${course.noteCount}',
                                '${course.assignmentCount}',
                                '${course.quizCount}',
                                '${course.enrollmentCount}',
                                '${enrolled}'
                            )"
                            class="w-full mb-2 py-2.5 rounded-xl text-sm font-semibold transition bg-slate-100 text-slate-600 hover:bg-red-50 hover:text-red-600 border border-transparent hover:border-red-200">
                            View details
                        </button>
                            
                        <!-- Course Details Modal -->
                        <div id="courseModal"
                             class="fixed inset-0 bg-black/50 backdrop-blur-sm hidden items-center justify-center z-50 p-4">
                            <div class="bg-white rounded-2xl shadow-2xl w-full max-w-2xl max-h-[90vh] overflow-hidden">
                                <!-- Header -->
                                <div class="flex justify-between items-start p-6 border-b">
                                    <div>
                                        <h2 id="modalTitle"
                                            class="text-2xl font-bold text-slate-900"></h2>
                                        <p id="modalLecturer"
                                           class="text-slate-500 mt-1"></p>
                                    </div>
                                    <button
                                        onclick="closeCourseModal()"
                                        class="w-10 h-10 rounded-full hover:bg-slate-100 text-slate-500">
                                        ✕
                                    </button>
                                </div>

                                <!-- Body -->
                                <div class="p-6 overflow-y-auto">
                                    <h4 class="font-semibold text-slate-700 mb-2">
                                        Course Description
                                    </h4>
                                    <p id="modalDescription"
                                       class="text-slate-600 leading-7 whitespace-pre-line mb-8">
                                    </p>

                                    <div class="grid grid-cols-4 gap-4">
                                        <div class="bg-slate-50 rounded-xl p-4 text-center">
                                            <div id="modalNotes" class="text-2xl font-bold text-slate-900"></div>
                                            <div class="text-xs text-slate-500 mt-1">Notes</div>
                                        </div>
                                        <div class="bg-slate-50 rounded-xl p-4 text-center">
                                            <div id="modalAssignments" class="text-2xl font-bold text-slate-900"></div>
                                            <div class="text-xs text-slate-500 mt-1">Assignments</div>
                                        </div>
                                        <div class="bg-slate-50 rounded-xl p-4 text-center">
                                            <div id="modalQuizzes" class="text-2xl font-bold text-slate-900"></div>
                                            <div class="text-xs text-slate-500 mt-1">Quizzes</div>
                                        </div>
                                        <div class="bg-slate-50 rounded-xl p-4 text-center">
                                            <div id="modalStudents" class="text-2xl font-bold text-slate-900"></div>
                                            <div class="text-xs text-slate-500 mt-1">Students</div>
                                        </div>
                                    </div>
                                </div>

                                <div class="border-t p-4 flex justify-end">
                                    <button
                                        onclick="closeCourseModal()"
                                        class="px-5 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700">
                                        Close
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- Enroll / Unenroll button -->
                        <form method="post"
                            action="enrollment"
                            onsubmit="${enrolled ? 'return confirmUnenroll(this.dataset.title)' : 'return true'}"
                            data-title="${course.title}">
                                <input type="hidden" name="courseId" value="${course.id}"/>
                                <input type="hidden" name="action"    value="${enrolled ? 'unenroll' : 'enroll'}"/>
                                <button type="submit"
                                    class="w-full py-2.5 rounded-xl text-sm font-semibold transition
                                           ${enrolled
                                               ? 'bg-slate-100 text-slate-600 hover:bg-red-50 hover:text-red-600 border border-transparent hover:border-red-200'
                                               : 'bg-indigo-600 text-white hover:bg-indigo-700 shadow-sm shadow-indigo-200'}">
                                    ${enrolled ? 'Unenroll' : 'Enroll now'}
                                </button>
                        </form>
                    </div>
                </c:forEach>
            </div>

            <!-- Empty state -->
            <div id="empty-state" class="hidden text-center py-16">
                <div class="w-14 h-14 rounded-full bg-slate-100 text-slate-300 flex items-center justify-center mx-auto mb-3">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.2"
                              d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/>
                    </svg>
                </div>
                <p class="text-sm text-slate-400">No courses found.</p>
            </div>

        </main>

        
        <script>
            let currentFilter = 'all';

            function setFilter(type, btn) {
                currentFilter = type;

                // Update button styles
                document.querySelectorAll('.filter-btn').forEach(b => {
                    b.className = 'filter-btn px-4 py-2 text-xs rounded-full border border-slate-200 text-slate-500 hover:border-indigo-300 font-medium transition';
                });
                btn.className = 'filter-btn px-4 py-2 text-xs rounded-full border border-indigo-600 bg-indigo-600 text-white font-medium transition';

                filterCourses();
            }

            function filterCourses() {
                const search  = document.getElementById('search-input').value.toLowerCase();
                const cards   = document.querySelectorAll('.course-card');
                let   visible = 0;

                cards.forEach(card => {
                    const title = (card.dataset.title || '').toLowerCase();
                    const lec   = (card.dataset.lec || '').toLowerCase();
                    const enrolled = card.dataset.enrolled === '1';

                    const matchSearch = title.includes(search) || lec.includes(search);
                    const matchFilter = currentFilter === 'all'
                        || (currentFilter === 'enrolled'  &&  enrolled)
                        || (currentFilter === 'available' && !enrolled);

                    const show = matchSearch && matchFilter;
                    card.style.display = show ? '' : 'none';
                    if (show) visible++;
                });

                document.getElementById('count-label').textContent = visible + ' course' + (visible !== 1 ? 's' : '');
                document.getElementById('empty-state').classList.toggle('hidden', visible > 0);
            }
            
            function confirmUnenroll(title) {
                return confirm('Are you sure you want to unenroll from "' + title + '"?\nYour submitted assignments will be kept.');
            }

            const sidebar = document.getElementById('sidebar');
            const overlay = document.getElementById('sidebar-overlay');
            const menuToggle  = document.getElementById('menu-toggle');

            function openSidebar() {
                sidebar.classList.remove('-translate-x-full');
                overlay.classList.remove('hidden');
            }
            function closeSidebar() {
                sidebar.classList.add('-translate-x-full');
                overlay.classList.add('hidden');
            }
            if (menuToggle) {
                menuToggle.addEventListener('click', () => {
                    sidebar.classList.contains('-translate-x-full') ? openSidebar() : closeSidebar();
                });
            }
            if (overlay) {
                overlay.addEventListener('click', closeSidebar);
            }
            
            const courseModal = document.getElementById("courseModal");

            function openCourseModal(title, lecturer, description, notes, assignments, quizzes, students){
                document.getElementById("modalTitle").textContent = title;
                document.getElementById("modalLecturer").textContent = lecturer;

                document.getElementById("modalDescription").textContent =
                    description && description !== "null"
                        ? description
                        : "No description available.";

                document.getElementById("modalNotes").textContent = notes;
                document.getElementById("modalAssignments").textContent = assignments;
                document.getElementById("modalQuizzes").textContent = quizzes;
                document.getElementById("modalStudents").textContent = students;

                courseModal.classList.remove("hidden");
                courseModal.classList.add("flex");

                document.body.classList.add("overflow-hidden");
            }

            function closeCourseModal(){

                courseModal.classList.remove("flex");
                courseModal.classList.add("hidden");

                document.body.classList.remove("overflow-hidden");
            }
        </script>

    </body>
</html>
