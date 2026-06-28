<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MyStudyZone — Sign in</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-gray-50 flex flex-col items-center justify-center px-4">
    <div class="w-full max-w-md">

        <!-- Back to home -->
        <a href="${pageContext.request.contextPath}/"
           class="inline-flex items-center gap-2 text-sm text-gray-500 hover:text-gray-700 mb-6">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7"/>
            </svg>
            Back
        </a>

        <!--Kotak putih dekat tengah-->
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-8">
            <h1 class="text-xl font-medium text-gray-900 mb-1 text-center">Sign in</h1>
            <p class="text-gray-500 text-sm mb-6 text-center">Enter your email and password to continue.</p>

            <!-- Error message (from LoginServlet) -->
            <% if (request.getAttribute("error") != null) { %>
            <div class="bg-red-50 border border-red-100 text-red-700 text-sm rounded-xl px-4 py-3 mb-5">
                <%= request.getAttribute("error") %>
            </div>
            <% } %>

            <!-- Success message (from RegisterServlet redirect) -->
            <% if (request.getAttribute("success") != null) { %>
            <div class="bg-green-50 border border-green-100 text-green-700 text-sm rounded-xl px-4 py-3 mb-5">
                <%= request.getAttribute("success") %>
            </div>
            <% } %>

            <!--Form login, submit ke LoginServlet-->
            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Email address</label>
                    <input type="email" name="email" required
                           placeholder="you@example.com"
                           class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm text-gray-900 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent"/>
                </div>

                <div class="mb-6">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Password</label>
                    <input type="password" name="password" required
                           placeholder="******"
                           class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm text-gray-900 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent"/>
                </div>

                <button type="submit"
                        class="w-full bg-indigo-600 hover:bg-indigo-700 text-white text-sm font-medium py-3 rounded-xl transition-colors duration-150">
                    Sign in
                </button>
            </form>
        </div>

        <p class="text-center text-sm text-gray-500 mt-4">
            Don't have an account?
            <a href="${pageContext.request.contextPath}/register"
               class="text-indigo-600 hover:underline font-medium">Create one</a>
        </p>

    </div>
</body>
</html>
