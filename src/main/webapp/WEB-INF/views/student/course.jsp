<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My Course - MyStudyZone</title>
        
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css"/>
        
    </head>
    <body class="bg-gray-50 text-gray-900">
        
        <aside class="w-52 bg-white border-r border-gray-100 flex flex-col py-5 fixed h-full">
            <div class="px-4 mb-6">
                <span class="text-base font-semibold text-gray-900">MyStudyZone</span>
                <span class="block text-xs text-gray-400 mt-0.5">Student portal</span>
            </div>
            <nav class="flex flex-col gap-0.5 flex-1">
                <a href="${pageContext.request.contextPath}/dashboard"
                   class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">Dashboard</a>
                <a href="${pageContext.request.contextPath}/enrollment"
                   class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-5">Enroll</a>
                <a href="${pageContext.request.contextPath}/course"
                   class="px-4 py-2.5 text-sm font-medium bg-gray-50 text-gray-900">My Courses</a>
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
               
        <main class="ml-56 min-h-screen flex">
             <!-- ── LEFT PANEL: Course list ── -->
            <div class="w-72 bg-white border-r border-gray-100 flex flex-col min-h-screen">
                <div class="px-5 py-5 border-b border-gray-100">
                    <h1 class="text-base font-semibold text-gray-900">My Courses</h1>
                    <p class="text-xs text-gray-400 mt-0.5">
                        ${fn:length(enrolledCourses)} enrolled
                    </p>
                </div>

                <!-- Search -->
                <div class="px-4 py-3 border-b border-gray-100">
                    <div class="relative">
                        <svg class="absolute left-3 top-1/2 -translate-y-1/2 w-3.5 h-3.5 text-gray-400"
                             fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <circle cx="11" cy="11" r="7"/><path stroke-linecap="round" d="M21 21l-4.35-4.35"/>
                        </svg>
                        <input type="text" id="course-search" placeholder="Search courses..."
                               oninput="searchCourses(this.value)"
                               class="w-full pl-8 pr-3 py-2 text-xs border border-gray-200 rounded-lg focus:outline-none focus:border-gray-400 bg-gray-50 transition"/>
                    </div>
                </div>

                <!-- Course list -->
                <c:set var="selectedCourse" value="${null}" />
                <div class="flex-1 overflow-y-auto py-2" id="course-list">
                    <c:choose>
                        <c:when test="${empty enrolledCourses}">
                            <div class="px-5 py-10 text-center">
                                <p class="text-xs text-gray-400">No enrolled courses.</p>
                                <a href="${pageContext.request.contextPath}/enrollment" class="text-xs text-emerald-600 hover:underline mt-1 inline-block">Browse courses →</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="course" items="${enrolledCourses}" varStatus="status">
                                <c:set var="palette" value="${palettes[status.index % fn:length(palettes)]}" />

                                <a href="course?id=${course.id}"
                                    class="course-item flex items-start gap-3 px-4 py-3.5 transition border-l-2 cursor-pointer
                                           ${course.id == selected_courseId ? 'bg-gray-50 border-gray-900' : 'border-transparent hover:bg-gray-50 hover:border-gray-200'}"
                                    data-title="${course.title}">
                                     <div class="w-8 h-8 rounded-lg flex items-center justify-center flex-shrink-0 ${palette.icon}">
                                         <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                             <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                                   d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/>
                                         </svg>
                                     </div>
                                     <div class="flex-1 min-w-0">
                                         <div class="text-sm font-medium text-gray-900 leading-snug truncate">
                                            ${course.title}
                                         </div>
                                         <div class="text-xs text-gray-400 mt-0.5">
                                            ${course.noteCount} notes · ${course.assignmentCount} assignments
                                         </div>
                                     </div>
                                 </a>
                                <c:if test="${course.id == selected_courseId}">
                                    <c:set var="selectedCourse" value="${course}" />
                                </c:if>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- ── RIGHT PANEL: Course detail ── -->
            <div class="flex-1 overflow-y-auto">
                <c:choose>
                    <c:when test="${empty selectedCourse}">
                        <div class="flex items-center justify-center h-full">
                            <div class="text-center">
                                <svg class="w-10 h-10 text-gray-300 mx-auto mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.2"
                                          d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/>
                                </svg>
                                <p class="text-sm text-gray-400">Select a course to view its content</p>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Course header -->
                        <div class="bg-white border-b border-gray-100 px-8 py-5">
                            <div class="flex items-start justify-between">
                                <div>
                                    <h2 class="text-lg font-semibold text-gray-900">${selectedCourse.title}</h2>
                                    <c:if test="${not empty selectedCourse.title}">
                                        <p class="text-sm text-gray-400 mt-1">${selectedCourse.title}</p>
                                    </c:if>
                                    <div class="flex gap-4 mt-3 text-xs text-gray-400">
                                        <span>${selectedCourse.noteCount} notes</span>
                                        <span>${selectedCourse.assignmentCount} assignments</span>
                                        <span>${selectedCourse.quizCount} quizzes</span>
                                    </div>
                                </div>
                                    <!--not work-->
                                <a href="enrollment" class="text-xs text-gray-400 hover:text-red-500 transition border border-gray-200 px-3 py-1.5 rounded-lg hover:border-red-200">
                                    Unenroll
                                </a>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
                    
                <div class="p-8">
                    <!-- Lecturer selector -->
                    <c:set var="selectedLecturer" value="${null}" />
                    <div class="mb-8">
                        <h3 class="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-3">Choose lecturer</h3>
                        <c:choose>
                            <c:when test="${empty lectCourse}">
                                <p class="text-sm text-gray-400">No lecturers assigned to this course yet.</p>
                            </c:when>
                            <c:otherwise>
                                <div class="flex flex-wrap gap-2">
                                    <c:forEach var="lect" items="${lectCourse}" varStatus="status">
                                        
                                        <c:set var="palette" value="${palettes[status.index % fn:length(palettes)]}" />
                                        <c:set var="lectActive" value="${lect.lectId == selected_lecturerId ? 'selected_lecturerId' : ''}" />

                                        <a href="course?id=${selected_courseId}&lecturerId=${lect.lectId}"
                                            class="flex items-center gap-2.5 px-4 py-2.5 rounded-xl border text-sm transition
                                                   ${not empty lectActive ? 'border-gray-900 bg-gray-900 text-white' : 'border-gray-200 bg-white text-gray-600 hover:border-gray-400'}">
                                            <div class="w-6 h-6 rounded-full flex items-center justify-center text-xs font-semibold flex-shrink-0
                                                   ${not empty lectActive ? 'bg-white/20 text-white' : palette.info}">
                                               ${lect.lectName.substring(0,1)}
                                            </div>
                                            <div>
                                                <div class="font-medium">${lect.lectName}</div>
                                                <div class="text-xs ${not empty lectActive ? 'text-white/70' : 'text-gray-400'}">
                                                    ${lect.noteCount} notes · ${lect.assignmentCount} assignments
                                                </div>
                                            </div>
                                        </a>
                                        <c:if test="${lect.lectId == selected_lecturerId}">
                                            <c:set var="selectedLecturer" value="${lect}" />
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <c:if test="${not empty selectedLecturer}">
                        <!-- Notes section -->
                        <div class="mb-8">
                            <div class="flex items-center justify-between mb-3">
                                <h3 class="text-xs font-semibold text-gray-400 uppercase tracking-wide">
                                    Notes — ${selectedLecturer.lectName}
                                </h3>
                                <span class="text-xs text-gray-400">${fn:length(notes)} files</span>
                            </div>

                            <c:choose>
                                <c:when test="${empty notes}">
                                    <div class="bg-white border border-gray-100 rounded-xl px-5 py-8 text-center">
                                        <p class="text-sm text-gray-400">No notes uploaded by this lecturer yet.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="flex flex-col gap-2">
                                        <c:forEach var="note" items="${notes}">
                                            <c:set var="is_pdf" value="${note.type eq 'pdf'}" />
                                            <div class="bg-white border border-gray-100 rounded-xl px-4 py-3.5 flex items-center gap-4
                                                        hover:border-gray-200 transition group">
                                                <!-- File icon -->
                                                <div class="w-9 h-9 rounded-lg flex items-center justify-center flex-shrink-0
                                                            ${is_pdf ? 'bg-red-50 text-red-500' : 'bg-blue-50 text-blue-500'}">
                                                    <c:choose>
                                                        <c:when test="${is_pdf}">
                                                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                                                      d="M7 21h10a2 2 0 002-2V9l-5-5H7a2 2 0 00-2 2v14a2 2 0 002 2z"/>
                                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M14 3v5h5"/>
                                                            </svg>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                                                      d="M14.752 11.168l-3.197-2.132A1 1 0 0010 9.87v4.263a1 1 0 001.555.832l3.197-2.132a1 1 0 000-1.664z"/>
                                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                                                      d="M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                                            </svg>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <!-- Title + meta -->
                                                <div class="flex-1 min-w-0">
                                                    <div class="text-sm font-medium text-gray-900 truncate">${note.title}</div>
                                                    <div class="text-xs text-gray-400 mt-0.5">
                                                        ${fn:toUpperCase(note.type)} · <fmt:formatDate value="${note.createdAt}" pattern="MMM dd, yyyy" />
                                                    </div>
                                                </div>

                                                <!-- Download/open button -->
                                                <a href="${note.fileUrl}" target="_blank"
                                                   class="opacity-0 group-hover:opacity-100 transition flex items-center gap-1.5 text-xs
                                                          text-gray-500 hover:text-gray-900 border border-gray-200 px-3 py-1.5 rounded-lg">
                                                    <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                                              d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"/>
                                                    </svg>
                                                    Open
                                                </a>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Assignments section -->
                        <div>
                            <div class="flex items-center justify-between mb-3">
                                <h3 class="text-xs font-semibold text-gray-400 uppercase tracking-wide">
                                    Assignments — ${selectedLecturer.lectName}
                                </h3>

                                <a href="assignment"
                                   class="text-xs text-gray-400 hover:text-gray-700 transition">
                                    View all →
                                </a>
                            </div>

                            <c:choose>

                                <c:when test="${empty assignments}">
                                    <div class="bg-white border border-gray-100 rounded-xl px-5 py-8 text-center">
                                        <p class="text-sm text-gray-400">
                                            No assignments from this lecturer yet.
                                        </p>
                                    </div>
                                </c:when>

                                <c:otherwise>
                                    <div class="flex flex-col gap-2">

                                        <c:forEach var="asgn" items="${assignments}">

                                            <div class="bg-white border border-gray-100 rounded-xl px-4 py-3.5 flex items-center gap-4
                                                        hover:border-gray-200 transition cursor-pointer"
                                                 onclick="location.href='assignment?id=${asgn.id}'">

                                                <!-- Assignment icon -->
                                                <div class="w-9 h-9 rounded-lg bg-amber-50 text-amber-600 flex items-center justify-center flex-shrink-0">
                                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                                              d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"/>
                                                    </svg>
                                                </div>

                                                <div class="flex-1 min-w-0">
                                                    <div class="text-sm font-medium text-gray-900 truncate">
                                                        ${asgn.title}
                                                    </div>

                                                    <div class="text-xs text-gray-400 mt-0.5">
                                                        Due
                                                        <fmt:formatDate value="${asgn.dueDate}" pattern="MMM dd, yyyy"/>

                                                        <%--<c:if test="${asgn.mark != null}">--%>
<!--                                                            · Score:
                                                            <span class="text-violet-600 font-medium">
                                                              <%--  ${asgn.mark}/${asgn.maxMarks} --%>
                                                            </span>-->
                                                        <%--</c:if>--%>
                                                    </div>
                                                </div>

                                                <!-- Status badge -->
                                                <span class="text-xs px-2.5 py-1 rounded-full font-medium ${asgn.getStatusClass()}">
                                                    ${asgn.getStatusText()}
                                                </span>

                                            </div>

                                        </c:forEach>

                                    </div>
                                </c:otherwise>

                            </c:choose>
                        </div>
                    </c:if>
                </div>
            </div>
        </main>
               
        <script>
            function searchCourses(val) {
                const q = val.toLowerCase();
                document.querySelectorAll('.course-item').forEach(item => {
                    const title = (item.dataset.title || '').toLowerCase();
                    item.style.display = title.includes(q) ? '' : 'none';
                });
            }
        </script>
    </body>
</html>