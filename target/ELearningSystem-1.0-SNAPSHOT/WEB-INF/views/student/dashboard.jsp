<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!--Core tag   c:remove, c:if , c:choose, c:forEach  -->
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<!--Function  	fn:length() , -->
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions" %> 

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MyStudyZone - Student Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 min-h-screen">
    <div class="flex min-h-screen">
        <aside class="w-52 bg-white border-r flex flex-col py-5 fixed h-full">

            <!--Sidebar kiri-->
            <div class="px-4 mb-6">
                <span class="text-base font-semibold text-gray-900">MyStudyZone</span>
                <span class="block text-xs text-gray-400 mt-0.5">E-Learning System</span>
            </div>
            <nav class="flex flex-col gap-0.5 flex-1">
                <a href="${pageContext.request.contextPath}/dashboard"
                   class="flex items-center gap-2.5 px-4 py-2.5 text-sm font-medium bg-gray-50 text-gray-900 rounded-none">
                    Dashboard
                </a>
                   <a href="${pageContext.request.contextPath}/course"
                   class="flex items-center gap-2.5 px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50 hover:text-gray-900">
                    My Courses
                </a>
                <a href="${pageContext.request.contextPath}/note"
                   class="flex items-center gap-2.5 px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50 hover:text-gray-900">
                    Notes
                </a>
                <a href="${pageContext.request.contextPath}/assignment"
                   class="flex items-center gap-2.5 px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50 hover:text-gray-900">
                    Assignments
                </a>
                <a href="${pageContext.request.contextPath}/quiz"
                   class="flex items-center gap-2.5 px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50 hover:text-gray-900">
                    Quiz
                </a>
                <a href="${pageContext.request.contextPath}/discussion"
                   class="flex items-center gap-2.5 px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50 hover:text-gray-900">
                    Discussion
                </a>
            </nav>
            <a href="${pageContext.request.contextPath}/logout"
               class="px-4 py-2.5 text-sm text-red-500 hover:bg-red-50 mt-auto">
                Logout
            </a>
        </aside>

        <!--Kanan-->
        <main class="ml-52 flex-1 p-6">
            <div class="flex justify-between mb-6 items-center">
                <h1 class="text-lg font-semibold text-gray-900">Dashboard</h1>
                <span class="text-sm text-gray-500">Welcome, <strong>${sessionScope.userName}</strong></span>   
            </div>
            
            <!--3 Kotak-->
            <div class="grid grid-cols-3 gap-4 mb-6">
                <div class="bg-white rounded-xl border border-gray-100 p-4">
                    <p class="text-xs text-gray-400 mb-1">Enrolled courses</p>
                    <p class="text-2xl font-semibold text-gray-900">${fn:length(enrolledCourses)}</p>
                </div>
                
                <div class="bg-white rounded-xl border border-gray-100 p-4">
                    <p class="text-xs text-gray-400 mb-1">Pending assignments</p>
                    <p class="text-2xl font-semibold text-gray-900">${fn:length(upcomingAssignments)}</p>
                </div>
                
                <div class="bg-white rounded-xl border border-gray-100 p-4">
                    <p class="text-xs text-gray-400 mb-1">Quizzes taken</p>
                    <p class="text-2xl font-semibold text-gray-900">${fn:length(recentQuizScores)}</p>
                </div>
            </div>
            
            <!--2 kotak bawah-->
            <div class="grid grid-cols-2 gap-6">        
                <div class="bg-white rounded-xl border border-gray-100 p-5">
                    <h2 class="text-xs font-semibold text-gray-400 mb-4">UPCOMING DEADLINES</h2>
                    <c:choose>
                        <c:when test="${empty upcomingAssignments}">  <!-- Kalau array upcomingAssignments kosong -->
                            <p class="text-sm text-gray-400">No pending assignments.</p>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="a" items="${upcomingAssignments}">
                                <div class="flex items-start justify-between py-3 border-b border-gray-50 last:border-0">
                                <div>
                                    <p class="text-sm font-medium text-gray-900">${a.title}</p>
                                    <p class="text-xs text-gray-400 mt-0.5">${a.courseName}</p>
                                </div>
                                <span class="text-xs bg-red-50 text-red-600 px-2 py-1 rounded-full font-medium whitespace-nowrap ml-3">
                                    ${a.dueDate}
                                </span>
                            </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <div class="bg-white rounded-xl border border-gray-100 p-5">
                <h2 class="text-xs font-semibold text-gray-400  mb-4">RECENT QUIZ SCORES</h2>
                <c:choose>
                    <c:when test="${empty recentQuizScores}">
                        <p class="text-sm text-gray-400">No quiz scores yet.</p>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="q" items="${recentQuizScores}">
                            <div class="flex items-center justify-between py-3 border-b border-gray-50 last:border-0">
                                <div>
                                    <p class="text-sm font-medium text-gray-900">${q.title}</p>
                                    <p class="text-xs text-gray-400 mt-0.5">${q.course_title}</p>
                                </div>
                                <span class="text-sm font-semibold text-indigo-600">${q.score}</span>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
                
            </div>
            
                <!--a1 card enrol course, kalau tak empty retrieve arraylist data guna forloop -->
            <div class="bg-white rounded-xl border border-gray-100 p-5 mt-6">
            <h2 class="text-xs font-semibold text-gray-400 mb-4">ENROLLED COURSES</h2>
            <c:choose>
                <c:when test="${empty enrolledCourses}"> <!-- Kalau array enrolledCourses kosong -->
                    <p class="text-sm text-gray-400">You are not enrolled in any courses yet.
                        <a href="${pageContext.request.contextPath}/course" class="text-indigo-600 hover:underline">Browse courses</a>
                    </p>
                </c:when>
                <c:otherwise>
                    <div class="grid grid-cols-2 gap-4">
                        <c:forEach var="c" items="${enrolledCourses}">
                            <a href="${pageContext.request.contextPath}/course?id=${c.id}"
                               class="border border-gray-100 rounded-xl p-4 hover:bg-gray-50 transition-colors">
                                <p class="text-sm font-medium text-gray-900">${c.title}</p>
                            </a>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
                
        </main>
    </div>
</body>