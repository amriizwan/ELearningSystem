<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!--Core tag   c:remove, c:if , c:choose, c:forEach  -->
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>MyStudyZone — Assignments</title>
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

            <main class="ml-52 flex-1 flex">

                <%-- LEFT PANEL: assignment list (UC006 Step 1) --%>
                <div class="w-72 border-r border-gray-100 bg-white flex flex-col">
                    <div class="px-4 py-4 border-b border-gray-100">
                        <h1 class="text-base font-semibold text-gray-900">Assignments</h1>
                    </div>

                    <%-- Success / Error messages --%>
                    <c:if test="${not empty sessionScope.success}">
                        <div class="mx-3 mt-3 bg-green-50 border border-green-100 text-green-700 text-xs rounded-lg px-3 py-2">
                            ${sessionScope.success}
                        </div>
                        <c:remove var="success" scope="session"/>
                    </c:if>
                    <c:if test="${not empty sessionScope.error}">
                        <div class="mx-3 mt-3 bg-red-50 border border-red-100 text-red-700 text-xs rounded-lg px-3 py-2">
                            ${sessionScope.error}
                        </div>
                        <c:remove var="error" scope="session"/>
                    </c:if>

                    <%-- UC006 E1: No assignments available --%>
                    <c:choose>
                        <c:when test="${empty assignments}">
                            <div class="px-4 py-6 text-sm text-gray-400">
                                No assignments available
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="overflow-auto flex-1">
                                <c:set var="currentCourse" value=""/>
                                <c:forEach var="a" items="${assignments}">

                                    <%-- Course group header --%>
                                    <c:if test="${a.courseName != currentCourse}">
                                        <div class="px-4 pt-4 pb-1">
                                            <span class="text-xs font-semibold text-gray-400 uppercase tracking-wide">
                                                ${a.courseName}
                                            </span>
                                        </div>
                                        <c:set var="currentCourse" value="${a.courseName}"/>
                                    </c:if>

                                    <%-- UC006 Step 2: clicking opens detail panel on right --%>
                                    <a href="${pageContext.request.contextPath}/assignment?id=${a.id}"
                                       class="block px-4 py-3 border-b border-gray-50 hover:bg-gray-50
                                              ${param.id == a.id ? 'bg-indigo-50 border-l-2 border-l-indigo-500' : ''}">
                                        <div class="flex items-start justify-between">
                                            <p class="text-sm font-medium text-gray-900 leading-snug">${a.title}</p>
                                            <%-- UC007 Post condition: Submitted badge --%>
                                            <c:choose>
                                                <c:when test="${a.submitted}">
                                                    <span class="text-xs bg-green-50 text-green-600 px-2 py-0.5 rounded-full font-medium ml-2 whitespace-nowrap">
                                                        Submitted
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-xs bg-amber-50 text-amber-600 px-2 py-0.5 rounded-full font-medium ml-2 whitespace-nowrap">
                                                        Pending
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <p class="text-xs text-gray-400 mt-1">Due: ${a.dueDate}</p>
                                    </a>

                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <%-- RIGHT PANEL: assignment detail + submission panel (UC006 Step 2, UC007) --%>
                <div class="flex-1 p-6">
                    <c:choose>
                        <c:when test="${empty selected}">
                            <div class="flex items-center justify-center h-full">
                                <p class="text-sm text-gray-400">Select an assignment to view details</p>
                            </div>
                        </c:when>
                        <c:otherwise>

                            <%-- Assignment details --%>
                            <div class="bg-white rounded-xl border border-gray-100 p-6 mb-5">
                                <div class="flex items-start justify-between mb-3">
                                    <h2 class="text-base font-semibold text-gray-900">${selected.title}</h2>
                                    <span class="text-xs text-gray-400">${selected.courseName}</span>
                                </div>
                                <p class="text-sm text-gray-600 mb-4">${selected.description}</p>
                                <div class="flex gap-6 text-xs text-gray-400">
                                    <span>Due: <strong class="text-gray-700">${selected.dueDate}</strong></span>
                                    <span>Max marks: <strong class="text-gray-700">${selected.maxMarks}</strong></span>
                                    <span>By: <strong class="text-gray-700">${selected.lecturerName}</strong></span>
                                </div>
                            </div>

                            <%-- If already submitted: show submission + mark/comment --%>
                            <c:choose>
                                <c:when test="${not empty existingSubmission}">
                                    <div class="bg-green-50 border border-green-100 rounded-xl p-5">
                                        <h3 class="text-sm font-medium text-green-800 mb-3">
                                            Submitted
                                        </h3>
                                        <c:if test="${not empty existingSubmission.answerText}">
                                            <p class="text-sm text-gray-700 mb-2">
                                                <strong>Your answer:</strong> ${existingSubmission.answerText}
                                            </p>
                                        </c:if>
                                        <c:if test="${not empty existingSubmission.fileUrl}">
                                            <p class="text-sm text-gray-700 mb-2">
                                                <strong>File:</strong>
                                                <a href="${pageContext.request.contextPath}/${existingSubmission.fileUrl}" target="_blank"
                                                   class="text-indigo-600 hover:underline">View</a>
                                            </p>
                                        </c:if>
                                        <p class="text-xs text-gray-400">
                                            Submitted at: ${existingSubmission.submittedAt}
                                        </p>

                                        <%-- Show mark and comment if graded --%>
                                        <c:if test="${existingSubmission.mark != null}">
                                            <div class="mt-4 pt-4 border-t border-green-200">
                                                <p class="text-sm font-medium text-gray-900">
                                                    Mark: <span class="text-indigo-600">${existingSubmission.mark} / ${selected.maxMarks}</span>
                                                </p>
                                                <c:if test="${not empty existingSubmission.lecturerComment}">
                                                    <p class="text-sm text-gray-600 mt-1">
                                                        Comment: ${existingSubmission.lecturerComment}
                                                    </p>
                                                </c:if>
                                            </div>
                                        </c:if>
                                    </div>
                                </c:when>

                                <c:otherwise>
                                    <%-- UC007: Submission panel --%>
                                    <div class="bg-white rounded-xl border border-gray-100 p-6">
                                        <h3 class="text-sm font-medium text-gray-900 mb-4">
                                            Submit Assignment
                                        </h3>

                                        <form action="${pageContext.request.contextPath}/assignment"
                                              method="post"
                                              enctype="multipart/form-data">
                                            <input type="hidden" name="action" value="submit"/>
                                            <input type="hidden" name="assignmentId" value="${selected.id}"/>

                                            <%-- File URL input --%>
<!--                                            <div class="mb-4">
                                                <label class="block text-xs font-medium text-gray-600 mb-1">
                                                    File URL (PDF only)
                                                </label>
                                                <input type="text" name="fileUrl"
                                                       placeholder="e.g. https://drive.google.com/.../Assignment2_Aqeel.pdf"
                                                       class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"/>
                                                <p class="text-xs text-gray-400 mt-1">
                                                    Only PDF files are accepted (URL must end with .pdf)
                                                </p>
                                            </div>-->

                                            <div>
                                                <label class="block text-xs font-medium text-gray-600 mb-1">Upload File</label>
                                                <input type="file" name="file"
                                                       class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"/>
                                            </div>

                                            <%-- Text answer --%>
                                            <div class="mb-5">
                                                <label class="block text-xs font-medium text-gray-600 mb-1">
                                                    Answer text (optional)
                                                </label>
                                                <textarea name="answerText" rows="4"
                                                          placeholder="Type your answer here..."
                                                          class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 resize-none"></textarea>
                                            </div>

                                            <%-- UC007 Step 3: Submit button (exact label from SDD) --%>
                                            <button type="submit"
                                                    class="bg-indigo-600 hover:bg-indigo-700 text-white text-sm px-5 py-2 rounded-lg transition-colors">
                                                Submit
                                            </button>
                                        </form>
                                    </div>
                                </c:otherwise>
                            </c:choose>

                        </c:otherwise>
                    </c:choose>
                </div>

            </main>
        </div>
    </body>
</html>
