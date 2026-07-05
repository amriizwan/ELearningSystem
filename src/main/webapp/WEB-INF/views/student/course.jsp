<%-- 
    Document   : courses
    Created on : 23 Jun 2026, 5:41:15 pm
    Author     : User
--%>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
        <title>My Course - MyStudyZone</title>
        
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

        <!-- Sidebar -->
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
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-500 hover:bg-slate-50 hover:text-slate-900 transition">
                    <i class="fa-solid fa-pen-to-square w-4 text-center"></i>
                    Enroll
                </a>
                <a href="${pageContext.request.contextPath}/course"
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-semibold bg-indigo-50 text-indigo-700 transition">
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
               
        <main class="lg:ml-64 min-h-screen flex flex-col lg:flex-row">
             <!-- ── LEFT PANEL: Course list ── -->
            <div class="w-full lg:w-80 bg-white border-r border-slate-100 flex flex-col lg:min-h-screen flex-shrink-0">
                <div class="px-5 py-5 border-b border-slate-100">
                    <h1 class="text-base font-bold text-slate-900">My Courses</h1>
                    <p class="text-xs text-slate-400 mt-0.5">
                        ${fn:length(enrolledCourses)} enrolled
                    </p>
                </div>

                <!-- Search -->
                <div class="px-4 py-3 border-b border-slate-100">
                    <div class="relative">
                        <svg class="absolute left-3 top-1/2 -translate-y-1/2 w-3.5 h-3.5 text-slate-400"
                             fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <circle cx="11" cy="11" r="7"/><path stroke-linecap="round" d="M21 21l-4.35-4.35"/>
                        </svg>
                        <input type="text" id="course-search" placeholder="Search courses..."
                               oninput="searchCourses(this.value)"
                               class="w-full pl-8 pr-3 py-2.5 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-indigo-100 focus:border-indigo-400 bg-slate-50 transition"/>
                    </div>
                </div>

                <!-- Course list -->
                <c:set var="selectedCourse" value="${null}" />
                <div class="flex-1 overflow-y-auto py-2 max-h-[70vh] lg:max-h-none" id="course-list">
                    <c:choose>
                        <c:when test="${empty enrolledCourses}">
                            <div class="px-5 py-10 text-center">
                                <p class="text-xs text-slate-400">No enrolled courses.</p>
                                <a href="course" class="text-xs text-emerald-600 hover:underline mt-1 inline-block">Browse courses →</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="course" items="${enrolledCourses}" varStatus="status">
                                <c:set var="palette" value="${palettes[status.index % fn:length(palettes)]}" />

                                <a href="course?id=${course.id}"
                                    class="course-item flex items-start gap-3 px-4 py-3.5 transition border-l-2 cursor-pointer
                                           ${course.id == selected_courseId ? 'bg-indigo-50 border-indigo-600' : 'border-transparent hover:bg-slate-50 hover:border-slate-200'}"
                                    data-title="${course.title}">
                                     <div class="w-9 h-9 rounded-xl flex items-center justify-center flex-shrink-0 ${palette.icon}">
                                         <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                             <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                                   d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/>
                                         </svg>
                                     </div>
                                     <div class="flex-1 min-w-0">
                                         <div class="text-sm font-semibold text-slate-900 leading-snug truncate">
                                            ${course.title}
                                         </div>
                                         <div class="text-xs text-slate-400 mt-0.5">
                                            ${course.noteCount} notes · ${course.assignmentCount} assignments
                                         </div>
                                     </div>
                                 </a>
                                <c:if test="${course.id == selected_courseId}">
                                    <c:set var="selectedCourse" value="${course}" />
                                </c:if>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- ── RIGHT PANEL: Course detail ── -->
            <div class="flex-1 overflow-y-auto">
                <c:choose>
                    <c:when test="${empty selectedCourse}">
                        <div class="flex items-center justify-center h-96 lg:h-full">
                            <div class="text-center">
                                <div class="w-14 h-14 rounded-full bg-slate-100 text-slate-300 flex items-center justify-center mx-auto mb-3">
                                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.2"
                                              d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/>
                                    </svg>
                                </div>
                                <p class="text-sm text-slate-400">Select a course to view its content</p>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Course header -->
                        <div class="bg-white border-b border-slate-100 px-6 sm:px-8 py-5">
                            <div class="flex flex-col sm:flex-row sm:items-start justify-between gap-3">
                                <div>
                                    <h2 class="text-lg font-bold text-slate-900">${selectedCourse.title}</h2>
                                    <c:if test="${not empty selectedCourse.description}">
                                        <p class="text-sm text-slate-400 mt-1">${selectedCourse.description}</p>
                                    </c:if>
                                    <div class="flex flex-wrap gap-x-4 gap-y-1 mt-3 text-xs text-slate-400">
                                        <span class="flex items-center gap-1"><i class="fa-regular fa-file-lines"></i> ${selectedCourse.noteCount} notes</span>
                                        <span class="flex items-center gap-1"><i class="fa-regular fa-clipboard"></i> ${selectedCourse.assignmentCount} assignments</span>
                                        <span class="flex items-center gap-1"><i class="fa-solid fa-square-poll-vertical"></i> ${selectedCourse.quizCount} quizzes</span>
                                    </div>
                                </div>
                                <a href="enrollment" class="text-xs font-medium text-slate-400 hover:text-red-500 transition border border-slate-200 px-3.5 py-2 rounded-xl hover:border-red-200 hover:bg-red-50 flex-shrink-0 text-center">
                                    Unenroll
                                </a>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
                    
                <div class="p-6 sm:p-8">
                    <!-- Lecturer selector -->
                    <c:set var="selectedLecturer" value="${null}" />
                    <div class="mb-8">
                        <h3 class="text-xs font-bold text-slate-400 uppercase tracking-wide mb-3">Choose lecturer</h3>
                        <c:choose>
                            <c:when test="${empty lectCourse}">
                                <p class="text-sm text-slate-400">No lecturers assigned to this course yet.</p>
                            </c:when>
                            <c:otherwise>
                                <div class="flex flex-wrap gap-2">
                                    <c:forEach var="lect" items="${lectCourse}" varStatus="status">
                                        
                                        <c:set var="palette" value="${palettes[status.index % fn:length(palettes)]}" />
                                        <c:set var="lectActive" value="${lect.lectId == selected_lecturerId ? 'selected_lecturerId' : ''}" />

                                        <a href="course?id=${selected_courseId}&lecturerId=${lect.lectId}"
                                            class="flex items-center gap-2.5 px-4 py-2.5 rounded-xl border text-sm transition
                                                   ${not empty lectActive ? 'border-indigo-600 bg-indigo-600 text-white shadow-sm shadow-indigo-200' : 'border-slate-200 bg-white text-slate-600 hover:border-indigo-300 hover:bg-indigo-50/40'}">
                                            <div class="w-7 h-7 rounded-full flex items-center justify-center text-xs font-semibold flex-shrink-0
                                                   ${not empty lectActive ? 'bg-white/20 text-white' : palette.info}">
                                                ${lect.initials}
                                            </div>
                                            <div>
                                                <div class="font-medium">${lect.lectName}</div>
                                                <div class="text-xs ${not empty lectActive ? 'text-white/70' : 'text-slate-400'}">
                                                    ${lect.noteCount} notes · ${lect.assignmentCount} assignments
                                                </div>
                                            </div>
                                        </a>
                                        <c:if test="${lect.lectId == selected_lecturerId}">
                                            <c:set var="selectedLecturer" value="${lect}" />
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <c:if test="${not empty selectedLecturer}">
                        <!-- Notes section -->
                        <div class="mb-8">
                            <div class="flex items-center justify-between mb-3">
                                <h3 class="text-xs font-bold text-slate-400 uppercase tracking-wide">
                                    Notes — ${selectedLecturer.lectName}
                                </h3>
                                <span class="text-xs text-slate-400">${fn:length(notes)} files</span>
                            </div>

                            <c:choose>
                                <c:when test="${empty notes}">
                                    <div class="bg-white border border-dashed border-slate-200 rounded-2xl px-5 py-8 text-center">
                                        <p class="text-sm text-slate-400">No notes uploaded by this lecturer yet.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="flex flex-col gap-2">
                                        <c:forEach var="note" items="${notes}">
                                            <c:set var="is_pdf" value="${note.type eq 'pdf'}" />
                                            <div class="bg-white border border-slate-100 rounded-2xl px-4 py-3.5 flex items-center gap-4
                                                        hover:border-slate-200 hover:shadow-sm transition group">
                                                <!-- File icon -->
                                                <div class="w-9 h-9 rounded-lg flex items-center justify-center flex-shrink-0
                                                            ${is_pdf ? 'bg-red-50 text-red-500' : 'bg-blue-50 text-blue-500'}">
                                                    <c:choose>
                                                        <c:when test="${is_pdf}">
                                                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                                                      d="M7 21h10a2 2 0 002-2V9l-5-5H7a2 2 0 00-2 2v14a2 2 0 002 2z"/>
                                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M14 3v5h5"/>
                                                            </svg>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                                                      d="M14.752 11.168l-3.197-2.132A1 1 0 0010 9.87v4.263a1 1 0 001.555.832l3.197-2.132a1 1 0 000-1.664z"/>
                                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                                                      d="M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                                            </svg>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <!-- Title + meta -->
                                                <div class="flex-1 min-w-0">
                                                    <div class="text-sm font-medium text-slate-900 truncate">${note.title}</div>
                                                    <div class="text-xs text-slate-400 mt-0.5">
                                                        ${fn:toUpperCase(note.type)} · <fmt:formatDate value="${note.createdAt}" pattern="MMM dd, yyyy" />
                                                    </div>
                                                </div>

                                                <!-- Download/open button -->
                                                <a href="${note.fileUrl}" target="_blank"
                                                   class="opacity-100 sm:opacity-0 group-hover:opacity-100 transition flex items-center gap-1.5 text-xs
                                                          text-slate-500 hover:text-slate-900 border border-slate-200 px-3 py-1.5 rounded-lg flex-shrink-0">
                                                    <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                                              d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"/>
                                                    </svg>
                                                    Open
                                                </a>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Assignments section -->
                        <div>
                            <div class="flex items-center justify-between mb-3">
                                <h3 class="text-xs font-bold text-slate-400 uppercase tracking-wide">
                                    Assignments — ${selectedLecturer.lectName}
                                </h3>

                                <a href="assignment"
                                   class="text-xs font-medium text-indigo-600 hover:text-indigo-800 transition flex items-center gap-1">
                                    View all <i class="fa-solid fa-arrow-right text-[10px]"></i>
                                </a>
                            </div>

                            <c:choose>

                                <c:when test="${empty assignments}">
                                    <div class="bg-white border border-dashed border-slate-200 rounded-2xl px-5 py-8 text-center">
                                        <p class="text-sm text-slate-400">
                                            No assignments from this lecturer yet.
                                        </p>
                                    </div>
                                </c:when>

                                <c:otherwise>
                                    <div class="flex flex-col gap-2">

                                        <c:forEach var="asgn" items="${assignments}">

                                            <div class="bg-white border border-slate-100 rounded-2xl px-4 py-3.5 flex items-center gap-4
                                                        hover:border-slate-200 hover:shadow-sm transition cursor-pointer"
                                                 onclick="location.href='assignment?id=${asgn.id}'">

                                                <!-- Assignment icon -->
                                                <div class="w-9 h-9 rounded-lg bg-amber-50 text-amber-600 flex items-center justify-center flex-shrink-0">
                                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                                              d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"/>
                                                    </svg>
                                                </div>

                                                <div class="flex-1 min-w-0">
                                                    <div class="text-sm font-medium text-slate-900 truncate">
                                                        ${asgn.title}
                                                    </div>

                                                    <div class="text-xs text-slate-400 mt-0.5">
                                                        Due
                                                        <fmt:formatDate value="${asgn.dueDate}" pattern="MMM dd, yyyy"/>

                                                        <c:if test="${asgn.submission.mark != null}">
                                                            · Score:
                                                            <span class="text-violet-600 font-medium">
                                                                ${asgn.submission.mark}/${asgn.maxMark}
                                                            </span>
                                                        </c:if>
                                                    </div>
                                                </div>

                                                <!-- Status badge -->
                                                <span class="text-xs px-2.5 py-1 rounded-full font-medium flex-shrink-0 ${asgn.statusClass}">
                                                    ${asgn.statusText}
                                                </span>

                                            </div>

                                        </c:forEach>

                                    </div>
                                </c:otherwise>

                            </c:choose>
                        </div>
                    </c:if>
                </div>
            </div>
        </main>
               
        <script>
            function searchCourses(val) {
                const q = val.toLowerCase();
                document.querySelectorAll('.course-item').forEach(item => {
                    const title = (item.dataset.title || '').toLowerCase();
                    item.style.display = title.includes(q) ? '' : 'none';
                });
            }

            const sidebar = document.getElementById('sidebar');
            const overlay = document.getElementById('sidebar-overlay');
            const toggle  = document.getElementById('menu-toggle');

            function openSidebar() {
                sidebar.classList.remove('-translate-x-full');
                overlay.classList.remove('hidden');
            }
            function closeSidebar() {
                sidebar.classList.add('-translate-x-full');
                overlay.classList.add('hidden');
            }
            if (toggle) {
                toggle.addEventListener('click', () => {
                    sidebar.classList.contains('-translate-x-full') ? openSidebar() : closeSidebar();
                });
            }
            if (overlay) {
                overlay.addEventListener('click', closeSidebar);
            }
        </script>
    </body>
</html>
