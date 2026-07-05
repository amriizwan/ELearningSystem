<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script src="https://cdn.tailwindcss.com"></script>
        <script src="https://kit.fontawesome.com/7ac8763a86.js" crossorigin="anonymous"></script>
        <title>Course - MyStudyZone</title>
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
                <a href="${pageContext.request.contextPath}/course"
                   class="px-4 py-2.5 text-sm font-medium bg-gray-50 text-gray-900">My Courses</a>
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
        <main class="ml-56 min-h-screen p-8">
             <!-- Header -->
            <div class="mb-6">
                <h1 class="text-xl font-semibold text-gray-900">Course catalog</h1>
                <p class="text-sm text-gray-400 mt-1">Choose which courses you want to teach</p>
            </div>
            <!-- Toast -->
             <c:if test="${not empty sessionScope.success}">
                    <div id="toast" class="bg-green-50 border border-green-100 text-green-700 text-sm rounded-xl px-4 py-3 mb-5">
                        ${sessionScope.success}
                    </div>
                    <c:remove var="success" scope="session"/>
            </c:if>
             
             <!-- Search -->
             <div class="flex flex-col sm:flex-row gap-3 mb-5">
                <div class="relative flex-1">
                    <input type="hidden" name="tab" />
                    <svg class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400"
                         fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <circle cx="11" cy="11" r="7"/><path stroke-linecap="round" d="M21 21l-4.35-4.35"/>
                    </svg>
                    <input type="text" name="q" id="searchCourse"  oninput="searchCourses()"
                           placeholder="Search courses..."
                           class="w-full pl-9 pr-4 py-2.5 text-sm border border-gray-200 rounded-xl
                                  focus:outline-none focus:border-gray-400 bg-white transition"/>
                </div>
                <div class="flex gap-2">
                    <a href="course?show=all"
                       class="px-4 py-2.5 text-sm rounded-xl border font-medium transition 
                            ${show eq 'all' ? 'bg-gray-900 text-white border-gray-900' : 'bg-white border-gray-200 text-gray-500 hover:border-gray-400'}">
                        All courses
                        <span class="ml-1 text-xs opacity-70">
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
                       class="px-4 py-2.5 text-sm rounded-xl border font-medium transition 
                            ${show eq 'teaching' ? 'bg-gray-900 text-white border-gray-900' : 'bg-white border-gray-200 text-gray-500 hover:border-gray-400'}">
                        Teaching
                        <span class="ml-1 text-xs opacity-70 ">(${mine})</span>
                    </a>
                </div>
            </div>
            <!-- Summary -->
            <p class="text-xs text-gray-400 mb-5">
                Showing ${fn:length(courses)} course${fn:length(courses) > 1 ? 's' : ''}
                <c:if test="${mine > 0}">
                · <span class="text-emerald-600 font-medium">${mine} teaching</span>
                </c:if>
            </p>
            
            <!-- Course grid -->
            <c:if test="${empty courses}">
            <div class="bg-white border border-gray-100 rounded-2xl p-16 text-center">
                <svg class="w-10 h-10 text-gray-300 mx-auto mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.2"
                          d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/>
                </svg>
                <p class="text-sm text-gray-400">No courses found.</p>
            </div>
            </c:if>
            <c:if test="${not empty courses}">
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 h-fit">
                    
                    <c:forEach var="courses" items="${courses}" varStatus="status">
                       
                    <div class=" course-card bg-white border rounded-2xl p-5 flex flex-col transition hover:shadow-sm h-full
                                ${courses.is_mine == 1 ? 'border-emerald-300' : 'border-gray-100 hover:border-gray-200'}" 
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
                            <span class="text-xs font-medium px-2.5 py-1 rounded-full bg-emerald-100 text-emerald-700">Teaching</span>
                            </c:if>
                        </div>

                        <!-- Course name -->
                        <h3 class="text-sm font-semibold text-gray-900 mb-1 leading-snug">${courses.title} </h3>
                            <c:choose>
                                <c:when test="${courses.description != null}">
                                    <p class="text-xs text-gray-400 leading-relaxed mb-4 line-clamp-2">
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
                                <div class="text-sm font-semibold text-gray-900">${courses.student_count}</div>
                                <div class="text-[10px] text-gray-400">Students</div>
                            </div>
                            <div class="text-center">
                                <div class="text-sm font-semibold text-gray-900">${courses.note_count}</div>
                                <div class="text-[10px] text-gray-400">Notes</div>
                            </div>
                            <div class="text-center">
                                <div class="text-sm font-semibold text-gray-900">${courses.asgn_count}</div>
                                <div class="text-[10px] text-gray-400">Asgn</div>
                            </div>
                            <div class="text-center">
                                <div class="text-sm font-semibold text-gray-900">${courses.lecturer_count}</div>
                                <div class="text-[10px] text-gray-400">Lecturers</div>
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
                                               ? 'bg-gray-100 text-gray-600 hover:bg-red-50 hover:text-red-600 hover:border hover:border-red-200'
                                               : 'bg-gray-900 text-white hover:bg-gray-700'}">
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