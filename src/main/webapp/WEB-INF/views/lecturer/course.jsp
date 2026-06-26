<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!--Core tag   c:remove, c:if , c:choose, c:forEach, c:set, c:when -->
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<!--Function  	fn:length() , -->
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions" %> 
<!--allCourses, myCourses-->

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>MyStudyZone — My Courses</title>
    <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-50 min-h-screen">
        <div class="flex min-h-screen">
            <aside class="w-52 bg-white border-r border-gray-100 flex flex-col py-5 fixed h-full">
                <div class="px-4 mb-6">
                    <span class="text-base font-semibold text-gray-900">MyStudyZone</span>
                    <span class="block text-xs text-gray-400 mt-0.5">Lecturer portal</span>
                </div>
                <nav class="flex flex-col gap-0.5 flex-1">
                    <a href="${pageContext.request.contextPath}/dashboard"
                       class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">Dashboard</a>
                    <a href="${pageContext.request.contextPath}/course"
                       class="px-4 py-2.5 text-sm font-medium bg-gray-50 text-gray-900">My Courses</a>
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

            <main class="ml-52 flex-1 p-6">
                <h1 class="text-lg font-semibold text-gray-900 mb-6">My Courses</h1>

                <c:if test="${not empty sessionScope.success}">
                    <div class="bg-green-50 border border-green-100 text-green-700 text-sm rounded-xl px-4 py-3 mb-5">
                        ${sessionScope.success}
                    </div>
                    <c:remove var="success" scope="session"/>
                </c:if>

                <%-- UC014 E1: No courses available --%>
                <c:if test="${not empty error}">
                    <div class="bg-yellow-50 border border-yellow-100 text-yellow-700 text-sm rounded-xl px-4 py-3 mb-5">
                        ${error}
                    </div>
                </c:if>

                <div class="grid grid-cols-2 gap-4">
                    <c:forEach var="course" items="${allCourses}">
                        <div class="bg-white rounded-xl border border-gray-100 p-5">
                            <div class="flex items-start justify-between mb-2">
                                <h3 class="text-sm font-medium text-gray-900">${course.title}</h3>

                                <%-- Check if already teaching this course --%>
                                <c:set var="alreadyTeaching" value="false"/>
                                <c:forEach var="my" items="${myCourses}">
                                    <c:if test="${my.id == course.id}">
                                        <c:set var="alreadyTeaching" value="true"/>
                                    </c:if>
                                </c:forEach>

                                <c:if test="${alreadyTeaching}">
                                    <span class="text-xs bg-teal-50 text-teal-600 px-2 py-1 rounded-full font-medium ml-2">
                                        Teaching
                                    </span>
                                </c:if>
                            </div>
                            <p class="text-xs text-gray-400 mb-4">${course.description}</p>

                            <c:choose>
                                <c:when test="${alreadyTeaching}">
                                    <form action="${pageContext.request.contextPath}/course" method="post">
                                        <input type="hidden" name="action" value="stopteach"/>
                                        <input type="hidden" name="courseId" value="${course.id}"/>
                                        <button type="submit"
                                                class="text-xs border border-red-200 text-red-500 px-3 py-1.5 rounded-lg hover:bg-red-50">
                                            Stop teaching
                                        </button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <form action="${pageContext.request.contextPath}/course" method="post">
                                        <input type="hidden" name="action" value="teach"/>
                                        <input type="hidden" name="courseId" value="${course.id}"/>
                                        <button type="submit"
                                                class="text-xs bg-indigo-600 hover:bg-indigo-700 text-white px-3 py-1.5 rounded-lg">
                                            Teach
                                        </button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:forEach>
                </div>
            </main>
        </div>
    </body>
</html>
