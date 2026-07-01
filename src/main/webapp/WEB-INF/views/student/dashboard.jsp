<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!--Core tag   c:remove, c:if , c:choose, c:forEach  -->
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<!--Function  	fn:length() , -->
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions" %> 


<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Dashboard - MyStudyZone</title>
        
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css"/>
        
    </head>
    <body class="bg-gray-50 text-gray-900">
        <aside class="w-52 bg-white border-r border-gray-100 flex flex-col py-5 fixed h-full">
            <div class="px-4 mb-6">
                <span class="text-base font-semibold text-gray-900">MyStudyZone</span>
                <span class="block text-xs text-gray-400 mt-0.5">E-Learning System</span>
            </div>
            <nav class="flex flex-col gap-0.5 flex-1">
                <a href="${pageContext.request.contextPath}/dashboard"
                   class="px-4 py-2.5 text-sm font-medium bg-gray-50 text-gray-900">Dashboard</a>
                <a href="${pageContext.request.contextPath}/enrollment"
                   class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">Enroll</a>
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
            <div class="mb-8">
                <h1 class="text-xl font-semibold text-gray-900">
                    ${greeting}, ${studentName}!
                </h1>

                <p class="text-sm text-gray-400 mt-1">
                    Here's what's happening today — ${today}
                </p>
            </div>

            <!-- Stat cards -->
            <div class="grid grid-cols-4 gap-4 mb-8">
                
                <div class="bg-white border border-gray-100 rounded-xl p-5">
                    <p class="text-xs text-gray-400 mb-2">Enrolled courses</p>
                    <p class="text-3xl font-semibold text-gray-900">${enrolCourseCount}</p>
                    <p class="text-xs text-gray-400 mt-1">active this semester</p>
                </div>

                <div class="bg-white border border-gray-100 rounded-xl p-5">
                    <p class="text-xs text-gray-400 mb-2">Assignments due</p>

                    <p class="text-3xl font-semibold ${overDueCount > 0 ? 'text-red-500' : 'text-gray-900'}">
                        ${totalAsgnCount + overDueCount}
                    </p>

                    <p class="text-xs text-gray-400 mt-1">
                        ${overDueCount} overdue
                    </p>
                </div>

                <div class="bg-white border border-gray-100 rounded-xl p-5">
                    <p class="text-xs text-gray-400 mb-2">Quizzes pending</p>
                    <p class="text-3xl font-semibold text-gray-900">${avlQuizCount}</p>
                    <p class="text-xs text-gray-400 mt-1">not yet attempted</p>
                </div>

                <div class="bg-white border border-gray-100 rounded-xl p-5">
                    <p class="text-xs text-gray-400 mb-2">Avg. quiz score</p>
                    <p class="text-3xl font-semibold text-gray-900">${avgCount}%</p>
                    <p class="text-xs text-gray-400 mt-1">across all quizzes</p>
                </div>

            </div>

            <!-- Two column layout -->
            <div class="grid grid-cols-2 gap-6">

                <!-- My courses -->
                <div>
                    <div class="flex items-center justify-between mb-4">
                        <h2 class="text-sm font-semibold text-gray-700">My courses</h2>
                        <a href="courses.php" class="text-xs text-gray-400 hover:text-gray-700 transition">View all →</a>
                    </div>

                    <c:choose>
                        <c:when test="${empty enrolledCourses}">
                            <div class="bg-white border border-gray-100 rounded-xl p-8 text-center">
                                <p class="text-sm text-gray-400">
                                    You haven't enrolled in any courses yet.
                                </p>

                                <a href="EnrollmentController"
                                   class="inline-block mt-3 text-sm text-emerald-600 hover:underline">
                                    Browse courses →
                                </a>
                            </div>
                        </c:when>

                        <c:otherwise>
                            <div class="grid grid-cols-1 gap-3">
                                <c:forEach var="course" items="${enrolledCourses}" varStatus="status">
                                    <c:set var="palette" value="${palettes[status.index % 4]}" />
                                    <div class="bg-white border border-gray-100 rounded-xl p-4 hover:border-gray-200 transition cursor-pointer"
                                         onclick="location.href='course'">
                                        <div class="flex items-center justify-between mb-3">
                                            <span class="text-xs font-medium px-2.5 py-1 rounded-full ${palette.badge}">
                                                ${course.title}
                                            </span>
                                        </div>

                                        <div class="text-xs text-gray-400 mb-3">
                                            ${course.noteCount} notes ·
                                            ${course.assignmentCount} assignments
                                        </div>

                                        <div class="h-1 bg-gray-100 rounded-full overflow-hidden">
                                        <!--<div class="h-full rounded-full ${palette.bar}"
                                                 style="width:course.progress%">
                                            </div>-->
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Upcoming tasks -->
                <div>
                    <div class="flex items-center justify-between mb-4">
                        <h2 class="text-sm font-semibold text-gray-700">Upcoming tasks</h2>
                        <a href="assignments.php" class="text-xs text-gray-400 hover:text-gray-700 transition">View all →</a>
                    </div>

                    <c:choose>
                        <c:when test="${empty tasks}">
                            <div class="bg-white border border-gray-100 rounded-xl p-8 text-center">
                                <p class="text-sm text-gray-400">
                                    No pending assignments. You're all caught up! 🎉
                                </p>
                            </div>
                        </c:when>

                        <c:otherwise>

                            <div class="flex flex-col gap-3">

                                <c:forEach var="task" items="${tasks}">
                                    <div class="bg-white border border-gray-100 rounded-xl px-4 py-3 flex items-center gap-4
                                                hover:border-gray-200 transition cursor-pointer"
                                         onclick="location.href='AssignmentController'">
                                        <div class="w-2 h-2 rounded-full flex-shrink-0
                                            ${task.urgency == 'overdue' ? 'bg-red-400'
                                                : task.urgency == 'soon' ? 'bg-amber-400'
                                                : 'bg-emerald-400'}">
                                        </div>
                                        <div class="flex-1 min-w-0">
                                            <div class="text-sm text-gray-900 truncate">
                                                ${task.title}
                                            </div>

                                            <div class="text-xs text-gray-400 truncate">
                                                ${task.courseTitle} · ${task.lecturerName}
                                            </div>
                                        </div>

                                        <div class="text-xs flex-shrink-0">
                                            <c:choose>
                                                <c:when test="${task.urgency == 'overdue'}">
                                                    <span class="text-red-500 font-medium">Overdue</span>
                                                </c:when>

                                                <c:when test="${task.urgency == 'soon'}">
                                                    <span class="text-amber-600">${task.dueDate}</span>
                                                </c:when>

                                                <c:otherwise>
                                                    <span class="text-gray-400">${task.dueDate}</span>
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
    </body>
</html>