<%-- FILE 5: web/lecturer/dashboard.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css"/>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', ui-sans-serif, system-ui, sans-serif; }
    </style>
    <title>Dashboard — MyStudyZone</title>
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

    <!-- Sidebar -->
    <aside id="sidebar" class="w-64 bg-white border-r border-slate-100 flex flex-col py-6 fixed h-full z-40 -translate-x-full lg:translate-x-0 transition-transform duration-200 ease-in-out">
        <div class="px-6 mb-8 hidden lg:flex items-center gap-2.5">
            <div class="w-9 h-9 rounded-xl bg-indigo-600 flex items-center justify-center shadow-sm shadow-indigo-200">
                <i class="fa-solid fa-graduation-cap text-white text-sm"></i>
            </div>
            <div>
                <span class="block text-base font-bold text-slate-900 leading-tight">MyStudyZone</span>
                <span class="block text-xs text-slate-400">Lecturer portal</span>
            </div>
        </div>
        <nav class="flex flex-col gap-1 flex-1 px-3">
            <a href="${pageContext.request.contextPath}/dashboard"
               class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-semibold bg-indigo-50 text-indigo-700 transition">
                <i class="fa-solid fa-gauge-high w-4 text-center"></i>
                Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/course"
               class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-500 hover:bg-slate-50 hover:text-slate-900 transition">
                <i class="fa-solid fa-book-open w-4 text-center"></i>
                My Courses
            </a>
            <a href="${pageContext.request.contextPath}/note"
               class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-500 hover:bg-slate-50 hover:text-slate-900 transition">
                <i class="fa-solid fa-note-sticky w-4 text-center"></i>
                Notes
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


<%--
    Palette list — used to cycle colors across course cards.
    We define them as arrays and pick by index % size inside the forEach.
    Because JSTL has no modulo on arrays, we use varStatus.index % 6 and
    a <c:choose> block for the 6 palettes.
--%>

<main class="lg:ml-64 min-h-screen p-5 sm:p-8">

    <%-- ── Header ── --%>
    <div class="mb-6">
        <h1 class="text-xl font-semibold text-slate-900">${greeting}, ${sessionScope.userName}  !</h1>
        <p class="text-sm text-slate-400 mt-1">${today}</p>
    </div>

    <%-- ── Stat cards ── --%>
    <div class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-5 gap-4 mb-8">

        <div class="bg-white border border-slate-100 rounded-xl p-5">
            <p class="text-xs text-slate-400 mb-2">Courses teaching</p>
            <p class="text-3xl font-semibold text-slate-900">${course_count}</p>
        </div>

        <div class="bg-white border border-slate-100 rounded-xl p-5">
            <p class="text-xs text-slate-400 mb-2">Total students</p>
            <p class="text-3xl font-semibold text-slate-900">${student_count}</p>
        </div>

        <div class="bg-white border border-slate-100 rounded-xl p-5">
            <p class="text-xs text-slate-400 mb-2">Pending to mark</p>
            <p class="text-3xl font-semibold ${pending_mark > 0 ? 'text-amber-500' : 'text-slate-900'}">
                ${pending_mark}
            </p>
            <c:if test="${pending_mark > 0}">
                <p class="text-xs text-amber-500 mt-1">needs attention</p>
            </c:if>
        </div>

        <div class="bg-white border border-slate-100 rounded-xl p-5">
            <p class="text-xs text-slate-400 mb-2">Notes uploaded</p>
            <p class="text-3xl font-semibold text-slate-900">${notes_count}</p>
        </div>

        <div class="bg-white border border-slate-100 rounded-xl p-5">
            <p class="text-xs text-slate-400 mb-2">Quizzes created</p>
            <p class="text-3xl font-semibold text-slate-900">${quiz_count}</p>
        </div>

    </div>

    <%-- ── Main grid ── --%>
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">

        <%-- My courses (col 1-2) --%>
        <div class="lg:col-span-2">
            <div class="flex items-center justify-between mb-4">
                <h2 class="text-sm font-semibold text-slate-700">My courses</h2>
                <a href="course" class="text-xs text-slate-400 hover:text-slate-700 transition">View all →</a>
            </div>

            <c:choose>
                <c:when test="${empty courses}">
                    <div class="bg-white border border-slate-100 rounded-xl p-10 text-center">
                        <p class="text-sm text-slate-400">You haven't been assigned to any courses yet.</p>
                        <p class="text-xs text-slate-400 mt-1">Contact your admin to get assigned.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-3 mb-6">
                        <c:forEach var="course" items="${courses}" varStatus="status">

                            <%--
                                Palette cycling: 6 palettes, pick by index % 6.
                                We set bg/text/bar variables using <c:set> inside a <c:choose>.
                            --%>
                            <c:set var="paletteIndex" value="${status.index % 6}" />
                            <c:choose>
                                <c:when test="${paletteIndex == 0}">
                                    <c:set var="pBg"   value="bg-emerald-50" />
                                    <c:set var="pText" value="text-emerald-600" />
                                </c:when>
                                <c:when test="${paletteIndex == 1}">
                                    <c:set var="pBg"   value="bg-violet-50" />
                                    <c:set var="pText" value="text-violet-600" />
                                </c:when>
                                <c:when test="${paletteIndex == 2}">
                                    <c:set var="pBg"   value="bg-amber-50" />
                                    <c:set var="pText" value="text-amber-600" />
                                </c:when>
                                <c:when test="${paletteIndex == 3}">
                                    <c:set var="pBg"   value="bg-blue-50" />
                                    <c:set var="pText" value="text-blue-600" />
                                </c:when>
                                <c:when test="${paletteIndex == 4}">
                                    <c:set var="pBg"   value="bg-rose-50" />
                                    <c:set var="pText" value="text-rose-600" />
                                </c:when>
                                <c:otherwise>
                                    <c:set var="pBg"   value="bg-teal-50" />
                                    <c:set var="pText" value="text-teal-600" />
                                </c:otherwise>
                            </c:choose>

                            <div class="bg-white border border-slate-100 rounded-xl p-4 hover:border-slate-200 hover:shadow-sm transition cursor-pointer"
                                 onclick="location.href='course'">
                                <div class="flex items-center gap-3 mb-3">
                                    <div class="w-9 h-9 rounded-lg flex items-center justify-center flex-shrink-0 ${pBg} ${pText}">
                                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                                  d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/>
                                        </svg>
                                    </div>
                                    <div class="flex-1 min-w-0">
                                        <div class="text-sm font-medium text-slate-900 truncate">${fn:escapeXml(course.title)}</div>
                                        <div class="text-xs text-slate-400 mt-0.5">${course.enrollmentCount} students</div>
                                    </div>
                                </div>
                                <%-- Mini stats --%>
                                <div class="grid grid-cols-3 gap-2 text-center">
                                    <div class="bg-slate-50 rounded-lg py-2">
                                        <div class="text-sm font-semibold text-slate-900">${course.noteCount}</div>
                                        <div class="text-[10px] text-slate-400">Notes</div>
                                    </div>
                                    <div class="bg-slate-50 rounded-lg py-2">
                                        <div class="text-sm font-semibold text-slate-900">${course.enrollmentCount}</div>
                                        <div class="text-[10px] text-slate-400">Assignments</div>
                                    </div>
                                    <div class="bg-slate-50 rounded-lg py-2">
                                        <div class="text-sm font-semibold text-slate-900">${course.quizCount}</div>
                                        <div class="text-[10px] text-slate-400">Quizzes</div>
                                    </div>
                                </div>
                            </div>

                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>

            <%-- Pending submissions --%>
            <div>
                <div class="flex items-center justify-between mb-4">
                    <h2 class="text-sm font-semibold text-slate-700">
                        Pending submissions
                        <c:if test="${pending_mark > 0}">
                            <span class="ml-1.5 text-xs px-2 py-0.5 rounded-full bg-amber-100 text-amber-700">${pending_mark}</span>
                        </c:if>
                    </h2>
                    <a href="assignment" class="text-xs text-slate-400 hover:text-slate-700 transition">View all →</a>
                </div>

                <c:choose>
                    <c:when test="${empty pending_submissions}">
                        <div class="bg-white border border-slate-100 rounded-xl px-5 py-8 text-center">
                            <p class="text-sm text-slate-400">All submissions have been marked! 🎉</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="flex flex-col gap-2">
                            <c:forEach var="sub" items="${pending_submissions}">
                                <div class="bg-white border border-slate-100 rounded-xl px-4 py-3 flex items-center gap-4
                                            hover:border-amber-200 hover:bg-amber-50 transition cursor-pointer group"
                                     onclick="location.href='assignment?submission_id=${sub.id}'">
                                    <%-- Student avatar --%>
                                    <div class="w-8 h-8 rounded-full bg-slate-100 text-slate-600
                                                flex items-center justify-center text-xs font-semibold">
                                        ${sub.initials}
                                    </div>
                                    <div class="flex-1 min-w-0">
                                        <div class="text-sm font-medium text-slate-900 truncate">${fn:escapeXml(sub.studentName)}</div>
                                        <div class="text-xs text-slate-400 truncate">
                                            ${fn:escapeXml(sub.assignmentTitle)} · ${fn:escapeXml(sub.courseName)}
                                        </div>
                                    </div>
                                    <div class="text-right flex-shrink-0">
                                        <div class="text-xs text-slate-400">
                                            ${sub.timeAgo}
                                        </div>
                                        <div class="text-xs text-amber-600 font-medium mt-0.5">Ungraded</div>
                                    </div>
                                    <svg class="w-4 h-4 text-slate-300 group-hover:text-amber-400 transition flex-shrink-0"
                                         fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 5l7 7-7 7"/>
                                    </svg>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <%-- Right column --%>
        <div class="flex flex-col gap-6">

            <%-- Quick actions --%>
            <div>
                <h2 class="text-sm font-semibold text-slate-700 mb-3">Quick actions</h2>
                <div class="flex flex-col gap-2">
                    <a href="note?new=1"
                       class="flex items-center gap-3 bg-white border border-slate-100 rounded-xl px-4 py-3
                              hover:border-slate-200 hover:shadow-sm transition group">
                        <div class="w-8 h-8 rounded-lg bg-blue-50 text-blue-600 flex items-center justify-center flex-shrink-0">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                      d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12"/>
                            </svg>
                        </div>
                        <div>
                            <div class="text-sm font-medium text-slate-900">Upload note</div>
                            <div class="text-xs text-slate-400">PDF or video</div>
                        </div>
                        <svg class="w-4 h-4 text-slate-300 ml-auto group-hover:text-slate-500 transition"
                             fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 5l7 7-7 7"/>
                        </svg>
                    </a>
                    <a href="assignment?new=1"
                       class="flex items-center gap-3 bg-white border border-slate-100 rounded-xl px-4 py-3
                              hover:border-slate-200 hover:shadow-sm transition group">
                        <div class="w-8 h-8 rounded-lg bg-amber-50 text-amber-600 flex items-center justify-center flex-shrink-0">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                      d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
                            </svg>
                        </div>
                        <div>
                            <div class="text-sm font-medium text-slate-900">Create assignment</div>
                            <div class="text-xs text-slate-400">Set title, due date, marks</div>
                        </div>
                        <svg class="w-4 h-4 text-slate-300 ml-auto group-hover:text-slate-500 transition"
                             fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 5l7 7-7 7"/>
                        </svg>
                    </a>
                    <a href="quiz?new=1"
                       class="flex items-center gap-3 bg-white border border-slate-100 rounded-xl px-4 py-3
                              hover:border-slate-200 hover:shadow-sm transition group">
                        <div class="w-8 h-8 rounded-lg bg-indigo-50 text-indigo-600 flex items-center justify-center flex-shrink-0">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                      d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"/>
                            </svg>
                        </div>
                        <div>
                            <div class="text-sm font-medium text-slate-900">Create quiz</div>
                            <div class="text-xs text-slate-400">Add questions & code</div>
                        </div>
                        <svg class="w-4 h-4 text-slate-300 ml-auto group-hover:text-slate-500 transition"
                             fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 5l7 7-7 7"/>
                        </svg>
                    </a>
                </div>
            </div>

            <%-- Recent quiz results --%>
            <div>
                <div class="flex items-center justify-between mb-3">
                    <h2 class="text-sm font-semibold text-slate-700">Recent quiz results</h2>
                    <a href="quiz" class="text-xs text-slate-400 hover:text-slate-700 transition">View all →</a>
                </div>
                <c:choose>
                    <c:when test="${empty recent_attempts}">
                        <div class="bg-white border border-slate-100 rounded-xl px-4 py-6 text-center">
                            <p class="text-xs text-slate-400">No quiz attempts yet.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="flex flex-col gap-2">
                            <c:forEach var="attempt" items="${recent_attempts}">
                                <div class="bg-white border border-slate-100 rounded-xl px-4 py-3 flex items-center gap-3">

                                    <div class="w-7 h-7 rounded-full bg-slate-100 text-slate-600
                                                flex items-center justify-center text-[10px] font-semibold">
                                        ${attempt.initials}
                                    </div>

                                    <div class="flex-1 min-w-0">
                                        <div class="text-xs font-medium text-slate-900">
                                            ${attempt.studentName}
                                        </div>

                                        <div class="text-[10px] text-slate-400">
                                            ${attempt.quizTitle}
                                        </div>
                                    </div>

                                    <div class="text-right">
                                        <div class="text-sm font-semibold ${attempt.percentageColor}">
                                            ${attempt.percentage}%
                                        </div>

                                        <div class="text-[10px] text-slate-400">
                                            ${attempt.score}/${attempt.totalQuestions}
                                        </div>
                                    </div>

                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <%-- Recent forum activity --%>
            

        </div>
    </div>
</main>

</body>
<script>
    const sidebar = document.getElementById('sidebar');
    const overlay = document.getElementById('sidebar-overlay');
    const toggle  = document.getElementById('menu-toggle');
    function openSidebar() { sidebar.classList.remove('-translate-x-full'); overlay.classList.remove('hidden'); }
    function closeSidebar() { sidebar.classList.add('-translate-x-full'); overlay.classList.add('hidden'); }
    if (toggle) toggle.addEventListener('click', () => { sidebar.classList.contains('-translate-x-full') ? openSidebar() : closeSidebar(); });
    if (overlay) overlay.addEventListener('click', closeSidebar);
</script>
</html>