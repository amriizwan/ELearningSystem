<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css"/>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <style>
            body { font-family: 'Inter', ui-sans-serif, system-ui, sans-serif; }
        </style>
        <title>Assigments</title>
    </head>
    <body class="bg-slate-50 text-slate-900 antialiased">

        <!-- Mobile top bar -->
        <div class="lg:hidden sticky top-0 z-40 flex items-center justify-between bg-white border-b border-slate-200 px-4 py-3">
            <div class="flex items-center gap-2">
                <div class="w-8 h-8 rounded-lg bg-indigo-600 flex items-center justify-center">
                    <i class="fa-solid fa-graduation-cap text-white text-sm"></i>
                </div>
                <span class="text-base font-bold text-slate-900">MyStudyZone</span>
            </div>
            <button id="menu-toggle" type="button" class="w-9 h-9 flex items-center justify-center rounded-lg text-slate-500 hover:bg-slate-100 transition">
                <i class="fa-solid fa-bars text-lg"></i>
            </button>
        </div>

        <!-- Sidebar overlay (mobile) -->
        <div id="sidebar-overlay" class="hidden fixed inset-0 bg-slate-900/40 z-30 lg:hidden"></div>

        <!-- Sidebar -->
        <aside id="sidebar" class="w-64 bg-white border-r border-slate-100 flex flex-col py-6 fixed h-full z-40 -translate-x-full lg:translate-x-0 transition-transform duration-200 ease-in-out">
            <div class="px-6 mb-8 hidden lg:flex items-center gap-2.5">
                <div class="w-9 h-9 rounded-xl bg-indigo-600 flex items-center justify-center shadow-sm shadow-indigo-200">
                    <i class="fa-solid fa-graduation-cap text-white text-sm"></i>
                </div>
                <div>
                    <span class="block text-base font-bold text-slate-900 leading-tight">MyStudyZone</span>
                    <span class="block text-xs text-slate-400">Lecturer portal</span>
                </div>
            </div>
            <nav class="flex flex-col gap-1 flex-1 px-3">
                <a href="${pageContext.request.contextPath}/dashboard"
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-500 hover:bg-slate-50 hover:text-slate-900 transition">
                    <i class="fa-solid fa-gauge-high w-4 text-center"></i>
                    Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/course"
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-500 hover:bg-slate-50 hover:text-slate-900 transition">
                    <i class="fa-solid fa-book-open w-4 text-center"></i>
                    My Courses
                </a>
                <a href="${pageContext.request.contextPath}/note"
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-500 hover:bg-slate-50 hover:text-slate-900 transition">
                    <i class="fa-solid fa-note-sticky w-4 text-center"></i>
                    Notes
                </a>
                <a href="${pageContext.request.contextPath}/assignment"
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-semibold bg-indigo-50 text-indigo-700 transition">
                    <i class="fa-solid fa-file-lines w-4 text-center"></i>
                    Assignments
                </a>
                <a href="${pageContext.request.contextPath}/quiz"
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-500 hover:bg-slate-50 hover:text-slate-900 transition">
                    <i class="fa-solid fa-square-poll-vertical w-4 text-center"></i>
                    Quiz
                </a>
                <a href="${pageContext.request.contextPath}/discussion"
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-500 hover:bg-slate-50 hover:text-slate-900 transition">
                    <i class="fa-solid fa-comments w-4 text-center"></i>
                    Discussion
                </a>
            </nav>
            <div class="px-3 mt-auto">
                <a href="${pageContext.request.contextPath}/logout"
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-medium text-red-500 hover:bg-red-50 transition">
                    <i class="fa-solid fa-arrow-right-from-bracket w-4 text-center"></i>
                    Logout
                </a>
            </div>
        </aside>

        <main class="lg:ml-64 min-h-screen flex flex-col lg:flex-row">
            
            <!-- ── LEFT: Course list ── -->
            <div class="w-full lg:w-64 flex-shrink-0 bg-white border-b lg:border-b-0 lg:border-r border-slate-100 flex flex-col lg:min-h-screen">
                <div class="px-5 py-5 border-b border-slate-100">
                    <h1 class="text-base font-bold text-slate-900">Assignments</h1>
                    <p class="text-xs text-slate-400 mt-0.5">Manage & grade submissions</p>
                </div>
                <div class="flex-1 overflow-y-auto py-2">
                    <c:if test="${lectCourses.isEmpty()}">
                    <div class="px-5 py-8 text-center text-xs text-slate-400">No courses available.</div>
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
                                ${lectCourses.courseId == param.course_id ? 'bg-indigo-50 border-indigo-600' : 'border-transparent hover:bg-slate-50 hover:border-slate-200' }">
                        <div class="min-w-0 flex-1">
                            <div class="text-sm font-medium text-slate-900 truncate">${lectCourses.title}</div>
                            <div class="text-xs text-slate-400 mt-0.5">${lectCourses.assignment_count} assignments</div>
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
                                <a href="assignment?course_id=${firstId}" class="text-slate-400 hover:text-slate-700 transition">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 19l-7-7 7-7"/>
                                    </svg>
                                </a>
                                <h2 class="text-lg font-semibold text-slate-900">Create assignment</h2>
                            </div>
                           <!--ruang message--> 
                            <form method="POST" action="assignment?course_id=${firstId}&view=new"
                                  class="bg-white border border-slate-100 rounded-2xl p-6 flex flex-col gap-4">
                                <input type="hidden" name="action" value="create_assignment"/>
                                <div>
                                    <label class="block text-xs font-medium text-slate-700 mb-1.5">Course</label>
                                    <select name="selectedCourseId" required
                                            class="w-full border border-slate-200 rounded-xl px-4 py-2.5 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition">
                                        <c:forEach var="lectCourses" items="${lectCourses}" varStatus="status">
                                        <option value="${lectCourses.courseId}" ${lectCourses.courseId == firstId ?'selected':''} >${lectCourses.title}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div>
                                    <label class="block text-xs font-medium text-slate-700 mb-1.5">Title <span class="text-red-400">*</span></label>
                                    <input type="text" name="title" required placeholder="e.g. Assignment 1 — ER Diagram"
                                           class="w-full border border-slate-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition"/>
                                </div>
                                <div>
                                    <label class="block text-xs font-medium text-slate-700 mb-1.5">Description</label>
                                    <textarea name="description" rows="4"
                                              placeholder="Describe the assignment task, requirements, and submission format..."
                                              class="w-full border border-slate-200 rounded-xl px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition resize-none"></textarea>
                                </div>
                                <div class="grid grid-cols-2 gap-4">
                                    <div>
                                        <label class="block text-xs font-medium text-slate-700 mb-1.5">Due date <span class="text-red-400">*</span></label>
                                        <input type="datetime-local" name="due_date" required
                                               min="${currentDate}"
                                               class="w-full border border-slate-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition"/>
                                    </div>
                                    <div>
                                        <label class="block text-xs font-medium text-slate-700 mb-1.5">Max marks</label>
                                        <input type="number" name="max_marks" value="100" min="1" max="1000"
                                               class="w-full border border-slate-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition"/>
                                    </div>
                                </div>
                                <div class="flex gap-3 pt-2">
                                    <button type="submit" class="flex-1 py-2.5 rounded-xl bg-indigo-600 text-white text-sm font-medium hover:bg-indigo-700 transition">
                                        Create assignment
                                    </button>
                                    <a href="assignment?course_id=${firstId}"
                                       class="px-5 py-2.5 rounded-xl border border-slate-200 text-sm text-slate-600 hover:bg-slate-100 transition">
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
                                <a href="assignment?course_id=${firstId}" class="text-slate-400 hover:text-slate-700 transition">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 19l-7-7 7-7"/>
                                    </svg>
                                </a>
                                <h2 class="text-lg font-semibold text-slate-900">Edit assignment</h2>
                            </div>
                            <form method="POST" action="assignment?course_id=${firstId}&asgn_id=${selectedAssign.id}&view=edit"
                                  class="bg-white border border-slate-100 rounded-2xl p-6 flex flex-col gap-4">
                                <input type="hidden" name="action"    value="edit_assignment"/>
                                <input type="hidden" name="asgn_id"   value="${selectedAssign.id}"/>
                                <input type="hidden" name="course_id" value="${selectedAssign.courseId}"/>
                                <div>
                                    <label class="block text-xs font-medium text-slate-700 mb-1.5">Title</label>
                                    <input type="text" name="title" required value="${selectedAssign.title}"
                                           class="w-full border border-slate-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition"/>
                                </div>
                                <div>
                                    <label class="block text-xs font-medium text-slate-700 mb-1.5">Description</label>
                                    <textarea name="description" rows="4"
                                              class="w-full border border-slate-200 rounded-xl px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition resize-none">${selectedAssign.description}</textarea>
                                </div>
                                <div class="grid grid-cols-2 gap-4">
                                    <div>
                                        <fmt:formatDate value="${selectedAssign.dueDate}"
                                            pattern="yyyy-MM-dd'T'HH:mm"
                                            var="formattedDueDate"/>
                                        <label class="block text-xs font-medium text-slate-700 mb-1.5">Due date</label>
                                        <input type="datetime-local" name="due_date" required
                                               value="${formattedDueDate}"
                                               class="w-full border border-slate-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition"/>
                                    </div>
                                    <div>
                                        <label class="block text-xs font-medium text-slate-700 mb-1.5">Max marks</label>
                                        <input type="number" name="max_marks" value="${selectedAssign.maxMarks}" min="1" max="1000"
                                               class="w-full border border-slate-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition"/>
                                    </div>
                                </div>
                                <div class="flex gap-3 pt-2">
                                    <button type="submit" class="flex-1 py-2.5 rounded-xl bg-indigo-600 text-white text-sm font-medium hover:bg-indigo-700 transition">
                                        Save changes
                                    </button>
                                    <a href="assignment?course_id=${selectedAssign.courseId}"
                                       class="px-5 py-2.5 rounded-xl border border-slate-200 text-sm text-slate-600 hover:bg-slate-100 transition">
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
                                <a href="assignment?course_id=${firstId}" class="text-slate-400 hover:text-slate-700 transition">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 19l-7-7 7-7"/>
                                    </svg>
                                </a>
                                <div>
                                    <h2 class="text-lg font-semibold text-slate-900">${title}</h2>
                                    <p class="text-sm text-slate-400"> ${assignment_count} submissions</p>
                                </div>
                            </div>

                         
                            <c:if test="${submission.isEmpty()}">
                            <div class="bg-white border border-slate-100 rounded-2xl p-16 text-center">
                                <p class="text-sm text-slate-400">No submissions yet.</p>
                            </div>
                            </c:if>
                            <c:if test="${!submission.isEmpty()}">
                            <div class="flex flex-col gap-3">
                                <c:forEach var="submission" items="${submission}">
                                <div class="bg-white border border-slate-100 rounded-xl px-5 py-4 flex items-center gap-4
                                            hover:border-slate-200 transition">
                                    <!-- Avatar -->
                                    <div class="w-9 h-9 rounded-full bg-slate-100 text-slate-600 flex items-center justify-center text-xs font-semibold flex-shrink-0">
                                        ${fn:substring(submission.studentName, 0, 2)}
                                    </div>
                                    <!-- Info -->
                                    <div class="flex-1 min-w-0">
                                        <div class="text-sm font-medium text-slate-900">${fn:split(submission.studentName, ' ')[0]}</div>
                                        <fmt:formatDate value="${submission.submittedAt}"
                                            pattern="yyyy-MM-dd'T'HH:mm"
                                            var="submitted_date"/>
                                        <div class="text-xs text-slate-400 mt-0.5">Submitted ${submittedAt}</div>
                                        <c:if test="${fn:split(submission.answerText, ' ')[0] != null}">
                                        <p class="text-xs text-slate-500 mt-1 line-clamp-1">${fn:split(submission.answerText, ' ')[0]}</p>
                                        </c:if>
                                    </div>
                                    <!-- File -->
                                    <c:if test="${submission.fileUrl != null}">
                                    <a href="${pageContext.request.contextPath}/${submission.fileUrl}" target="_blank"
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
                                        <div class="text-sm font-semibold text-violet-700">${submission.mark}/${selectedAssign.maxMarks}</div>
                                        <div class="text-xs text-slate-400"><fmt:formatNumber value="${(submission.mark / selectedAssign.maxMarks) * 100}" maxFractionDigits="0"/>%</div>
                                    </div>
                                    <a href="assignment?course_id=${firstId}&asgn_id=${selectedAssign.id}&submission_id=${submission.id}&view=mark"
                                       class="text-xs px-3 py-1.5 rounded-lg border border-slate-200 text-slate-500 hover:bg-slate-100 transition flex-shrink-0">
                                        Edit mark
                                    </a>
                                    </c:if>
                                    <c:if test="${submission.mark == 0}">
                                    <span class="text-xs text-amber-600 font-medium flex-shrink-0">Ungraded</span>
                                    <a href="assignment?course_id=${firstId}&asgn_id=${selectedAssign.id}&submission_id=${submission.id}&view=mark"
                                       class="text-xs px-3 py-1.5 rounded-lg bg-indigo-600 text-white hover:bg-indigo-700 transition flex-shrink-0">
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
                                   class="text-slate-400 hover:text-slate-700 transition">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 19l-7-7 7-7"/>
                                    </svg>
                                </a>
                                <div>
                                    <h2 class="text-lg font-semibold text-slate-900">Mark submission</h2>
                                    <p class="text-sm text-slate-400">${forMark.studentName}· ${forMark.title}</p>
                                </div>
                            </div>

                            <!-- Student submission -->
                            <div class="bg-white border border-slate-100 rounded-2xl p-5 mb-5">
                                <h3 class="text-xs font-semibold text-slate-400 uppercase tracking-wide mb-3">Student submission</h3>
                                <p class="text-xs text-slate-400 mb-3">Submitted<fmt:formatDate value="${forMark.submittedAt}"
                                                                                                pattern="yyyy-MM-dd'T'HH:mm"
                                                                                                var="submitted_date"/>></p>

                                <c:if test="${forMark.fileUrl != null}">
                                <a href="${pageContext.request.contextPath}/${forMark.fileUrl}" target="_blank"
                                   class="flex items-center gap-2 bg-blue-50 border border-blue-200 rounded-xl px-4 py-3 text-sm text-blue-600 hover:bg-blue-100 transition mb-3">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                              d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13"/>
                                    </svg>
                                    View submitted file
                                </a>
                                </c:if>

                                <c:if test="${forMark.answerText != null}">
                                <div class="bg-slate-50 rounded-xl px-4 py-3 text-sm text-slate-700 leading-relaxed whitespace-pre-line">
                                    ${forMark.answerText}
                                </div>
                                </c:if>
                            </div>

                            <!-- Mark form -->
                            <form method="POST" action="assignment?course_id=${firstId}&asgn_id=${param.asgn_id}&submission_id=${forMark.id}&view=mark"
                                  class="bg-white border border-slate-100 rounded-2xl p-5">
                                <input type="hidden" name="action"        value="mark_submission"/>
                                <input type="hidden" name="submission_id" value="${forMark.id}"/>
                                <input type="hidden" name="asgn_id"       value="${param.asgn_id}"/>
                                <input type="hidden" name="course_id"     value="${firstId}"/>

                                <h3 class="text-xs font-semibold text-slate-400 uppercase tracking-wide mb-4">Your assessment</h3>

                                <!-- Mark input with live percentage -->
                                <div class="mb-4">
                                    <label class="block text-xs font-medium text-slate-700 mb-1.5">
                                        Mark <span class="text-slate-400">(out of ${forMark.maxMarks})</span>
                                    </label>
                                    <div class="flex items-center gap-3">
                                        <input type="number" name="mark" id="mark-input" required
                                               min="0" max="${forMark.maxMarks}"
                                               value="${forMark.maxMarks != null ? forMark.mark : ''}"
                                               oninput="updatePct(this.value, ${forMark.maxMarks})"
                                               class="w-32 border border-slate-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition text-center font-semibold"/>
                                        <span class="text-sm text-slate-400">/ ${forMark.maxMarks}</span>
                                        <span id="pct-label" class="ml-auto text-lg font-semibold text-slate-900">
                                            <fmt:formatNumber
                                                        value="${(forMark.mark  / forMark.maxMarks) * 100.0}"
                                                        maxFractionDigits="0" var="roundMark"/>
                                            <c:choose>
                                                <c:when test="${forMark.maxMarks != null}">
                                                    ${roundMark}
                                                </c:when>
                                                <c:otherwise>
                                                    --
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <!-- Grade bar -->
                                    <div class="mt-2 h-1.5 bg-slate-100 rounded-full overflow-hidden">
                                        <div id="grade-bar" class="h-full rounded-full transition-all duration-300 bg-slate-300"
                                             style="width: ${forMark.maxMarks != null ? roundMark : 0 }%"></div>
                                    </div>
                                </div>

                                <div class="mb-5">
                                    <label class="block text-xs font-medium text-slate-700 mb-1.5">Comment / feedback</label>
                                    <textarea name="lecturer_comment" rows="4"
                                              placeholder="Write feedback for the student..."
                                              class="w-full border border-slate-200 rounded-xl px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition resize-none">${forMark.lecturerComment}</textarea>
                                </div>

                                <button type="submit"
                                        class="w-full py-2.5 rounded-xl bg-indigo-600 text-white text-sm font-medium hover:bg-indigo-700 transition">
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
                                <h2 class="text-lg font-semibold text-slate-900">
                                    ${course_id != null ? title : 'Assignments'}
                                </h2>
                                <p class="text-sm text-slate-400 mt-0.5">${assignment_count != null ? assignment_count : '0'} assignments</p>
                            </div>
                            <c:choose>
                                <c:when test="${hasReachLimit}">
                                    <button
                                        type="button"
                                        onclick="openCourseModal()"
                                        class="flex items-center gap-2 px-4 py-2.5 rounded-xl bg-gradient-to-r from-indigo-600 via-violet-600 to-purple-600 text-white text-sm font-medium">
                                        Upgrade Plan
                                    </button>

                                    <!-- Course Details Modal -->
                                    <div id="courseModal"
                                        class="fixed inset-0 hidden items-center justify-center bg-black/60 backdrop-blur-sm z-50 p-5">
                                        <div class="bg-white rounded-3xl overflow-hidden max-w-lg w-full shadow-2xl animate-[fadeIn_.25s_ease]">
                                            <!-- Header -->
                                            <div class="bg-gradient-to-r from-indigo-600 via-violet-600 to-purple-600 text-white p-8 relative">
                                                <div class="absolute top-4 right-4">
                                                    <button onclick="closeCourseModal()"
                                                            class="w-9 h-9 rounded-full bg-white/20 hover:bg-white/30 transition">
                                                        ✕
                                                    </button>
                                                </div>
                                                <div class="w-16 h-16 rounded-2xl bg-white/20 flex items-center justify-center mb-4">
                                                    <i class="fa-solid fa-crown text-3xl text-yellow-300"></i>
                                                </div>

                                                <h2 class="text-3xl font-extrabold">
                                                    Assignments Upload Limit Reached
                                                </h2>
                                                <p class="text-indigo-100 mt-2 leading-relaxed">
                                                    You've used all uploads available on the Free Plan.
                                                    Upgrade once and enjoy unlimited access forever.
                                                </p>
                                            </div>
                                            <!-- Body -->
                                            <div class="p-8">
                                                <div class="bg-indigo-50 rounded-2xl p-5 border border-indigo-100">
                                                    <div class="flex items-center gap-3 mb-4">
                                                        <div class="w-10 h-10 rounded-full bg-indigo-600 text-white flex items-center justify-center">
                                                            <i class="fa-solid fa-gem"></i>
                                                        </div>
                                                        <div>
                                                            <h3 class="font-bold text-lg">
                                                                Premium Lifetime
                                                            </h3>
                                                            <p class="text-sm text-slate-500">
                                                                One payment. Lifetime access.
                                                            </p>
                                                        </div>
                                                    </div>
                                                    <div class="space-y-3">
                                                        <div class="flex items-center gap-3">
                                                            <i class="fa-solid fa-circle-check text-green-500"></i>
                                                            Unlimited Assignment Uploads
                                                        </div>
                                                        <div class="flex items-center gap-3">
                                                            <i class="fa-solid fa-circle-check text-green-500"></i>
                                                            Unlimited Notes Uploads
                                                        </div>
                                                        <div class="flex items-center gap-3">
                                                            <i class="fa-solid fa-circle-check text-green-500"></i>
                                                            Unlimited Discussion Posts
                                                        </div>
                                                        <div class="flex items-center gap-3">
                                                            <i class="fa-solid fa-circle-check text-green-500"></i>
                                                            Instant Premium Activation
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="mt-8 text-center">
                                                    <p class="text-slate-500 text-sm">
                                                        Lifetime Price
                                                    </p>
                                                    <div class="text-5xl font-black text-indigo-600">
                                                        RM${price}
                                                    </div>
                                                    <p class="text-sm text-green-600 font-semibold mt-2">
                                                        Pay once • No monthly fees
                                                    </p>
                                                </div>

                                                <div class="mt-8 flex gap-3 justify-between">
                                                     <button type="button" onclick="closeCourseModal()"
                                                             class="flex-1 py-3 rounded-xl border font-semibold hover:bg-slate-100">
                                                         Maybe Later
                                                    </button>
                                                    
                                                    <form id="upgradeNow" action="subscribe" method="get" class="flex flex-1">
                                                        <input type="hidden" name="amount" value="${price}">
                                                        <input type="hidden" name="prevPage" value="assignment">
                                                        
                                                        <button type="submit" onclick="document.getElementById('upgradeNow').submit()"
                                                            class="flex-1 text-center py-3 rounded-xl bg-gradient-to-r from-indigo-600 to-violet-600 text-white font-bold hover:scale-105 transition">
                                                            Upgrade Now →
                                                        </button>
                                                    </form>
                                                </div>
                                           </div>
                                       </div>
                                   </div>
                                </c:when>

                                <c:otherwise>
                                    <a href="assignment?course_id=${course_id == null ? firstId : course_id}&view=new"
                                       class="flex items-center gap-2 px-4 py-2.5 rounded-xl bg-indigo-600 text-white text-sm font-medium hover:bg-indigo-700 transition">
                                        <i class="fa-solid fa-plus"></i> New Assignment
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <c:choose>
                            <c:when test="${listAssignment.isEmpty()}">
                            <div class="bg-white border border-slate-100 rounded-2xl p-16 text-center">
                                <svg class="w-10 h-10 text-slate-300 mx-auto mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.2"
                                          d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
                                </svg>
                                <p class="text-sm text-slate-400">No assignments yet.</p>
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
                            <div class="bg-white border border-slate-100 rounded-xl p-5 hover:border-slate-200 transition group">
                                <div class="flex items-start justify-between gap-4">
                                    <div class="flex-1 min-w-0">
                                        <!-- Title + due -->
                                        <div class="flex items-center gap-2 flex-wrap mb-1">
                                            <h3 class="text-sm font-semibold text-slate-900">${listAssignment.title}</h3>
                                            <c:if test="${listAssignment.dueDate lt currentDate  }">
                                            <span class="text-xs px-2 py-0.5 rounded-full bg-red-100 text-red-600 font-medium">Past due</span>
                                            </c:if>
                                        </div>
                                        <p class="text-xs text-slate-400 mb-3">Due <fmt:formatDate value="${listAssignment.dueDate}"  pattern="dd MMM yyyy "/> · ${listAssignment.maxMarks} marks</p>

                                        <!-- Submission bar -->
                                        <div class="flex items-center gap-3">
                                            <div class="flex-1 h-1.5 bg-slate-100 rounded-full overflow-hidden">
                                                <div class="h-full bg-amber-400 rounded-full" style="width: ${percentage}%;"></div>
                                            </div>
                                            <span class="text-xs text-slate-500 flex-shrink-0">
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
                                        <a href="assignment?course_id=${course_id}&asgn_id=${listAssignment.id}&view=submissions"
                                           class="text-xs px-3 py-1.5 rounded-lg border border-slate-200 text-slate-600 hover:bg-slate-100 transition">
                                            Submissions ${listAssignment.assignment_count}
                                        </a>
                                        <a href="assignment?course_id=${course_id}&asgn_id=${listAssignment.id}&view=edit"
                                           class="text-xs px-3 py-1.5 rounded-lg border border-slate-200 text-slate-600 hover:bg-slate-100 transition">
                                            Edit
                                        </a>
                                        <form method="POST" action="assignment?course_id=${course_id}"
                                              onsubmit="return confirm('Delete this assignment? All student submissions will also be deleted.')">
                                            <input type="hidden" name="action"    value="delete_assignment"/>
                                            <input type="hidden" name="asgn_id"   value="${listAssignment.id}"/>
                                            <input type="hidden" name="course_id" value="${course_id}"/>
                                            <button type="submit"
                                                    class="text-xs px-3 py-1.5 rounded-lg border border-slate-200 text-slate-500 hover:bg-red-50 hover:text-red-600 hover:border-red-200 transition">
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
    const sidebar = document.getElementById('sidebar');
    const overlay = document.getElementById('sidebar-overlay');
    const toggle  = document.getElementById('menu-toggle');
    function openSidebar() { sidebar.classList.remove('-translate-x-full'); overlay.classList.remove('hidden'); }
    function closeSidebar() { sidebar.classList.add('-translate-x-full'); overlay.classList.add('hidden'); }
    if (toggle) toggle.addEventListener('click', () => { sidebar.classList.contains('-translate-x-full') ? openSidebar() : closeSidebar(); });
    if (overlay) overlay.addEventListener('click', closeSidebar);

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
    
    const courseModal = document.getElementById("courseModal");

    function openCourseModal(title, lecturer, description, notes, assignments, quizzes, students){
        courseModal.classList.remove("hidden");
        courseModal.classList.add("flex");

        document.body.classList.add("overflow-hidden");
    }

    function closeCourseModal(){
        courseModal.classList.remove("flex");
        courseModal.classList.add("hidden");

        document.body.classList.remove("overflow-hidden");
    }
    </script>
</html>