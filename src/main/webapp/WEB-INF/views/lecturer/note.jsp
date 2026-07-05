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
        <title>Notes</title>
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
                   class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">My Courses</a>
                <a href="${pageContext.request.contextPath}/note"
                   class="px-4 py-2.5 text-sm font-medium bg-gray-50 text-gray-900">Notes</a>
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
            
            <!-- ── LEFT: Course list ── -->
            <div class="w-64 flex-shrink-0 bg-white border-r border-gray-100 flex flex-col min-h-screen">
                <div class="px-5 py-5 border-b border-gray-100">
                    <h1 class="text-base font-semibold text-gray-900">Notes</h1>
                    <p class="text-xs text-gray-400 mt-0.5">Manage your course materials</p>
                </div>

                <div class="flex-1 overflow-y-auto py-2">
                    <c:if test="${noteList.isEmpty()}">
                    <div class="px-5 py-8 text-center text-xs text-gray-400">No courses assigned yet.</div>
                    </c:if>
                    <c:if test="${!noteList.isEmpty()}">
                        <c:forEach var="noteList" items="${noteList}" varStatus="status">
                        <c:if test="${status.index == 0}">
                            <c:set var="firstId" value="${noteList.id}" />
                        </c:if>
                        <a href="note?course_id=${noteList.id}&&title=${noteList.title}"
                           class="flex items-center justify-between px-4 py-3 border-l-2 transition
                                  ${noteList.id == param.course_id ? 'bg-gray-50 border-gray-900' : 'border-transparent hover:bg-gray-50 hover:border-gray-200'}">
                            <div class="flex-1 min-w-0">
                                <div class="text-sm font-medium text-gray-900 truncate">${noteList.title}</div>
                                <div class="text-xs text-gray-400 mt-0.5">${noteList.noteCount} notes</div>
                            </div>
                            <c:if test="${noteList.id == param.course_id}">
                            <svg class="w-4 h-4 text-gray-400 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 5l7 7-7 7"/>
                            </svg>
                            </c:if>
                        </a>
                        </c:forEach>
                    </c:if>
                </div>
            </div>
            
            <!-- ── RIGHT: Notes panel ── -->
        <div class="flex-1 overflow-y-auto">
           
            <c:choose>
                <c:when test="${param.edit != null}">
                <!-- ── EDIT NOTE FORM ── -->
                <div class="max-w-xl mx-auto px-8 py-8">
                    <div class="flex items-center gap-3 mb-6">
                        <a href="note?course_id=${selectedNote.courseId}" class="text-gray-400 hover:text-gray-700 transition">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 19l-7-7 7-7"/>
                            </svg>
                        </a>
                        <h2 class="text-lg font-semibold text-gray-900">Edit note</h2>
                    </div>
                    <form method="POST" action="note"
                          class="bg-white border border-gray-100 rounded-2xl p-6">
                        <input type="hidden" name="action"    value="edit_note"/>
                        <input type="hidden" name="note_id"   value="${selectedNote.id}"/>
                        <input type="hidden" name="course_id" value="${selectedNote.courseId}"/>
                        <div class="mb-5">
                            <label class="block text-xs font-medium text-gray-700 mb-1.5">Title</label>
                            <input type="text" name="title" required value="${selectedNote.title}"
                                   class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:border-gray-400 transition"/>
                        </div>
                        <div class="mb-4">
                            <label class="block text-xs font-medium text-gray-700 mb-1.5">Current file</label>
                            <div class="bg-gray-50 rounded-xl px-4 py-3 text-sm text-gray-500 flex items-center gap-2">
                                <svg class="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                          d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13"/>
                                </svg>
                                ${selectedNote.fileUrl}
                                <span class="text-xs text-gray-400 ml-auto uppercase">${selectedNote.type}</span>
                            </div>
                            <p class="text-xs text-gray-400 mt-1.5">File cannot be changed. Delete and re-upload to replace.</p>
                        </div>
                        <div class="flex gap-3 mt-6">
                            <button type="submit" class="flex-1 py-2.5 rounded-xl bg-gray-900 text-white text-sm font-medium hover:bg-gray-700 transition">
                                Save changes
                            </button>
                            <a href="note?course_id=${selectedNote.courseId}"
                               class="px-5 py-2.5 rounded-xl border border-gray-200 text-sm text-gray-600 hover:bg-gray-100 transition">
                                Cancel
                            </a>
                        </div>
                    </form>
                </div>
                </c:when>
                <c:when test="${param.new != null}">
                    <!-- ── UPLOAD NOTE FORM ── -->
                <div class="max-w-xl mx-auto px-8 py-8">
                    <div class="flex items-center gap-3 mb-6">
                        <a href="note?course_id=${param.course_id}" class="text-gray-400 hover:text-gray-700 transition">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 19l-7-7 7-7"/>
                            </svg>
                        </a>
                        <h2 class="text-lg font-semibold text-gray-900">Upload note</h2>
                    </div>
                    <form method="POST" enctype="multipart/form-data"
                          action="note?course_id=${param.course_id}"
                          class="bg-white border border-gray-100 rounded-2xl p-6">
                        <input type="hidden" name="action" value="upload_note"/>

                        <!-- Course -->
                        <div class="mb-4">
                            <label class="block text-xs font-medium text-gray-700 mb-1.5">Course</label>
                            <select name="course_id" required
                                    class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm bg-white focus:outline-none focus:border-gray-400 transition">
                                <c:forEach var="noteList" items="${noteList}">
                                <option value="${noteList.id}" ${noteList.id == param.course_id ? 'selected' : '' }>
                                    ${noteList.title}
                                </option>
                            </c:forEach>
                            </select>
                        </div>

                        <!-- Title -->
                        <div class="mb-4">
                            <label class="block text-xs font-medium text-gray-700 mb-1.5">Note title</label>
                            <input type="text" name="title" required placeholder="e.g. Week 3 — Flexbox Layout"
                                   class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:border-gray-400 transition"/>
                        </div>

                        <!-- Type toggle -->
                        <div class="mb-4">
                            <label class="block text-xs font-medium text-gray-700 mb-1.5">Type</label>
                            <div class="flex gap-2">
                                <label class="flex-1 cursor-pointer">
                                    <input type="radio" name="type" value="pdf" class="hidden peer" checked
                                           onchange="updateAccept('pdf')"/>
                                    <div class="flex items-center justify-center gap-2 py-2.5 rounded-xl border border-gray-200
                                                peer-checked:border-red-300 peer-checked:bg-red-50 peer-checked:text-red-600
                                                text-gray-500 text-sm font-medium transition">
                                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                                  d="M7 21h10a2 2 0 002-2V9l-5-5H7a2 2 0 00-2 2v14a2 2 0 002 2z"/>
                                        </svg>
                                        PDF
                                    </div>
                                </label>
                                <label class="flex-1 cursor-pointer">
                                    <input type="radio" name="type" value="video" class="hidden peer"
                                           onchange="updateAccept('video')"/>
                                    <div class="flex items-center justify-center gap-2 py-2.5 rounded-xl border border-gray-200
                                                peer-checked:border-blue-300 peer-checked:bg-blue-50 peer-checked:text-blue-600
                                                text-gray-500 text-sm font-medium transition">
                                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                                  d="M14.752 11.168l-3.197-2.132A1 1 0 0010 9.87v4.263a1 1 0 001.555.832l3.197-2.132a1 1 0 000-1.664z"/>
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                                  d="M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                        </svg>
                                        Video
                                    </div>
                                </label>
                            </div>
                        </div>

                        <!-- File upload -->
                        <div class="mb-4">
                            <label class="block text-xs font-medium text-gray-700 mb-1.5">Upload file</label>
                            <label for="note_file"
                                   class="flex flex-col items-center justify-center border-2 border-dashed border-gray-200
                                          rounded-xl py-8 cursor-pointer hover:border-gray-400 hover:bg-gray-50 transition"
                                   id="upload-label">
                                <svg class="w-8 h-8 text-gray-300 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                          d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12"/>
                                </svg>
                                <span class="text-sm text-gray-400" id="file-label">Click to upload</span>
                                <span class="text-xs text-gray-400 mt-1" id="file-hint">PDF up to 100MB</span>
                                <input type="file" id="note_file" name="note_file" class="hidden"
                                       accept=".pdf"
                                       onchange="updateFileLabel(this)"/>
                            </label>
                        </div>

                        <!-- Divider -->
                        

                        <div class="flex gap-3">
                            <button type="submit"
                                    class="flex-1 py-2.5 rounded-xl bg-gray-900 text-white text-sm font-medium hover:bg-gray-700 transition">
                                Upload note
                            </button>
                            <a href="note?course_id=${param.course_id}"
                               class="px-5 py-2.5 rounded-xl border border-gray-200 text-sm text-gray-600 hover:bg-gray-100 transition">
                                Cancel
                            </a>
                        </div>
                    </form>
                </div>
                </c:when>
                <c:otherwise>
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
                    <!-- Page header -->
                    <div class="flex items-center justify-between mb-6">
                        <div>
                            <h2 class="text-lg font-semibold text-gray-900">
                                ${param.title != null ? param.title : 'Notes'}
                            </h2>
                            <p class="text-sm text-gray-400 mt-0.5"> notes</p>
                            
                        </div>
                        <a href="note?course_id=${param.course_id != null ? param.course_id : firstId}&new=1"
                           class="flex items-center gap-2 px-4 py-2.5 rounded-xl bg-gray-900 text-white text-sm font-medium hover:bg-gray-700 transition">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                            </svg>
                            Upload note
                        </a>
                    </div>
                    <!-- Search + filter -->
                    <div class="flex gap-3 mb-5">
                        <div class="relative flex-1">
                            <input type="hidden" name="course_id" value="${param.course_id}"/>
                            <input type="hidden" name="type"      value="search"/>
                            <svg class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400"
                                 fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <circle cx="11" cy="11" r="7"/><path stroke-linecap="round" d="M21 21l-4.35-4.35"/>
                            </svg>
                            <input type="text" name="q" id="searchInput" oninput="applyFilters()"
                                   placeholder="Search notes..."
                                   class="w-full pl-9 pr-4 py-2.5 text-sm border border-gray-200 rounded-xl focus:outline-none focus:border-gray-400 bg-white transition"/>
                        </div>
                        <div class="flex gap-2">
                            <button type="button"
                                    class="filter-btn px-4 py-2 rounded-xl border border-gray-200 bg-gray-900 text-white text-sm"
                                    onclick="filterNotes('all', this)">
                                All
                            </button>

                            <button type="button"
                                    class="filter-btn px-4 py-2 rounded-xl border border-gray-200 bg-white text-sm"
                                    onclick="filterNotes('pdf', this)">
                                PDF
                            </button>

                            <button type="button"
                                    class="filter-btn px-4 py-2 rounded-xl border border-gray-200 bg-white text-sm"
                                    onclick="filterNotes('video', this)">
                                Video
                            </button>
                        </div>
                    </div>

                    <!-- Notes grid -->
                    <c:choose>
                     <c:when test="${listNote.isEmpty()}">
                        <div class="bg-white border border-gray-100 rounded-2xl p-16 text-center">
                            <svg class="w-10 h-10 text-gray-300 mx-auto mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.2"
                                      d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                            </svg>
                            <p class="text-sm text-gray-400">No notes yet.</p>
                            <a href="note?course_id=${param.course_id}&new=1"
                               class="inline-block mt-3 text-sm text-blue-600 hover:underline">Upload your first note →</a>
                        </div>
                     </c:when>

                        <c:otherwise>
                            <div id="notesContainer" class="flex flex-col gap-3">
                                <c:forEach var="listNote" items="${listNote}">
                                    <div class=" note-card bg-white border border-gray-100 rounded-xl px-5 py-4 flex items-center gap-4 hover:border-gray-200 transition group"
                                         data-type="${listNote.type}" >
                                        <!-- Icon -->
                                        <div class="w-10 h-10 rounded-xl flex items-center justify-center flex-shrink-0
                                                    ${listNote.type == 'pdf'  ? 'bg-red-50 text-red-500' : 'bg-blue-50 text-blue-500'}">
                                            <c:if test="${listNote.type == 'pdf'}">
                                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                                      d="M7 21h10a2 2 0 002-2V9l-5-5H7a2 2 0 00-2 2v14a2 2 0 002 2z"/>
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M14 3v5h5"/>
                                            </svg>
                                            </c:if>
                                            <c:if test="${listNote.type != 'pdf'}">
                                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                                      d="M14.752 11.168l-3.197-2.132A1 1 0 0010 9.87v4.263a1 1 0 001.555.832l3.197-2.132a1 1 0 000-1.664z"/>
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                            </svg>
                                            </c:if>
                                        </div>

                                        <!-- Info -->
                                        <div class="flex-1 min-w-0">
                                            <div class=" note-title text-sm font-medium text-gray-900 truncate">${listNote.title}</div>
                                            <div class="text-xs text-gray-400 mt-0.5 flex items-center gap-2">
                                                <span class="uppercase font-medium ${listNote.type == 'pdf' ?'text-red-400' : 'text-blue-400' }">${listNote.type}</span>
                                                <span>·</span>
                                                <span><fmt:formatDate value="${listNote.createdAt}"  pattern="dd MMM yyyy "/></span>
                                            </div>
                                        </div>

                                        <!-- Actions -->
                                        <div class="flex items-center gap-2 opacity-0 group-hover:opacity-100 transition">
                                            <a href="${pageContext.request.contextPath}/${listNote.fileUrl}" target="_blank"
                                               class="flex items-center gap-1.5 text-xs text-gray-500 hover:text-gray-900 border border-gray-200 px-3 py-1.5 rounded-lg transition">
                                                <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                                          d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"/>
                                                </svg>
                                                Open
                                            </a>
                                            <a href="note?course_id=${param.course_id}&edit=${listNote.id}"
                                               class="flex items-center gap-1.5 text-xs text-gray-500 hover:text-gray-900 border border-gray-200 px-3 py-1.5 rounded-lg transition">
                                                <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                                          d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                                                </svg>
                                                Edit
                                            </a>
                                            <form method="POST" action="note?course_id=${param.course_id}"
                                                  onsubmit="return confirm('Delete this note? This cannot be undone.')">
                                                <input type="hidden" name="action"    value="delete_note"/>
                                                <input type="hidden" name="note_id"   value="${listNote.id}"/>
                                                <input type="hidden" name="course_id" value="${param.course_id}"/>
                                                <button type="submit"
                                                        class="flex items-center gap-1.5 text-xs text-gray-500 hover:text-red-600 border border-gray-200 hover:border-red-200 px-3 py-1.5 rounded-lg transition">
                                                    <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                                              d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                                                    </svg>
                                                    Delete
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                            <div id="noResults"
                                style="display:none"
                                class="text-center py-8 text-gray-400">
                               No matching notes found.
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
    if (toast) setTimeout(() => { toast.style.opacity = '0'; setTimeout(() => toast.remove(), 300); }, 4000);
    
    let currentFilter = "all";

    function filterNotes(type, button) {
        currentFilter = type;

        document.querySelectorAll(".filter-btn").forEach(btn => {
            btn.classList.remove("bg-gray-900", "text-white");
            btn.classList.add("bg-white");
        });

        button.classList.remove("bg-white");
        button.classList.add("bg-gray-900", "text-white");

        applyFilters();
    }

    function applyFilters() {
        const keyword = document.getElementById("searchInput").value.toLowerCase();
        const cards = document.querySelectorAll(".note-card");
        const noResults = document.getElementById("noResults");

        let count = 0;

        cards.forEach(card => {
            const title = card.querySelector(".note-title").textContent.toLowerCase();
            const type = card.dataset.type.toLowerCase();

            const matchSearch = title.includes(keyword);
            const matchType = currentFilter === "all" || type === currentFilter;

            if (matchSearch && matchType) {
                card.style.display = "flex";
                count++;
            } else {
                card.style.display = "none";
            }
        });

        if (noResults) {
            noResults.style.display = count === 0 ? "block" : "none";
        }
    }
    
    function updateAccept(type) {
        const input = document.getElementById('note_file');
        const hint  = document.getElementById('file-hint');
        if (type === 'pdf') {
            input.accept = '.pdf';
            hint.textContent = 'PDF up to 100MB';
        } else {
            input.accept = '.mp4,.mov,.avi,.mkv,.webm';
            hint.textContent = 'MP4, MOV, AVI, MKV, WEBM up to 100MB';
        }
        input.value = '';
        document.getElementById('file-label').textContent = 'Click to upload';
    }
    
    function updateFileLabel(input) {
        if (input.files && input.files[0]) {
            document.getElementById('file-label').textContent = '📎 ' + input.files[0].name;
        }
    }
    </script>
</html>