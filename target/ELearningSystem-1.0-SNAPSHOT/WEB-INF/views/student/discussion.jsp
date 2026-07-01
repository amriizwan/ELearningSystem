<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!--Core tag   c:remove, c:if , c:choose, c:forEach  -->
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>MyStudyZone — Discussion</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-50 min-h-screen">
        <div class="flex min-h-screen">

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
                       class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">Quiz</a>
                    <a href="${pageContext.request.contextPath}/discussion"
                       class="px-4 py-2.5 text-sm font-medium bg-gray-50 text-gray-900">Discussion</a>
                </nav>
                <a href="${pageContext.request.contextPath}/logout"
                   class="px-4 py-2.5 text-sm text-red-500 hover:bg-red-50 mt-auto">Logout</a>
            </aside>

            <main class="ml-52 flex-1 flex">

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
                        <button onclick="toggleCreateForm()"
                                class="w-full text-xs bg-indigo-600 hover:bg-indigo-700 text-white px-3 py-2 rounded-lg">
                            + New post
                        </button>

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
        </div>

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
        </script>
    </body>
</html>