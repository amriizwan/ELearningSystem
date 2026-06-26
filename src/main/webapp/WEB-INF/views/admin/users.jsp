<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix = "sql" uri = "http://java.sun.com/jsp/jstl/sql" %>
<%@ taglib prefix = "x" uri = "http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>MyStudyZone — Manage Users</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-50 min-h-screen">
        <div class="flex min-h-screen">
            <!--Sidebar kiri-->
            <aside class="w-52 bg-white border-r border-gray-100 flex flex-col py-5 fixed h-full">
                <div class="px-4 mb-6">
                    <span class="text-base font-semibold text-gray-900">MyStudyZone</span>
                    <span class="block text-xs text-gray-400 mt-0.5">Admin panel</span>
                </div>
                <nav class="flex flex-col gap-0.5 flex-1">
                    <a href="${pageContext.request.contextPath}/dashboard"   class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">Dashboard</a>
                    <a href="${pageContext.request.contextPath}/admin/users" class="px-4 py-2.5 text-sm font-medium bg-gray-50 text-gray-900">Users</a>
                    <a href="${pageContext.request.contextPath}/course"      class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">Courses</a>
                    <a href="${pageContext.request.contextPath}/discussion"  class="px-4 py-2.5 text-sm text-gray-500 hover:bg-gray-50">Posts</a>
                </nav>
                <a href="${pageContext.request.contextPath}/logout" class="px-4 py-2.5 text-sm text-red-500 hover:bg-red-50 mt-auto">Logout</a>
            </aside>
            <!--Kanan-->
            <main class="ml-52 flex-1 p-6">
                <h1 class="text-lg font-semibold text-gray-900 mb-6">Manage Users</h1>

                <%-- Success / Error messages --%>
                <c:if test="${not empty sessionScope.success}">
                    <div class="bg-green-50 border border-green-100 text-green-700 text-sm rounded-xl px-4 py-3 mb-5">
                        ${sessionScope.success}
                    </div>
                    <c:remove var="success" scope="session"/>
                </c:if>
                <c:if test="${not empty sessionScope.error}">
                    <div class="bg-red-50 border border-red-100 text-red-700 text-sm rounded-xl px-4 py-3 mb-5">
                        ${sessionScope.error}
                    </div>
                    <c:remove var="error" scope="session"/>
                </c:if>

                <%-- UC020 Add: create new user form --%>
                <div class="bg-white rounded-xl border border-gray-100 p-5 mb-6">
                    <h2 class="text-sm font-medium text-gray-900 mb-4">Add New User</h2>
                    <form action="${pageContext.request.contextPath}/admin/users" method="post">
                        <input type="hidden" name="action" value="add"/>
                        <div class="grid grid-cols-4 gap-3 mb-3">
                            <div>
                                <label class="block text-xs font-medium text-gray-600 mb-1">Full name</label>
                                <input type="text" name="name" required
                                       placeholder="e.g. Muhammad Amri Izwan"
                                       class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"/>
                            </div>
                            <div>
                                <label class="block text-xs font-medium text-gray-600 mb-1">Email</label>
                                <input type="email" name="email" required
                                       placeholder="user@example.com"
                                       class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"/>
                            </div>
                            <div>
                                <label class="block text-xs font-medium text-gray-600 mb-1">
                                    Password
                                </label>
                                <input type="password" name="password" required
                                       placeholder="Min 8 characters"
                                       class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"/>
                            </div>
                            <div>
                                <label class="block text-xs font-medium text-gray-600 mb-1">Role</label>
                                <select name="role" required
                                        class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-indigo-500">
                                    <option value="student">Student</option>
                                    <option value="lecturer">Lecturer</option>
                                    <option value="admin">Admin</option>
                                </select>
                            </div>
                        </div>
                        <div class="flex justify-end">
                            <button type="submit"
                                    class="bg-indigo-600 hover:bg-indigo-700 text-white text-sm px-4 py-2 rounded-lg">
                                Create user
                            </button>
                        </div>
                    </form>
                </div>

                <%-- Role filter tabs --%>
                <div class="flex gap-2 mb-4">
                    <a href="${pageContext.request.contextPath}/admin/users"
                       class="text-xs px-3 py-1.5 rounded-full border font-medium
                              ${empty filterRole ? 'bg-gray-900 text-white border-gray-900' : 'border-gray-200 text-gray-600 hover:bg-gray-50'}">
                        All
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/users?role=student"
                       class="text-xs px-3 py-1.5 rounded-full border font-medium
                              ${filterRole == 'student' ? 'bg-gray-900 text-white border-gray-900' : 'border-gray-200 text-gray-600 hover:bg-gray-50'}">
                        Students
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/users?role=lecturer"
                       class="text-xs px-3 py-1.5 rounded-full border font-medium
                              ${filterRole == 'lecturer' ? 'bg-gray-900 text-white border-gray-900' : 'border-gray-200 text-gray-600 hover:bg-gray-50'}">
                        Lecturers
                    </a>
                </div>

                <%-- UC020 Step 1: User list table --%>
                <div class="bg-white rounded-xl border border-gray-100 overflow-hidden">
                    <table class="w-full text-sm">
                        <thead>
                            <tr class="border-b border-gray-100">
                                <th class="text-left text-xs font-medium text-gray-400 uppercase tracking-wide px-5 py-3">Name</th>
                                <th class="text-left text-xs font-medium text-gray-400 uppercase tracking-wide px-5 py-3">Email</th>
                                <th class="text-left text-xs font-medium text-gray-400 uppercase tracking-wide px-5 py-3">Role</th>
                                <th class="text-left text-xs font-medium text-gray-400 uppercase tracking-wide px-5 py-3">Status</th>
                                <th class="text-left text-xs font-medium text-gray-400 uppercase tracking-wide px-5 py-3">Joined</th>
                                <th class="px-5 py-3"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <%-- UC020 E1: no users --%>
                            <c:if test="${empty users}">
                                <tr>
                                    <td colspan="6" class="px-5 py-8 text-sm text-gray-400 text-center">
                                        No users in the system.
                                    </td>
                                </tr>
                            </c:if>

                            <c:forEach var="user" items="${users}">
                                <%-- Client-side role filter --%>
                                <tr class="border-b border-gray-50 hover:bg-gray-50 user-row"
                                    data-role="${user.role}">
                                    <td class="px-5 py-3 font-medium text-gray-900">
                                        ${user.name}
                                    </td>
                                    <td class="px-5 py-3 text-gray-500">${user.email}</td>
                                    <td class="px-5 py-3">
                                        <span class="text-xs px-2 py-1 rounded-full font-medium
                                            ${user.role == 'student' ? 'bg-blue-50 text-blue-600' :
                                              user.role == 'lecturer' ? 'bg-teal-50 text-teal-600' :
                                              'bg-purple-50 text-purple-600'}">
                                            ${user.role}
                                        </span>
                                    </td>
                                    <td class="px-5 py-3">
                                        <span class="text-xs px-2 py-1 rounded-full font-medium
                                            ${user.status == 'active' ? 'bg-green-50 text-green-600' : 'bg-red-50 text-red-600'}">
                                            ${user.status}
                                        </span>
                                    </td>
                                    <td class="px-5 py-3 text-gray-400 text-xs">${user.createdAt}</td>
                                    <td class="px-5 py-3">
                                        <div class="flex gap-2 justify-end">

                                            <%-- UC020 Edit button --%>
                                            <button onclick="showEditUser(
                                                        ${user.id},
                                                        '${user.name}',
                                                        '${user.email}',
                                                        '${user.role}')"
                                                    class="text-xs border border-gray-200 text-gray-600 px-3 py-1.5 rounded-lg hover:bg-gray-50">
                                                Edit
                                            </button>

                                            <%-- UC020 Deactivate / Activate toggle --%>
                                            <c:choose>
                                                <c:when test="${user.status == 'active'}">
                                                    <form action="${pageContext.request.contextPath}/admin/users"
                                                          method="post">
                                                        <input type="hidden" name="action" value="deactivate"/>
                                                        <input type="hidden" name="userId" value="${user.id}"/>
                                                        <button type="submit"
                                                                class="text-xs border border-amber-200 text-amber-600 px-3 py-1.5 rounded-lg hover:bg-amber-50">
                                                            Deactivate
                                                        </button>
                                                    </form>
                                                </c:when>
                                                <c:otherwise>
                                                    <form action="${pageContext.request.contextPath}/admin/users"
                                                          method="post">
                                                        <input type="hidden" name="action" value="activate"/>
                                                        <input type="hidden" name="userId" value="${user.id}"/>
                                                        <button type="submit"
                                                                class="text-xs border border-green-200 text-green-600 px-3 py-1.5 rounded-lg hover:bg-green-50">
                                                            Activate
                                                        </button>
                                                    </form>
                                                </c:otherwise>
                                            </c:choose>

                                            <%-- UC020 Delete --%>
                                            <form action="${pageContext.request.contextPath}/admin/users"
                                                  method="post"
                                                  onsubmit="return confirm('Delete this user? All their data will be permanently removed.')">
                                                <input type="hidden" name="action" value="delete"/>
                                                <input type="hidden" name="userId" value="${user.id}"/>
                                                <button type="submit"
                                                        class="text-xs border border-red-200 text-red-500 px-3 py-1.5 rounded-lg hover:bg-red-50">
                                                    Delete
                                                </button>
                                            </form>

                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

            </main>
        </div>

        <%-- UC020 Edit user modal --%>
        <div id="editUserModal" class="hidden fixed inset-0 bg-black bg-opacity-20 flex items-center justify-center z-50">
            <div class="bg-white rounded-xl border border-gray-100 p-6 w-full max-w-md">
                <h2 class="text-sm font-medium text-gray-900 mb-4">Edit User</h2>
                <form action="${pageContext.request.contextPath}/admin/users" method="post">
                    <input type="hidden" name="action" value="edit"/>
                    <input type="hidden" name="userId" id="editUserId"/>
                    <div class="mb-3">
                        <label class="block text-xs font-medium text-gray-600 mb-1">Full name</label>
                        <input type="text" name="name" id="editUserName" required
                               class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"/>
                    </div>
                    <div class="mb-3">
                        <label class="block text-xs font-medium text-gray-600 mb-1">Email</label>
                        <input type="email" name="email" id="editUserEmail" required
                               class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"/>
                    </div>
                    <div class="mb-5">
                        <label class="block text-xs font-medium text-gray-600 mb-1">Role</label>
                        <select name="role" id="editUserRole"
                                class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-indigo-500">
                            <option value="student">Student</option>
                            <option value="lecturer">Lecturer</option>
                            <option value="admin">Admin</option>
                        </select>
                    </div>
                    <div class="flex gap-2 justify-end">
                        <button type="button" onclick="hideEditUser()"
                                class="text-sm border border-gray-200 text-gray-600 px-4 py-2 rounded-lg hover:bg-gray-50">
                            Cancel
                        </button>
                        <button type="submit"
                                class="text-sm bg-indigo-600 hover:bg-indigo-700 text-white px-4 py-2 rounded-lg">
                            Save changes
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function showEditUser(id, name, email, role) {
                document.getElementById('editUserId').value  = id;
                document.getElementById('editUserName').value  = name;
                document.getElementById('editUserEmail').value = email;
                document.getElementById('editUserRole').value  = role;
                document.getElementById('editUserModal').classList.remove('hidden');
            }
            function hideEditUser() {
                document.getElementById('editUserModal').classList.add('hidden');
            }
        </script>
    </body>
</html>
