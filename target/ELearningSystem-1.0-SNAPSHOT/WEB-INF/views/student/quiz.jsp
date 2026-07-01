<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quiz - MyStudyZone</title>
        
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
                   class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">Enroll</a>
                <a href="${pageContext.request.contextPath}/course"
                   class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">My Courses</a>
                <a href="${pageContext.request.contextPath}/assignment"
                   class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">Assignments</a>
                <a href="${pageContext.request.contextPath}/quiz"
                   class="px-4 py-2.5 text-sm font-medium bg-gray-50 text-gray-900">Quiz</a>
                <a href="${pageContext.request.contextPath}/discussion"
                   class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">Discussion</a>
            </nav>
            <a href="${pageContext.request.contextPath}/logout"
               class="px-4 py-2.5 text-sm text-red-500 hover:bg-red-50 mt-auto">Logout</a>
        </aside>
        
        <main class="ml-56 min-h-screen p-8">
            
            <c:choose>
                <c:when test="${screen eq 'list'}">
                    <!-- ══════════════════════════════════════════
                        SCREEN 1: Quiz list
                    ══════════════════════════════════════════ -->
                    <div class="mb-6">
                        <h1 class="text-xl font-semibold text-gray-900">Quizzes</h1>
                        <p class="text-sm text-gray-400 mt-1">${fn:length(quizzes)} quizzes across your enrolled courses</p>
                    </div>

                    <c:choose>
                        <c:when test="${empty quizzes}">
                            <div class="bg-white border border-gray-100 rounded-2xl p-16 text-center">
                                <svg class="w-10 h-10 text-gray-300 mx-auto mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                </svg>
                                <p class="text-sm text-gray-400">No quizzes available yet.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
                                <c:forEach var="quiz" items="${quizzes}">
                                    <c:set var="done" value="${not empty quiz.quizAttempt.submittedAt}" />
                                    <c:set var="in_progress" value="${not empty quiz.quizAttempt and empty quiz.quizAttempt.submittedAt}" />
                                    
                                    <div class="bg-white border border-gray-100 rounded-2xl p-5 flex flex-col hover:border-gray-200 hover:shadow-sm transition
                                                ${done ? 'opacity-80' : '' }">
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

                                        <h3 class="text-sm font-semibold text-gray-900 mb-1">${quiz.title}</h3>
                                        <p class="text-xs text-gray-400 mb-1">${quiz.courseTitle}</p>
                                        <p class="text-xs text-gray-400 mb-4">${quiz.lectName} ·  ${quiz.questionCount} questions</p>

                                        <c:choose>
                                            <c:when test="${done}">
                                                <div class="mt-auto">
                                                    <div class="flex items-baseline gap-1 mb-3">
                                                        <span class="text-2xl font-bold text-violet-700">${quiz.quizAttempt.score}</span>
                                                        <span class="text-sm text-gray-400">/ ${quiz.questionCount}</span>
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
                                                    <a href="quiz?screen=result&quiz_id=${quiz.quizId}&attempt_id=${quiz.quizAttempt.attemptId}"
                                                       class="block w-full text-center py-2.5 rounded-xl text-sm font-medium bg-gray-100 text-gray-600 hover:bg-gray-200 transition">
                                                        View result
                                                    </a>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="mt-auto">
                                                    <a href="quiz?screen=entry&quiz_id=${quiz.quizId}"
                                                       class="block w-full text-center py-2.5 rounded-xl text-sm font-medium
                                                              ${in_progress ? 'bg-amber-500 text-white hover:bg-amber-600' : 'bg-gray-900 text-white hover:bg-gray-700'} transition">
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
                    <div class="max-w-md mx-auto mt-12">
                        <a href="quiz" class="inline-flex items-center gap-1.5 text-sm text-gray-400 hover:text-gray-700 mb-8 transition">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 19l-7-7 7-7"/>
                            </svg>
                            Back to quizzes
                        </a>

                        <div class="bg-white border border-gray-100 rounded-2xl p-8">
                            <!-- Icon -->
                            <div class="w-14 h-14 rounded-2xl bg-indigo-50 text-indigo-600 flex items-center justify-center mx-auto mb-5">
                                <svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                                </svg>
                            </div>
                            
                            
                            <c:choose>
                                <c:when test="${not empty quizDetails}">
                                    <h2 class="text-lg font-semibold text-gray-900 text-center mb-1">${quizDetails.title}</h2>
                                    <p class="text-sm text-gray-400 text-center mb-6">
                                        ${quizDetails.courseTitle} · ${quizDetails.lectName} · ${quizDetails.questionCount} questions
                                    </p>
                                </c:when>
                                <c:otherwise>
                                    <h2 class="text-lg font-semibold text-gray-900 text-center mb-1">Enter Quiz Code</h2>
                                    <p class="text-sm text-gray-400 text-center mb-6">Enter the code given by your lecturer to start</p>
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
                                <input type="hidden" name="quiz_id" value="${quizDetails.quizId}"/>

                                <label class="block text-xs font-medium text-gray-700 mb-3 text-center">Quiz code</label>
                                <!-- 6 individual boxes -->
                                <div class="flex justify-center gap-2 mb-2" id="code-boxes">
                                    <c:forEach var="i" begin="0" end="5">
                                        <input type="text" maxlength="1"
                                           id="code-${i}"
                                           class="w-11 h-12 text-center text-lg font-bold border border-gray-200 rounded-xl
                                                  focus:outline-none focus:border-gray-900 uppercase transition"
                                           oninput="codeInput(this, ${i})"
                                           onkeydown="codeBack(event, ${i})"/>
                                    </c:forEach>
                                </div>
                                <!-- Hidden combined input -->
                                <input type="hidden" name="quiz_code" id="quiz_code_hidden"/>
                                <p class="text-xs text-gray-400 text-center mb-6">Enter the 6-character code from your lecturer</p>

                                <button type="submit" name="enter_code" value="1"
                                        onclick="combineCode()"
                                        class="w-full py-3 rounded-xl text-sm font-semibold bg-gray-900 text-white hover:bg-gray-700 transition">
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
                        <div class="flex items-center justify-between mb-6">
                            <div>
                                <h1 class="text-lg font-semibold text-gray-900">${quizInfo.title}</h1>
                                <p class="text-sm text-gray-400">${quizInfo.courseTitle} · ${quizInfo.lectName}</p>
                            </div>
                            <!-- Timer -->
                            <div id="timer-box" class="flex items-center gap-2 bg-white border border-gray-200 rounded-xl px-4 py-2.5 text-sm font-semibold">
                                <svg class="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <circle cx="12" cy="12" r="9"/><path stroke-linecap="round" d="M12 7v5l3 3"/>
                                </svg>
                                <span id="timer-text">--:--</span>
                            </div>
                        </div>

                        <!-- Progress bar -->
                        <div class="mb-6">
                            <div class="flex justify-between text-xs text-gray-400 mb-2">
                                <span id="q-progress-label">Question 1 of ${fn:length(questions)}</span>
                                <span id="ans-count">0 answered</span>
                            </div>
                            <div class="h-1.5 bg-gray-100 rounded-full overflow-hidden">
                                <div id="prog-bar" class="h-full bg-indigo-500 rounded-full transition-all duration-300" style="width:0%"></div>
                            </div>
                        </div>

                        <!-- Question navigator dots -->
                        <div class="flex flex-wrap gap-2 mb-6" id="q-nav">
                            <c:forEach var="question" items="${questions}" varStatus="status">
                                <button type="button" onclick="goToQuestion(${status.index})"
                                        id="dot-${status.index}"
                                        class="w-8 h-8 rounded-full border text-xs font-medium transition
                                               ${question.savedAnswer ? 'bg-indigo-100 border-indigo-300 text-indigo-700' : 'border-gray-200 text-gray-500 hover:border-gray-400' }">
                                    ${status.index + 1}
                                </button>
                            </c:forEach>
                        </div>

                        <!-- Question card -->
                        <form method="POST" action="quiz.php" id="quiz-form">
                            <input type="hidden" name="quiz_id"    value="${quizId}"/>
                            <input type="hidden" name="attempt_id" value="${attemptId}"/>
                            <input type="hidden" name="submit_quiz" value="1"/>

                            <c:forEach var="question" items="${questions}" varStatus="status">
                                <div class="question-card ${status.index == 0 ? '' : 'hidden' }" id="qcard-${status.index}">
                                    <div class="bg-white border border-gray-100 rounded-2xl p-6 mb-4">
                                        <p class="text-xs text-gray-400 mb-3">Question ${status.index + 1} of ${fn:length(questions)}
                                            <c:if test="${question.marks > 1}">
                                                · ${question.marks} marks
                                            </c:if>
                                        </p>
                                        <p class="text-base font-medium text-gray-900 leading-relaxed mb-5">
                                            ${question.questionText}
                                        </p>

                                        <div class="flex flex-col gap-2.5">
                                            <c:forEach var="opt" items="${question.options}">
                                                <label class="option-label flex items-center gap-3 p-3.5 border border-gray-200 rounded-xl cursor-pointer
                                                              hover:border-indigo-300 hover:bg-indigo-50 transition
                                                              ${question.savedAnswer == opt.optionId ? 'border-indigo-400 bg-indigo-50' : '' }"
                                                       id="label-${question.questionId}-${opt.optionId}">
                                                    <input type="radio"
                                                           name="answers[${question.questionId}]"
                                                           value="${opt.optionId}"
                                                           ${question.savedAnswer == opt.optionId ? 'checked' : '' }
                                                           onchange="selectOption(${status.index}, ${question.questionId}, ${opt.optionId})"
                                                           class="hidden"/>
                                                    <div class="w-5 h-5 rounded-full border-2 flex-shrink-0 flex items-center justify-center transition
                                                                ${question.savedAnswer == opt.optionId ? 'border-indigo-500 bg-indigo-500' : 'border-gray-300' }"
                                                         id="circle-${question.questionId}-${opt.optionId}">
                                                        <div class="w-2 h-2 rounded-full bg-white ${question.savedAnswer == opt.optionId ? '' : 'hidden' }"
                                                             id="dot-inner-${question.questionId}-${opt.optionId}"></div>
                                                    </div>
                                                    <span class="text-sm text-gray-700">${opt.optionText}</span>
                                                </label>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>

                            <!-- Navigation buttons -->
                            <div class="flex justify-between items-center">
                                <button type="button" id="btn-prev" onclick="prevQ()"
                                        class="px-5 py-2.5 rounded-xl border border-gray-200 text-sm text-gray-600 hover:bg-gray-100 transition invisible">
                                    ← Previous
                                </button>
                                <button type="button" id="btn-next" onclick="nextQ()"
                                        class="px-6 py-2.5 rounded-xl bg-gray-900 text-white text-sm font-medium hover:bg-gray-700 transition">
                                    Next →
                                </button>
                                <button type="submit" id="btn-submit"
                                        onclick="return confirmSubmit()"
                                        class="hidden px-6 py-2.5 rounded-xl bg-indigo-600 text-white text-sm font-medium hover:bg-indigo-700 transition">
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
                           class="inline-flex items-center gap-1.5 text-sm text-gray-400 hover:text-gray-700 mb-8 transition">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round"
                                      stroke-width="1.5" d="M15 19l-7-7 7-7"/>
                            </svg>
                            Back to quizzes
                        </a>

                        <!-- Score card -->
                        <div class="bg-white border border-gray-100 rounded-2xl p-8 text-center mb-6">

                            <div class="w-24 h-24 rounded-full border-4 ${gradeBorder} ${gradeBg}
                                        flex flex-col items-center justify-center mx-auto mb-5">

                                <span class="text-3xl font-bold ${gradeText}">
                                    ${score}
                                </span>

                                <span class="text-xs text-gray-400">
                                    / ${totalQ}
                                </span>
                            </div>

                            <h2 class="text-xl font-semibold text-gray-900 mb-1">
                                <c:out value="${resultData.title}"/>
                            </h2>

                            <p class="text-sm text-gray-400 mb-6">
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
                                    <div class="text-xs text-gray-400 mt-0.5">
                                        Correct
                                    </div>
                                </div>

                                <div class="bg-red-50 rounded-xl px-4 py-3">
                                    <div class="text-2xl font-bold text-red-600">
                                        ${wrong}
                                    </div>
                                    <div class="text-xs text-gray-400 mt-0.5">
                                        Wrong
                                    </div>
                                </div>

                                <div class="${gradeBg} rounded-xl px-4 py-3">
                                    <div class="text-2xl font-bold ${gradeText}">
                                        ${pct}%
                                    </div>
                                    <div class="text-xs text-gray-400 mt-0.5">
                                        Score
                                    </div>
                                </div>

                            </div>
                        </div>

                        <!-- Answer breakdown -->
                        <c:if test="${not empty answersbd}">
                            <div class="bg-white border border-gray-100 rounded-2xl p-6">

                                <h3 class="text-sm font-semibold text-gray-900 mb-4">
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

                                                <span class="text-xs text-gray-700">
                                                    <c:out value="${item.questionText}"/>
                                                </span>

                                            </div>

                                            <div class="text-xs text-gray-500 ml-6">

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
                        box.classList.remove('border-gray-200');
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
                    document.querySelectorAll(`[id^="label-${qId}-"]`).forEach(lbl => {
                        lbl.classList.remove('border-indigo-400','bg-indigo-50');
                        lbl.classList.add('border-gray-200');
                    });
                    document.querySelectorAll(`[id^="circle-${qId}-"]`).forEach(c => {
                        c.classList.remove('border-indigo-500','bg-indigo-500');
                        c.classList.add('border-gray-300');
                    });
                    document.querySelectorAll(`[id^="dot-inner-${qId}-"]`).forEach(d => d.classList.add('hidden'));

                    document.getElementById(`label-${qId}-${optId}`).classList.add('border-indigo-400','bg-indigo-50');
                    document.getElementById(`label-${qId}-${optId}`).classList.remove('border-gray-200');
                    const circle = document.getElementById(`circle-${qId}-${optId}`);
                    circle.classList.add('border-indigo-500','bg-indigo-500');
                    circle.classList.remove('border-gray-300');
                    document.getElementById(`dot-inner-${qId}-${optId}`).classList.remove('hidden');

                    // Update dot navigator
                    const dot = document.getElementById('dot-' + qIdx);
                    dot.classList.add('bg-indigo-100','border-indigo-300','text-indigo-700');
                    dot.classList.remove('border-gray-200','text-gray-500');

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
        </script>
    </body>
</html>