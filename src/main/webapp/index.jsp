<%-- 
    Document   : index
    Created on : Jun 22, 2026, 4:18:48 PM
    Author     : amri1
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MyStudyZone — Welcome</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Plus Jakarta Sans', sans-serif; }
    </style>
</head>
<body class="min-h-screen bg-slate-50 text-slate-900 flex flex-col justify-between selection:bg-indigo-500 selection:text-white">

    <header class="w-full bg-white/80 backdrop-blur-md border-b border-slate-100 sticky top-0 z-50">
        <div class="max-w-7xl mx-auto px-6 h-16 flex items-center justify-between">
            <div class="flex items-center gap-3">
                <div class="inline-flex items-center justify-center w-10 h-10 bg-indigo-600 text-white rounded-xl shadow-md shadow-indigo-200">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-5 h-5">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M4.26 10.147a60.438 60.438 0 0 0-.491 6.347A48.62 48.62 0 0 1 12 20.904a48.62 48.62 0 0 1 8.232-4.41 60.46 60.46 0 0 0-.491-6.347m-15.482 0a50.636 50.636 0 0 0-2.658-.813A59.906 59.906 0 0 1 12 3.493a59.903 59.903 0 0 1 10.399 5.84c-.896.248-1.783.52-2.658.814m-15.482 0A50.717 50.717 0 0 1 12 13.489a50.702 50.702 0 0 1 7.74-3.342M6.75 15a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5Zm0 0v-3.675A55.378 55.378 0 0 1 12 8.443m-7.007 11.55A5.981 5.981 0 0 0 6.75 15.75v-1.5" />
                    </svg>
                </div>
                <div>
                    <span class="text-lg font-bold tracking-tight text-slate-900">MyStudyZone</span>
                    <span class="block text-[10px] text-indigo-600 font-semibold uppercase tracking-wider">CS2304C</span>
                </div>
            </div>

            <div class="flex items-center gap-4">
                <a href="${pageContext.request.contextPath}/login" 
                   class="text-sm font-medium text-slate-600 hover:text-indigo-600 transition-colors">
                    Sign in
                </a>
                <a href="${pageContext.request.contextPath}/register" 
                   class="bg-indigo-600 hover:bg-indigo-700 text-white text-sm font-medium px-4 py-2 rounded-xl transition-all duration-200 shadow-sm shadow-indigo-100 hover:shadow-md">
                    Get Started
                </a>
            </div>
        </div>
    </header>

    <main class="flex-grow">
        <section class="max-w-7xl mx-auto px-6 pt-16 pb-20 grid lg:grid-cols-12 gap-12 items-center">
            <div class="lg:col-span-7 space-y-6 text-center lg:text-left">
                <div class="inline-flex items-center gap-2 bg-indigo-50 border border-indigo-100 rounded-full px-3 py-1 text-xs font-semibold text-indigo-700">
                    <span class="flex h-2 w-2 rounded-full bg-indigo-500 animate-pulse"></span>
                    UiTM E-Learning System
                </div>
                <h2 class="text-4xl sm:text-5xl lg:text-6xl font-bold tracking-tight text-slate-900 leading-[1.15]">
                    Your Ultimate Hub for <span class="text-indigo-600 bg-gradient-to-r from-indigo-600 to-violet-500 bg-clip-text text-transparent">Academic Success</span>
                </h2>
                <p class="text-slate-600 text-base sm:text-lg max-w-2xl mx-auto lg:mx-0 leading-relaxed">
                    Access high-quality course materials, engage in timed quizzes, submit your assignments flawlessly, and experience a unified platform engineered specifically for your academic timeline.
                </p>
                <div class="flex flex-col sm:flex-row items-center justify-center lg:justify-start gap-4 pt-2">
                    <a href="${pageContext.request.contextPath}/register" 
                       class="w-full sm:w-auto bg-indigo-600 hover:bg-indigo-700 text-white font-medium px-8 py-3.5 rounded-xl transition-all shadow-lg shadow-indigo-100 hover:shadow-xl hover:-translate-y-0.5 text-center">
                        Create Student Account
                    </a>
                    <a href="#features" 
                       class="w-full sm:w-auto bg-white border border-slate-200 hover:border-slate-300 text-slate-700 font-medium px-8 py-3.5 rounded-xl transition-all text-center">
                        Explore Features
                    </a>
                </div>
            </div>

            <div class="lg:col-span-5 flex justify-center">
                <div class="w-full max-w-md bg-white rounded-3xl shadow-xl shadow-slate-200/50 border border-slate-100 p-8 relative overflow-hidden group">
                    <div class="absolute -top-24 -right-24 w-48 h-48 bg-indigo-50 rounded-full blur-2xl transition-opacity group-hover:opacity-70"></div>
                    
                    <div class="relative z-10">
                        <div class="mb-6">
                            <h3 class="text-2xl font-bold text-slate-800">Welcome Portal</h3>
                            <p class="text-slate-400 text-xs mt-1">Ready to manage your academic syllabus?</p>
                        </div>

                        <div class="space-y-4 mb-8">
                            <div class="flex gap-4 items-start p-3 rounded-2xl bg-slate-50 border border-slate-100">
                                <span class="p-2 bg-indigo-100 text-indigo-600 rounded-xl">
                                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-5 h-5"><path stroke-linecap="round" stroke-linejoin="round" d="M12 6.042A8.967 8.967 0 0 0 6 3.75c-1.052 0-2.062.18-3 .512v14.25A8.987 8.987 0 0 1 6 18c2.305 0 4.408.867 6 2.292m0-14.25a8.966 8.966 0 0 1 6-2.292c1.052 0 2.062.18 3 .512v14.25A8.987 8.987 0 0 0 18 18a8.967 8.967 0 0 0-6 2.292m0-14.25v14.25" /></svg>
                                </span>
                                <div>
                                    <h4 class="text-sm font-semibold text-slate-800">Centralized Materials</h4>
                                    <p class="text-xs text-slate-500">Download slide decks, notes, and records quickly.</p>
                                </div>
                            </div>
                            <div class="flex gap-4 items-start p-3 rounded-2xl bg-slate-50 border border-slate-100">
                                <span class="p-2 bg-emerald-100 text-emerald-600 rounded-xl">
                                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-5 h-5"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12h3.75M9 15h3.75M9 18h3.75m3 .75H18a2.25 2.25 0 0 0 2.25-2.25V6.108c0-1.135-.845-2.098-1.976-2.192a48.424 48.424 0 0 0-1.123-.08m-5.801 0c-.065.21-.1.433-.1.664 0 .414.336.75.75.75h4.5a.75.75 0 0 0 .75-.75 2.25 2.25 0 0 0-.1-.664m-5.8 0A2.251 2.251 0 0 1 13.5 2.25H15c1.03 0 1.9.693 2.166 1.638m-7.377 2.24a4.5 4.5 0 1 1 8.754 0M16.5 21V16.5L12 14l-4.5 2.5V21" /></svg>
                                </span>
                                <div>
                                    <h4 class="text-sm font-semibold text-slate-800">Assessments & Tasks</h4>
                                    <p class="text-xs text-slate-500">Track deadlines and review immediate quiz metrics.</p>
                                </div>
                            </div>
                        </div>

                        <div class="flex flex-col gap-3">
                            <a href="${pageContext.request.contextPath}/login"
                               class="w-full bg-indigo-600 hover:bg-indigo-700 text-white text-sm font-medium py-3 px-4 rounded-xl transition-all text-center shadow-md shadow-indigo-100">
                                Sign In to Workspace
                            </a>
                            <a href="${pageContext.request.contextPath}/register"
                               class="w-full bg-white hover:bg-slate-50 text-slate-700 text-sm font-medium py-3 px-4 rounded-xl border border-slate-200 transition-colors text-center">
                                Create an account
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section id="features" class="bg-white border-t border-b border-slate-100 py-20">
            <div class="max-w-7xl mx-auto px-6">
                <div class="text-center max-w-2xl mx-auto mb-16">
                    <h3 class="text-3xl font-bold text-slate-900 tracking-tight">Everything you need in one zone</h3>
                    <p class="text-slate-500 mt-3">Tailored specifically for learning efficiency and clean execution.</p>
                </div>

                <div class="grid md:grid-cols-3 gap-8">
                    <div class="p-6 rounded-2xl bg-slate-50/50 border border-slate-100 hover:border-indigo-100 transition-all hover:bg-white hover:shadow-lg hover:shadow-slate-100">
                        <div class="w-12 h-12 bg-indigo-50 rounded-xl flex items-center justify-center text-indigo-600 font-bold mb-5">01</div>
                        <h4 class="text-lg font-bold text-slate-800 mb-2">Smart Submissions</h4>
                        <p class="text-slate-500 text-sm leading-relaxed">Submit documents seamlessly. Instant confirmations and dynamic grading updates directly in your dashboard portal.</p>
                    </div>
                    <div class="p-6 rounded-2xl bg-slate-50/50 border border-slate-100 hover:border-indigo-100 transition-all hover:bg-white hover:shadow-lg hover:shadow-slate-100">
                        <div class="w-12 h-12 bg-indigo-50 rounded-xl flex items-center justify-center text-indigo-600 font-bold mb-5">02</div>
                        <h4 class="text-lg font-bold text-slate-800 mb-2">Interactive Quizzes</h4>
                        <p class="text-slate-500 text-sm leading-relaxed">Test your knowledge parameters inside cleanly structured examinations with embedded timers and progress indices.</p>
                    </div>
                    <div class="p-6 rounded-2xl bg-slate-50/50 border border-slate-100 hover:border-indigo-100 transition-all hover:bg-white hover:shadow-lg hover:shadow-slate-100">
                        <div class="w-12 h-12 bg-indigo-50 rounded-xl flex items-center justify-center text-indigo-600 font-bold mb-5">03</div>
                        <h4 class="text-lg font-bold text-slate-800 mb-2">Resource Repositories</h4>
                        <p class="text-slate-500 text-sm leading-relaxed">Organized on a week-by-week layout system, making it incredibly simple to hunt down relevant course data items.</p>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <footer class="w-full bg-slate-900 text-slate-400 py-12 border-t border-slate-800">
        <div class="max-w-7xl mx-auto px-6 flex flex-col md:flex-row items-center justify-between gap-6 text-sm">
            <div class="flex items-center gap-3">
                <div class="inline-flex items-center justify-center w-8 h-8 bg-indigo-600 text-white rounded-lg">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-4 h-4">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M4.26 10.147a60.438 60.438 0 0 0-.491 6.347A48.62 48.62 0 0 1 12 20.904a48.62 48.62 0 0 1 8.232-4.41 60.46 60.46 0 0 0-.491-6.347m-15.482 0a50.636 50.636 0 0 0-2.658-.813A59.906 59.906 0 0 1 12 3.493a59.903 59.903 0 0 1 10.399 5.84c-.896.248-1.783.52-2.658.814m-15.482 0A50.717 50.717 0 0 1 12 13.489a50.702 50.702 0 0 1 7.74-3.342M6.75 15a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5Zm0 0v-3.675A55.378 55.378 0 0 1 12 8.443m-7.007 11.55A5.981 5.981 0 0 0 6.75 15.75v-1.5" />
                    </svg>
                </div>
                <span class="font-semibold text-white tracking-tight">MyStudyZone</span>
            </div>
            <p class="text-center md:text-left text-slate-500 text-xs">
                Faculty of Computer and Mathematical Sciences &nbsp;·&nbsp; Universiti Teknologi MARA (UiTM)
            </p>
            <p class="text-slate-500 text-xs">
                &copy; 2026 MyStudyZone. All rights reserved.
            </p>
        </div>
    </footer>

</body>
</html>