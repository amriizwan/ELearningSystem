<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <script src="https://cdn.tailwindcss.com"></script>
        <script src="https://kit.fontawesome.com/7ac8763a86.js" crossorigin="anonymous"></script>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <title>Quizzes — MyStudyZone Lecturer</title>
        <style>
            body { font-family: 'Inter', ui-sans-serif, system-ui, sans-serif; }
            .line-clamp-2{display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden}
        </style>
    </head>
<body class="bg-slate-50 text-slate-900 antialiased">

<%--
    Replaces: require_once '../includes/lecturer_sidebar.php'
    In Jakarta EE we use a static include for the sidebar partial.
--%>
        <aside class="w-64 bg-white border-r border-slate-100 flex flex-col py-6 fixed h-full">
            <div class="px-6 mb-8 flex items-center gap-2.5">
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
                    Dashboard</a>
                <a href="${pageContext.request.contextPath}/course"
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-500 hover:bg-slate-50 hover:text-slate-900 transition">
                    <i class="fa-solid fa-book-open w-4 text-center"></i>
                    My Courses</a>
                <a href="${pageContext.request.contextPath}/note"
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-500 hover:bg-slate-50 hover:text-slate-900 transition">
                    <i class="fa-regular fa-file-lines w-4 text-center"></i>
                    Notes</a>
                <a href="${pageContext.request.contextPath}/assignment"
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-500 hover:bg-slate-50 hover:text-slate-900 transition">
                    <i class="fa-solid fa-file-lines w-4 text-center"></i>
                    Assignments</a>
                <a href="${pageContext.request.contextPath}/quiz"
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-semibold bg-indigo-50 text-indigo-700 transition">
                    <i class="fa-solid fa-square-poll-vertical w-4 text-center"></i>
                    Quiz</a>
                <a href="${pageContext.request.contextPath}/discussion"
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-500 hover:bg-slate-50 hover:text-slate-900 transition">
                    <i class="fa-solid fa-comments w-4 text-center"></i>
                    Discussion</a>
            </nav>
            <div class="px-3 mt-auto">
                <a href="${pageContext.request.contextPath}/logout"
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-medium text-red-500 hover:bg-red-50 transition">
                    <i class="fa-solid fa-arrow-right-from-bracket w-4 text-center"></i>
                    Logout</a>
            </div>
        </aside>

<%--
    Pick up a flash error message stored in session by the servlet
    (set when a POST action fails validation).
--%>
<c:set var="flashError" value="${sessionScope.flashError}"/>
<c:remove var="flashError" scope="session"/>

<main class="lg:ml-64 min-h-screen flex">

    <!-- ── LEFT: Course list ── -->
    <div class="w-64 flex-shrink-0 bg-white border-r border-slate-100 flex flex-col min-h-screen">
        <div class="px-5 py-5 border-b border-slate-100">
            <h1 class="text-base font-semibold text-slate-900">Quizzes</h1>
            <p class="text-xs text-slate-400 mt-0.5">Create &amp; manage quizzes</p>
        </div>
        <div class="flex-1 overflow-y-auto py-2">
            <%-- PHP: foreach ($courses as $c) --%>
            <c:forEach var="c" items="${courses}">
                <c:set var="active" value="${c.id == courseId}"/>
                <a href="${pageContext.request.contextPath}/quiz?course_id=${c.id}"
                   class="flex items-center justify-between px-4 py-3 border-l-2 transition
                          <c:choose>
                              <c:when test='${active}'>bg-slate-50 border-indigo-600</c:when>
                              <c:otherwise>border-transparent hover:bg-slate-50 hover:border-slate-200</c:otherwise>
                          </c:choose>">
                    <div class="min-w-0 flex-1">
                        <div class="text-sm font-medium text-slate-900 truncate">${fn:escapeXml(c.title)}</div>
                        <div class="text-xs text-slate-400 mt-0.5">${c.quizCount} quizzes</div>
                    </div>
                </a>
            </c:forEach>
        </div>
    </div>

    <!-- ── RIGHT: Content ── -->
    <div class="flex-1 overflow-y-auto">

        <!-- Toast — replaces PHP $url_msg block -->
        <c:if test="${not empty urlMsg}">
            <c:set var="toastClass" value=""/>
            <c:set var="toastMsg"   value=""/>
            <c:choose>
                <c:when test="${urlMsg == 'created'}">
                    <c:set var="toastClass" value="bg-emerald-50 border-emerald-200 text-emerald-700"/>
                    <c:set var="toastMsg"   value="Quiz created! Now add your questions."/>
                </c:when>
                <c:when test="${urlMsg == 'edited'}">
                    <c:set var="toastClass" value="bg-blue-50 border-blue-200 text-blue-700"/>
                    <c:set var="toastMsg"   value="Quiz updated!"/>
                </c:when>
                <c:when test="${urlMsg == 'deleted'}">
                    <c:set var="toastClass" value="bg-slate-50 border-slate-200 text-slate-600"/>
                    <c:set var="toastMsg"   value="Quiz deleted."/>
                </c:when>
                <c:when test="${urlMsg == 'question_added'}">
                    <c:set var="toastClass" value="bg-indigo-50 border-indigo-200 text-indigo-700"/>
                    <c:set var="toastMsg"   value="Question added!"/>
                </c:when>
            </c:choose>
            <div id="toast" class="mx-8 mt-6 flex items-center gap-2 border px-4 py-3 rounded-xl text-sm ${toastClass}">
                <svg class="w-4 h-4 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                          d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                ${toastMsg}
            </div>
        </c:if>

        <!-- ══════════════════════════════════════════════════════════
             VIEW: new — CREATE QUIZ FORM
             PHP: if ($view === 'new')
        ═══════════════════════════════════════════════════════════ -->
        <c:if test="${view == 'new'}">
            <div class="max-w-xl mx-auto px-8 py-8">
                <div class="flex items-center gap-3 mb-6">
                    <a href="${pageContext.request.contextPath}/quiz?course_id=${courseId}" class="text-slate-400 hover:text-slate-700">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 19l-7-7 7-7"/>
                        </svg>
                    </a>
                    <h2 class="text-lg font-semibold">Create quiz</h2>
                </div>

                <%-- Validation error (flash from session) --%>
                <c:if test="${not empty flashError}">
                    <div class="bg-red-50 border border-red-200 text-red-700 text-sm px-4 py-3 rounded-xl mb-5">
                        ${fn:escapeXml(flashError)}
                    </div>
                </c:if>

                <form method="POST" action="${pageContext.request.contextPath}/quiz?course_id=${courseId}&view=new"
                      class="bg-white border border-slate-100 rounded-2xl p-6 flex flex-col gap-4">
                    <input type="hidden" name="action" value="create_quiz"/>

                    <div>
                        <label class="block text-xs font-medium text-slate-700 mb-1.5">Course</label>
                        <select name="SelectedCourseId" required
                                class="w-full border border-slate-200 rounded-xl px-4 py-2.5 text-sm bg-white focus:outline-none focus:border-slate-400 transition">
                            <c:forEach var="c" items="${courses}">
                                <option value="${c.id}" <c:if test="${c.id == courseId}">selected</c:if>>
                                    ${fn:escapeXml(c.title)}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div>
                        <label class="block text-xs font-medium text-slate-700 mb-1.5">
                            Quiz title <span class="text-red-400">*</span>
                        </label>
                        <input type="text" name="title" required placeholder="e.g. Week 3 — OSI Model Quiz"
                               class="w-full border border-slate-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:border-slate-400 transition"/>
                    </div>

                    <div>
                        <label class="block text-xs font-medium text-slate-700 mb-1.5">
                            Quiz code <span class="text-red-400">*</span>
                            <span class="text-slate-400 font-normal ml-1">(6 characters, shared with students)</span>
                        </label>
                        <div class="flex gap-2">
                            <%-- generatedCode set by servlet (replaces PHP generate_code()) --%>
                            <input type="text" name="quiz_code" id="quiz-code" required maxlength="6"
                                   placeholder="e.g. ABC123"
                                   value="${generatedCode}"
                                   class="flex-1 border border-slate-200 rounded-xl px-4 py-2.5 text-sm uppercase font-mono
                                          focus:outline-none focus:border-slate-400 transition tracking-widest"/>
                            <button type="button" onclick="regenerateCode()"
                                    class="px-4 py-2.5 rounded-xl border border-slate-200 text-sm text-slate-600 hover:bg-slate-100 transition">
                                🔄 Generate
                            </button>
                        </div>
                        <p class="text-xs text-slate-400 mt-1.5">Students enter this code to access the quiz.</p>
                    </div>

                    <div class="flex gap-3 pt-2">
                        <button type="submit"
                                class="flex-1 py-2.5 rounded-xl bg-indigo-600 text-white text-sm font-medium hover:bg-indigo-700 transition">
                            Create quiz &amp; add questions
                        </button>
                        <a href="${pageContext.request.contextPath}/quiz?course_id=${courseId}"
                           class="px-5 py-2.5 rounded-xl border border-slate-200 text-sm text-slate-600 hover:bg-slate-100 transition">
                            Cancel
                        </a>
                    </div>
                </form>
            </div>
        </c:if>

        <!-- ══════════════════════════════════════════════════════════
             VIEW: edit — EDIT QUIZ FORM
             PHP: elseif ($view === 'edit' && $selected_quiz)
        ═══════════════════════════════════════════════════════════ -->
        <c:if test="${view == 'edit' and not empty selectedQuiz}">
            <div class="max-w-xl mx-auto px-8 py-8">
                <div class="flex items-center gap-3 mb-6">
                    <a href="${pageContext.request.contextPath}/quiz?course_id=${courseId}" class="text-slate-400 hover:text-slate-700">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 19l-7-7 7-7"/>
                        </svg>
                    </a>
                    <h2 class="text-lg font-semibold">Edit quiz</h2>
                </div>

                <c:if test="${not empty flashError}">
                    <div class="bg-red-50 border border-red-200 text-red-700 text-sm px-4 py-3 rounded-xl mb-5">
                        ${fn:escapeXml(flashError)}
                    </div>
                </c:if>

                <form method="POST"
                      action="${pageContext.request.contextPath}/quiz?course_id=${courseId}&quiz_id=${quizId}&view=edit"
                      class="bg-white border border-slate-100 rounded-2xl p-6 flex flex-col gap-4">
                    <input type="hidden" name="action"    value="edit_quiz"/>
                    <input type="hidden" name="quiz_id"   value="${selectedQuiz.id}"/>
                    <input type="hidden" name="course_id" value="${courseId}"/>

                    <div>
                        <label class="block text-xs font-medium text-slate-700 mb-1.5">Quiz title</label>
                        <input type="text" name="title" required value="${fn:escapeXml(selectedQuiz.title)}"
                               class="w-full border border-slate-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:border-slate-400 transition"/>
                    </div>

                    <div>
                        <label class="block text-xs font-medium text-slate-700 mb-1.5">Quiz code</label>
                        <div class="flex gap-2">
                            <input type="text" name="quiz_code" id="quiz-code" required maxlength="6"
                                   value="${fn:escapeXml(selectedQuiz.quizCode)}"
                                   class="flex-1 border border-slate-200 rounded-xl px-4 py-2.5 text-sm uppercase font-mono
                                          focus:outline-none focus:border-slate-400 transition tracking-widest"/>
                            <button type="button" onclick="regenerateCode()"
                                    class="px-4 py-2.5 rounded-xl border border-slate-200 text-sm text-slate-600 hover:bg-slate-100 transition">
                                🔄 New code
                            </button>
                        </div>
                    </div>

                    <div class="flex gap-3 pt-2">
                        <button type="submit"
                                class="flex-1 py-2.5 rounded-xl bg-indigo-600 text-white text-sm font-medium hover:bg-indigo-700 transition">
                            Save changes
                        </button>
                        <a href="${pageContext.request.contextPath}/quiz?course_id=${courseId}&quiz_id=${quizId}&view=questions"
                           class="px-5 py-2.5 rounded-xl border border-slate-200 text-sm text-slate-600 hover:bg-slate-100 transition">
                            Cancel
                        </a>
                    </div>
                </form>
            </div>
        </c:if>

        <!-- ══════════════════════════════════════════════════════════
             VIEW: questions — MANAGE QUESTIONS
             PHP: elseif ($view === 'questions' && $selected_quiz)
        ═══════════════════════════════════════════════════════════ -->
        <c:if test="${view == 'questions' and not empty selectedQuiz}">
            <div class="p-8">
                <!-- Header -->
                <div class="flex items-center justify-between mb-6">
                    <div class="flex items-center gap-3">
                        <a href="${pageContext.request.contextPath}/quiz?course_id=${courseId}" class="text-slate-400 hover:text-slate-700">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 19l-7-7 7-7"/>
                            </svg>
                        </a>
                        <div>
                            <h2 class="text-lg font-semibold text-slate-900">${fn:escapeXml(selectedQuiz.title)}</h2>
                            <div class="flex items-center gap-3 mt-0.5">
                                <span class="text-sm text-slate-400">${fn:length(questions)} questions</span>
                                <span class="text-xs font-mono font-semibold text-indigo-600 bg-indigo-50 px-2.5 py-1 rounded-lg tracking-widest">
                                    ${fn:escapeXml(selectedQuiz.quizCode)}
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="flex gap-2">
                        <a href="${pageContext.request.contextPath}/quiz?course_id=${courseId}&quiz_id=${quizId}&view=results"
                           class="px-4 py-2 rounded-xl border border-slate-200 text-sm text-slate-600 hover:bg-slate-100 transition">
                            View results
                        </a>
                        <a href="${pageContext.request.contextPath}/quiz?course_id=${courseId}&quiz_id=${quizId}&view=edit"
                           class="px-4 py-2 rounded-xl border border-slate-200 text-sm text-slate-600 hover:bg-slate-100 transition">
                            Edit quiz
                        </a>
                    </div>
                </div>

                <div class="grid grid-cols-2 gap-6">

                    <!-- Existing questions list -->
                    <div>
                        <h3 class="text-xs font-semibold text-slate-400 uppercase tracking-wide mb-3">Questions</h3>

                        <c:choose>
                            <c:when test="${empty questions}">
                                <div class="bg-white border border-dashed border-slate-200 rounded-2xl p-10 text-center">
                                    <p class="text-sm text-slate-400">No questions yet.</p>
                                    <p class="text-xs text-slate-400 mt-1">Add your first question using the form →</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="flex flex-col gap-3">
                                    <%-- PHP: foreach ($questions as $qi => $q) --%>
                                    <c:forEach var="q" items="${questions}" varStatus="status">
                                        <div class="bg-white border border-slate-100 rounded-xl p-4">
                                            <div class="flex items-start justify-between gap-2 mb-3">
                                                <div class="flex items-start gap-2 flex-1 min-w-0">
                                                    <span class="text-xs font-bold text-slate-400 flex-shrink-0 mt-0.5">Q${status.count}</span>
                                                    <p class="text-sm font-medium text-slate-900 leading-snug">
                                                        ${fn:escapeXml(q.questionText)}
                                                    </p>
                                                </div>
                                                <!-- Delete question form -->
                                                <form method="POST"
                                                      action="${pageContext.request.contextPath}/quiz?course_id=${courseId}&quiz_id=${quizId}&view=questions"
                                                      onsubmit="return confirm('Delete this question?')">
                                                    <input type="hidden" name="action"      value="delete_question"/>
                                                    <input type="hidden" name="question_id" value="${q.id}"/>
                                                    <input type="hidden" name="quiz_id"     value="${quizId}"/>
                                                    <input type="hidden" name="course_id"   value="${courseId}"/>
                                                    <button type="submit" class="text-slate-300 hover:text-red-500 transition flex-shrink-0">
                                                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                                                  d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                                                        </svg>
                                                    </button>
                                                </form>
                                            </div>

                                            <!-- Options -->
                                            <div class="flex flex-col gap-1.5">
                                                <c:forEach var="opt" items="${q.options}">
                                                    <div class="flex items-center gap-2 text-xs px-3 py-1.5 rounded-lg
                                                                ${opt.correct ? 'bg-emerald-50 text-emerald-700 font-medium' : 'bg-slate-50 text-slate-600'}">
                                                        <c:choose>
                                                            <c:when test="${opt.correct}">
                                                                <svg class="w-3.5 h-3.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                                                                </svg>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="w-3.5 h-3.5 rounded-full border border-slate-300 flex-shrink-0"></div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        ${fn:escapeXml(opt.optionText)}
                                                    </div>
                                                </c:forEach>
                                            </div>

                                            <div class="flex items-center gap-2 mt-2">
                                                <%-- PHP: str_replace('_',' ',$q['question_type']) → use model's displayType getter --%>
                                                <span class="text-[10px] text-slate-400 uppercase">${q.getDisplayType()}</span>
                                                <span class="text-[10px] text-slate-400">
                                                    · ${q.marks} mark<c:if test="${q.marks != 1}">s</c:if>
                                                </span>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Add question form -->
                    <div>
                        <h3 class="text-xs font-semibold text-slate-400 uppercase tracking-wide mb-3">Add question</h3>
                        <form method="POST"
                              action="${pageContext.request.contextPath}/quiz?course_id=${courseId}&quiz_id=${quizId}&view=questions"
                              class="bg-white border border-slate-100 rounded-2xl p-5 flex flex-col gap-4" id="add-q-form">
                            <input type="hidden" name="action"    value="add_question"/>
                            <input type="hidden" name="quiz_id"   value="${quizId}"/>
                            <input type="hidden" name="course_id" value="${courseId}"/>

                            <!-- Question type -->
                            <div>
                                <label class="block text-xs font-medium text-slate-700 mb-1.5">Type</label>
                                <div class="flex gap-2">
                                    <label class="flex-1 cursor-pointer">
                                        <input type="radio" name="question_type" value="multiple_choice" class="hidden peer" checked
                                               onchange="setQuestionType('multiple_choice')"/>
                                        <div class="text-center py-2 rounded-xl border border-slate-200 text-xs font-medium text-slate-500
                                                    peer-checked:border-indigo-300 peer-checked:bg-indigo-50 peer-checked:text-indigo-700 transition">
                                            Multiple choice
                                        </div>
                                    </label>
                                    <label class="flex-1 cursor-pointer">
                                        <input type="radio" name="question_type" value="true_false" class="hidden peer"
                                               onchange="setQuestionType('true_false')"/>
                                        <div class="text-center py-2 rounded-xl border border-slate-200 text-xs font-medium text-slate-500
                                                    peer-checked:border-indigo-300 peer-checked:bg-indigo-50 peer-checked:text-indigo-700 transition">
                                            True / False
                                        </div>
                                    </label>
                                </div>
                            </div>

                            <!-- Question text -->
                            <div>
                                <label class="block text-xs font-medium text-slate-700 mb-1.5">Question</label>
                                <textarea name="question_text" rows="3" required
                                          placeholder="Type your question here..."
                                          class="w-full border border-slate-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:border-slate-400 transition resize-none"></textarea>
                            </div>

                            <!-- Options -->
                            <div id="options-wrap">
                                <label class="block text-xs font-medium text-slate-700 mb-2">
                                    Options <span class="text-slate-400 font-normal">(tick the correct answer)</span>
                                </label>
                                <%--
                                    PHP rendered 4 option rows with a for loop.
                                    In JSP without scriptlets we use JSTL forEach over a fixed range.
                                --%>
                                <div class="flex flex-col gap-2" id="options-list">
                                    <c:forEach begin="0" end="3" var="i">
                                        <div class="flex items-center gap-2">
                                            <input type="radio" name="correct" value="${i}"
                                                   <c:if test="${i == 0}">checked</c:if>
                                                   class="w-4 h-4 accent-indigo-600 flex-shrink-0"/>
                                            <%--
                                                Option label A=65, B=66 ... as char.
                                                EL doesn't support chr(), so we map via c:choose.
                                            --%>
                                            <c:set var="optLabel">
                                                <c:choose>
                                                    <c:when test="${i == 0}">A</c:when>
                                                    <c:when test="${i == 1}">B</c:when>
                                                    <c:when test="${i == 2}">C</c:when>
                                                    <c:otherwise>D</c:otherwise>
                                                </c:choose>
                                            </c:set>
                                            <input type="text" name="options[]" required placeholder="Option ${optLabel}"
                                                   class="flex-1 border border-slate-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:border-slate-400 transition"/>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>

                            <!-- Marks -->
                            <div>
                                <label class="block text-xs font-medium text-slate-700 mb-1.5">Marks for this question</label>
                                <input type="number" name="marks" value="1" min="1" max="10"
                                       class="w-24 border border-slate-200 rounded-xl px-4 py-2 text-sm focus:outline-none focus:border-slate-400 transition text-center"/>
                            </div>

                            <button type="submit"
                                    class="w-full py-2.5 rounded-xl bg-indigo-600 text-white text-sm font-medium hover:bg-indigo-700 transition">
                                Add question
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- ══════════════════════════════════════════════════════════
             VIEW: results — RESULTS TABLE
             PHP: elseif ($view === 'results' && $selected_quiz)
        ═══════════════════════════════════════════════════════════ -->
        <c:if test="${view == 'results' and not empty selectedQuiz}">
            <div class="p-8">
                <div class="flex items-center gap-3 mb-6">
                    <a href="${pageContext.request.contextPath}/quiz?course_id=${courseId}&quiz_id=${quizId}&view=questions"
                       class="text-slate-400 hover:text-slate-700">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 19l-7-7 7-7"/>
                        </svg>
                    </a>
                    <div>
                        <h2 class="text-lg font-semibold">${fn:escapeXml(selectedQuiz.title)} — Results</h2>
                        <p class="text-sm text-slate-400">${fn:length(results)} attempts</p>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${empty results}">
                        <div class="bg-white border border-slate-100 rounded-2xl p-16 text-center">
                            <p class="text-sm text-slate-400">
                                No attempts yet. Share the quiz code
                                <span class="font-mono font-semibold text-indigo-600">${fn:escapeXml(selectedQuiz.quizCode)}</span>
                                with your students.
                            </p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Summary stats — computed by servlet into ResultStats bean -->
                        <div class="grid grid-cols-3 gap-4 mb-6">
                            <div class="bg-white border border-slate-100 rounded-xl px-5 py-4 text-center">
                                <div class="text-2xl font-bold text-slate-900">${stats.avgPct}%</div>
                                <div class="text-xs text-slate-400 mt-1">Average score</div>
                            </div>
                            <div class="bg-emerald-50 border border-emerald-100 rounded-xl px-5 py-4 text-center">
                                <div class="text-2xl font-bold text-emerald-700">${stats.highPct}%</div>
                                <div class="text-xs text-slate-400 mt-1">Highest score</div>
                            </div>
                            <div class="bg-red-50 border border-red-100 rounded-xl px-5 py-4 text-center">
                                <div class="text-2xl font-bold text-red-600">${stats.lowPct}%</div>
                                <div class="text-xs text-slate-400 mt-1">Lowest score</div>
                            </div>
                        </div>

                        <!-- Results table -->
                        <div class="bg-white border border-slate-100 rounded-2xl overflow-hidden">
                            <table class="w-full text-sm">
                                <thead>
                                    <tr class="border-b border-slate-100 bg-slate-50">
                                        <th class="text-left px-5 py-3 text-xs font-semibold text-slate-500">Student</th>
                                        <th class="text-center px-4 py-3 text-xs font-semibold text-slate-500">Score</th>
                                        <th class="text-center px-4 py-3 text-xs font-semibold text-slate-500">Percentage</th>
                                        <th class="text-center px-4 py-3 text-xs font-semibold text-slate-500">Grade</th>
                                        <th class="text-right px-5 py-3 text-xs font-semibold text-slate-500">Submitted</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-slate-50">
                                    <%-- PHP: foreach ($results as $i => $r) --%>
                                    <c:forEach var="r" items="${results}" varStatus="status">
                                        <tr class="hover:bg-slate-50 transition">
                                            <td class="px-5 py-3">
                                                <div class="flex items-center gap-2">
                                                    <div class="w-7 h-7 rounded-full bg-slate-100 text-slate-600 flex items-center justify-center text-xs font-semibold">
                                                        <%-- PHP: strtoupper(substr($r['student_name'],0,2)) → model method --%>
                                                        ${r.avatarText}
                                                    </div>
                                                    <span class="font-medium text-slate-900">${fn:escapeXml(r.studentName)}</span>
                                                    <c:if test="${status.first}">
                                                        <span class="text-[10px] text-amber-600">🏆 Top</span>
                                                    </c:if>
                                                </div>
                                            </td>
                                            <td class="px-4 py-3 text-center font-semibold text-slate-900">
                                                ${r.score}/${r.totalQuestions}
                                            </td>
                                            <td class="px-4 py-3 text-center">
                                                <div class="flex items-center justify-center gap-2">
                                                    <div class="w-20 h-1.5 bg-slate-100 rounded-full overflow-hidden">
                                                        <%-- PHP: style="width:<?= $pct ?>%" --%>
                                                        <div class="h-full rounded-full ${r.gradeBgClass} opacity-70"
                                                             style="width:${r.percentage}%"></div>
                                                    </div>
                                                    <span class="text-sm font-semibold ${r.gradeTextClass}">${r.percentage}%</span>
                                                </div>
                                            </td>
                                            <td class="px-4 py-3 text-center">
                                                <span class="text-xs font-bold px-2.5 py-1 rounded-full ${r.gradeBgClass} ${r.gradeTextClass}">
                                                    ${r.gradeLetter}
                                                </span>
                                            </td>
                                            <td class="px-5 py-3 text-right text-xs text-slate-400">
                                                <%-- PHP: date('d M Y, g:i A', strtotime($r['submitted_at'])) --%>
                                               ${r.submittedAtFormatted}
                                                <%--
                                                    Note: fmt:formatDate works with java.util.Date.
                                                    If submittedAt is LocalDateTime, convert in the model or use a custom EL function.
                                                    Alternatively expose a getSubmittedAtDate() returning java.util.Date.
                                                --%>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <!-- ══════════════════════════════════════════════════════════
             VIEW: list (default) — QUIZ LIST
             PHP: else (the default view)
        ═══════════════════════════════════════════════════════════ -->
        <c:if test="${view == 'list' or (view != 'new' and view != 'edit' and view != 'questions' and view != 'results')}">
            <div class="p-8">
                <div class="flex items-center justify-between mb-6">
                    <div>
                        <h2 class="text-lg font-semibold">
                            <c:choose>
                                <c:when test="${not empty selectedCourse}">${fn:escapeXml(selectedCourse.title)}</c:when>
                                <c:otherwise>Quizzes</c:otherwise>
                            </c:choose>
                        </h2>
                        <p class="text-sm text-slate-400 mt-0.5">${fn:length(quizzes)} quizzes</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/quiz?course_id=${courseId}&view=new"
                       class="flex items-center gap-2 px-4 py-2.5 rounded-xl bg-indigo-600 text-white text-sm font-medium hover:bg-indigo-700 transition">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                        </svg>
                        New quiz
                    </a>
                </div>

                <c:choose>
                    <c:when test="${empty quizzes}">
                        <div class="bg-white border border-slate-100 rounded-2xl p-16 text-center">
                            <svg class="w-10 h-10 text-slate-300 mx-auto mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.2"
                                      d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"/>
                            </svg>
                            <p class="text-sm text-slate-400">No quizzes yet.</p>
                            <a href="${pageContext.request.contextPath}/quiz?course_id=${courseId}&view=new"
                               class="inline-block mt-3 text-sm text-indigo-600 hover:underline">Create your first quiz →</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                            <c:forEach var="q" items="${quizzes}">
                                <div class="bg-white border border-slate-100 rounded-2xl p-5 hover:border-slate-200 hover:shadow-sm transition">
                                    <div class="flex items-start justify-between mb-3">
                                        <div class="w-10 h-10 rounded-xl bg-indigo-50 text-indigo-600 flex items-center justify-center flex-shrink-0">
                                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                                      d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"/>
                                            </svg>
                                        </div>
                                        <span class="text-sm font-mono font-bold text-indigo-600 bg-indigo-50 px-3 py-1 rounded-lg tracking-widest">
                                            ${fn:escapeXml(q.quizCode)}
                                        </span>
                                    </div>

                                    <h3 class="text-sm font-semibold text-slate-900 mb-1">${fn:escapeXml(q.title)}</h3>
                                    <p class="text-xs text-slate-400 mb-4">
                                        ${q.questionCount} questions · ${q.attemptCount} attempts
                                        <c:if test="${q.attemptCount > 0}">
                                            · Avg <fmt:formatNumber value="${q.avgScore}" maxFractionDigits="0"/>/${q.questionCount}
                                        </c:if>
                                    </p>

                                    <div class="flex gap-2">
                                        <a href="${pageContext.request.contextPath}/quiz?course_id=${courseId}&quiz_id=${q.id}&view=questions"
                                           class="flex-1 text-center py-2 rounded-xl border border-slate-200 text-xs text-slate-600 hover:bg-slate-100 transition font-medium">
                                            Questions
                                        </a>
                                        <a href="${pageContext.request.contextPath}/quiz?course_id=${courseId}&quiz_id=${q.id}&view=results"
                                           class="flex-1 text-center py-2 rounded-xl border border-slate-200 text-xs text-slate-600 hover:bg-slate-100 transition font-medium">
                                            Results
                                        </a>
                                        <form method="POST" action="${pageContext.request.contextPath}/quiz?course_id=${courseId}"
                                              onsubmit="return confirm('Delete this quiz? All student attempts will also be deleted.')">
                                            <input type="hidden" name="action"    value="delete_quiz"/>
                                            <input type="hidden" name="quiz_id"   value="${q.id}"/>
                                            <input type="hidden" name="course_id" value="${courseId}"/>
                                            <button type="submit"
                                                    class="py-2 px-3 rounded-xl border border-slate-200 text-xs text-slate-500 hover:bg-red-50 hover:text-red-600 hover:border-red-200 transition">
                                                Delete
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>

    </div>
</main>

<script>
// Auto-dismiss toast after 4 seconds — identical to original PHP page JS
const toast = document.getElementById('toast');
if (toast) setTimeout(() => { toast.style.opacity='0'; setTimeout(()=>toast.remove(),300); }, 4000);

// Generate a random 6-char code client-side (same charset as PHP generate_code())
function regenerateCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    let code = '';
    for (let i = 0; i < 6; i++) code += chars[Math.floor(Math.random() * chars.length)];
    document.getElementById('quiz-code').value = code;
}

// Toggle options list between multiple-choice (4 options) and true/false (2 options)
function setQuestionType(type) {
    const list = document.getElementById('options-list');
    if (type === 'true_false') {
        list.innerHTML = `
            <div class="flex items-center gap-2">
                <input type="radio" name="correct" value="0" checked class="w-4 h-4 accent-indigo-600"/>
                <input type="text" name="options[]" value="True" readonly
                       class="flex-1 border border-slate-200 rounded-lg px-3 py-2 text-sm bg-slate-50 text-slate-600"/>
            </div>
            <div class="flex items-center gap-2">
                <input type="radio" name="correct" value="1" class="w-4 h-4 accent-indigo-600"/>
                <input type="text" name="options[]" value="False" readonly
                       class="flex-1 border border-slate-200 rounded-lg px-3 py-2 text-sm bg-slate-50 text-slate-600"/>
            </div>`;
    } else {
        list.innerHTML = ['A','B','C','D'].map((l,i) => `
            <div class="flex items-center gap-2">
                <input type="radio" name="correct" value="${i}"  class="w-4 h-4 accent-indigo-600"/>
                <input type="text" name="options[]" required placeholder="Option ${l}"
                       class="flex-1 border border-slate-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:border-slate-400 transition"/>
            </div>`).join('');
    }
}
</script>
</body>
</html>
