<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!--Core tag   c:remove, c:if , c:choose, c:forEach, c:set, c:when -->
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<!--Function  	fn:length() , -->
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions" %> 

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>MySudyZone — Manage Courses</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-50 min-h-screen">
        <div class="flex min-h-screen">
            <aside class="w-52 bg-white border-r border-gray-100 flex flex-col py-5 fixed h-full">
                <div class="px-4 mb-6">
                    <span class="text-base font-semibold text-gray-900">MyStudyZone</span>
                    <span class="block text-xs text-gray-400 mt-0.5">Admin panel</span>
                </div>
                <nav class="flex flex-col gap-0.5 flex-1">
                    <a href="${pageContext.request.contextPath}/dashboard"
                       class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">Dashboard</a>
                    <a href="${pageContext.request.contextPath}/admin/users"
                       class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">Users</a>
                    <a href="${pageContext.request.contextPath}/course"
                       class="px-4 py-2.5 text-sm font-medium bg-gray-50 text-gray-900">Courses</a>
                    <a href="${pageContext.request.contextPath}/discussion"
                       class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">Posts</a>
                </nav>
                <a href="${pageContext.request.contextPath}/logout"
                   class="px-4 py-2.5 text-sm text-red-500 hover:bg-red-50 mt-auto">Logout</a>
            </aside>

            <main class="ml-52 flex-1 p-6">
                <h1 class="text-lg font-semibold text-gray-900 mb-6">Manage Courses</h1>

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

                <%-- UC021: Create new course form --%>
                <div class="bg-white rounded-xl border border-gray-100 p-5 mb-6">
                    <h2 class="text-sm font-medium text-gray-900 mb-4">Create New Course</h2>
                    <form action="${pageContext.request.contextPath}/course" method="post" class="flex gap-3 items-end">
                        <input type="hidden" name="action" value="create"/>
                        <input type="hidden" name="courseId" value="0"/>
                        <div class="flex-1">
                            <label class="block text-xs font-medium text-gray-600 mb-1">Course title</label>
                            <input type="text" name="title" required placeholder="e.g. Web Technology"
                                   class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"/>
                        </div>
                        <div class="flex-1">
                            <label class="block text-xs font-medium text-gray-600 mb-1">Description</label>
                            <input type="text" name="description" placeholder="Brief description..."
                                   class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"/>
                        </div>
                        <button type="submit"
                                class="bg-indigo-600 hover:bg-indigo-700 text-white text-sm px-4 py-2 rounded-lg transition-colors whitespace-nowrap">
                            Create course
                        </button>
                    </form>
                </div>

                <%-- UC021: Course list with edit and delete --%>
                <div class="bg-white rounded-xl border border-gray-100 overflow-hidden">
                    <table class="w-full text-sm">
                        <thead>
                            <tr class="border-b border-gray-100">
                                <th class="text-left text-xs font-medium text-gray-400 uppercase tracking-wide px-5 py-3">Course</th>
                                <th class="text-left text-xs font-medium text-gray-400 uppercase tracking-wide px-5 py-3">Description</th>
                                <th class="text-left text-xs font-medium text-gray-400 uppercase tracking-wide px-5 py-3">Students</th>
                                <th class="px-5 py-3"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty courses}">
                                    <tr>
                                        <td colspan="4" class="px-5 py-8 text-sm text-gray-400 text-center">
                                            No course available
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="course" items="${courses}">
                                        <tr class="border-b border-gray-50 hover:bg-gray-50">
                                            <td class="px-5 py-3 font-medium text-gray-900">${course.title}</td>
                                            <td class="px-5 py-3 text-gray-500">${course.description}</td>
                                            <td class="px-5 py-3">
                                                <span class="text-xs bg-blue-50 text-blue-600 px-2 py-1 rounded-full">
                                                    ${course.enrollmentCount}
                                                </span>
                                            </td>
                                            <td class="px-5 py-3">
                                                <div class="flex gap-2 justify-end">

                                                    <%-- Edit button — shows inline edit form via JS --%>
                                                    <button onclick="showEdit(${course.id}, '${course.title}', '${course.description}')"
                                                            class="text-xs border border-gray-200 text-gray-600 px-3 py-1.5 rounded-lg hover:bg-gray-50">
                                                        Edit
                                                    </button>

                                                    <%-- UC021: Delete course --%>
                                                    <form action="${pageContext.request.contextPath}/course"
                                                          method="post"
                                                          onsubmit="return confirm('Delete this course? This cannot be undone.')">
                                                        <input type="hidden" name="action" value="delete"/>
                                                        <input type="hidden" name="courseId" value="${course.id}"/>
                                                        <button type="submit"
                                                                class="text-xs border border-red-200 text-red-500 px-3 py-1.5 rounded-lg hover:bg-red-50">
                                                            Delete
                                                        </button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <%-- UC021: Hidden edit form — shown by JS when Edit is clicked --%>
                <div id="editModal" class="hidden fixed inset-0 bg-black bg-opacity-20 flex items-center justify-center z-50">
                    <div class="bg-white rounded-xl border border-gray-100 p-6 w-full max-w-md">
                        <h2 class="text-sm font-medium text-gray-900 mb-4">Edit Course</h2>
                        <form action="${pageContext.request.contextPath}/course" method="post">
                            <input type="hidden" name="action" value="update"/>
                            <input type="hidden" name="courseId" id="editCourseId"/>
                            <div class="mb-3">
                                <label class="block text-xs font-medium text-gray-600 mb-1">Course title</label>
                                <input type="text" name="title" id="editTitle" required
                                       class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"/>
                            </div>
                            <div class="mb-5">
                                <label class="block text-xs font-medium text-gray-600 mb-1">Description</label>
                                <input type="text" name="description" id="editDescription"
                                       class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"/>
                            </div>
                            <div class="flex gap-2 justify-end">
                                <button type="button" onclick="hideEdit()"
                                        class="text-sm border border-gray-200 text-gray-600 px-4 py-2 rounded-lg hover:bg-gray-50">
                                    Cancel
                                </button>
                                <button type="submit"
                                        class="text-sm bg-indigo-600 hover:bg-indigo-700 text-white px-4 py-2 rounded-lg">
                                    Save changes
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

            </main>
        </div>

        <script>
            function showEdit(id, title, description) {
                document.getElementById('editCourseId').value = id;
                document.getElementById('editTitle').value = title;
                document.getElementById('editDescription').value = description;
                document.getElementById('editModal').classList.remove('hidden');
            }
            function hideEdit() {
                document.getElementById('editModal').classList.add('hidden');
            }
        </script>
    </body>
</html>
