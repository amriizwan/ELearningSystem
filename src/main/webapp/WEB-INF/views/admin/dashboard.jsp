<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!--Core tag   c:remove, c:if , c:choose, c:forEach  -->
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<!--Function  	fn:length() , -->
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions" %> 

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>MyStudyZone - Admin Dashboard</title>
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
                       <!--Guna different servlet-->
                    <a href="${pageContext.request.contextPath}/admin/users"
                       class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">Users</a>
                    <a href="${pageContext.request.contextPath}/course"
                       class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">Courses</a>
                    <a href="${pageContext.request.contextPath}/discussion"
                       class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">Posts</a>
                </nav>
                <a href="${pageContext.request.contextPath}/logout"
                   class="px-4 py-2.5 text-sm text-red-500 hover:bg-red-50 mt-auto">Logout</a>
            </aside>
            <!--Kanan-->
            <main class="ml-52 flex-1 p-6">
                <div class="flex items-center justify-between mb-6">
                    <h1 class="text-lg font-semibold text-gray-900">Dashboard</h1>
                    <!--Dapat lepas login , setAttribute, userName...-->
                    <span class="text-sm text-gray-500">Welcome, <strong>${sessionScope.userName}</strong></span>
                </div>

                <%-- Stats grid - total users, students, lecturers, inactive, courses, notes, assignments, quizzes, posts --%>
                <!--Semua berkaitan nombor(count)-->
                <div class="grid grid-cols-4 gap-4 mb-6">
                    <div class="bg-white rounded-xl border border-gray-100 p-4">
                        <p class="text-xs text-gray-400 mb-1">Total users</p>
                        <p class="text-2xl font-semibold text-gray-900">${stats.totalUsers}</p>
                        <p class="text-xs text-gray-400 mt-1">${stats.totalStudents} students - ${stats.totalLecturers} lecturers</p>
                    </div>
                    <div class="bg-white rounded-xl border border-gray-100 p-4">
                        <p class="text-xs text-gray-400 mb-1">Total courses</p>
                        <p class="text-2xl font-semibold text-gray-900">${stats.totalCourses}</p>
                    </div>
                    <div class="bg-white rounded-xl border border-gray-100 p-4">
                        <p class="text-xs text-gray-400 mb-1">Assignments</p>
                        <p class="text-2xl font-semibold text-gray-900">${stats.totalAssignments}</p>
                        <p class="text-xs text-gray-400 mt-1">${stats.totalQuizzes} quizzes</p>
                    </div>
                    <div class="bg-white rounded-xl border border-gray-100 p-4">
                        <p class="text-xs text-gray-400 mb-1">Inactive users</p>
                        <p class="text-2xl font-semibold text-gray-900">${stats.inactiveUsers}</p>
                    </div>
                    <div class="bg-white rounded-xl border border-gray-100 p-4">
                        <p class="text-xs text-gray-400 mb-1">Total Revenue</p>
                        <p class="text-2xl font-semibold text-gray-900">RM ${totalRevenue}</p>
                    </div>
                </div>

                <!--TOP 5-->
                <div class="grid grid-cols-2 gap-6 mb-6">
                    <%-- Top courses by enrollment --%>
                    <div class="bg-white rounded-xl border border-gray-100 p-5">
                        <h2 class="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-4">Top Courses by Enrollment</h2>
                        <c:choose>
                            <c:when test="${empty topCourses}">
                                <p class="text-sm text-gray-400">No courses yet.</p>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="c" items="${topCourses}">
                                    <div class="flex items-center justify-between py-3 border-b border-gray-50 last:border-0">
                                        <p class="text-sm text-gray-900">${c.title}</p>
                                        <span class="text-xs bg-blue-50 text-blue-600 px-2 py-1 rounded-full font-medium">
                                            ${c.enrollmentCount} students
                                        </span>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <%-- Recent users --%>
                    <div class="bg-white rounded-xl border border-gray-100 p-5">
                        <h2 class="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-4">Recent Users</h2>
                        <c:choose>
                            <c:when test="${empty recentUsers}">
                                <p class="text-sm text-gray-400">No users yet.</p>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="u" items="${recentUsers}">
                                    <div class="flex items-center justify-between py-3 border-b border-gray-50 last:border-0">
                                        <div>
                                            <p class="text-sm font-medium text-gray-900">${u.name}</p>
                                            <p class="text-xs text-gray-400">${u.email}</p>
                                        </div>
                                        <span class="text-xs px-2 py-1 rounded-full font-medium
                                            ${u.role == 'student' ? 'bg-blue-50 text-blue-600' : 'bg-teal-50 text-teal-600'}">
                                            ${u.role}
                                        </span>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>

                </div>

                <%-- Recent forum posts --%>
                <div class="bg-white rounded-xl border border-gray-100 p-5">
                    <h2 class="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-4">Recent Forum Posts</h2>
                    <c:choose>
                        <c:when test="${empty recentPosts}">
                            <p class="text-sm text-gray-400">No forum posts yet.</p>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="p" items="${recentPosts}">
                                <div class="flex items-start justify-between py-3 border-b border-gray-50 last:border-0">
                                    <div>
                                        <p class="text-sm font-medium text-gray-900">${p.title}</p>
                                        <p class="text-xs text-gray-400 mt-0.5">
                                            by ${p.authorName} &nbsp;·&nbsp; ${p.courseName}
                                        </p>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/admin/posts"
                                       class="text-xs bg-red-50 text-red-600 px-3 py-1 rounded-full font-medium ml-3 hover:bg-red-100">
                                        Delete
                                    </a>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

            </main>
        </div>
    </body>
</html>
