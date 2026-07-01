<%-- FILE 5: web/lecturer/dashboard.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Dashboard — MyStudyZone</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 text-gray-900">

<%-- Sidebar include --%>
 <aside class="w-52 bg-white border-r border-gray-100 flex flex-col py-5 fixed h-full">
    <div class="px-4 mb-6">
        <span class="text-base font-semibold text-gray-900">MyStudyZone</span>
        <span class="block text-xs text-gray-400 mt-0.5">Lecturer portal</span>
    </div>
    <nav class="flex flex-col gap-0.5 flex-1">
        <a href="${pageContext.request.contextPath}/dashboard"
           class="px-4 py-2.5 text-sm font-medium bg-gray-50 text-gray-900">Dashboard</a>
        <a href="${pageContext.request.contextPath}/course"
           class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">My Courses</a>
        <a href="${pageContext.request.contextPath}/note"
           class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">Notes</a>
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

<%--
    Palette list — used to cycle colors across course cards.
    We define them as arrays and pick by index % size inside the forEach.
    Because JSTL has no modulo on arrays, we use varStatus.index % 6 and
    a <c:choose> block for the 6 palettes.
--%>

<main class="ml-56 min-h-screen p-8">

    <%-- ── Header ── --%>
    <div class="mb-8">
        <h1 class="text-xl font-semibold text-gray-900">${greeting}, ${firstName} !</h1>
        <p class="text-sm text-gray-400 mt-1">${today}</p>
    </div>

    <%-- ── Stat cards ── --%>
    <div class="grid grid-cols-5 gap-4 mb-8">

        <div class="bg-white border border-gray-100 rounded-xl p-5">
            <p class="text-xs text-gray-400 mb-2">Courses teaching</p>
            <p class="text-3xl font-semibold text-gray-900">${course_count}</p>
        </div>

        <div class="bg-white border border-gray-100 rounded-xl p-5">
            <p class="text-xs text-gray-400 mb-2">Total students</p>
            <p class="text-3xl font-semibold text-gray-900">${student_count}</p>
        </div>

        <div class="bg-white border border-gray-100 rounded-xl p-5">
            <p class="text-xs text-gray-400 mb-2">Pending to mark</p>
            <p class="text-3xl font-semibold ${pending_mark > 0 ? 'text-amber-500' : 'text-gray-900'}">
                ${pending_mark}
            </p>
            <c:if test="${pending_mark > 0}">
                <p class="text-xs text-amber-500 mt-1">needs attention</p>
            </c:if>
        </div>

        <div class="bg-white border border-gray-100 rounded-xl p-5">
            <p class="text-xs text-gray-400 mb-2">Notes uploaded</p>
            <p class="text-3xl font-semibold text-gray-900">${notes_count}</p>
        </div>

        <div class="bg-white border border-gray-100 rounded-xl p-5">
            <p class="text-xs text-gray-400 mb-2">Quizzes created</p>
            <p class="text-3xl font-semibold text-gray-900">${quiz_count}</p>
        </div>

    </div>

    <%-- ── Main grid ── --%>
    <div class="grid grid-cols-3 gap-6">

        <%-- My courses (col 1-2) --%>
        <div class="col-span-2">
            <div class="flex items-center justify-between mb-4">
                <h2 class="text-sm font-semibold text-gray-700">My courses</h2>
                <a href="lectureCourses" class="text-xs text-gray-400 hover:text-gray-700 transition">View all →</a>
            </div>

            <c:choose>
                <c:when test="${empty courses}">
                    <div class="bg-white border border-gray-100 rounded-xl p-10 text-center">
                        <p class="text-sm text-gray-400">You haven't been assigned to any courses yet.</p>
                        <p class="text-xs text-gray-400 mt-1">Contact your admin to get assigned.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="grid grid-cols-2 gap-3 mb-6">
                        <c:forEach var="course" items="${courses}" varStatus="status">

                            <%--
                                Palette cycling: 6 palettes, pick by index % 6.
                                We set bg/text/bar variables using <c:set> inside a <c:choose>.
                            --%>
                            <c:set var="paletteIndex" value="${status.index % 6}" />
                            <c:choose>
                                <c:when test="${paletteIndex == 0}">
                                    <c:set var="pBg"   value="bg-emerald-50" />
                                    <c:set var="pText" value="text-emerald-600" />
                                </c:when>
                                <c:when test="${paletteIndex == 1}">
                                    <c:set var="pBg"   value="bg-violet-50" />
                                    <c:set var="pText" value="text-violet-600" />
                                </c:when>
                                <c:when test="${paletteIndex == 2}">
                                    <c:set var="pBg"   value="bg-amber-50" />
                                    <c:set var="pText" value="text-amber-600" />
                                </c:when>
                                <c:when test="${paletteIndex == 3}">
                                    <c:set var="pBg"   value="bg-blue-50" />
                                    <c:set var="pText" value="text-blue-600" />
                                </c:when>
                                <c:when test="${paletteIndex == 4}">
                                    <c:set var="pBg"   value="bg-rose-50" />
                                    <c:set var="pText" value="text-rose-600" />
                                </c:when>
                                <c:otherwise>
                                    <c:set var="pBg"   value="bg-teal-50" />
                                    <c:set var="pText" value="text-teal-600" />
                                </c:otherwise>
                            </c:choose>

                            <div class="bg-white border border-gray-100 rounded-xl p-4 hover:border-gray-200 hover:shadow-sm transition cursor-pointer"
                                 onclick="location.href='lectureCourses'">
                                <div class="flex items-center gap-3 mb-3">
                                    <div class="w-9 h-9 rounded-lg flex items-center justify-center flex-shrink-0 ${pBg} ${pText}">
                                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                                  d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/>
                                        </svg>
                                    </div>
                                    <div class="flex-1 min-w-0">
                                        <div class="text-sm font-medium text-gray-900 truncate">${fn:escapeXml(course.title)}</div>
                                        <div class="text-xs text-gray-400 mt-0.5">${course.enrollmentCount} students</div>
                                    </div>
                                </div>
                                <%-- Mini stats --%>
                                <div class="grid grid-cols-3 gap-2 text-center">
                                    <div class="bg-gray-50 rounded-lg py-2">
                                        <div class="text-sm font-semibold text-gray-900">${course.noteCount}</div>
                                        <div class="text-[10px] text-gray-400">Notes</div>
                                    </div>
                                    <div class="bg-gray-50 rounded-lg py-2">
                                        <div class="text-sm font-semibold text-gray-900">${course.enrollmentCount}</div>
                                        <div class="text-[10px] text-gray-400">Assignments</div>
                                    </div>
                                    <div class="bg-gray-50 rounded-lg py-2">
                                        <div class="text-sm font-semibold text-gray-900">${course.quizCount}</div>
                                        <div class="text-[10px] text-gray-400">Quizzes</div>
                                    </div>
                                </div>
                            </div>

                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>

            <%-- Pending submissions --%>
            <div>
                <div class="flex items-center justify-between mb-4">
                    <h2 class="text-sm font-semibold text-gray-700">
                        Pending submissions
                        <c:if test="${pending_mark > 0}">
                            <span class="ml-1.5 text-xs px-2 py-0.5 rounded-full bg-amber-100 text-amber-700">${pending_mark}</span>
                        </c:if>
                    </h2>
                    <a href="assignment" class="text-xs text-gray-400 hover:text-gray-700 transition">View all →</a>
                </div>

                <c:choose>
                    <c:when test="${empty pending_submissions}">
                        <div class="bg-white border border-gray-100 rounded-xl px-5 py-8 text-center">
                            <p class="text-sm text-gray-400">All submissions have been marked! 🎉</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="flex flex-col gap-2">
                            <c:forEach var="sub" items="${pending_submissions}">
                                <div class="bg-white border border-gray-100 rounded-xl px-4 py-3 flex items-center gap-4
                                            hover:border-amber-200 hover:bg-amber-50 transition cursor-pointer group"
                                     onclick="location.href='assignment?submission_id=${sub.id}'">
                                    <%-- Student avatar --%>
                                    <div class="w-8 h-8 rounded-full bg-gray-100 text-gray-600
                                                flex items-center justify-center text-xs font-semibold">
                                        ${sub.initials}
                                    </div>
                                    <div class="flex-1 min-w-0">
                                        <div class="text-sm font-medium text-gray-900 truncate">${fn:escapeXml(sub.studentName)}</div>
                                        <div class="text-xs text-gray-400 truncate">
                                            ${fn:escapeXml(sub.assignmentTitle)} · ${fn:escapeXml(sub.courseName)}
                                        </div>
                                    </div>
                                    <div class="text-right flex-shrink-0">
                                        <div class="text-xs text-gray-400">
                                            ${sub.timeAgo}
                                        </div>
                                        <div class="text-xs text-amber-600 font-medium mt-0.5">Ungraded</div>
                                    </div>
                                    <svg class="w-4 h-4 text-gray-300 group-hover:text-amber-400 transition flex-shrink-0"
                                         fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 5l7 7-7 7"/>
                                    </svg>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <%-- Right column --%>
        <div class="flex flex-col gap-6">

            <%-- Quick actions --%>
            <div>
                <h2 class="text-sm font-semibold text-gray-700 mb-3">Quick actions</h2>
                <div class="flex flex-col gap-2">
                    <a href="note?new=1"
                       class="flex items-center gap-3 bg-white border border-gray-100 rounded-xl px-4 py-3
                              hover:border-gray-200 hover:shadow-sm transition group">
                        <div class="w-8 h-8 rounded-lg bg-blue-50 text-blue-600 flex items-center justify-center flex-shrink-0">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                      d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12"/>
                            </svg>
                        </div>
                        <div>
                            <div class="text-sm font-medium text-gray-900">Upload note</div>
                            <div class="text-xs text-gray-400">PDF or video</div>
                        </div>
                        <svg class="w-4 h-4 text-gray-300 ml-auto group-hover:text-gray-500 transition"
                             fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 5l7 7-7 7"/>
                        </svg>
                    </a>
                    <a href="assignment?new=1"
                       class="flex items-center gap-3 bg-white border border-gray-100 rounded-xl px-4 py-3
                              hover:border-gray-200 hover:shadow-sm transition group">
                        <div class="w-8 h-8 rounded-lg bg-amber-50 text-amber-600 flex items-center justify-center flex-shrink-0">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                      d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
                            </svg>
                        </div>
                        <div>
                            <div class="text-sm font-medium text-gray-900">Create assignment</div>
                            <div class="text-xs text-gray-400">Set title, due date, marks</div>
                        </div>
                        <svg class="w-4 h-4 text-gray-300 ml-auto group-hover:text-gray-500 transition"
                             fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 5l7 7-7 7"/>
                        </svg>
                    </a>
                    <a href="quiz?new=1"
                       class="flex items-center gap-3 bg-white border border-gray-100 rounded-xl px-4 py-3
                              hover:border-gray-200 hover:shadow-sm transition group">
                        <div class="w-8 h-8 rounded-lg bg-indigo-50 text-indigo-600 flex items-center justify-center flex-shrink-0">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                      d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"/>
                            </svg>
                        </div>
                        <div>
                            <div class="text-sm font-medium text-gray-900">Create quiz</div>
                            <div class="text-xs text-gray-400">Add questions & code</div>
                        </div>
                        <svg class="w-4 h-4 text-gray-300 ml-auto group-hover:text-gray-500 transition"
                             fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 5l7 7-7 7"/>
                        </svg>
                    </a>
                </div>
            </div>

            <%-- Recent quiz results --%>
            <div>
                <div class="flex items-center justify-between mb-3">
                    <h2 class="text-sm font-semibold text-gray-700">Recent quiz results</h2>
                    <a href="quiz" class="text-xs text-gray-400 hover:text-gray-700 transition">View all →</a>
                </div>
                <c:choose>
                    <c:when test="${empty recent_attempts}">
                        <div class="bg-white border border-gray-100 rounded-xl px-4 py-6 text-center">
                            <p class="text-xs text-gray-400">No quiz attempts yet.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="flex flex-col gap-2">
                            <c:forEach var="attempt" items="${recent_attempts}">
                                <div class="bg-white border border-gray-100 rounded-xl px-4 py-3 flex items-center gap-3">

                                    <div class="w-7 h-7 rounded-full bg-gray-100 text-gray-600
                                                flex items-center justify-center text-[10px] font-semibold">
                                        ${attempt.initials}
                                    </div>

                                    <div class="flex-1 min-w-0">
                                        <div class="text-xs font-medium text-gray-900">
                                            ${attempt.studentName}
                                        </div>

                                        <div class="text-[10px] text-gray-400">
                                            ${attempt.quizTitle}
                                        </div>
                                    </div>

                                    <div class="text-right">
                                        <div class="text-sm font-semibold ${attempt.percentageColor}">
                                            ${attempt.percentage}%
                                        </div>

                                        <div class="text-[10px] text-gray-400">
                                            ${attempt.score}/${attempt.totalQuestions}
                                        </div>
                                    </div>

                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <%-- Recent forum activity --%>
            

        </div>
    </div>
</main>

</body>
</html>