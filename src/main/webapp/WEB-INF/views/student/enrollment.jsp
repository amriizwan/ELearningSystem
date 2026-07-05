<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%--<%@ page import="java.util.*" %>--%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Enroll - MyStudyZone</title>
        
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css"/>
        
    </head>
    <body class="bg-gray-50 text-gray-900">
        
        <aside class="w-52 bg-white border-r border-gray-100 flex flex-col py-5 fixed h-full">
            <div class="px-4 mb-6">
                <span class="text-base font-semibold text-gray-900">MyStudyZone</span>
                <span class="block text-xs text-gray-400 mt-0.5">Student portal</span>
            </div>
            <nav class="flex flex-col gap-0.5 flex-1">
                <a href="${pageContext.request.contextPath}/dashboard"
                   class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">Dashboard</a>
                <a href="${pageContext.request.contextPath}/enrollment"
                   class="px-4 py-2.5 text-sm font-medium bg-gray-50 text-gray-900">Enroll</a>
                <a href="${pageContext.request.contextPath}/course"
                   class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">My Courses</a>
                <a href="${pageContext.request.contextPath}/assignment"
                   class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">Assignments</a>
                <a href="${pageContext.request.contextPath}/quiz"
                   class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">Quiz</a>
                <a href="${pageContext.request.contextPath}/discussion"
                   class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">Discussion</a>
            </nav>
            <a href="${pageContext.request.contextPath}/logout"
               class="px-4 py-2.5 text-sm text-red-500 hover:bg-red-50 mt-auto">Logout</a>
        </aside>
        
        <main class="ml-56 min-h-screen p-8">

            <!-- Header -->
            <div class="mb-6">
                <h1 class="text-xl font-semibold text-gray-900">Course catalog</h1>
                <p class="text-sm text-gray-400 mt-1">Browse and enroll in available courses</p>
            </div>
            
            <!-- Toast -->
            <%-- Success / Error messages --%>
            <c:if test="${not empty sessionScope.success}">
                <div id="taostMsg" class="bg-green-50 border border-green-100 text-green-700 text-sm rounded-xl px-4 py-3 mb-5">
                    ${sessionScope.success}
                </div>
                <c:remove var="success" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.info}">
                <div id="taostMsg" class="bg-blue-50 border-blue-200 text-blue-700 text-sm rounded-xl px-4 py-3 mb-5">
                    ${sessionScope.info}
                </div>
                <c:remove var="info" scope="session"/>
            </c:if>

            <!-- Search + filter bar -->
            <div class="flex flex-col sm:flex-row gap-3 mb-6">
                <div class="relative flex-1">
                    <svg class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <circle cx="11" cy="11" r="7"/><path stroke-linecap="round" d="M21 21l-4.35-4.35"/>
                    </svg>
                    <input id="search-input" type="text" placeholder="Search courses or lecturers..."
                           oninput="filterCourses()"
                           class="w-full pl-9 pr-4 py-2.5 text-sm border border-gray-200 rounded-xl focus:outline-none focus:border-gray-400 bg-white transition"/>
                </div>
                <div class="flex gap-2 flex-wrap">
                    <button onclick="setFilter('all',this)"
                        class="filter-btn px-4 py-2 text-xs rounded-full border border-gray-900 bg-gray-900 text-white font-medium transition">
                        All
                    </button>
                    <button onclick="setFilter('enrolled',this)"
                        class="filter-btn px-4 py-2 text-xs rounded-full border border-gray-200 text-gray-500 hover:border-gray-400 font-medium transition">
                        Enrolled
                    </button>
                    <button onclick="setFilter('available',this)"
                        class="filter-btn px-4 py-2 text-xs rounded-full border border-gray-200 text-gray-500 hover:border-gray-400 font-medium transition">
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
            <div class="flex items-center gap-6 mb-6 text-sm text-gray-500">
                <span id="count-label">${fn:length(courses)} courses</span>
                <span class="text-gray-300">|</span>
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

                    <div class="course-card bg-white border rounded-2xl p-5 flex flex-col transition hover:shadow-sm ${enrolled ? 'border-emerald-300' : 'border-gray-100 hover:border-gray-200'}"
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
                                <span class="text-xs font-medium px-2.5 py-1 rounded-full bg-emerald-100 text-emerald-700">Enrolled</span>
                            </c:if>
                        </div>

                        <!-- Course title -->
                        <h3 class="text-sm font-semibold text-gray-900 mb-1 leading-snug">
                            ${course.title}
                        </h3>

                        <!-- Lecturers -->
                        <p class="text-xs text-gray-400 mb-3">${lecs}</p>

                        <!-- Description -->
                        <c:if test="${not empty course.description}">
                            <p class="text-xs text-gray-500 leading-relaxed mb-4 line-clamp-2">
                                ${course.description}
                            </p>
                        </c:if>

                        <!-- Stats row -->
                        <div class="flex gap-3 mb-4 mt-auto">
                            <div class="text-center">
                                <div class="text-sm font-semibold text-gray-900">${course.noteCount}</div>
                                <div class="text-xs text-gray-400">Notes</div>
                            </div>
                            <div class="w-px bg-gray-100"></div>
                            <div class="text-center">
                                <div class="text-sm font-semibold text-gray-900">${course.assignmentCount}</div>
                                <div class="text-xs text-gray-400">Assignments</div>
                            </div>
                            <div class="w-px bg-gray-100"></div>
                            <div class="text-center">
                                <div class="text-sm font-semibold text-gray-900">${course.quizCount}</div>
                                <div class="text-xs text-gray-400">Quizzes</div>
                            </div>
                            <div class="w-px bg-gray-100"></div>
                            <div class="text-center">
                                <div class="text-sm font-semibold text-gray-900">${course.enrollmentCount}</div>
                                <div class="text-xs text-gray-400">Students</div>
                            </div>
                        </div>

                        <!-- Enroll / Unenroll button -->
<!--                        <form method="POST" action=""
                              onsubmit="return <?= $enrolled ? "confirmUnenroll('" . htmlspecialchars($course['title'], ENT_QUOTES) . "')" : 'true' ?>">-->
                        <form method="post"
                            action="enrollment"
                            onsubmit="${enrolled ? 'return confirmUnenroll(this.dataset.title)' : 'return true'}"
                            data-title="${course.title}">
                                <input type="hidden" name="courseId" value="${course.id}"/>
                                <input type="hidden" name="action"    value="${enrolled ? 'unenroll' : 'enroll'}"/>
                                <button type="submit"
                                    class="w-full py-2.5 rounded-xl text-sm font-medium transition
                                           ${enrolled
                                               ? 'bg-gray-100 text-gray-600 hover:bg-red-50 hover:text-red-600 hover:border hover:border-red-200'
                                               : 'bg-gray-900 text-white hover:bg-gray-700'}">
                                    ${enrolled ? 'Unenroll' : 'Enroll now'}
                                </button>
                        </form>
                    </div>
                </c:forEach>
            </div>

            <!-- Empty state -->
            <div id="empty-state" class="hidden text-center py-16">
                <svg class="w-10 h-10 text-gray-300 mx-auto mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.2"
                          d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/>
                </svg>
                <p class="text-sm text-gray-400">No courses found.</p>
            </div>

        </main>

        
        <script>
            let currentFilter = 'all';

            function setFilter(type, btn) {
                currentFilter = type;

                // Update button styles
                document.querySelectorAll('.filter-btn').forEach(b => {
                    b.className = 'filter-btn px-4 py-2 text-xs rounded-full border border-gray-200 text-gray-500 hover:border-gray-400 font-medium transition';
                });
                btn.className = 'filter-btn px-4 py-2 text-xs rounded-full border border-gray-900 bg-gray-900 text-white font-medium transition';

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
        </script>

    </body>
</html>