<%-- 
    Document   : index
    Created on : Jun 22, 2026, 4:18:48 PM
    Author     : amri1
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MyStudyZone — Welcome</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-gray-50 flex flex-col items-center justify-center px-4">

    <div class="w-full max-w-md text-center">
        <!-- Logo / Brand -->
        <div class="mb-8">            <%-- tengah --%>
            <div class="inline-flex items-center justify-center w-16 h-16 bg-indigo-600 rounded-2xl mb-4">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M4.26 10.147a60.438 60.438 0 0 0-.491 6.347A48.62 48.62 0 0 1 12 20.904a48.62 48.62 0 0 1 8.232-4.41 60.46 60.46 0 0 0-.491-6.347m-15.482 0a50.636 50.636 0 0 0-2.658-.813A59.906 59.906 0 0 1 12 3.493a59.903 59.903 0 0 1 10.399 5.84c-.896.248-1.783.52-2.658.814m-15.482 0A50.717 50.717 0 0 1 12 13.489a50.702 50.702 0 0 1 7.74-3.342M6.75 15a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5Zm0 0v-3.675A55.378 55.378 0 0 1 12 8.443m-7.007 11.55A5.981 5.981 0 0 0 6.75 15.75v-1.5" />
                </svg>    <%-- ambil svg icon https://heroicons.com/ --%>
            </div>
            <h1 class="text-3xl font-semibold text-gray-900">MyStudyZone</h1>
            <p class="text-gray-500 mt-2 text-sm">E-Learning System — CS2304C</p>
        </div>

        <!-- Card -->
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-8">
            <h2 class="text-xl font-medium text-gray-800 mb-2">Welcome</h2>
            <p class="text-gray-500 text-sm mb-8">
                Access course materials, assignments, quizzes, and more.
                Sign in to your account or create a new one to get started.
            </p>

            <!-- Buttons -->
            <div class="flex flex-col gap-3">
                            <%-- root path = ELearningSystem/... --%>
                <a href="${pageContext.request.contextPath}/login"
                   class="w-full bg-indigo-600 hover:bg-indigo-700 text-white text-sm font-medium py-3 px-4 rounded-xl transition-colors duration-150 text-center">
                    Sign in
                </a>
                <a href="${pageContext.request.contextPath}/register"
                   class="w-full bg-white hover:bg-gray-50 text-gray-700 text-sm font-medium py-3 px-4 rounded-xl border border-gray-200 transition-colors duration-150 text-center">
                    Create account
                </a>
            </div>
        </div>

        <!-- Footer note -->
        <p class="text-gray-400 text-xs mt-6">
            Faculty of Computer and Mathematical Sciences &nbsp;·&nbsp; UiTM
        </p>

    </div>

</body>
</html>
