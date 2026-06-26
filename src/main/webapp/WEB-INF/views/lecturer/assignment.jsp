<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!--Core tag   c:remove, c:if , c:choose, c:forEach  -->
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>MyStudyZone — Manage Assignments</title>
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
                       class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">My Courses</a>
                    <a href="${pageContext.request.contextPath}/note"
                       class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">Notes</a>
                    <a href="${pageContext.request.contextPath}/assignment"
                       class="px-4 py-2.5 text-sm font-medium bg-gray-50 text-gray-900">Assignments</a>
                    <a href="${pageContext.request.contextPath}/quiz"
                       class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">Quiz</a>
                    <a href="${pageContext.request.contextPath}/discussion"
                       class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">Discussion</a>
                </nav>
                <a href="${pageContext.request.contextPath}/logout"
                   class="px-4 py-2.5 text-sm text-red-500 hover:bg-red-50 mt-auto">Logout</a>
            </aside>

            <main class="ml-52 flex-1 p-6">
                <h1 class="text-lg font-semibold text-gray-900 mb-6">Assignments</h1>

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

                <%-- UC016 E1: No courses available --%>
                <c:choose>
                    <c:when test="${empty myCourses}">
                        <div class="bg-yellow-50 border border-yellow-100 text-yellow-700 text-sm rounded-xl px-4 py-3">
                            No courses available.
                        </div>
                    </c:when>
                    <c:otherwise>

                        <%-- If lecturer clicked View Submissions, show submission list --%>
                        <c:if test="${not empty selected and not empty submissions}">
                            <div class="bg-white rounded-xl border border-gray-100 p-5 mb-6">
                                <div class="flex items-center justify-between mb-4">
                                    <h2 class="text-sm font-medium text-gray-900">
                                        Submissions — ${selected.title}
                                    </h2>
                                    <a href="${pageContext.request.contextPath}/assignment"
                                       class="text-xs text-gray-500 hover:text-gray-700">
                                        ← Back to assignments
                                    </a>
                                </div>
                                <c:choose>
                                    <c:when test="${empty submissions}">
                                        <p class="text-sm text-gray-400">No submissions yet.</p>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="sub" items="${submissions}">
                                            <div class="border border-gray-100 rounded-xl p-4 mb-3">
                                                <div class="flex items-start justify-between mb-3">
                                                    <div>
                                                        <p class="text-sm font-medium text-gray-900">${sub.studentName}</p>
                                                        <p class="text-xs text-gray-400 mt-0.5">Submitted: ${sub.submittedAt}</p>
                                                    </div>
                                                    <c:choose>
                                                        <c:when test="${sub.mark != null}">
                                                            <span class="text-sm font-semibold text-indigo-600">
                                                                ${sub.mark} / ${selected.maxMarks}
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-xs bg-amber-50 text-amber-600 px-2 py-1 rounded-full">
                                                                Not marked
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <c:if test="${not empty sub.answerText}">
                                                    <p class="text-sm text-gray-600 bg-gray-50 rounded-lg p-3 mb-3">
                                                        ${sub.answerText}
                                                    </p>
                                                </c:if>
                                                <c:if test="${not empty sub.fileUrl}">
                                                    <p class="text-xs text-gray-500 mb-3">
                                                        File: <a href="${pageContext.request.contextPath}/${sub.fileUrl}" target="_blank"
                                                                 class="text-indigo-600 hover:underline">View</a>
                                                    </p>
                                                </c:if>

                                                <%-- Mark form --%>
                                                <form action="${pageContext.request.contextPath}/assignment"
                                                      method="post" class="flex gap-2 items-end">
                                                    <input type="hidden" name="action" value="mark"/>
                                                    <input type="hidden" name="submissionId" value="${sub.id}"/>
                                                    <input type="hidden" name="assignmentId" value="${selected.id}"/>
                                                    <div>
                                                        <label class="block text-xs text-gray-500 mb-1">Mark</label>
                                                        <input type="number" name="mark" min="0" max="${selected.maxMarks}"
                                                               value="${sub.mark}"
                                                               class="w-20 border border-gray-200 rounded-lg px-2 py-1.5 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"/>
                                                    </div>
                                                    <div class="flex-1">
                                                        <label class="block text-xs text-gray-500 mb-1">Comment</label>
                                                        <input type="text" name="comment" value="${sub.lecturerComment}"
                                                               placeholder="Feedback for student..."
                                                               class="w-full border border-gray-200 rounded-lg px-2 py-1.5 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"/>
                                                    </div>
                                                    <button type="submit"
                                                            class="bg-indigo-600 hover:bg-indigo-700 text-white text-sm px-3 py-1.5 rounded-lg whitespace-nowrap">
                                                        Save mark
                                                    </button>
                                                </form>
                                            </div>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:if>

                        <%-- UC016 Step 2: Create new assignment form --%>
                        <div class="bg-white rounded-xl border border-gray-100 p-5 mb-6">
                            <h2 class="text-sm font-medium text-gray-900 mb-4">Create New Assignment</h2>
                            <form action="${pageContext.request.contextPath}/assignment" method="post">
                                <input type="hidden" name="action" value="create"/>
                                <div class="grid grid-cols-2 gap-3 mb-3">
                                    <div>
                                        <label class="block text-xs font-medium text-gray-600 mb-1">Course</label>
                                        <select name="courseId" required
                                                class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-indigo-500">
                                            <c:forEach var="course" items="${myCourses}">
                                                <option value="${course.id}">${course.title}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div>
                                        <label class="block text-xs font-medium text-gray-600 mb-1">Max marks</label>
                                        <input type="number" name="maxMarks" value="100" min="1" required
                                               class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"/>
                                    </div>
                                    <div>
                                        <label class="block text-xs font-medium text-gray-600 mb-1">Title</label>
                                        <input type="text" name="title" required
                                               placeholder="e.g. Assignment 2: Normalization Exercise"
                                               class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"/>
                                    </div>
                                    <div>
                                        <label class="block text-xs font-medium text-gray-600 mb-1">Due date</label>
                                        <input type="datetime-local" name="dueDate" required
                                               class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"/>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label class="block text-xs font-medium text-gray-600 mb-1">Description</label>
                                    <textarea name="description" rows="2"
                                              placeholder="e.g. Normalize the given schema to 3NF."
                                              class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 resize-none"></textarea>
                                </div>
                                <div class="flex justify-end">
                                    <button type="submit"
                                            class="bg-indigo-600 hover:bg-indigo-700 text-white text-sm px-4 py-2 rounded-lg">
                                        Create assignment
                                    </button>
                                </div>
                            </form>
                        </div>

                        <%-- UC016 Step 1: Assignment list --%>
                        <c:choose>
                            <c:when test="${empty assignments}">
                                <div class="bg-white rounded-xl border border-gray-100 p-8 text-center">
                                    <p class="text-sm text-gray-400">No assignments created yet.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:set var="currentCourse" value=""/>
                                <c:forEach var="a" items="${assignments}">
                                    <c:if test="${a.courseName != currentCourse}">
                                        <h2 class="text-xs font-semibold text-gray-400 uppercase tracking-wide mt-5 mb-3">
                                              ${a.courseName}
                                        </h2>
                                        <c:set var="currentCourse" value="${a.courseName}"/>
                                    </c:if>

                                    <div class="bg-white rounded-xl border border-gray-100 p-5 mb-3">
                                        <div class="flex items-start justify-between mb-2">
                                            <div>
                                                <h3 class="text-sm font-medium text-gray-900">${a.title}</h3>
                                                <p class="text-xs text-gray-400 mt-0.5">
                                                    Due: ${a.dueDate} &nbsp;·&nbsp;
                                                    Max: ${a.maxMarks} marks &nbsp;·&nbsp;
                                                    ${a.submissionCount} submission(s)
                                                </p>
                                            </div>
                                            <div class="flex gap-2 ml-3">
                                                <%-- View submissions --%>
                                                <a href="${pageContext.request.contextPath}/assignment?viewSubmissions=${a.id}"
                                                   class="text-xs border border-indigo-200 text-indigo-600 px-3 py-1.5 rounded-lg hover:bg-indigo-50 whitespace-nowrap">
                                                    Submissions (${a.submissionCount})
                                                </a>
                                                <%-- Edit --%>
                                                <button onclick="showEditAssignment(${a.id}, '${a.title}', '${a.description}', '${a.maxMarks}')"
                                                        class="text-xs border border-gray-200 text-gray-600 px-3 py-1.5 rounded-lg hover:bg-gray-50">
                                                    Edit
                                                </button>
                                                <%-- Delete --%>
                                                <form action="${pageContext.request.contextPath}/assignment"
                                                      method="post"
                                                      onsubmit="return confirm('Delete this assignment and all submissions?')">
                                                    <input type="hidden" name="action" value="delete"/>
                                                    <input type="hidden" name="assignmentId" value="${a.id}"/>
                                                    <button type="submit"
                                                            class="text-xs border border-red-200 text-red-500 px-3 py-1.5 rounded-lg hover:bg-red-50">
                                                        Delete
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                        <p class="text-sm text-gray-500">${a.description}</p>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>

                    </c:otherwise>
                </c:choose>
            </main>
        </div>

        <%-- Edit assignment modal --%>
        <div id="editAssignModal" class="hidden fixed inset-0 bg-black bg-opacity-20 flex items-center justify-center z-50">
            <div class="bg-white rounded-xl border border-gray-100 p-6 w-full max-w-md">
                <h2 class="text-sm font-medium text-gray-900 mb-4">Edit Assignment</h2>
                <form action="${pageContext.request.contextPath}/assignment" method="post">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="assignmentId" id="editAssignId"/>
                    <div class="mb-3">
                        <label class="block text-xs font-medium text-gray-600 mb-1">Title</label>
                        <input type="text" name="title" id="editAssignTitle" required
                               class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"/>
                    </div>
                    <div class="mb-3">
                        <label class="block text-xs font-medium text-gray-600 mb-1">Description</label>
                        <textarea name="description" id="editAssignDesc" rows="2"
                                  class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 resize-none"></textarea>
                    </div>
                    <div class="grid grid-cols-2 gap-3 mb-5">
                        <div>
                            <label class="block text-xs font-medium text-gray-600 mb-1">Due date</label>
                            <input type="datetime-local" name="dueDate" id="editAssignDue"
                                   class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"/>
                        </div>
                        <div>
                            <label class="block text-xs font-medium text-gray-600 mb-1">Max marks</label>
                            <input type="number" name="maxMarks" id="editAssignMarks"
                                   class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"/>
                        </div>
                    </div>
                    <div class="flex gap-2 justify-end">
                        <button type="button" onclick="hideEditAssignment()"
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

    <script>
        function showEditAssignment(id, title, desc, marks) {
            document.getElementById('editAssignId').value = id;
            document.getElementById('editAssignTitle').value = title;
            document.getElementById('editAssignDesc').value = desc;
            document.getElementById('editAssignMarks').value = marks;
            document.getElementById('editAssignModal').classList.remove('hidden');
        }
        function hideEditAssignment() {
            document.getElementById('editAssignModal').classList.add('hidden');
        }
    </script>
    </body>
</html>
