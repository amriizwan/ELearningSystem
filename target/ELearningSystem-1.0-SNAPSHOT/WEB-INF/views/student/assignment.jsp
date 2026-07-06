<%-- 
    Document   : assignments
    Created on : 23 Jun 2026, 5:41:44 pm
    Author     : User
--%>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Assignment - MyStudyZone</title>
        
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css"/>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <style>
            body { font-family: 'Inter', ui-sans-serif, system-ui, sans-serif; }
        </style>
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
                    <span class="block text-xs text-slate-400">Student portal</span>
                </div>
            </div>
            <nav class="flex flex-col gap-1 flex-1 px-3">
                <a href="${pageContext.request.contextPath}/dashboard"
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-500 hover:bg-slate-50 hover:text-slate-900 transition">
                    <i class="fa-solid fa-gauge-high w-4 text-center"></i>
                    Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/enrollment"
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-500 hover:bg-slate-50 hover:text-slate-900 transition">
                    <i class="fa-solid fa-pen-to-square w-4 text-center"></i>
                    Enroll
                </a>
                <a href="${pageContext.request.contextPath}/course"
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-500 hover:bg-slate-50 hover:text-slate-900 transition">
                    <i class="fa-solid fa-book-open w-4 text-center"></i>
                    My Courses
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
            <!-- ── LEFT PANEL: Assignment list ── -->
            <div class="w-full lg:w-80 bg-white border-r border-slate-100 flex flex-col lg:min-h-screen flex-shrink-0">
                <div class="px-5 py-5 border-b border-slate-100">
                    <h1 class="text-base font-bold text-slate-900">Assignments</h1>
                    <p class="text-xs text-slate-400 mt-0.5">${fn:length(assignments)} total</p>
                </div>

                <!-- Filter tabs -->
                <div class="px-4 py-3 border-b border-slate-100 flex gap-1.5 flex-wrap">
                   
                    <a href="?filter=all"
                        class="px-3 py-1.5 text-xs rounded-full font-medium transition
                        ${filter == 'all' ? 'bg-indigo-600 text-white shadow-sm shadow-indigo-200'
                                          : 'bg-slate-100 text-slate-500 hover:bg-slate-200'}">
                         All ${allCount > 0 ? '(' += allCount += ')' : ''}
                     </a>

                     <a href="?filter=pending"
                        class="px-3 py-1.5 text-xs rounded-full font-medium transition
                        ${filter == 'pending' ? 'bg-indigo-600 text-white shadow-sm shadow-indigo-200'
                                              : 'bg-slate-100 text-slate-500 hover:bg-slate-200'}">
                         Pending ${pendingCount > 0 ? '(' += pendingCount += ')' : ''}
                     </a>

                     <a href="?filter=submitted"
                        class="px-3 py-1.5 text-xs rounded-full font-medium transition
                        ${filter == 'submitted' ? 'bg-indigo-600 text-white shadow-sm shadow-indigo-200'
                                                : 'bg-slate-100 text-slate-500 hover:bg-slate-200'}">
                         Submitted ${submittedCount > 0 ? '(' += submittedCount += ')' : ''}
                     </a>

                     <a href="?filter=marked"
                        class="px-3 py-1.5 text-xs rounded-full font-medium transition
                        ${filter == 'marked' ? 'bg-indigo-600 text-white shadow-sm shadow-indigo-200'
                                             : 'bg-slate-100 text-slate-500 hover:bg-slate-200'}">
                         Marked ${markedCount > 0 ? '(' += markedCount += ')' : ''}
                     </a>
                </div>

                <!-- Assignment list -->
                <div class="flex-1 overflow-y-auto py-2 max-h-[70vh] lg:max-h-none">
                    <c:choose>
                        <c:when test="${empty assignments}">
                            <div class="px-5 py-10 text-center">
                                <p class="text-xs text-slate-400">No assignments in this category.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:set var="selectedAsgn" value="${null}" />
                            <c:forEach var="asgn" items="${assignments}">
                                <c:set var="active" value="${asgn.id == asgnId ? asgnId : ''}" />
                                <a href="assignment?filter=${filter}&id=${asgn.id}"
                                    class="flex items-start gap-3 px-4 py-3.5 border-l-2 transition cursor-pointer
                                            ${not empty active ? 'bg-indigo-50 border-indigo-600' : 'border-transparent hover:bg-slate-50 hover:border-slate-200'}
                                            ${asgn.status eq 'overdue' && !$active ? 'border-l-red-200' : ''}">
                                    <!-- Status dot -->
                                    <div class="mt-1.5 w-2 h-2 rounded-full flex-shrink-0
                                        <c:choose>
                                            <c:when test="${asgn.status == 'overdue'}">bg-red-400</c:when>
                                            <c:when test="${asgn.status == 'due_soon'}">bg-amber-400</c:when>
                                            <c:when test="${asgn.status == 'submitted'}">bg-emerald-400</c:when>
                                            <c:when test="${asgn.status == 'marked'}">bg-violet-400</c:when>
                                            <c:otherwise>bg-slate-300</c:otherwise>
                                        </c:choose>">
                                    </div>
                                    <div class="flex-1 min-w-0">
                                        <div class="text-sm font-medium text-slate-900 leading-snug truncate">
                                            ${asgn.title}
                                        </div>
                                        <div class="text-xs text-slate-400 mt-0.5 truncate">
                                            ${asgn.courseName}
                                        </div>
                                        <div class="flex items-center justify-between mt-1.5 gap-2">
                                            <span class="text-xs ${asgn.dueColor}">
                                                <c:choose>
                                                    <c:when test="${asgn.status == 'submitted'}">
                                                        Submitted <fmt:formatDate value="${asgn.submission.submitDate}" pattern="MMM dd"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        Due <fmt:formatDate value="${asgn.dueDate}" pattern="MMM dd"/>
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                            <span class="text-xs px-2.5 py-1 rounded-full font-medium flex-shrink-0 ${asgn.statusClass}">
                                                ${asgn.statusText}
                                            </span>
                                        </div>
                                    </div>
                                </a>
                                <c:if test="${asgn.id == asgnId}" >
                                    <c:set var="selectedAsgn" value="${asgn}" />
                                </c:if>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                   
                </div>
            </div>

            <!-- ── RIGHT PANEL: Assignment detail ── -->
            <div class="flex-1 overflow-y-auto">
                <c:choose>
                    <c:when test="${empty selectedAsgn}">
                        <div class="flex items-center justify-center h-96 lg:h-full">
                            <div class="text-center">
                                <div class="w-14 h-14 rounded-full bg-slate-100 text-slate-300 flex items-center justify-center mx-auto mb-3">
                                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.2"
                                              d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
                                    </svg>
                                </div>
                                <p class="text-sm text-slate-400">Select an assignment to view details</p>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="max-w-2xl mx-auto px-5 sm:px-8 py-8">
                            
                            <!-- Toast -->
                            <%-- Success / Error messages --%>
                            <c:if test="${not empty sessionScope.success}">
                                <div id="taostMsg" class="flex items-center gap-2.5 bg-emerald-50 border border-emerald-100 text-emerald-700 text-sm rounded-xl px-4 py-3 mb-5">
                                    <i class="fa-solid fa-circle-check text-emerald-500"></i>
                                    ${sessionScope.success}
                                </div>
                                <c:remove var="success" scope="session"/>
                            </c:if>
                            <c:if test="${not empty sessionScope.error}">
                                <div id="taostMsg" class="flex items-center gap-2.5 bg-red-50 border border-red-100 text-red-700 text-sm rounded-xl px-4 py-3 mb-5">
                                    <i class="fa-solid fa-circle-exclamation text-red-500"></i>
                                    ${sessionScope.error}
                                </div>
                                <c:remove var="error" scope="session"/>
                            </c:if>
                            
                            <!-- Assignment title + status -->
                            <div class="flex flex-col sm:flex-row sm:items-start justify-between gap-3 mb-6">
                                <div>
                                    <h2 class="text-xl font-bold text-slate-900 leading-snug">
                                    ${selectedAsgn.title}
                                    </h2>
                                    <p class="text-sm text-slate-400 mt-1">
                                        ${selectedAsgn.courseName} · ${selectedAsgn.lecturerName}
                                    </p>
                                </div>
                                <span class="text-xs px-2.5 py-1 rounded-full font-medium flex-shrink-0 ${selectedAsgn.statusClass}">
                                    ${selectedAsgn.statusText}
                                </span>
                            </div>

                            <!-- Info grid -->
                            <div class="grid grid-cols-1 sm:grid-cols-3 gap-3 mb-6">
                                <div class="bg-white border border-slate-100 rounded-xl px-4 py-3">
                                    <div class="text-xs text-slate-400 mb-1">Due date</div>
                                    <div class="text-sm font-semibold ${selectedAsgn.dueColor}">
                                        <fmt:formatDate value="${selectedAsgn.dueDate}" pattern="d MMM Y"/>
                                    </div>
                                    <div class="text-xs text-slate-400"><fmt:formatDate value="${selectedAsgn.dueDate}" pattern="h:mm a"/></div>
                                </div>
                                <div class="bg-white border border-slate-100 rounded-xl px-4 py-3">
                                    <div class="text-xs text-slate-400 mb-1">Max marks</div>
                                    <div class="text-sm font-semibold text-slate-900">${selectedAsgn.maxMarks}</div>
                                </div>
                                <div class="bg-white border border-slate-100 rounded-xl px-4 py-3">
                                    <div class="text-xs text-slate-400 mb-1">Lecturer</div>
                                    <div class="text-sm font-semibold text-slate-900 truncate">${selectedAsgn.lecturerName}</div>
                                </div>
                            </div>

                            <!-- Description -->
                            <div class="bg-white border border-slate-100 rounded-xl px-5 py-4 mb-6">
                                <h3 class="text-xs font-bold text-slate-400 uppercase tracking-wide mb-2">Description</h3>
                                <p class="text-sm text-slate-600 leading-relaxed">
                                    <c:choose>
                                        <c:when test="${not empty selectedAsgn.description}">
                                            <c:set var="newline">
                                            </c:set>
                                            <c:set var="safeText" value="${fn:escapeXml(selectedAsgn.description)}" />
                                            <c:out value="${fn:replace(safeText, newline, '<br/>')}" escapeXml="false" />
                                        </c:when>
                                        <c:otherwise>
                                            No description provided.
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>

                            <!-- ── SUBMISSION AREA ── -->
                            <c:choose>
                                <c:when test="${selectedAsgn.status == 'marked'}">
                                    <!-- Result: marked -->
                                    <div class="bg-violet-50 border border-violet-200 rounded-xl px-5 py-5 mb-6">
                                        <h3 class="text-xs font-bold text-violet-500 uppercase tracking-wide mb-4">Result</h3>
                                        <div class="flex items-baseline gap-2 mb-3">
                                            <span class="text-4xl font-bold text-violet-700">${selectedAsgn.submission.mark}</span>
                                            <span class="text-lg text-violet-400">/ ${selectedAsgn.maxMarks}</span>
                                            <span class="ml-auto text-sm font-semibold text-violet-600">
                                                <fmt:formatNumber value="${selectedAsgn.submission.mark * 100.0 / selectedAsgn.maxMarks}" maxFractionDigits="0"/>%
                                            </span>
                                        </div>
                                        <c:if test="${not empty selectedAsgn.submission.lecturerComment}">
                                            <div class="bg-white border border-violet-100 rounded-lg px-4 py-3 text-sm text-slate-600 leading-relaxed italic">
                                                "${selectedAsgn.submission.lecturerComment}"
                                            </div>
                                            <p class="text-xs text-violet-400 mt-2">— ${selectedAsgn.lecturerName}</p>
                                        </c:if>
                                    </div>
                                </c:when>
                                <c:when test="${selectedAsgn.status == 'submitted'}">
                                    <!-- Submitted, awaiting mark -->
                                    <div class="bg-emerald-50 border border-emerald-200 rounded-xl px-5 py-4 mb-6 flex items-center gap-3">
                                        <svg class="w-5 h-5 text-emerald-600 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                        </svg>
                                        <div>
                                            <div class="text-sm font-semibold text-emerald-700">Submitted successfully</div>
                                            <div class="text-xs text-emerald-600 mt-0.5">
                                                Submitted on <fmt:formatDate value="${selectedAsgn.submission.submitDate}" pattern="d M Y, h:mm a"/> · Awaiting marking
                                            </div>
                                        </div>
                                    </div>
                                            
                                    <c:if test="${not empty selectedAsgn.submission.filePath}">
                                        <div class="bg-white border border-slate-100 rounded-xl px-4 py-3 flex items-center gap-3 mb-6">
                                            <div class="w-8 h-8 rounded-lg bg-blue-50 text-blue-500 flex items-center justify-center flex-shrink-0">
                                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                                          d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13"/>
                                                </svg>
                                            </div>
                                            <div class="flex-1 text-sm text-slate-600">Submitted file attached</div>
                                            <a href="${pageContext.request.contextPath}/${selectedAsgn.submission.filePath}" target="_blank"
                                               class="text-xs font-medium text-blue-600 hover:underline flex-shrink-0">View file</a>
                                        </div>
                                    </c:if>
                                    
                                    <c:if test="${not empty selectedAsgn.submission.answerText}">
                                        <div class="bg-white border border-slate-100 rounded-xl px-5 py-4 mb-6">
                                            <h3 class="text-xs font-bold text-slate-400 uppercase tracking-wide mb-2">Your answer</h3>
                                            <p class="text-sm text-slate-600 leading-relaxed">
                                                <c:set var="newline">
                                                </c:set>
                                                <c:set var="safeText" value="${fn:escapeXml(selectedAsgn.submission.answerText)}" />
                                                <c:out value="${fn:replace(safeText, newline, '<br/>')}" escapeXml="false" />
                                            </p>
                                        </div>
                                    </c:if>
                                </c:when>
                                    
                                <c:otherwise>
                                    <!-- Not submitted — show submit form -->
                                    <div class="bg-white border border-slate-100 rounded-xl px-5 py-5">
                                        <h3 class="text-sm font-bold text-slate-900 mb-4">Submit your answer</h3>

                                        <form method="post" enctype="multipart/form-data" action="submission?filter=${filter}&assignment_id=${selectedAsgn.id}">
                                            <input type="hidden" name="assignment_id" value="${selectedAsgn.id}"/>

                                            <!-- File upload -->
                                            <div class="mb-4">
                                                <label class="block text-xs font-medium text-slate-700 mb-2">Upload file
                                                    <span class="text-slate-400 font-normal">(PDF, DOC, DOCX, image, ZIP · max 20MB)</span>
                                                </label>
                                                <label for="file-input"
                                                       class="flex flex-col items-center justify-center border-2 border-dashed border-slate-200
                                                              rounded-xl py-8 cursor-pointer hover:border-indigo-400 hover:bg-indigo-50/40 transition"
                                                       id="upload-label">
                                                    <svg class="w-8 h-8 text-slate-300 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                                              d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12"/>
                                                    </svg>
                                                    <span class="text-sm text-slate-400" id="file-label-text">Click to upload or drag and drop</span>
                                                    <input type="file" id="file-input" name="submission_file" class="hidden"
                                                           accept=".pdf,.doc,.docx,.jpg,.jpeg,.png,.zip"
                                                           onchange="updateFileLabel(this)"/>
                                                </label>
                                            </div>

                                            <!-- Divider -->
                                            <div class="flex items-center gap-3 mb-4">
                                                <div class="flex-1 h-px bg-slate-100"></div>
                                                <span class="text-xs text-slate-400">or write your answer below</span>
                                                <div class="flex-1 h-px bg-slate-100"></div>
                                            </div>

                                            <!-- Text answer -->
                                            <div class="mb-5">
                                                <textarea name="answer_text" rows="5"
                                                    placeholder="Type your answer here..."
                                                    class="w-full border border-slate-200 rounded-xl px-4 py-3 text-sm text-slate-900
                                                           placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-indigo-100 focus:border-indigo-400 transition resize-none"></textarea>
                                            </div>

                                            <!-- Submit -->
                                            <button type="submit"
                                                    class="w-full py-3 rounded-xl text-sm font-semibold transition
                                                           ${selectedAsgn.status == 'overdue'
                                                                ? 'bg-red-50 text-red-600 border border-red-200 hover:bg-red-100'
                                                                : 'bg-indigo-600 text-white hover:bg-indigo-700 shadow-sm shadow-indigo-200'}">
                                                ${selectedAsgn.status == 'overdue'
                                                    ? 'Submit late answer'
                                                    : 'Submit assignment'}
                                            </button>

                                            <c:if test="${selectedAsgn.status eq 'overdue'}">
                                                <p class="text-xs text-red-400 text-center mt-2">This assignment is past due. Late submissions may be penalised.</p>
                                            </c:if>
                                        </form>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
                     
        <script>
            function updateFileLabel(input) {
                const label = document.getElementById('file-label-text');
                if (input.files && input.files[0]) {
                    label.textContent = '📎 ' + input.files[0].name;
                    label.classList.add('text-slate-700');
                }
            }

            // Drag and drop styling
            const uploadLabel = document.getElementById('upload-label');
            if (uploadLabel) {
                uploadLabel.addEventListener('dragover', e => {
                    e.preventDefault();
                    uploadLabel.classList.add('border-indigo-400', 'bg-indigo-50/40');
                });
                uploadLabel.addEventListener('dragleave', () => {
                    uploadLabel.classList.remove('border-indigo-400', 'bg-indigo-50/40');
                });
                uploadLabel.addEventListener('drop', e => {
                    e.preventDefault();
                    uploadLabel.classList.remove('border-indigo-400', 'bg-indigo-50/40');
                    const file = e.dataTransfer.files[0];
                    if (file) {
                        document.getElementById('file-input').files = e.dataTransfer.files;
                        document.getElementById('file-label-text').textContent = '📎 ' + file.name;
                    }
                });
            }

            // Auto-hide toast
            const toast = document.getElementById('taostMsg');
            if (toast) setTimeout(() => toast.style.display = 'none', 4000);

            const sidebar = document.getElementById('sidebar');
            const overlay = document.getElementById('sidebar-overlay');
            const menuToggle  = document.getElementById('menu-toggle');

            function openSidebar() {
                sidebar.classList.remove('-translate-x-full');
                overlay.classList.remove('hidden');
            }
            function closeSidebar() {
                sidebar.classList.add('-translate-x-full');
                overlay.classList.add('hidden');
            }
            if (menuToggle) {
                menuToggle.addEventListener('click', () => {
                    sidebar.classList.contains('-translate-x-full') ? openSidebar() : closeSidebar();
                });
            }
            if (overlay) {
                overlay.addEventListener('click', closeSidebar);
            }
        </script>
    </body>
</html>
