<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!--Core tag   c:remove, c:if , c:choose, c:forEach  -->
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<!--Function  	fn:length() , -->
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions" %> 

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>MyStudyZone - Lecturer Dashboard</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-50 min-h-screen">
        <div class="flex min-h-screen">
            <!--Sidebar kiri-->
            <aside class="w-52 bg-white border-r border-gray-100 flex flex-col py-5 fixed h-full">
                <div class="px-4 mb-6">
                    <span class="text-base font-semibold text-gray-900">MyStudyZone</span>
                    <span class="block text-xs text-gray-400 mt-0.5">E-Learning System</span>
                </div>
                <nav class="flex flex-col gap-0.5 flex-1">
                    <a href="${pageContext.request.contextPath}/dashboard"
                       class="px-4 py-2.5 text-sm font-medium bg-gray-50 text-gray-900">Dashboard</a>
                    <a href="${pageContext.request.contextPath}/course"
                       class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">My Courses</a>
                    <a href="${pageContext.request.contextPath}/note"
                       class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">Notes</a>
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
            
            <!--Kanan-->
            <main class="ml-52 flex-1 p-6">
                <div class="flex items-center justify-between mb-6">
                    <h1 class="text-lg font-semibold text-gray-900">Dashboard</h1>
                    <span class="text-sm text-gray-500">Welcome, <strong>${sessionScope.userName}</strong></span>
                </div>

                <%-- 2 Kotak  Stats--%>
                <div class="grid grid-cols-2 gap-4 mb-6">
                    <div class="bg-white rounded-xl border border-gray-100 p-4">
                        <p class="text-xs text-gray-400 mb-1">Courses assigned</p>
                        <p class="text-2xl font-semibold text-gray-900">${fn:length(myCourses)}</p>
                    </div>
                    <div class="bg-white rounded-xl border border-gray-100 p-4">
                        <p class="text-xs text-gray-400 mb-1">Pending to mark</p>
                        <p class="text-2xl font-semibold text-gray-900">${fn:length(pendingSubmissions)}</p>
                    </div>
                </div>

                <div class="grid grid-cols-2 gap-6">
                    <%-- My courses --%>
                    <div class="bg-white rounded-xl border border-gray-100 p-5">
                        <h2 class="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-4">My Courses</h2>
                        <c:choose>
                            <c:when test="${empty myCourses}">
                                <p class="text-sm text-gray-400">No courses available.</p>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="c" items="${myCourses}">
                                    <div class="py-3 border-b border-gray-50 last:border-0">
                                        <p class="text-sm font-medium text-gray-900">${c.title}</p>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <%-- Pending submissions to mark --%>
                    <div class="bg-white rounded-xl border border-gray-100 p-5">
                        <h2 class="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-4">Pending Submissions</h2>
                        <c:choose>
                            <c:when test="${empty pendingSubmissions}">
                                <p class="text-sm text-gray-400">No submissions to mark.</p>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="s" items="${pendingSubmissions}">
                                    <div class="flex items-start justify-between py-3 border-b border-gray-50 last:border-0">
                                        <div>
                                            <p class="text-sm font-medium text-gray-900">${s.studentName}</p>
                                            <p class="text-xs text-gray-400 mt-0.5">${s.assignmentTitle} &nbsp;·&nbsp; ${s.courseName}</p>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/assignment?viewSubmissions=${s.id}"
                                           class="text-xs bg-indigo-50 text-indigo-600 px-3 py-1 rounded-full font-medium ml-3 whitespace-nowrap hover:bg-indigo-100">
                                            Mark
                                        </a>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </main>
        </div>
    </body>
</html>
