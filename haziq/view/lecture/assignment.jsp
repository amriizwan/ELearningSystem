<%-- 
    Document   : assignment
    Created on : Jun 27, 2026, 4:39:14 PM
    Author     : Haziq
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script src="https://cdn.tailwindcss.com"></script>
        <script src="https://kit.fontawesome.com/7ac8763a86.js" crossorigin="anonymous"></script>
        <title>Assigments</title>
    </head>
    <body>
        <aside class="w-52 bg-white border-r border-gray-100 flex flex-col py-5 fixed h-full">
            <div class="px-4 mb-6">
                <span class="text-base font-semibold text-gray-900">MyStudyZone</span>
                <span class="block text-xs text-gray-400 mt-0.5">Lecturer portal</span>
            </div>
            <nav class="flex flex-col gap-0.5 flex-1">
                <a href="${pageContext.request.contextPath}/dashboard"
                   class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">Dashboard</a>
                <a href="${pageContext.request.contextPath}/lectureCourses"
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
        <main class="ml-56 min-h-screen flex">
            
            <!-- ── LEFT: Course list ── -->
            <div class="w-64 flex-shrink-0 bg-white border-r border-gray-100 flex flex-col min-h-screen">
                <div class="px-5 py-5 border-b border-gray-100">
                    <h1 class="text-base font-semibold text-gray-900">Assignments</h1>
                    <p class="text-xs text-gray-400 mt-0.5">Manage & grade submissions</p>
                </div>
                <div class="flex-1 overflow-y-auto py-2">
                    <c:if test="${lectCourses.isEmpty()}">
                    <div class="px-5 py-8 text-center text-xs text-gray-400">No courses available.</div>
                    </c:if>
                    <c:forEach var="lectCourses" items="${lectCourses}" varStatus="status">
                        <c:if test="${status.index == 0}">
                            <c:set var="firstId" value="${lectCourses.courseId}" />
                        </c:if>
                        <c:if test="${lectCourses.courseId == param.course_id}">
                            <c:set var="assignment_count" value="${lectCourses.assignment_count}" />
                            <c:set var="title" value="${lectCourses.title}" />
                        </c:if>
                    <a href="assignment?course_id=${lectCourses.courseId}"
                       class="flex items-center justify-between px-4 py-3 border-l-2 transition
                                ${lectCourses.courseId == param.course_id ? 'bg-gray-50 border-gray-900' : 'border-transparent hover:bg-gray-50 hover:border-gray-200' }">
                        <div class="min-w-0 flex-1">
                            <div class="text-sm font-medium text-gray-900 truncate">${lectCourses.title}</div>
                            <div class="text-xs text-gray-400 mt-0.5">${lectCourses.assignment_count} assignments</div>
                        </div>
                    </a>
                    </c:forEach>
                </div>
            </div>
            <!-- ── RIGHT: Content ── -->
            <div class="flex-1 overflow-y-auto">
                <c:choose>
                    <c:when test="${param.view == 'new'}">
                        <!-- ══ CREATE ASSIGNMENT ══ -->
                        <div class="max-w-xl mx-auto px-8 py-8">
                            <div class="flex items-center gap-3 mb-6">
                                <a href="assignment?course_id=${firstId}" class="text-gray-400 hover:text-gray-700 transition">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 19l-7-7 7-7"/>
                                    </svg>
                                </a>
                                <h2 class="text-lg font-semibold text-gray-900">Create assignment</h2>
                            </div>
                           <!--ruang message--> 
                            <form method="POST" action="assignment?course_id=${firstId}&view=new"
                                  class="bg-white border border-gray-100 rounded-2xl p-6 flex flex-col gap-4">
                                <input type="hidden" name="action" value="create_assignment"/>
                                <div>
                                    <label class="block text-xs font-medium text-gray-700 mb-1.5">Course</label>
                                    <select name="selectedCourseId" required
                                            class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm bg-white focus:outline-none focus:border-gray-400 transition">
                                        <c:forEach var="lectCourses" items="${lectCourses}" varStatus="status">
                                        <option value="${lectCourses.courseId}" ${lectCourses.courseId == firstId ?'selected':''} >${lectCourses.title}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div>
                                    <label class="block text-xs font-medium text-gray-700 mb-1.5">Title <span class="text-red-400">*</span></label>
                                    <input type="text" name="title" required placeholder="e.g. Assignment 1 — ER Diagram"
                                           class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:border-gray-400 transition"/>
                                </div>
                                <div>
                                    <label class="block text-xs font-medium text-gray-700 mb-1.5">Description</label>
                                    <textarea name="description" rows="4"
                                              placeholder="Describe the assignment task, requirements, and submission format..."
                                              class="w-full border border-gray-200 rounded-xl px-4 py-3 text-sm focus:outline-none focus:border-gray-400 transition resize-none"></textarea>
                                </div>
                                <div class="grid grid-cols-2 gap-4">
                                    <div>
                                        <label class="block text-xs font-medium text-gray-700 mb-1.5">Due date <span class="text-red-400">*</span></label>
                                        <input type="datetime-local" name="due_date" required
                                               min="${currentDate}"
                                               class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:border-gray-400 transition"/>
                                    </div>
                                    <div>
                                        <label class="block text-xs font-medium text-gray-700 mb-1.5">Max marks</label>
                                        <input type="number" name="max_marks" value="100" min="1" max="1000"
                                               class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:border-gray-400 transition"/>
                                    </div>
                                </div>
                                <div class="flex gap-3 pt-2">
                                    <button type="submit" class="flex-1 py-2.5 rounded-xl bg-gray-900 text-white text-sm font-medium hover:bg-gray-700 transition">
                                        Create assignment
                                    </button>
                                    <a href="assignment?course_id=${firstId}"
                                       class="px-5 py-2.5 rounded-xl border border-gray-200 text-sm text-gray-600 hover:bg-gray-100 transition">
                                        Cancel
                                    </a>
                                </div>
                            </form>
                        </div>
                    </c:when>
                    <c:when test="${param.view == 'edit'}">
                        <!-- ══ EDIT ASSIGNMENT ══ -->
                        <div class="max-w-xl mx-auto px-8 py-8">
                            <div class="flex items-center gap-3 mb-6">
                                <a href="assignment?course_id=${firstId}" class="text-gray-400 hover:text-gray-700 transition">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 19l-7-7 7-7"/>
                                    </svg>
                                </a>
                                <h2 class="text-lg font-semibold text-gray-900">Edit assignment</h2>
                            </div>
                            <form method="POST" action="assignment?course_id=${firstId}&asgn_id=${selectedAssign.assignmentId}&view=edit"
                                  class="bg-white border border-gray-100 rounded-2xl p-6 flex flex-col gap-4">
                                <input type="hidden" name="action"    value="edit_assignment"/>
                                <input type="hidden" name="asgn_id"   value="${selectedAssign.assignmentId}"/>
                                <input type="hidden" name="course_id" value="${selectedAssign.courseId}"/>
                                <div>
                                    <label class="block text-xs font-medium text-gray-700 mb-1.5">Title</label>
                                    <input type="text" name="title" required value="${selectedAssign.title}"
                                           class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:border-gray-400 transition"/>
                                </div>
                                <div>
                                    <label class="block text-xs font-medium text-gray-700 mb-1.5">Description</label>
                                    <textarea name="description" rows="4"
                                              class="w-full border border-gray-200 rounded-xl px-4 py-3 text-sm focus:outline-none focus:border-gray-400 transition resize-none">${selectedAssign.description}</textarea>
                                </div>
                                <div class="grid grid-cols-2 gap-4">
                                    <div>
                                        <fmt:formatDate value="${selectedAssign.dueDate}"
                                            pattern="yyyy-MM-dd'T'HH:mm"
                                            var="formattedDueDate"/>
                                        <label class="block text-xs font-medium text-gray-700 mb-1.5">Due date</label>
                                        <input type="datetime-local" name="due_date" required
                                               value="${formattedDueDate}"
                                               class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:border-gray-400 transition"/>
                                    </div>
                                    <div>
                                        <label class="block text-xs font-medium text-gray-700 mb-1.5">Max marks</label>
                                        <input type="number" name="max_marks" value="${selectedAssign.maxMark}" min="1" max="1000"
                                               class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:border-gray-400 transition"/>
                                    </div>
                                </div>
                                <div class="flex gap-3 pt-2">
                                    <button type="submit" class="flex-1 py-2.5 rounded-xl bg-gray-900 text-white text-sm font-medium hover:bg-gray-700 transition">
                                        Save changes
                                    </button>
                                    <a href="assignment?course_id=${selectedAssign.courseId}"
                                       class="px-5 py-2.5 rounded-xl border border-gray-200 text-sm text-gray-600 hover:bg-gray-100 transition">
                                        Cancel
                                    </a>
                                </div>
                            </form>
                        </div>
                        
                    </c:when>
                    <c:when test="${param.view == 'submissions'}">
                        <!-- ══ SUBMISSIONS LIST ══ -->
                        <div class="p-8">
                            <div class="flex items-center gap-3 mb-6">
                                <a href="assignment?course_id=${firstId}" class="text-gray-400 hover:text-gray-700 transition">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 19l-7-7 7-7"/>
                                    </svg>
                                </a>
                                <div>
                                    <h2 class="text-lg font-semibold text-gray-900">${title}</h2>
                                    <p class="text-sm text-gray-400"> ${assignment_count} submissions</p>
                                </div>
                            </div>

                         
                            <c:if test="${submission.isEmpty()}">
                            <div class="bg-white border border-gray-100 rounded-2xl p-16 text-center">
                                <p class="text-sm text-gray-400">No submissions yet.</p>
                            </div>
                            </c:if>
                            <c:if test="${!submission.isEmpty()}">
                            <div class="flex flex-col gap-3">
                                <c:forEach var="submission" items="${submission}">
                                <div class="bg-white border border-gray-100 rounded-xl px-5 py-4 flex items-center gap-4
                                            hover:border-gray-200 transition">
                                    <!-- Avatar -->
                                    <div class="w-9 h-9 rounded-full bg-gray-100 text-gray-600 flex items-center justify-center text-xs font-semibold flex-shrink-0">
                                        ${fn:substring(submission.student_name, 0, 2)}
                                    </div>
                                    <!-- Info -->
                                    <div class="flex-1 min-w-0">
                                        <div class="text-sm font-medium text-gray-900">${fn:split(submission.student_name, ' ')[0]}</div>
                                        <fmt:formatDate value="${submission.submitted_date}"
                                            pattern="yyyy-MM-dd'T'HH:mm"
                                            var="submitted_date"/>
                                        <div class="text-xs text-gray-400 mt-0.5">Submitted ${submitted_date}</div>
                                        <c:if test="${fn:split(submission.answer, ' ')[0] != null}">
                                        <p class="text-xs text-gray-500 mt-1 line-clamp-1">${fn:split(submission.answer, ' ')[0]}</p>
                                        </c:if>
                                    </div>
                                    <!-- File -->
                                    <c:if test="${submission.file_url != null}">
                                    <a href="${pageContext.request.contextPath}/${submission.file_url}" target="_blank"
                                       class="flex items-center gap-1.5 text-xs text-blue-600 hover:underline border border-blue-200 px-3 py-1.5 rounded-lg flex-shrink-0">
                                        <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                                  d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13"/>
                                        </svg>
                                        File
                                    </a>
                                    </c:if>
                                    <!-- Mark status + action -->
                                    <c:if test="${submission.mark != 0}">
                                    <div class="text-right flex-shrink-0">
                                        <div class="text-sm font-semibold text-violet-700">${submission.mark}/${selectedAssign.maxMark}</div>
                                        <div class="text-xs text-gray-400"><fmt:formatNumber value="${(submission.mark / selectedAssign.maxMark) * 100}" maxFractionDigits="0"/>%</div>
                                    </div>
                                    <a href="assignment?course_id=${firstId}&asgn_id=${selectedAssign.assignmentId}&submission_id=${submission.id}&view=mark"
                                       class="text-xs px-3 py-1.5 rounded-lg border border-gray-200 text-gray-500 hover:bg-gray-100 transition flex-shrink-0">
                                        Edit mark
                                    </a>
                                    </c:if>
                                    <c:if test="${submission.mark == 0}">
                                    <span class="text-xs text-amber-600 font-medium flex-shrink-0">Ungraded</span>
                                    <a href="assignment?course_id=${firstId}&asgn_id=${selectedAssign.assignmentId}&submission_id=${submission.id}&view=mark"
                                       class="text-xs px-3 py-1.5 rounded-lg bg-gray-900 text-white hover:bg-gray-700 transition flex-shrink-0">
                                        Mark
                                    </a>
                                    </c:if>
                                </div>
                                </c:forEach>
                            </div>
                            </c:if>
                        </div>
                    </c:when>
                    <c:when test="${param.view == 'mark'}">
                         <!-- ══ MARK SUBMISSION ══ -->
                        <div class="max-w-xl mx-auto px-8 py-8">
                            <div class="flex items-center gap-3 mb-6">
                                <a href="assignment?course_id=${firstId}&asgn_id=${param.asgn_id}&view=submissions"
                                   class="text-gray-400 hover:text-gray-700 transition">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 19l-7-7 7-7"/>
                                    </svg>
                                </a>
                                <div>
                                    <h2 class="text-lg font-semibold text-gray-900">Mark submission</h2>
                                    <p class="text-sm text-gray-400">${forMark.student_name}· ${forMark.title}</p>
                                </div>
                            </div>

                            <!-- Student submission -->
                            <div class="bg-white border border-gray-100 rounded-2xl p-5 mb-5">
                                <h3 class="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-3">Student submission</h3>
                                <p class="text-xs text-gray-400 mb-3">Submitted<fmt:formatDate value="${forMark.submitted_date}"
                                                                                                pattern="yyyy-MM-dd'T'HH:mm"
                                                                                                var="submitted_date"/>></p>

                                <c:if test="${forMark.file_url != null}">
                                <a href="${pageContext.request.contextPath}/upload/${forMark.file_url}" target="_blank"
                                   class="flex items-center gap-2 bg-blue-50 border border-blue-200 rounded-xl px-4 py-3 text-sm text-blue-600 hover:bg-blue-100 transition mb-3">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                              d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13"/>
                                    </svg>
                                    View submitted file
                                </a>
                                </c:if>

                                <c:if test="${forMark.answer != null}">
                                <div class="bg-gray-50 rounded-xl px-4 py-3 text-sm text-gray-700 leading-relaxed whitespace-pre-line">
                                    ${forMark.answer}
                                </div>
                                </c:if>
                            </div>

                            <!-- Mark form -->
                            <form method="POST" action="assignment?course_id=${firstId}&asgn_id=${param.asgn_id}&submission_id=${forMark.id}&view=mark"
                                  class="bg-white border border-gray-100 rounded-2xl p-5">
                                <input type="hidden" name="action"        value="mark_submission"/>
                                <input type="hidden" name="submission_id" value="${forMark.id}"/>
                                <input type="hidden" name="asgn_id"       value="${param.asgn_id}"/>
                                <input type="hidden" name="course_id"     value="${firstId}"/>

                                <h3 class="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-4">Your assessment</h3>

                                <!-- Mark input with live percentage -->
                                <div class="mb-4">
                                    <label class="block text-xs font-medium text-gray-700 mb-1.5">
                                        Mark <span class="text-gray-400">(out of ${forMark.maxMark})</span>
                                    </label>
                                    <div class="flex items-center gap-3">
                                        <input type="number" name="mark" id="mark-input" required
                                               min="0" max="${forMark.maxMark}"
                                               value="${forMark.maxMark != null ? forMark.mark : ''}"
                                               oninput="updatePct(this.value, ${forMark.maxMark})"
                                               class="w-32 border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:border-gray-400 transition text-center font-semibold"/>
                                        <span class="text-sm text-gray-400">/ ${forMark.maxMark}</span>
                                        <span id="pct-label" class="ml-auto text-lg font-semibold text-gray-900">
                                            <fmt:formatNumber
                                                        value="${(forMark.mark  / forMark.maxMark) * 100.0}"
                                                        maxFractionDigits="0" var="roundMark"/>
                                            <c:choose>
                                                <c:when test="${forMark.maxMark != null}">
                                                    ${roundMark}
                                                </c:when>
                                                <c:otherwise>
                                                    --
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <!-- Grade bar -->
                                    <div class="mt-2 h-1.5 bg-gray-100 rounded-full overflow-hidden">
                                        <div id="grade-bar" class="h-full rounded-full transition-all duration-300 bg-gray-300"
                                             style="width: ${forMark.maxMark != null ? roundMark : 0 }%"></div>
                                    </div>
                                </div>

                                <div class="mb-5">
                                    <label class="block text-xs font-medium text-gray-700 mb-1.5">Comment / feedback</label>
                                    <textarea name="lecturer_comment" rows="4"
                                              placeholder="Write feedback for the student..."
                                              class="w-full border border-gray-200 rounded-xl px-4 py-3 text-sm focus:outline-none focus:border-gray-400 transition resize-none">${forMark.lecturer_comment}</textarea>
                                </div>

                                <button type="submit"
                                        class="w-full py-2.5 rounded-xl bg-gray-900 text-white text-sm font-medium hover:bg-gray-700 transition">
                                    Save mark & feedback
                                </button>
                            </form>
                        </div>
                    </c:when>
                    <c:otherwise>

                    <!-- ══ ASSIGNMENT LIST ══ -->
                    <div class="p-8">
                        <!-- Toast -->
                       <c:if test="${not empty sessionScope.success}">
                               <div id="toast" class="bg-green-50 border border-green-100 text-green-700 text-sm rounded-xl px-4 py-3 mb-5 w-full">
                                   ${sessionScope.success}
                               </div>
                               <c:remove var="success" scope="session"/>
                       </c:if>
                       <c:if test="${not empty sessionScope.error}">
                               <div id="toast" class="bg-green-50 border border-red-100 text-red-700 text-sm rounded-xl px-4 py-3 mb-5 w-full">
                                   ${sessionScope.error}
                               </div>
                               <c:remove var="error" scope="session"/>
                       </c:if>
                        <div class="flex items-center justify-between mb-6">
                            <div>
                                <h2 class="text-lg font-semibold text-gray-900">
                                    ${course_id != null ? title : 'Assignments'}
                                </h2>
                                <p class="text-sm text-gray-400 mt-0.5">${assignment_count != null ? assignment_count : '0'} assignments</p>
                            </div>
                            <a href="assignment?course_id=${course_id == null ? firstId : course_id}&view=new"
                               class="flex items-center gap-2 px-4 py-2.5 rounded-xl bg-gray-900 text-white text-sm font-medium hover:bg-gray-700 transition">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                                </svg>
                                New assignment
                            </a>
                        </div>
                        <c:choose>
                            <c:when test="${listAssignment.isEmpty()}">
                            <div class="bg-white border border-gray-100 rounded-2xl p-16 text-center">
                                <svg class="w-10 h-10 text-gray-300 mx-auto mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.2"
                                          d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
                                </svg>
                                <p class="text-sm text-gray-400">No assignments yet.</p>
                                <a href="assignment?course_id=${course_id!= 0 ? course_id : firstId }&view=new"
                                   class="inline-block mt-3 text-sm text-amber-600 hover:underline">Create your first assignment →</a>
                            </div>
                            </c:when>
                        <c:otherwise>
                        <div class="flex flex-col gap-3">
                            <c:forEach var="listAssignment" items="${listAssignment}">
                                <c:set var="percentage"
                                    value="${listAssignment.enroll_count > 0 ?
                                            listAssignment.assignment_count * 100.0 / listAssignment.enroll_count :
                                            0}" />
                            <div class="bg-white border border-gray-100 rounded-xl p-5 hover:border-gray-200 transition group">
                                <div class="flex items-start justify-between gap-4">
                                    <div class="flex-1 min-w-0">
                                        <!-- Title + due -->
                                        <div class="flex items-center gap-2 flex-wrap mb-1">
                                            <h3 class="text-sm font-semibold text-gray-900">${listAssignment.title}</h3>
                                            <c:if test="${listAssignment.dueDate lt currentDate  }">
                                            <span class="text-xs px-2 py-0.5 rounded-full bg-red-100 text-red-600 font-medium">Past due</span>
                                            </c:if>
                                        </div>
                                        <p class="text-xs text-gray-400 mb-3">Due <fmt:formatDate value="${listAssignment.dueDate}"  pattern="dd MMM yyyy "/> · ${listAssignment.maxMark} marks</p>

                                        <!-- Submission bar -->
                                        <div class="flex items-center gap-3">
                                            <div class="flex-1 h-1.5 bg-gray-100 rounded-full overflow-hidden">
                                                <div class="h-full bg-amber-400 rounded-full" style="width: ${percentage}%;"></div>
                                            </div>
                                            <span class="text-xs text-gray-500 flex-shrink-0">
                                                ${listAssignment.assignment_count}/${listAssignment.enroll_count} submitted
                                            </span>
                                            <c:if test="${listAssignment.ungraded_count > 0}">
                                            <span class="text-xs px-2 py-0.5 rounded-full bg-amber-100 text-amber-700 font-medium flex-shrink-0">
                                                ${listAssignment.ungraded_count} ungraded
                                            </span>
                                            </c:if>
                                        </div>
                                    </div>

                                    <!-- Actions -->
                                    <div class="flex items-center gap-2 flex-shrink-0">
                                        <a href="assignment?course_id=${course_id}&asgn_id=${listAssignment.assignmentId}&view=submissions"
                                           class="text-xs px-3 py-1.5 rounded-lg border border-gray-200 text-gray-600 hover:bg-gray-100 transition">
                                            Submissions ${listAssignment.assignment_count}
                                        </a>
                                        <a href="assignment?course_id=${course_id}&asgn_id=${listAssignment.assignmentId}&view=edit"
                                           class="text-xs px-3 py-1.5 rounded-lg border border-gray-200 text-gray-600 hover:bg-gray-100 transition">
                                            Edit
                                        </a>
                                        <form method="POST" action="assignment?course_id=${course_id}"
                                              onsubmit="return confirm('Delete this assignment? All student submissions will also be deleted.')">
                                            <input type="hidden" name="action"    value="delete_assignment"/>
                                            <input type="hidden" name="asgn_id"   value="${listAssignment.assignmentId}"/>
                                            <input type="hidden" name="course_id" value="${course_id}"/>
                                            <button type="submit"
                                                    class="text-xs px-3 py-1.5 rounded-lg border border-gray-200 text-gray-500 hover:bg-red-50 hover:text-red-600 hover:border-red-200 transition">
                                                Delete
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                            </c:forEach>
                        </div>
                        </c:otherwise>
                        </c:choose>
                    </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </body>
    <script>
    const toast = document.getElementById('toast');
    if (toast) setTimeout(() => { toast.style.opacity='0'; setTimeout(()=>toast.remove(),300); }, 4000);

    function updatePct(val, max) {
        const pct = max > 0 ? Math.round((val / max) * 100) : 0;
        const label = document.getElementById('pct-label');
        const bar   = document.getElementById('grade-bar');
        if (!label || !bar) return;
        label.textContent = val !== '' ? pct + '%' : '--';
        bar.style.width   = (val !== '' ? Math.min(pct, 100) : 0) + '%';
        bar.className     = 'h-full rounded-full transition-all duration-300 ' +
            (pct >= 80 ? 'bg-emerald-500' : pct >= 60 ? 'bg-blue-500' : pct >= 40 ? 'bg-amber-400' : 'bg-red-400');
        label.className   = 'ml-auto text-lg font-semibold ' +
            (pct >= 80 ? 'text-emerald-600' : pct >= 60 ? 'text-blue-600' : pct >= 40 ? 'text-amber-600' : 'text-red-500');
    }
    </script>
</html>
