<%-- 
    Document   : quiz
    Created on : 23 Jun 2026, 5:42:10 pm
    Author     : User
--%>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@page import="com.mycompany.elearningsystem.model.Course"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quiz - MyStudyZone</title>
        
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
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-500 hover:bg-slate-50 hover:text-slate-900 transition">
                    <i class="fa-solid fa-file-lines w-4 text-center"></i>
                    Assignments
                </a>
                <a href="${pageContext.request.contextPath}/quiz"
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-semibold bg-indigo-50 text-indigo-700 transition">
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
        
        <main class="lg:ml-64 min-h-screen p-5 sm:p-8">
            
            <c:choose>
                <c:when test="${screen eq 'list'}">
                    <!-- ══════════════════════════════════════════
                        SCREEN 1: Quiz list
                    ══════════════════════════════════════════ -->
                    <div class="mb-8">
                        <h1 class="text-2xl font-bold text-slate-900 tracking-tight">Quizzes</h1>
                        <p class="text-sm text-slate-400 mt-1.5">${fn:length(quizzes)} quizzes across your enrolled courses</p>
                    </div>

                    <c:choose>
                        <c:when test="${empty quizzes}">
                            <div class="bg-white border border-dashed border-slate-200 rounded-2xl p-16 text-center">
                                <div class="w-14 h-14 rounded-full bg-slate-50 text-slate-300 flex items-center justify-center mx-auto mb-3">
                                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                    </svg>
                                </div>
                                <p class="text-sm text-slate-400">No quizzes available yet.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
                                <c:forEach var="quiz" items="${quizzes}">
                                    <c:set var="done" value="${not empty quiz.quizAttempt.submittedAt}" />
                                    <c:set var="in_progress" value="${not empty quiz.quizAttempt and empty quiz.quizAttempt.submittedAt}" />
                                    
                                    <div class="bg-white border border-slate-100 rounded-2xl p-5 flex flex-col hover:border-slate-200 hover:shadow-md transition
                                                ${done ? 'opacity-90' : '' }">
                                        <!-- Top -->
                                        <div class="flex items-start justify-between mb-3">
                                            <div class="w-10 h-10 rounded-xl bg-indigo-50 text-indigo-600 flex items-center justify-center">
                                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"/>
                                                </svg>
                                            </div>
                                            <c:choose>
                                                <c:when test="${done}">
                                                    <span class="text-xs px-2.5 py-1 rounded-full bg-violet-100 text-violet-700 font-medium">Completed</span>
                                                </c:when>
                                                <c:when test="${in_progress}">
                                                    <span class="text-xs px-2.5 py-1 rounded-full bg-amber-100 text-amber-700 font-medium">In progress</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-xs px-2.5 py-1 rounded-full bg-emerald-100 text-emerald-700 font-medium">Open</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <h3 class="text-sm font-bold text-slate-900 mb-1">${quiz.title}</h3>
                                        <p class="text-xs text-slate-400 mb-1">${quiz.courseTitle}</p>
                                        <p class="text-xs text-slate-400 mb-4">${quiz.lectName} ·  ${quiz.questionCount} questions</p>

                                        <c:choose>
                                            <c:when test="${done}">
                                                <div class="mt-auto">
                                                    <div class="flex items-baseline gap-1 mb-3">
                                                        <span class="text-2xl font-bold text-violet-700">${quiz.quizAttempt.score}</span>
                                                        <span class="text-sm text-slate-400">/ ${quiz.questionCount}</span>
                                                        <span class="ml-auto text-sm font-semibold text-violet-600">
                                                            <c:choose>
                                                                <c:when test="${quiz.questionCount > 0}">
                                                                    <fmt:formatNumber value="${quiz.quizAttempt.score / quiz.questionCount * 100.0}" maxFractionDigits="0" />%
                                                                </c:when>
                                                                <c:otherwise>
                                                                    0%
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </div>
                                                    <a href="quiz?screen=result&quiz_id=${quiz.id}&attempt_id=${quiz.quizAttempt.id}"
                                                       class="block w-full text-center py-2.5 rounded-xl text-sm font-medium bg-slate-100 text-slate-600 hover:bg-slate-200 transition">
                                                        View result
                                                    </a>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="mt-auto">
                                                    <a href="quiz?screen=entry&quiz_id=${quiz.id}"
                                                       class="block w-full text-center py-2.5 rounded-xl text-sm font-medium transition
                                                              ${in_progress ? 'bg-amber-500 text-white hover:bg-amber-600' : 'bg-indigo-600 text-white hover:bg-indigo-700 shadow-sm shadow-indigo-200'}">
                                                        ${in_progress ? 'Resume quiz' : 'Enter code & start'}
                                                    </a>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:when>
                <c:when test="${screen eq 'entry'}">
                    <!-- ══════════════════════════════════════════
                        SCREEN 2: Code entry
                    ══════════════════════════════════════════ -->
                    <div class="max-w-md mx-auto mt-4 sm:mt-12">
                        <a href="quiz" class="inline-flex items-center gap-1.5 text-sm text-slate-400 hover:text-slate-700 mb-8 transition">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 19l-7-7 7-7"/>
                            </svg>
                            Back to quizzes
                        </a>

                        <div class="bg-white border border-slate-100 rounded-2xl p-6 sm:p-8 shadow-sm">
                            <!-- Icon -->
                            <div class="w-14 h-14 rounded-2xl bg-indigo-50 text-indigo-600 flex items-center justify-center mx-auto mb-5">
                                <svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                                </svg>
                            </div>
                            
                            
                            <c:choose>
                                <c:when test="${not empty quizDetails}">
                                    <h2 class="text-lg font-bold text-slate-900 text-center mb-1">${quizDetails.title}</h2>
                                    <p class="text-sm text-slate-400 text-center mb-6">
                                        ${quizDetails.courseTitle} · ${quizDetails.lectName} · ${quizDetails.questionCount} questions
                                    </p>
                                </c:when>
                                <c:otherwise>
                                    <h2 class="text-lg font-bold text-slate-900 text-center mb-1">Enter Quiz Code</h2>
                                    <p class="text-sm text-slate-400 text-center mb-6">Enter the code given by your lecturer to start</p>
                                </c:otherwise>
                            </c:choose>
                                    
                            <c:if test="${not empty error}">
                                <div class="flex items-center gap-2 bg-red-50 border border-red-200 text-red-700 text-sm px-4 py-3 rounded-xl mb-5">
                                    <svg class="w-4 h-4 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                    </svg>
                                    ${error}
                                </div>
                            </c:if>

                            <form method="POST" action="quiz?screen=entry">
                                <input type="hidden" name="quiz_id" value="${quizDetails.id}"/>

                                <label class="block text-xs font-medium text-slate-700 mb-3 text-center">Quiz code</label>
                                <!-- 6 individual boxes -->
                                <div class="flex justify-center gap-2 mb-2" id="code-boxes">
                                    <c:forEach var="i" begin="0" end="5">
                                        <input type="text" maxlength="1"
                                           id="code-${i}"
                                           class="w-11 h-12 text-center text-lg font-bold border border-slate-200 rounded-xl
                                                  focus:outline-none focus:ring-2 focus:ring-indigo-100 focus:border-indigo-500 uppercase transition"
                                           oninput="codeInput(this, ${i})"
                                           onkeydown="codeBack(event, ${i})"/>
                                    </c:forEach>
                                </div>
                                <!-- Hidden combined input -->
                                <input type="hidden" name="quiz_code" id="quiz_code_hidden"/>
                                <p class="text-xs text-slate-400 text-center mb-6">Enter the 6-character code from your lecturer</p>

                                <button type="submit" name="enter_code" value="1"
                                        onclick="combineCode()"
                                        class="w-full py-3 rounded-xl text-sm font-semibold bg-indigo-600 text-white hover:bg-indigo-700 shadow-sm shadow-indigo-200 transition">
                                    Start quiz
                                </button>
                            </form>
                        </div>
                    </div>
                </c:when>
                <c:when test="${screen eq 'quiz' and not empty questions}">
                    <!-- ══════════════════════════════════════════
                         SCREEN 3: Taking the quiz
                    ══════════════════════════════════════════ -->
                    <div class="max-w-2xl mx-auto">

                        <!-- Quiz header -->
                        <div class="flex items-center justify-between mb-6 gap-3">
                            <div class="min-w-0">
                                <h1 class="text-lg font-bold text-slate-900 truncate">${quizInfo.title}</h1>
                                <p class="text-sm text-slate-400 truncate">${quizInfo.courseTitle} · ${quizInfo.lectName}</p>
                            </div>
                            <!-- Timer -->
                            <div id="timer-box" class="flex items-center gap-2 bg-white border border-slate-200 rounded-xl px-4 py-2.5 text-sm font-semibold flex-shrink-0">
                                <svg class="w-4 h-4 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <circle cx="12" cy="12" r="9"/><path stroke-linecap="round" d="M12 7v5l3 3"/>
                                </svg>
                                <span id="timer-text">--:--</span>
                            </div>
                        </div>

                        <!-- Progress bar -->
                        <div class="mb-6">
                            <div class="flex justify-between text-xs text-slate-400 mb-2">
                                <span id="q-progress-label">Question 1 of ${fn:length(questions)}</span>
                                <span id="ans-count">0 answered</span>
                            </div>
                            <div class="h-1.5 bg-slate-100 rounded-full overflow-hidden">
                                <div id="prog-bar" class="h-full bg-indigo-500 rounded-full transition-all duration-300" style="width:0%"></div>
                            </div>
                        </div>

                        <!-- Question navigator dots -->
                        <div class="flex flex-wrap gap-2 mb-6" id="q-nav">
                            <c:forEach var="question" items="${questions}" varStatus="status">
                                <button type="button" onclick="goToQuestion(${status.index})"
                                        id="dot-${status.index}"
                                        class="w-8 h-8 rounded-full border text-xs font-medium transition
                                               ${question.savedAnswer ? 'bg-indigo-100 border-indigo-300 text-indigo-700' : 'border-slate-200 text-slate-500 hover:border-indigo-300' }">
                                    ${status.index + 1}
                                </button>
                            </c:forEach>
                        </div>

                        <!-- Question card -->
                        <form method="POST" action="quiz" id="quiz-form">
                            <input type="hidden" name="quiz_id"    value="${quizId}"/>
                            <input type="hidden" name="attempt_id" value="${attemptId}"/>
                            <input type="hidden" name="submit_quiz" value="1"/>

                            <c:forEach var="question" items="${questions}" varStatus="status">
                                <div class="question-card ${status.index == 0 ? '' : 'hidden' }" id="qcard-${status.index}">
                                    <div class="bg-white border border-slate-100 rounded-2xl p-6 mb-4 shadow-sm">
                                        <p class="text-xs text-slate-400 mb-3">Question ${status.index + 1} of ${fn:length(questions)}
                                            <c:if test="${question.marks > 1}">
                                                · ${question.marks} marks
                                            </c:if>
                                        </p>
                                        <p class="text-base font-medium text-slate-900 leading-relaxed mb-5">
                                            ${question.questionText}
                                        </p>

                                        <div class="flex flex-col gap-2.5">
                                            <c:forEach var="opt" items="${question.options}">
                                                <label class="option-label flex items-center gap-3 p-3.5 border border-slate-200 rounded-xl cursor-pointer
                                                              hover:border-indigo-300 hover:bg-indigo-50 transition
                                                              ${question.savedAnswer == opt.id ? 'border-indigo-400 bg-indigo-50' : '' }"
                                                       id="label-${question.id}-${opt.id}">
                                                    <input type="radio"
                                                           name="answers[${question.id}]"
                                                           value="${opt.id}"
                                                           ${question.savedAnswer == opt.id ? 'checked' : '' }
                                                           onchange="selectOption(${status.index}, ${question.id}, ${opt.id})"
                                                           class="hidden"/>
                                                    <div class="w-5 h-5 rounded-full border-2 flex-shrink-0 flex items-center justify-center transition
                                                                ${question.savedAnswer == opt.id ? 'border-indigo-500 bg-indigo-500' : 'border-slate-300' }"
                                                         id="circle-${question.id}-${opt.id}">
                                                        <div class="w-2 h-2 rounded-full bg-white ${question.savedAnswer == opt.id ? '' : 'hidden' }"
                                                             id="dot-inner-${question.id}-${opt.id}"></div>
                                                    </div>
                                                    <span class="text-sm text-slate-700">${opt.optionText}</span>
                                                </label>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>

                            <!-- Navigation buttons -->
                            <div class="flex justify-between items-center">
                                <button type="button" id="btn-prev" onclick="prevQ()"
                                        class="px-5 py-2.5 rounded-xl border border-slate-200 text-sm text-slate-600 hover:bg-slate-100 transition invisible">
                                    ← Previous
                                </button>
                                <button type="button" id="btn-next" onclick="nextQ()"
                                        class="px-6 py-2.5 rounded-xl bg-indigo-600 text-white text-sm font-medium hover:bg-indigo-700 shadow-sm shadow-indigo-200 transition">
                                    Next →
                                </button>
                                <button type="submit" id="btn-submit"
                                        onclick="return confirmSubmit()"
                                        class="hidden px-6 py-2.5 rounded-xl bg-indigo-600 text-white text-sm font-medium hover:bg-indigo-700 shadow-sm shadow-indigo-200 transition">
                                    Submit quiz
                                </button>
                            </div>
                        </form>
                    </div>
                </c:when>
                <c:when test="${screen eq 'result' and not empty resultData}">
                    <!-- ══════════════════════════════════════════
                        SCREEN 4: Result
                    ══════════════════════════════════════════ -->

                    <c:set var="score" value="${resultData.score}" />
                    <c:set var="totalQ" value="${resultData.totalQuestions}" />
                    <c:set var="pct" value="${totalQ > 0 ? (score * 100 / totalQ) : 0}" />
                    <fmt:formatNumber var="pct" value="${pct}" maxFractionDigits="0"/>
                    <c:set var="wrong" value="${totalQ - score}" />

                    <c:choose>
                        <c:when test="${pct >= 80}">
                            <c:set var="gradeText" value="text-emerald-600"/>
                            <c:set var="gradeBorder" value="border-emerald-400"/>
                            <c:set var="gradeBg" value="bg-emerald-50"/>
                        </c:when>

                        <c:when test="${pct >= 60}">
                            <c:set var="gradeText" value="text-blue-600"/>
                            <c:set var="gradeBorder" value="border-blue-400"/>
                            <c:set var="gradeBg" value="bg-blue-50"/>
                        </c:when>

                        <c:when test="${pct >= 40}">
                            <c:set var="gradeText" value="text-amber-600"/>
                            <c:set var="gradeBorder" value="border-amber-400"/>
                            <c:set var="gradeBg" value="bg-amber-50"/>
                        </c:when>

                        <c:otherwise>
                            <c:set var="gradeText" value="text-red-600"/>
                            <c:set var="gradeBorder" value="border-red-400"/>
                            <c:set var="gradeBg" value="bg-red-50"/>
                        </c:otherwise>
                    </c:choose>

                    <div class="max-w-xl mx-auto">
                        <a href="quiz"
                           class="inline-flex items-center gap-1.5 text-sm text-slate-400 hover:text-slate-700 mb-8 transition">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round"
                                      stroke-width="1.5" d="M15 19l-7-7 7-7"/>
                            </svg>
                            Back to quizzes
                        </a>

                        <!-- Score card -->
                        <div class="bg-white border border-slate-100 rounded-2xl p-8 text-center mb-6 shadow-sm">

                            <div class="w-24 h-24 rounded-full border-4 ${gradeBorder} ${gradeBg}
                                        flex flex-col items-center justify-center mx-auto mb-5">

                                <span class="text-3xl font-bold ${gradeText}">
                                    ${score}
                                </span>

                                <span class="text-xs text-slate-400">
                                    / ${totalQ}
                                </span>
                            </div>

                            <h2 class="text-xl font-bold text-slate-900 mb-1">
                                <c:out value="${resultData.quizTitle}"/>
                            </h2>

                            <p class="text-sm text-slate-400 mb-6">
                                <c:out value="${resultData.courseTitle}"/>
                                · Submitted
                                <fmt:formatDate value="${resultData.submittedAt}"
                                                pattern="dd MMM yyyy, h:mm a"/>
                            </p>

                            <!-- Breakdown -->
                            <div class="grid grid-cols-3 gap-3">

                                <div class="bg-emerald-50 rounded-xl px-4 py-3">
                                    <div class="text-2xl font-bold text-emerald-700">
                                        ${score}
                                    </div>
                                    <div class="text-xs text-slate-400 mt-0.5">
                                        Correct
                                    </div>
                                </div>

                                <div class="bg-red-50 rounded-xl px-4 py-3">
                                    <div class="text-2xl font-bold text-red-600">
                                        ${wrong}
                                    </div>
                                    <div class="text-xs text-slate-400 mt-0.5">
                                        Wrong
                                    </div>
                                </div>

                                <div class="${gradeBg} rounded-xl px-4 py-3">
                                    <div class="text-2xl font-bold ${gradeText}">
                                        ${pct}%
                                    </div>
                                    <div class="text-xs text-slate-400 mt-0.5">
                                        Score
                                    </div>
                                </div>

                            </div>
                        </div>

                        <!-- Answer breakdown -->
                        <c:if test="${not empty answersbd}">
                            <div class="bg-white border border-slate-100 rounded-2xl p-6 shadow-sm">

                                <h3 class="text-sm font-bold text-slate-900 mb-4">
                                    Answer review
                                </h3>

                                <div class="flex flex-col gap-3">

                                    <c:forEach var="item" items="${answersbd}" varStatus="status">

                                        <div class="border
                                            ${item.selectedCorrect ? 'border-emerald-200 bg-emerald-50'
                                                           : 'border-red-200 bg-red-50'}
                                            rounded-xl px-4 py-3">

                                            <div class="flex items-start gap-2 mb-2">

                                                <span class="text-xs font-semibold
                                                    ${item.selectedCorrect ? 'text-emerald-600'
                                                                   : 'text-red-600'}
                                                    flex-shrink-0 mt-0.5">

                                                    ${item.selectedCorrect ? '✓' : '✗'}
                                                    Q${status.index + 1}
                                                </span>

                                                <span class="text-xs text-slate-700">
                                                    <c:out value="${item.questionText}"/>
                                                </span>

                                            </div>

                                            <div class="text-xs text-slate-500 ml-6">

                                                Your answer:

                                                <span class="font-medium
                                                    ${item.selectedCorrect ? 'text-emerald-700'
                                                                   : 'text-red-700'}">

                                                    <c:out value="${item.selectedOption}"/>

                                                </span>

                                                <c:if test="${not item.selectedCorrect}">
                                                    · Correct:
                                                    <span class="font-medium text-emerald-700">
                                                        <c:out value="${item.correctOption}"/>
                                                    </span>
                                                </c:if>

                                            </div>

                                        </div>

                                    </c:forEach>

                                </div>

                            </div>
                        </c:if>

                    </div>
                </c:when>
                <c:otherwise></c:otherwise>
            </c:choose>
        </main>
               
        <script>
            // ══════════════════════════════
            // CODE ENTRY: 6-box input
            // ══════════════════════════════
            function codeInput(el, idx) {
                el.value = el.value.toUpperCase().replace(/[^A-Z0-9]/g,'');
                if (el.value && idx < 5) document.getElementById('code-' + (idx + 1)).focus();
            }
            function codeBack(e, idx) {
                if (e.key === 'Backspace' && !document.getElementById('code-' + idx).value && idx > 0) {
                    document.getElementById('code-' + (idx - 1)).focus();
                }
            }
            function combineCode() {
                let code = '';
                for (let i = 0; i < 6; i++) {
                    code += (document.getElementById('code-' + i)?.value || '');
                }
                document.getElementById('quiz_code_hidden').value = code;
            }

            // ══════════════════════════════
            // QUIZ TAKING
            // ══════════════════════════════
            <c:if test="${screen eq 'quiz'}">
                const totalQ   = ${fn:length(questions)};
                let   currentQ = 0;
                const answered = [
                    <c:forEach var="q" items="${questions}" varStatus="status">
                        ${q.savedAnswer != null}
                        <c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                    ];

                // Timer: 30 seconds per question
                let totalSec = totalQ * 30;

                function updateTimer() {
                    const m   = Math.floor(totalSec / 60);
                    const s   = totalSec % 60;
                    const txt = m + ':' + (s < 10 ? '0' : '') + s;
                    document.getElementById('timer-text').textContent = txt;

                    const box = document.getElementById('timer-box');
                    if (totalSec <= 60) {
                        box.classList.add('border-red-300', 'bg-red-50', 'text-red-600');
                        box.classList.remove('border-slate-200');
                    }
                    if (totalSec <= 0) {
                        clearInterval(timerInterval);
                        document.getElementById('quiz-form').submit();
                    }
                    totalSec--;
                }
                const timerInterval = setInterval(updateTimer, 1000);
                updateTimer();

                function goToQuestion(idx) {
                    document.getElementById('qcard-' + currentQ).classList.add('hidden');
                    document.getElementById('dot-' + currentQ).classList.remove('ring-2', 'ring-indigo-400');
                    currentQ = idx;
                    document.getElementById('qcard-' + currentQ).classList.remove('hidden');
                    document.getElementById('dot-' + currentQ).classList.add('ring-2', 'ring-indigo-400');
                    updateNav();
                }

                function nextQ() { if (currentQ < totalQ - 1) goToQuestion(currentQ + 1); }
                function prevQ() { if (currentQ > 0)           goToQuestion(currentQ - 1); }

                function selectOption(qIdx, qId, optId) {
                    answered[qIdx] = true;

                    // Update all labels for this question
                    document.querySelectorAll('[id^="label-' + qId + '-"]').forEach(function(lbl) {
                        lbl.classList.remove('border-indigo-400', 'bg-indigo-50');
                        lbl.classList.add('border-slate-200');
                    });

                    document.querySelectorAll('[id^="circle-' + qId + '-"]').forEach(function(c) {
                        c.classList.remove('border-indigo-500', 'bg-indigo-500');
                        c.classList.add('border-slate-300');
                    });

                    document.querySelectorAll('[id^="dot-inner-' + qId + '-"]').forEach(function(d) {
                        d.classList.add('hidden');
                    });

                    document.getElementById('label-' + qId + '-' + optId)
                            .classList.add('border-indigo-400', 'bg-indigo-50');
                    document.getElementById('label-' + qId + '-' + optId)
                            .classList.remove('border-slate-200');

                    var circle = document.getElementById('circle-' + qId + '-' + optId);
                    circle.classList.add('border-indigo-500', 'bg-indigo-500');
                    circle.classList.remove('border-slate-300');

                    document.getElementById('dot-inner-' + qId + '-' + optId)
                            .classList.remove('hidden');

                    // Update dot navigator
                    var dot = document.getElementById('dot-' + qIdx);
                    dot.classList.add('bg-indigo-100', 'border-indigo-300', 'text-indigo-700');
                    dot.classList.remove('border-slate-200', 'text-slate-500');

                    updateNav();
                }

                function updateNav() {
                    const ansCount = answered.filter(Boolean).length;
                    const pct      = Math.round(ansCount / totalQ * 100);

                    document.getElementById('q-progress-label').textContent = 'Question ' + (currentQ + 1) + ' of ' + totalQ;
                    document.getElementById('ans-count').textContent        = ansCount + ' answered';
                    document.getElementById('prog-bar').style.width         = pct + '%';

                    document.getElementById('btn-prev').classList.toggle('invisible', currentQ === 0);
                    const isLast = currentQ === totalQ - 1;
                    document.getElementById('btn-next').classList.toggle('hidden', isLast);
                    document.getElementById('btn-submit').classList.toggle('hidden', !isLast);
                }

                function confirmSubmit() {
                    const unanswered = answered.filter(v => !v).length;
                    if (unanswered > 0) {
                        return confirm(`You have ${unanswered} unanswered question(s). Submit anyway?`);
                    }
                    return true;
                }

                updateNav();
            </c:if>

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
