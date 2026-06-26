<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!--Core tag   c:remove, c:if , c:choose, c:forEach  -->
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>MyStudyZone — Notes</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-50 min-h-screen">
        <div class="flex min-h-screen">

            <aside class="w-52 bg-white border-r border-gray-100 flex flex-col py-5 fixed h-full">
                <div class="px-4 mb-6">
                    <span class="text-base font-semibold text-gray-900">MyStudyZone</span>
                    <span class="block text-xs text-gray-400 mt-0.5">Student portal</span>
                </div>
                <nav class="flex flex-col gap-0.5 flex-1">
                    <a href="${pageContext.request.contextPath}/dashboard"
                       class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">Dashboard</a>
                    <a href="${pageContext.request.contextPath}/course"
                       class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">My Courses</a>
                    <a href="${pageContext.request.contextPath}/note"
                       class="px-4 py-2.5 text-sm font-medium bg-gray-50 text-gray-900">Notes</a>
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
                <h1 class="text-lg font-semibold text-gray-900 mb-6">Notes</h1>

                <%-- UC005 Step 2 + 3: Filter by course and lecturer --%>
                <form action="${pageContext.request.contextPath}/note" method="get"
                      class="bg-white rounded-xl border border-gray-100 p-4 mb-6 flex gap-3 items-end">
                    <div class="flex-1">
                        <label class="block text-xs font-medium text-gray-600 mb-1">Course</label>
                        <select name="courseId"
                                class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-indigo-500">
                            <option value="">All enrolled courses</option>
                            <c:forEach var="course" items="${enrolledCourses}">
                                <option value="${course.id}"
                                    ${param.courseId == course.id ? 'selected' : ''}>
                                    ${course.title}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="flex-1">
                        <label class="block text-xs font-medium text-gray-600 mb-1">Lecturer</label>
                        <select name="lecturerId"
                                class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-indigo-500">>
                            <option value="">All Lecturers</option>
                            <c:forEach var="lecturer" items="${lecturers}">
                                <option value="${lecturer.id}"
                                    ${param.lecturerId == lecturer.id ? 'selected' : ''}>
                                    ${lecturer.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <button type="submit"
                            class="bg-indigo-600 hover:bg-indigo-700 text-white text-sm px-4 py-2 rounded-lg">
                        Filter
                    </button>
                    <a href="${pageContext.request.contextPath}/note"
                       class="border border-gray-200 text-gray-600 text-sm px-4 py-2 rounded-lg hover:bg-gray-50">
                        Clear
                    </a>
                </form>

                <%-- E1: No notes available --%>
                <c:if test="${not empty error}">
                    <div class="bg-yellow-50 border border-yellow-100 text-yellow-700 text-sm rounded-xl px-4 py-3 mb-5">
                        ${error}
                    </div>
                </c:if>

                <%-- Notes list grouped by course --%>
                <c:choose>
                    <c:when test="${empty notes}">
                        <div class="bg-white rounded-xl border border-gray-100 p-8 text-center">
                            <p class="text-sm text-gray-400">No notes available</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <%-- Track current course for grouping headers --%>
                        <c:set var="currentCourse" value=""/>
                        <c:forEach var="note" items="${notes}">

                            <%-- Print course header when course changes --%>
                            <c:if test="${note.courseName != currentCourse}">
                                <c:if test="${not empty currentCourse}">
                                    </div> <%-- close previous group --%>
                                </c:if>
                                <h2 class="text-xs font-semibold text-gray-400 uppercase tracking-wide mt-5 mb-3">
                                    ${note.courseName}
                                </h2>
                                <div class="bg-white rounded-xl border border-gray-100 overflow-hidden">
                                <c:set var="currentCourse" value="${note.courseName}"/>
                            </c:if>

                            <%-- Note row --%>
                            <div class="flex items-center justify-between px-5 py-3 border-b border-gray-50 last:border-0">
                                <div class="flex items-center gap-3">
                                    <%-- Icon by type --%>
                                    <div class="w-8 h-8 rounded-lg flex items-center justify-center
                                                ${note.type == 'pdf' ? 'bg-red-50' : 'bg-blue-50'}">
                                        <c:choose>
                                            <c:when test="${note.type == 'pdf'}">
                                                <span class="text-xs font-bold text-red-500">PDF</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-xs font-bold text-blue-500">VID</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div>
                                        <p class="text-sm font-medium text-gray-900">${note.title}</p>
                                        <p class="text-xs text-gray-400">by ${note.lecturerName} &nbsp;·&nbsp; ${note.createdAt}</p>
                                    </div>
                                </div>

                                <%-- UC005 Step 4: open (video) or download (pdf) --%>
                                <c:choose>
                                    <c:when test="${note.type == 'pdf'}">
                                        <a href="${pageContext.request.contextPath}/${note.fileUrl}" target="_blank"
                                           class="text-xs bg-gray-100 hover:bg-gray-200 text-gray-700 px-3 py-1.5 rounded-lg transition-colors">
                                            Open pdf
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/${note.fileUrl}" target="_blank"
                                           class="text-xs bg-blue-50 hover:bg-blue-100 text-blue-600 px-3 py-1.5 rounded-lg transition-colors">
                                            Open video
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                        </c:forEach>
                        </div> <%-- close last group --%>
                    </c:otherwise>
                </c:choose>
            </main>
        </div>
    </body>
</html>
