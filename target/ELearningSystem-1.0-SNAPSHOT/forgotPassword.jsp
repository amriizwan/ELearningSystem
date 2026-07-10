<%@page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>MyStudyZone — Reset Password</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>

    <body class="min-h-screen bg-gray-50 flex flex-col items-center justify-center px-4">

        <div class="w-full max-w-md">

            <a href="${pageContext.request.contextPath}/login"
               class="inline-flex items-center gap-2 text-sm text-gray-500 hover:text-gray-700 mb-6">

                <svg class="w-4 h-4" fill="none" stroke="currentColor" 
                     stroke-width="2" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" 
                          d="M15 19l-7-7 7-7"/>
                </svg>

                Back to Sign in
            </a>


            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-8">

                <h1 class="text-xl font-medium text-gray-900 mb-1 text-center">
                    Reset Password
                </h1>

                <p class="text-gray-500 text-sm mb-6 text-center">
                    Enter your account details and create a new password.
                </p>


                <% if (request.getAttribute("error") != null) { %>
                <div class="bg-red-50 border border-red-100 text-red-700 text-sm rounded-xl px-4 py-3 mb-5">
                    <%= request.getAttribute("error") %>
                </div>
                <% } %>


                <% if (request.getAttribute("success") != null) { %>
                <div class="bg-green-50 border border-green-100 text-green-700 text-sm rounded-xl px-4 py-3 mb-5">
                    <%= request.getAttribute("success") %>
                </div>
                <% } %>


                <form action="${pageContext.request.contextPath}/resetPassword" 
                      method="post">


                    <!-- Email -->
                    <div class="mb-4">

                        <label class="block text-sm font-medium text-gray-700 mb-1">
                            Email address
                        </label>

                        <input type="email" 
                               name="email"
                               required
                               placeholder="you@example.com"
                               class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm 
                                      text-gray-900 placeholder-gray-400 
                                      focus:outline-none focus:ring-2 
                                      focus:ring-indigo-500 focus:border-transparent"/>

                    </div>



                    <!-- Name -->
                    <div class="mb-4">

                        <label class="block text-sm font-medium text-gray-700 mb-1">
                            Full Name
                        </label>

                        <input type="text"
                               name="name"
                               required
                               placeholder="Enter your name"
                               class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm 
                                      text-gray-900 placeholder-gray-400 
                                      focus:outline-none focus:ring-2 
                                      focus:ring-indigo-500 focus:border-transparent"/>

                    </div>



                    <!-- Password -->
                    <div class="mb-6">

                        <label class="block text-sm font-medium text-gray-700 mb-1">
                            New Password
                        </label>


                        <div class="relative">

                            <input id="password"
                                   type="password"
                                   name="password"
                                   required
                                   placeholder="Enter new password"
                                   class="w-full border border-gray-200 rounded-xl 
                                          pl-4 pr-12 py-2.5 text-sm 
                                          text-gray-900 placeholder-gray-400 
                                          focus:outline-none focus:ring-2 
                                          focus:ring-indigo-500 focus:border-transparent"/>


                            <button type="button"
                                    onclick="togglePasswordVisibility()"
                                    class="absolute inset-y-0 right-0 flex items-center pr-4 
                                           text-gray-400 hover:text-gray-600 focus:outline-none">


                                <!-- Eye -->
                                <svg id="eye-icon"
                                     class="w-5 h-5 block"
                                     fill="none"
                                     stroke="currentColor"
                                     stroke-width="2"
                                     viewBox="0 0 24 24">

                                    <path stroke-linecap="round"
                                          stroke-linejoin="round"
                                          d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>

                                    <path stroke-linecap="round"
                                          stroke-linejoin="round"
                                          d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>

                                </svg>


                                <!-- Eye slash -->
                                <svg id="eye-slash-icon"
                                     class="w-5 h-5 hidden"
                                     fill="none"
                                     stroke="currentColor"
                                     stroke-width="2"
                                     viewBox="0 0 24 24">

                                    <path stroke-linecap="round"
                                          stroke-linejoin="round"
                                          d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.542-7a10.025 10.025 0 014.132-5.4"/>

                                    <path stroke-linecap="round"
                                          stroke-linejoin="round"
                                          d="M9.9 4.24A9.122 9.122 0 0112 4c4.478 0 8.268 2.943 9.542 7a10.025 10.025 0 01-4.132 5.4"/>

                                    <path stroke-linecap="round"
                                          stroke-linejoin="round"
                                          d="M9.9 4.24L1.5 1.5m14 14L22.5 22.5"/>

                                </svg>

                            </button>

                        </div>

                    </div>



                    <button type="submit"
                            class="w-full bg-indigo-600 hover:bg-indigo-700 
                                   text-white text-sm font-medium 
                                   py-3 rounded-xl transition-colors duration-150">

                        Update Password

                    </button>


                </form>

            </div>


            <p class="text-center text-sm text-gray-500 mt-4">
                Remember your password?
                <a href="${pageContext.request.contextPath}/login"
                   class="text-indigo-600 hover:underline font-medium">
                    Sign in
                </a>
            </p>


        </div>



    <script>

    function togglePasswordVisibility() {

        const passwordInput = document.getElementById('password');
        const eyeIcon = document.getElementById('eye-icon');
        const eyeSlashIcon = document.getElementById('eye-slash-icon');


        if(passwordInput.type === "password") {

            passwordInput.type = "text";

            eyeIcon.classList.replace("block", "hidden");
            eyeSlashIcon.classList.replace("hidden", "block");

        } else {

            passwordInput.type = "password";

            eyeSlashIcon.classList.replace("block", "hidden");
            eyeIcon.classList.replace("hidden", "block");

        }

    }

    </script>


    </body>
</html>