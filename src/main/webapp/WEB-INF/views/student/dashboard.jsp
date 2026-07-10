<%-- 
    Document   : dashboard
    Created on : 23 Jun 2026, 5:40:57 pm
    Author     : User
--%>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dashboard - MyStudyZone</title>
        
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
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-semibold bg-indigo-50 text-indigo-700 transition">
                    <i class="fa-solid fa-gauge-high w-4 text-center"></i>
                    Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/enrollment"
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-500 hover:bg-slate-50 hover:text-slate-900 transition">
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
            <div class="mb-8">
                <h1 class="text-2xl font-bold text-slate-900 tracking-tight">
                    ${greeting}, ${sessionScope.userName}!
                </h1>

                <p class="text-sm text-slate-400 mt-1.5 flex items-center gap-1.5">
                    <i class="fa-regular fa-calendar text-slate-300"></i>
                    Here's what's happening today — ${today}
                </p>
            </div>

            <!-- Stat cards -->
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-10">

                <div class="bg-white border border-slate-100 rounded-2xl p-5 shadow-sm hover:shadow-md transition">
                    <div class="flex items-center justify-between mb-3">
                        <p class="text-xs font-medium text-slate-400 uppercase tracking-wide">Enrolled courses</p>
                        <div class="w-9 h-9 rounded-xl bg-indigo-50 text-indigo-600 flex items-center justify-center">
                            <i class="fa-solid fa-book-open text-sm"></i>
                        </div>
                    </div>
                    <p class="text-3xl font-bold text-slate-900">${enrolCourseCount}</p>
                    <p class="text-xs text-slate-400 mt-1">active this semester</p>
                </div>

                <div class="bg-white border border-slate-100 rounded-2xl p-5 shadow-sm hover:shadow-md transition">
                    <div class="flex items-center justify-between mb-3">
                        <p class="text-xs font-medium text-slate-400 uppercase tracking-wide">Assignments due</p>
                        <div class="w-9 h-9 rounded-xl flex items-center justify-center
                                    ${overDueCount > 0 ? 'bg-red-50 text-red-500' : 'bg-emerald-50 text-emerald-600'}">
                            <i class="fa-solid fa-file-lines text-sm"></i>
                        </div>
                    </div>

                    <p class="text-3xl font-bold ${overDueCount > 0 ? 'text-red-500' : 'text-slate-900'}">
                        ${totalAsgnCount + overDueCount}
                    </p>

                    <p class="text-xs mt-1 ${overDueCount > 0 ? 'text-red-400 font-medium' : 'text-slate-400'}">
                        ${overDueCount} overdue
                    </p>
                </div>

                <div class="bg-white border border-slate-100 rounded-2xl p-5 shadow-sm hover:shadow-md transition">
                    <div class="flex items-center justify-between mb-3">
                        <p class="text-xs font-medium text-slate-400 uppercase tracking-wide">Quizzes pending</p>
                        <div class="w-9 h-9 rounded-xl bg-amber-50 text-amber-600 flex items-center justify-center">
                            <i class="fa-solid fa-square-poll-vertical text-sm"></i>
                        </div>
                    </div>
                    <p class="text-3xl font-bold text-slate-900">${avlQuizCount}</p>
                    <p class="text-xs text-slate-400 mt-1">not yet attempted</p>
                </div>

                <div class="bg-white border border-slate-100 rounded-2xl p-5 shadow-sm hover:shadow-md transition">
                    <div class="flex items-center justify-between mb-3">
                        <p class="text-xs font-medium text-slate-400 uppercase tracking-wide">Avg. quiz score</p>
                        <div class="w-9 h-9 rounded-xl bg-violet-50 text-violet-600 flex items-center justify-center">
                            <i class="fa-solid fa-chart-line text-sm"></i>
                        </div>
                    </div>
                    <p class="text-3xl font-bold text-slate-900">${avgCount}%</p>
                    <p class="text-xs text-slate-400 mt-1">across all quizzes</p>
                </div>

            </div>

            <!-- Two column layout -->
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">

                <!-- My courses -->
                <div>
                    <div class="flex items-center justify-between mb-4">
                        <h2 class="text-sm font-bold text-slate-700 uppercase tracking-wide">My courses</h2>
                        <a href="${pageContext.request.contextPath}/course" class="text-xs font-medium text-indigo-600 hover:text-indigo-800 transition flex items-center gap-1">
                            View all <i class="fa-solid fa-arrow-right text-[10px]"></i>
                        </a>
                    </div>

                    <c:choose>

                        <c:when test="${empty enrolledCourses}">
                            <div class="bg-white border border-dashed border-slate-200 rounded-2xl p-10 text-center">
                                <div class="w-12 h-12 rounded-full bg-slate-50 text-slate-300 flex items-center justify-center mx-auto mb-3">
                                    <i class="fa-solid fa-book-open text-lg"></i>
                                </div>
                                <p class="text-sm text-slate-400">
                                    You haven't enrolled in any courses yet.
                                </p>

                                <a href="enrollment"
                                   class="inline-flex items-center gap-1.5 mt-3 text-sm font-medium text-emerald-600 hover:text-emerald-700 transition">
                                    Browse courses <i class="fa-solid fa-arrow-right text-xs"></i>
                                </a>
                            </div>
                        </c:when>

                        <c:otherwise>

                            <div class="grid grid-cols-1 gap-3">

                                <c:forEach var="course" items="${enrolledCourses}" varStatus="status">

                                    <c:set var="palette" value="${palettes[status.index % 4]}" />

                                    <div class="bg-white border border-slate-100 rounded-2xl p-4 hover:border-indigo-200 hover:shadow-sm transition cursor-pointer group"
                                         onclick="location.href='course'">

                                        <div class="flex items-center justify-between mb-3">

                                            <span class="text-xs font-semibold px-2.5 py-1 rounded-full ${palette.badge}">
                                                ${course.title}
                                            </span>

                                            <i class="fa-solid fa-chevron-right text-slate-300 group-hover:text-indigo-400 group-hover:translate-x-0.5 transition"></i>

                                        </div>

                                        <div class="text-xs text-slate-400 mb-3 flex items-center gap-3">
                                            <span class="flex items-center gap-1"><i class="fa-regular fa-file-lines"></i> ${course.noteCount} notes</span>
                                            <span class="flex items-center gap-1"><i class="fa-regular fa-clipboard"></i> ${course.assignmentCount} assignments</span>
                                        </div>

                                        <div class="h-1.5 bg-slate-100 rounded-full overflow-hidden">
<!--                                            <div class="h-full rounded-full ${palette.bar}"
                                                 style="width:course.progress%">
                                            </div>-->
                                        </div>

                                    </div>

                                </c:forEach>

                            </div>

                        </c:otherwise>

                    </c:choose>
                </div>

                <!-- Upcoming Tasks -->
                <div>
                    <div class="flex items-center justify-between mb-4">
                        <h2 class="text-sm font-bold text-slate-700 uppercase tracking-wide">Upcoming Tasks</h2>
                        <a href="${pageContext.request.contextPath}/assignment" class="text-xs font-medium text-indigo-600 hover:text-indigo-800 transition flex items-center gap-1">
                            View all <i class="fa-solid fa-arrow-right text-[10px]"></i>
                        </a>
                    </div>

                    <c:choose>

                        <c:when test="${empty tasks}">
                            <div class="bg-white border border-dashed border-slate-200 rounded-2xl p-10 text-center">
                                <div class="w-12 h-12 rounded-full bg-emerald-50 text-emerald-400 flex items-center justify-center mx-auto mb-3">
                                    <i class="fa-solid fa-check text-lg"></i>
                                </div>
                                <p class="text-sm text-slate-400">
                                    No pending assignments. You're all caught up! 🎉
                                </p>
                            </div>
                        </c:when>

                        <c:otherwise>

                            <div class="flex flex-col gap-3">

                                <c:forEach var="task" items="${tasks}">

                                    <div class="bg-white border border-slate-100 rounded-2xl px-4 py-3.5 flex items-center gap-4
                                                hover:border-indigo-200 hover:shadow-sm transition cursor-pointer"
                                         onclick="location.href='assignment'">

                                        <div class="w-2.5 h-2.5 rounded-full flex-shrink-0
                                            ${task.status == 'overdue' ? 'bg-red-400'
                                                : task.status == 'soon' ? 'bg-amber-400'
                                                : 'bg-emerald-400'}">
                                        </div>

                                        <div class="flex-1 min-w-0">

                                            <div class="text-sm font-medium text-slate-900 truncate">
                                                ${task.title}
                                            </div>

                                            <div class="text-xs text-slate-400 truncate mt-0.5">
                                                ${task.courseName} · ${task.lecturerName}
                                            </div>

                                        </div>

                                        <div class="text-xs flex-shrink-0">

                                            <c:choose>

                                                <c:when test="${task.status == 'overdue'}">
                                                    <span class="px-2.5 py-1 rounded-full bg-red-50 text-red-500 font-semibold">Overdue</span>
                                                </c:when>

                                                <c:when test="${task.status == 'soon'}">
                                                    <span class="px-2.5 py-1 rounded-full bg-amber-50 text-amber-600 font-medium">${task.dueDate}</span>
                                                </c:when>

                                                <c:otherwise>
                                                    <span class="px-2.5 py-1 rounded-full bg-slate-50 text-slate-400 font-medium">${task.dueDate}</span>
                                                </c:otherwise>

                                            </c:choose>

                                        </div>

                                    </div>

                                </c:forEach>

                            </div>

                        </c:otherwise>

                    </c:choose>
                </div>

            </div>
        </main>

        <script>
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
