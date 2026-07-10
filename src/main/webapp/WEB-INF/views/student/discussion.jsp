<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!--Core tag   c:remove, c:if , c:choose, c:forEach  -->
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>MyStudyZone — Discussion</title>
        
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css"/>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <style>
            body { font-family: 'Inter', ui-sans-serif, system-ui, sans-serif; }
        </style>
    </head>
    <body class="bg-gray-50 min-h-screen">
        <!--<div class="flex min-h-screen">-->

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
                       class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-500 hover:bg-slate-50 hover:text-slate-900 transition">
                        <i class="fa-solid fa-file-lines w-4 text-center"></i>
                        Assignments
                    </a>
                    <a href="${pageContext.request.contextPath}/quiz"
                       class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-medium text-slate-500 hover:bg-slate-50 hover:text-slate-900 transition">
                        <i class="fa-solid fa-square-poll-vertical w-4 text-center"></i>
                        Quiz
                    </a>
                    <a href="${pageContext.request.contextPath}/discussion"
                       class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-sm font-semibold bg-indigo-50 text-indigo-700 transition">
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

                <%-- LEFT PANEL: post list + create form --%>
                <div class="w-80 border-r border-gray-100 bg-white flex flex-col">
                    <div class="px-4 py-4 border-b border-gray-100">
                        <h1 class="text-base font-semibold text-gray-900">Discussion</h1>
                    </div>

                    <%-- Success / Error --%>
                    <c:if test="${not empty sessionScope.success}">
                        <div class="mx-3 mt-3 bg-green-50 border border-green-100 text-green-700 text-xs rounded-lg px-3 py-2">
                            ${sessionScope.success}
                        </div>
                        <c:remove var="success" scope="session"/>
                    </c:if>
                    <c:if test="${not empty sessionScope.error}">
                        <div class="mx-3 mt-3 bg-red-50 border border-red-100 text-red-700 text-xs rounded-lg px-3 py-2">
                            ${sessionScope.error}
                        </div>
                        <c:remove var="error" scope="session"/>
                    </c:if>

                    <%-- Create post form --%>
                    <div class="px-4 py-3 border-b border-gray-100">
                        <c:choose>
                            <c:when test="${hasReachLimit}">
                                <button
                                    type="button"
                                    onclick="openCourseModal()"
                                    class="flex justify-self-center items-center gap-2 px-4 py-2.5 rounded-xl bg-gradient-to-r from-indigo-600 via-violet-600 to-purple-600 text-white text-sm font-medium">
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
                                                Discussion Post Limit Reached
                                            </h2>
                                            <p class="text-indigo-100 mt-2 leading-relaxed">
                                                You've reached the maximum number of discussion posts allowed on the Free plan.
                                                Upgrade to Premium to participate in unlimited discussions and collaborate with your classmates.
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
                                                    <input type="hidden" name="prevPage" value="discussion">

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
                                <button onclick="toggleCreateForm()"
                                        class="w-full text-xs bg-indigo-600 hover:bg-indigo-700 text-white px-3 py-2 rounded-lg">
                                    + New post
                                </button>
                            </c:otherwise>
                        </c:choose>

                        <div id="createForm" class="hidden mt-3">
                            <form action="${pageContext.request.contextPath}/discussion" method="post">
                                <input type="hidden" name="action" value="post"/>

                                <div class="mb-2">
                                    <select name="courseId" required
                                            class="w-full border border-gray-200 rounded-lg px-3 py-2 text-xs bg-white focus:outline-none focus:ring-2 focus:ring-indigo-500">
                                        <c:forEach var="course" items="${courses}">
                                            <option value="${course.id}">${course.title}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="mb-2">
                                    <input type="text" name="title" required
                                           placeholder="Post title (e.g. Error 404)"
                                           class="w-full border border-gray-200 rounded-lg px-3 py-2 text-xs focus:outline-none focus:ring-2 focus:ring-indigo-500"/>
                                </div>
                                <div class="mb-2">
                                    <%-- content cannot be empty --%>
                                    <textarea name="content" required rows="3"
                                              placeholder="Please help me solve this error..."
                                              class="w-full border border-gray-200 rounded-lg px-3 py-2 text-xs resize-none focus:outline-none focus:ring-2 focus:ring-indigo-500"></textarea>
                                </div>
                                <%--  Post button --%>
                                <button type="submit"
                                        class="w-full text-xs bg-indigo-600 hover:bg-indigo-700 text-white px-3 py-2 rounded-lg">
                                    Post
                                </button>
                            </form>
                        </div>
                    </div>

                    <%-- Post list --%>
                    <div class="overflow-auto flex-1">
                        <c:choose>
                            <c:when test="${empty posts}">
                                <p class="px-4 py-6 text-sm text-gray-400">No posts available</p>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="post" items="${posts}">
                                    <%-- UC010 Step 2: clicking loads post detail on right --%>
                                    <a href="${pageContext.request.contextPath}/discussion?id=${post.id}"
                                       class="block px-4 py-3 border-b border-gray-50 hover:bg-gray-50
                                              ${param.id == post.id ? 'bg-indigo-50 border-l-2 border-l-indigo-500' : ''}">
                                        <div class="flex items-start justify-between">
                                            <p class="text-sm font-medium text-gray-900 leading-snug">${post.title}</p>
                                            <span class="text-xs text-gray-400 ml-2 whitespace-nowrap">
                                                ${post.commentCount} reply
                                            </span>
                                        </div>
                                        <p class="text-xs text-gray-400 mt-0.5">
                                            ${post.authorName} &nbsp;·&nbsp; ${post.courseName}
                                        </p>
                                    </a>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <%-- RIGHT PANEL: selected post + comments --%>
                <div class="flex-1 p-6 overflow-auto">
                    <c:choose>
                        <c:when test="${empty selectedPost}">
                            <div class="flex items-center justify-center h-full">
                                <p class="text-sm text-gray-400">Select a post to read it</p>
                            </div>
                        </c:when>
                        <c:otherwise>

                            <%-- Post content --%>
                            <div class="bg-white rounded-xl border border-gray-100 p-6 mb-5">
                                <div class="flex items-start justify-between mb-3">
                                    <div>
                                        <h2 class="text-base font-semibold text-gray-900">
                                            ${selectedPost.title}
                                        </h2>
                                        <p class="text-xs text-gray-400 mt-1">
                                            by ${selectedPost.authorName}
                                            &nbsp;·&nbsp; ${selectedPost.courseName}
                                            &nbsp;·&nbsp; ${selectedPost.createdAt}
                                        </p>
                                    </div>

                                    <%-- show edit/delete only for post owner --%>
                                    <c:if test="${selectedPost.userId == sessionScope.userId}">
                                        <div class="flex gap-2 ml-3">
                                            <button onclick="showEditPost(
                                                        '${selectedPost.id}',
                                                        '${selectedPost.title}',
                                                        '${selectedPost.content}')"
                                                    class="text-xs border border-gray-200 text-gray-600 px-3 py-1.5 rounded-lg hover:bg-gray-50">
                                                Edit
                                            </button>
                                            <form action="${pageContext.request.contextPath}/discussion"
                                                  method="post"
                                                  onsubmit="return confirm('Delete this post and all its comments?')">
                                                <input type="hidden" name="action" value="delete"/>
                                                <input type="hidden" name="postId" value="${selectedPost.id}"/>
                                                <button type="submit"
                                                        class="text-xs border border-red-200 text-red-500 px-3 py-1.5 rounded-lg hover:bg-red-50">
                                                    Delete
                                                </button>
                                            </form>
                                        </div>
                                    </c:if>
                                </div>
                                <p class="text-sm text-gray-700 leading-relaxed">
                                    ${selectedPost.content}
                                </p>
                            </div>

                            <%-- Comments list --%>
                            <div class="mb-5">
                                <h3 class="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-3">
                                    ${selectedPost.commentCount} Replies
                                </h3>

                                <c:choose>
                                    <c:when test="${empty selectedPost.comments}">
                                        <p class="text-sm text-gray-400">No replies yet. Be the first!</p>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="comment" items="${selectedPost.comments}">
                                            <div class="bg-white rounded-xl border border-gray-100 p-4 mb-2">
                                                <div class="flex items-start justify-between mb-2">
                                                    <div>
                                                        <span class="text-xs font-medium text-gray-900">
                                                            ${comment.authorName}
                                                        </span>
                                                        <span class="text-xs text-gray-400 ml-2">
                                                            ${comment.createdAt}
                                                        </span>
                                                    </div>
                                                    <%-- Delete own comment --%>
                                                    <c:if test="${comment.userId == sessionScope.userId}">
                                                        <form action="${pageContext.request.contextPath}/discussion"
                                                              method="post">
                                                            <input type="hidden" name="action" value="deleteComment"/>
                                                            <input type="hidden" name="commentId" value="${comment.id}"/>
                                                            <input type="hidden" name="postId" value="${selectedPost.id}"/>
                                                            <button type="submit"
                                                                    class="text-xs text-gray-400 hover:text-red-500">
                                                                ✕
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                </div>
                                                <p class="text-sm text-gray-700">${comment.content}</p>
                                            </div>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <%-- Add comment form --%>
                            <div class="bg-white rounded-xl border border-gray-100 p-5">
                                <h3 class="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-3">
                                    Add Reply
                                </h3>
                                <form action="${pageContext.request.contextPath}/discussion" method="post">
                                    <input type="hidden" name="action" value="comment"/>
                                    <input type="hidden" name="postId" value="${selectedPost.id}"/>
                                    <textarea name="content" required rows="2"
                                              placeholder="Write your reply..."
                                              class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm resize-none focus:outline-none focus:ring-2 focus:ring-indigo-500 mb-3"></textarea>
                                    <div class="flex justify-end">
                                        <button type="submit"
                                                class="text-sm bg-indigo-600 hover:bg-indigo-700 text-white px-4 py-2 rounded-lg">
                                            Reply
                                        </button>
                                    </div>
                                </form>
                            </div>

                        </c:otherwise>
                    </c:choose>
                </div>

            </main>
        </div>

        <%-- Edit post modal --%>
        <div id="editPostModal" class="hidden fixed inset-0 bg-black bg-opacity-20 flex items-center justify-center z-50">
            <div class="bg-white rounded-xl border border-gray-100 p-6 w-full max-w-lg">
                <h2 class="text-sm font-medium text-gray-900 mb-4">Edit Post</h2>
                <form action="${pageContext.request.contextPath}/discussion" method="post">
                    <input type="hidden" name="action" value="edit"/>
                    <input type="hidden" name="postId" id="editPostId"/>
                    <div class="mb-3">
                        <label class="block text-xs font-medium text-gray-600 mb-1">Title</label>
                        <input type="text" name="title" id="editPostTitle" required
                               class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"/>
                    </div>
                    <div class="mb-5">
                        <label class="block text-xs font-medium text-gray-600 mb-1">Content</label>
                        <textarea name="content" id="editPostContent" required rows="4"
                                  class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm resize-none focus:outline-none focus:ring-2 focus:ring-indigo-500"></textarea>
                    </div>
                    <%-- UC013 Step 3: Save button (exact label from SDD) --%>
                    <div class="flex gap-2 justify-end">
                        <button type="button" onclick="hideEditPost()"
                                class="text-sm border border-gray-200 text-gray-600 px-4 py-2 rounded-lg hover:bg-gray-50">
                            Cancel
                        </button>
                        <button type="submit"
                                class="text-sm bg-indigo-600 hover:bg-indigo-700 text-white px-4 py-2 rounded-lg">
                            Save
                        </button>
                    </div>
                </form>
            </div>
        <!--</div>-->

        <script>
            function toggleCreateForm() {
                const f = document.getElementById('createForm');
                f.classList.toggle('hidden');
            }
            function showEditPost(id, title, content) {
                document.getElementById('editPostId').value = id;
                document.getElementById('editPostTitle').value = title;
                document.getElementById('editPostContent').value = content;
                document.getElementById('editPostModal').classList.remove('hidden');
            }
            function hideEditPost() {
                document.getElementById('editPostModal').classList.add('hidden');
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
    </body>
</html>