<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!--Core tag   c:remove, c:if , c:choose, c:forEach, c:set, c:when -->
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<!--Function  	fn:length() , -->
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions" %> 
<!--enrolledCourses, allCourses-->

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>MyStudyZone — My Courses</title>
    <script src="https://cdn.tailwindcss.com"></script>
    </head> 
    <body class="bg-gray-50 min-h-screen">
        <div class="flex min-h-screen">

            <%-- Sidebar --%>
            <aside class="w-52 bg-white border-r border-gray-100 flex flex-col py-5 fixed h-full">
                <div class="px-4 mb-6">
                    <span class="text-base font-semibold text-gray-900">MyStudyZone</span>
                    <span class="block text-xs text-gray-400 mt-0.5">Student portal</span>
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

                <%-- Success / Error messages (from session) --%>
                <c:if test="${not empty sessionScope.success}">
                    <div class="bg-green-50 border border-green-100 text-green-700 text-sm rounded-xl px-4 py-3 mb-5">
                        ${sessionScope.success}
                    </div>
                    <c:remove var="success" scope="session"/>
                </c:if>
                <c:if test="${not empty sessionScope.error}">
                    <div class="bg-red-50 border border-red-100 text-red-700 text-sm rounded-xl px-4 py-3 mb-5">
                        ${sessionScope.error}
                    </div>
                    <c:remove var="error" scope="session"/>
                </c:if>

                <%-- UC004 E1: No course available --%>
                <c:if test="${not empty error}">
                    <div class="bg-yellow-50 border border-yellow-100 text-yellow-700 text-sm rounded-xl px-4 py-3 mb-5">
                        ${error}
                    </div>
                </c:if>

                <%-- UC004 Post condition: Enrolled courses with Unenroll button --%>
                <c:if test="${not empty enrolledCourses}">
                    <div class="mb-8">
                        <h2 class="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-4">
                            Enrolled Courses
                        </h2>
                        <div class="grid grid-cols-2 gap-4"> 
                            <!--For loop item dalam enrolled course-->
                            <c:forEach var="course" items="${enrolledCourses}">
                                <div class="bg-white rounded-xl border border-gray-100 p-5">
                                    <div class="flex items-start justify-between mb-2">
                                        <h3 class="text-sm font-medium text-gray-900">${course.title}</h3>
                                        <%-- UC004 Post condition: Enrolled badge --%>
                                        <span class="text-xs bg-green-50 text-green-600 px-2 py-1 rounded-full font-medium ml-2 whitespace-nowrap">
                                            Enrolled
                                        </span>
                                    </div>
                                    <p class="text-xs text-gray-400 mb-4">${course.description}</p>
                                    <%-- UC004 Post condition: Unenroll button --%>
                                    <form action="${pageContext.request.contextPath}/course" method="post">
                                        <input type="hidden" name="action" value="unenroll"/>
                                        <input type="hidden" name="courseId" value="${course.id}"/>
                                        <button type="submit"
                                                class="text-xs border border-red-200 text-red-500 px-3 py-1.5 rounded-lg hover:bg-red-50 transition-colors">
                                            Unenroll
                                        </button>
                                    </form>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>

                <%-- UC004 Normal flow Step 1: Display available courses --%>
                <div>
                    <h2 class="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-4">
                        Available Courses
                    </h2>
                    <c:choose>
                        <c:when test="${empty allCourses}">
                            <p class="text-sm text-gray-400">No course available</p>
                        </c:when>
                        <c:otherwise>
                            <div class="grid grid-cols-2 gap-4">
                                <c:forEach var="course" items="${allCourses}">
                                    <div class="bg-white rounded-xl border border-gray-100 p-5">
                                        <h3 class="text-sm font-medium text-gray-900 mb-1">${course.title}</h3>
                                        <p class="text-xs text-gray-400 mb-4">${course.description}</p>

                                        <%-- Check if already enrolled — show badge or Enrol now button --%>
                                        <c:set var="alreadyEnrolled" value="false"/>
                                        <c:forEach var="enrolled" items="${enrolledCourses}">
                                            <c:if test="${enrolled.id == course.id}">
                                                <c:set var="alreadyEnrolled" value="true"/>
                                            </c:if>
                                        </c:forEach>

                                        <c:choose>
                                            <c:when test="${alreadyEnrolled}">
                                                <span class="text-xs bg-green-50 text-green-600 px-3 py-1.5 rounded-lg font-medium">
                                                    Enrolled
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <%-- UC004 Step 3: Enrol now button (exact label from SDD) --%>
                                                <form action="${pageContext.request.contextPath}/course" method="post">
                                                    <input type="hidden" name="action" value="enrol"/>
                                                    <input type="hidden" name="courseId" value="${course.id}"/>
                                                    <button type="submit"
                                                            class="text-xs bg-indigo-600 hover:bg-indigo-700 text-white px-3 py-1.5 rounded-lg transition-colors">
                                                        Enrol now
                                                    </button>
                                                </form>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </main>
        </div>
    </body>
</html>
