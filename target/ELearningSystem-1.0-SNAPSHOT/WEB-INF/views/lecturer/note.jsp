<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!--Core tag   c:remove, c:if , c:choose, c:forEach  -->
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>MyStudyZone — Manage Notes</title>
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

                <%-- Success / Error messages --%>
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

                <%-- UC015 E1: No courses assigned --%>
                <c:choose>
                    <c:when test="${empty myCourses}">
                        <div class="bg-yellow-50 border border-yellow-100 text-yellow-700 text-sm rounded-xl px-4 py-3">
                            No courses available.
                        </div>
                    </c:when>
                    <c:otherwise>

                        <%-- UC015 Step 2: Upload form --%>
                        <div class="bg-white rounded-xl border border-gray-100 p-5 mb-6">
                            <h2 class="text-sm font-medium text-gray-900 mb-4">Upload New Note</h2>
                            <form action="${pageContext.request.contextPath}/note" method="post" enctype="multipart/form-data">
                                <input type="hidden" name="action" value="upload"/>
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
                                        <label class="block text-xs font-medium text-gray-600 mb-1">Note type</label>
                                        <select name="type" required
                                                class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-indigo-500">
                                            <option value="pdf">PDF</option>
                                            <option value="video">Video</option>
                                        </select>
                                    </div>
                                    
                                    <div>
                                        <label class="block text-xs font-medium text-gray-600 mb-1">Note title</label>
                                        <input type="text" name="title" required
                                               placeholder="e.g. Chapter 3 - SQL Joins"
                                               class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"/>
                                    </div>
<!--                                    <div>
                                        <label class="block text-xs font-medium text-gray-600 mb-1">File URL</label>
                                        <input type="text" name="fileUrl" required
                                               placeholder="https://..."
                                               class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"/>
                                    </div>-->
                                    <div>
                                        <label class="block text-xs font-medium text-gray-600 mb-1">Upload File</label>
                                        <input type="file" name="file"
                                               class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"/>
                                    </div>
                                </div>
                                <div class="flex justify-end">
                                    <button type="submit"
                                            class="bg-indigo-600 hover:bg-indigo-700 text-white text-sm px-4 py-2 rounded-lg">
                                        Upload note
                                    </button>
                                </div>
                            </form>
                        </div>

                        <%-- UC015 Step 1: Notes list grouped by course --%>
                        <c:choose>
                            <c:when test="${empty notes}">
                                <div class="bg-white rounded-xl border border-gray-100 p-8 text-center">
                                    <p class="text-sm text-gray-400">No notes uploaded yet.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:set var="currentCourse" value=""/>
                                <c:forEach var="note" items="${notes}">

                                    <c:if test="${note.courseName != currentCourse}">
                                        <c:if test="${not empty currentCourse}">
                                            </div>
                                        </c:if>
                                        <h2 class="text-xs font-semibold text-gray-400 uppercase tracking-wide mt-5 mb-3">
                                            ${note.courseName}
                                        </h2>
                                        <div class="bg-white rounded-xl border border-gray-100 overflow-hidden">
                                        <c:set var="currentCourse" value="${note.courseName}"/>
                                    </c:if>

                                    <div class="flex items-center justify-between px-5 py-3 border-b border-gray-50 last:border-0">
                                        <div class="flex items-center gap-3">
                                            <div class="w-8 h-8 rounded-lg flex items-center justify-center
                                                        ${note.type == 'pdf' ? 'bg-red-50' : 'bg-blue-50'}">
                                                <span class="text-xs font-bold ${note.type == 'pdf' ? 'text-red-500' : 'text-blue-500'}">
                                                    ${note.type == 'pdf' ? 'PDF' : 'VID'}
                                                </span>
                                            </div>
                                            <div>
                                                <p class="text-sm font-medium text-gray-900">${note.title}</p>
                                                <p class="text-xs text-gray-400">${note.createdAt}</p>
                                            </div>
                                        </div>

                                        <div class="flex gap-2">
                                            <%-- UC015 Step 3: Edit note title --%>
                                            <button onclick="showEditNote(${note.id}, '${note.title}')"
                                                    class="text-xs border border-gray-200 text-gray-600 px-3 py-1.5 rounded-lg hover:bg-gray-50">
                                                Edit
                                            </button>

                                            <%-- UC015 Step 4: Delete note --%>
                                            <form action="${pageContext.request.contextPath}/note" method="post"
                                                  onsubmit="return confirm('Delete this note?')">
                                                <input type="hidden" name="action" value="delete"/>
                                                <input type="hidden" name="noteId" value="${note.id}"/>
                                                <button type="submit"
                                                        class="text-xs border border-red-200 text-red-500 px-3 py-1.5 rounded-lg hover:bg-red-50">
                                                    Delete
                                                </button>
                                            </form>
                                        </div>
                                    </div>

                                </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>

                    </c:otherwise>
                </c:choose>
            </main>
        </div>

        <%-- Edit note modal --%>
        <div id="editNoteModal" class="hidden fixed inset-0 bg-black bg-opacity-20 flex items-center justify-center z-50">
            <div class="bg-white rounded-xl border border-gray-100 p-6 w-full max-w-md">
                <h2 class="text-sm font-medium text-gray-900 mb-4">Edit Note Title</h2>
                <form action="${pageContext.request.contextPath}/note" method="post">
                    <input type="hidden" name="action" value="edit"/>
                    <input type="hidden" name="noteId" id="editNoteId"/>
                    <div class="mb-5">
                        <label class="block text-xs font-medium text-gray-600 mb-1">Note title</label>
                        <input type="text" name="title" id="editNoteTitle" required
                               class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"/>
                    </div>
                    <div class="flex gap-2 justify-end">
                        <button type="button" onclick="hideEditNote()"
                                class="text-sm border border-gray-200 text-gray-600 px-4 py-2 rounded-lg hover:bg-gray-50">
                            Cancel
                        </button>
                        <button type="submit"
                                class="text-sm bg-indigo-600 hover:bg-indigo-700 text-white px-4 py-2 rounded-lg">
                            Save
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function showEditNote(id, title) {
                document.getElementById('editNoteId').value = id;
                document.getElementById('editNoteTitle').value = title;
                document.getElementById('editNoteModal').classList.remove('hidden');
            }
            function hideEditNote() {
                document.getElementById('editNoteModal').classList.add('hidden');
            }
        </script>
    </body>
</html>
