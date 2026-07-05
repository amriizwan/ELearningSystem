<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script src="https://cdn.tailwindcss.com"></script>
        <script src="https://kit.fontawesome.com/7ac8763a86.js" crossorigin="anonymous"></script>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <title>Course - MyStudyZone</title>

        <style>
            body { font-family: 'Inter', ui-sans-serif, system-ui, sans-serif; }
        </style>
    </head>
    <body class="bg-slate-50 text-slate-900 antialiased">
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
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-semibold bg-indigo-50 text-indigo-700 transition">
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
                   class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-500 hover:bg-slate-50 hover:text-slate-900 transition">
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
        <main class="lg:ml-64 min-h-screen p-5 sm:p-8">
             <!-- Header -->
            <div class="mb-8">
                <h1 class="text-2xl font-bold text-slate-900 tracking-tight">Course catalog</h1>
                <p class="text-sm text-slate-400 mt-1.5">Choose which courses you want to teach</p>
            </div>
            <!-- Toast -->
             <c:if test="${not empty sessionScope.success}">
                    <div id="toast" class="bg-emerald-50 border border-emerald-100 text-emerald-700 text-sm rounded-2xl px-4 py-3 mb-5 flex items-center gap-2">
                        <i class="fa-solid fa-circle-check text-emerald-500"></i>
                        ${sessionScope.success}
                    </div>
                    <c:remove var="success" scope="session"/>
            </c:if>
             
             <!-- Search -->
             <div class="flex flex-col sm:flex-row gap-3 mb-5">
                <div class="relative flex-1">
                    <input type="hidden" name="tab" />
                    <svg class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400"
                         fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <circle cx="11" cy="11" r="7"/><path stroke-linecap="round" d="M21 21l-4.35-4.35"/>
                    </svg>
                    <input type="text" name="q" id="searchCourse"  oninput="searchCourses()"
                           placeholder="Search courses..."
                           class="w-full pl-9 pr-4 py-2.5 text-sm border border-slate-200 rounded-xl
                                  focus:outline-none focus:border-indigo-400 focus:ring-2 focus:ring-indigo-100 bg-white transition"/>
                </div>
                <div class="flex gap-2">
                    <a href="course?show=all"
                       class="px-4 py-2.5 text-sm rounded-xl border font-medium transition bg-indigo-600 text-white border-indigo-600 shadow-sm shadow-indigo-100">
                        All courses
                        <span class="ml-1 text-xs opacity-80">
                            (${courses.size()})
                        </span>
                    </a>
                            <c:set var="mine" value="0"/>
                            <c:forEach var="courses" items="${courses}">
                                <c:if test="${courses.is_mine == 1}">
                                    <c:set var="mine" value="${mine + 1}"/>
                                </c:if>
                            </c:forEach>
                    <a href="course?show=teaching" 
                       class="px-4 py-2.5 text-sm rounded-xl border font-medium transition bg-white border-slate-200 text-slate-500 hover:border-indigo-300 hover:text-indigo-700">
                        Teaching
                        <span class="ml-1 text-xs opacity-70 ">(${mine})</span>
                    </a>
                </div>
            </div>
            <!-- Summary -->
            <p class="text-xs text-slate-400 mb-5">
                Showing ${fn:length(courses)} course${fn:length(courses) > 1 ? 's' : ''}
                <c:if test="${mine > 0}">
                · <span class="text-emerald-600 font-medium">${mine} teaching</span>
                </c:if>
            </p>
            
            <!-- Course grid -->
            <c:if test="${empty courses}">
            <div class="bg-white border border-dashed border-slate-200 rounded-2xl p-16 text-center">
                <div class="w-12 h-12 rounded-full bg-slate-50 text-slate-300 flex items-center justify-center mx-auto mb-3">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.2"
                              d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/>
                    </svg>
                </div>
                <p class="text-sm text-slate-400">No courses found.</p>
            </div>
            </c:if>
            <c:if test="${not empty courses}">
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 h-fit">
                    
                    <c:forEach var="courses" items="${courses}" varStatus="status">
                       
                    <div class=" course-card bg-white border rounded-2xl p-5 flex flex-col transition hover:shadow-md h-full
                                ${courses.is_mine == 1 ? 'border-emerald-200' : 'border-slate-100 hover:border-indigo-200'}" 
                          data-title="${fn:toLowerCase(courses.title)}"
                          data-description ="${courses.description != null ? fn:toLowerCase(courses.description) : ''}"
                          data-teaching ="${courses.is_mine}"
                          style="display:${show == 'teaching' && courses.is_mine == 0 ? 'none' : 'block'}">
                                

                        <!-- Top row -->
                        <div class="flex items-start justify-between mb-4">
                            <div class="w-10 h-10 rounded-xl flex items-center justify-center flex-shrink-0 ${palettes[status.index % fn:length(palettes)]}">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                          d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/>
                                </svg>
                            </div>
                            <c:if test="${courses.is_mine == 1}">
                            <span class="text-xs font-semibold px-2.5 py-1 rounded-full bg-emerald-50 text-emerald-700">Teaching</span>
                            </c:if>
                        </div>

                        <!-- Course name -->
                        <h3 class="text-sm font-semibold text-slate-900 mb-1 leading-snug">${courses.title} </h3>
                            <c:choose>
                                <c:when test="${courses.description != null}">
                                    <p class="text-xs text-slate-400 leading-relaxed mb-4 line-clamp-2">
                                        ${courses.description}
                                    </p>
                                </c:when>
                                <c:otherwise>
                                    <div class="mb-4"></div>
                                </c:otherwise>
                            </c:choose>

                        <!-- Stats -->
                        <div class="grid grid-cols-4 gap-2 mb-4 mt-auto">
                            <div class="text-center">
                                <div class="text-sm font-semibold text-slate-900">${courses.student_count}</div>
                                <div class="text-[10px] text-slate-400">Students</div>
                            </div>
                            <div class="text-center">
                                <div class="text-sm font-semibold text-slate-900">${courses.note_count}</div>
                                <div class="text-[10px] text-slate-400">Notes</div>
                            </div>
                            <div class="text-center">
                                <div class="text-sm font-semibold text-slate-900">${courses.asgn_count}</div>
                                <div class="text-[10px] text-slate-400">Asgn</div>
                            </div>
                            <div class="text-center">
                                <div class="text-sm font-semibold text-slate-900">${courses.lecturer_count}</div>
                                <div class="text-[10px] text-slate-400">Lecturers</div>
                            </div>
                        </div>

                        <!-- Action button -->
                        <form method="POST" action="${pageContext.request.contextPath}/course">
                            <input type="hidden" name="submit" value="buttonCourse"/>
                            <input type="hidden" name="courseId" value="${courses.id}"/>
                            <input type="hidden" name="action"    value="${courses.is_mine == 1 ? 'uassign': 'assign'}"/>
                            <button type="submit"
                                    class="w-full py-2.5 rounded-xl text-sm font-medium transition
                                           ${courses.is_mine == 1 
                                               ? 'bg-slate-100 text-slate-600 hover:bg-red-50 hover:text-red-600 hover:border hover:border-red-200'
                                               : 'bg-indigo-600 text-white hover:bg-indigo-700 shadow-sm shadow-indigo-100'}">
                                ${courses.is_mine == 1 ? 'Stop teaching' :'Teach this course'}
                            </button>
                        </form>
                    </div>
                    </c:forEach>
                </div>
            </c:if>

                    
                        
            
        </main>
        
    </body>
    <script>
        const show = "${show}";
        function searchCourses() {

            const keyword = document.getElementById("searchCourse").value.toLowerCase();
            const cards = document.querySelectorAll(".course-card");

            cards.forEach(card => {

                const title = card.dataset.title;
                const description = card.dataset.description;
                const is_teaching = card.dataset.teaching === '1';
                const matchFilter = show === "all" || (show === "teaching" && is_teaching);

                if ((title.includes(keyword) || description.includes(keyword)) && matchFilter) {
                    card.style.display = "block";
                } else {
                    card.style.display = "none";
                }

            });
        }
        
        const toast = document.getElementById('toast');
        if (toast) setTimeout(() => { toast.style.opacity = '0'; setTimeout(() => toast.remove(), 300); }, 4000);
    </script>
</html>
