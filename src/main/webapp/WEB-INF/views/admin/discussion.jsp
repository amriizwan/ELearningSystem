<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!--Core tag   c:remove, c:if , c:choose, c:forEach  -->
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>MyStudyZone — Manage Posts</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-50 min-h-screen">
        <div class="flex min-h-screen">

            <aside class="w-52 bg-white border-r border-gray-100 flex flex-col py-5 fixed h-full">
                <div class="px-4 mb-6">
                    <span class="text-base font-semibold text-gray-900">MyStudyZone</span>
                    <span class="block text-xs text-gray-400 mt-0.5">Admin panel</span>
                </div>
                <nav class="flex flex-col gap-0.5 flex-1">
                    <a href="${pageContext.request.contextPath}/dashboard"  class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">Dashboard</a>
                    <a href="${pageContext.request.contextPath}/admin/users" class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">Users</a>
                    <a href="${pageContext.request.contextPath}/course"     class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">Courses</a>
                    <a href="${pageContext.request.contextPath}/discussion" class="px-4 py-2.5 text-sm font-medium bg-gray-50 text-gray-900">Posts</a>
                </nav>
                <a href="${pageContext.request.contextPath}/logout" class="px-4 py-2.5 text-sm text-red-500 hover:bg-red-50 mt-auto">Logout</a>
            </aside>

            <main class="ml-52 flex-1 p-6">
                <h1 class="text-lg font-semibold text-gray-900 mb-6">Manage Posts</h1>

                <c:if test="${not empty sessionScope.success}">
                    <div class="bg-green-50 border border-green-100 text-green-700 text-sm rounded-xl px-4 py-3 mb-5">
                        ${sessionScope.success}
                    </div>
                    <c:remove var="success" scope="session"/>
                </c:if>

                <%-- UC019: if a post is selected, show it with delete option --%>
                <c:if test="${not empty selectedPost}">
                    <div class="bg-white rounded-xl border border-gray-100 p-5 mb-6">
                        <div class="flex items-start justify-between mb-3">
                            <div>
                                <h2 class="text-sm font-semibold text-gray-900">${selectedPost.title}</h2>
                                <p class="text-xs text-gray-400 mt-0.5">
                                    by ${selectedPost.authorName}
                                    &nbsp;·&nbsp; ${selectedPost.courseName}
                                    &nbsp;·&nbsp; ${selectedPost.createdAt}
                                </p>
                            </div>
                            <%-- UC019: Admin delete — no ownership check --%>
                            <form action="${pageContext.request.contextPath}/discussion"
                                  method="post"
                                  onsubmit="return confirm('Permanently delete this post and all comments?')">
                                <input type="hidden" name="action" value="deleteAdmin"/>
                                <input type="hidden" name="postId" value="${selectedPost.id}"/>
                                <button type="submit"
                                        class="text-xs border border-red-200 text-red-500 px-3 py-1.5 rounded-lg hover:bg-red-50 ml-3">
                                    Delete post
                                </button>
                            </form>
                        </div>
                        <p class="text-sm text-gray-700 mb-4">${selectedPost.content}</p>

                        <c:if test="${not empty selectedPost.comments}">
                            <h3 class="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-2">
                                Comments (${selectedPost.commentCount})
                            </h3>
                            <c:forEach var="comment" items="${selectedPost.comments}">
                                <div class="bg-gray-50 rounded-lg px-4 py-2 mb-1 text-sm text-gray-700">
                                    <span class="font-medium text-gray-900">${comment.authorName}:</span>
                                    ${comment.content}
                                </div>
                            </c:forEach>
                        </c:if>
                    </div>
                </c:if>

                <%-- UC010 E1: no posts --%>
                <c:choose>
                    <c:when test="${empty posts}">
                        <div class="bg-white rounded-xl border border-gray-100 p-8 text-center">
                            <p class="text-sm text-gray-400">No posts available</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="bg-white rounded-xl border border-gray-100 overflow-hidden">
                            <table class="w-full text-sm">
                                <thead>
                                    <tr class="border-b border-gray-100">
                                        <th class="text-left text-xs font-medium text-gray-400 uppercase tracking-wide px-5 py-3">Post</th>
                                        <th class="text-left text-xs font-medium text-gray-400 uppercase tracking-wide px-5 py-3">Author</th>
                                        <th class="text-left text-xs font-medium text-gray-400 uppercase tracking-wide px-5 py-3">Course</th>
                                        <th class="text-left text-xs font-medium text-gray-400 uppercase tracking-wide px-5 py-3">Replies</th>
                                        <th class="text-left text-xs font-medium text-gray-400 uppercase tracking-wide px-5 py-3">Date</th>
                                        <th class="px-5 py-3"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="post" items="${posts}">
                                        <tr class="border-b border-gray-50 hover:bg-gray-50">
                                            <td class="px-5 py-3">
                                                <a href="${pageContext.request.contextPath}/discussion?id=${post.id}"
                                                   class="font-medium text-gray-900 hover:text-indigo-600">
                                                    ${post.title}
                                                </a>
                                            </td>
                                            <td class="px-5 py-3 text-gray-500">${post.authorName}</td>
                                            <td class="px-5 py-3 text-gray-500">${post.courseName}</td>
                                            <td class="px-5 py-3">
                                                <span class="text-xs bg-gray-100 text-gray-600 px-2 py-0.5 rounded-full">
                                                    ${post.commentCount}
                                                </span>
                                            </td>
                                            <td class="px-5 py-3 text-gray-400 text-xs">${post.createdAt}</td>
                                            <td class="px-5 py-3">
                                                <%-- UC019: Admin delete --%>
                                                <form action="${pageContext.request.contextPath}/discussion"
                                                      method="post"
                                                      onsubmit="return confirm('Delete this post?')">
                                                    <input type="hidden" name="action" value="deleteAdmin"/>
                                                    <input type="hidden" name="postId" value="${post.id}"/>
                                                    <button type="submit"
                                                            class="text-xs border border-red-200 text-red-500 px-3 py-1.5 rounded-lg hover:bg-red-50">
                                                        Delete
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </main>
        </div>
    </body>
</html>
