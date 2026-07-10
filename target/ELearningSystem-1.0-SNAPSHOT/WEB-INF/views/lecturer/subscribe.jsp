<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css"/>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <style>
            body { font-family: 'Inter', ui-sans-serif, system-ui, sans-serif; }
            
            #loadingOverlay{

                position:fixed;
                inset:0;

                background:rgba(255,255,255,.95);

                display:none;

                justify-content:center;
                align-items:center;

                flex-direction:column;

                z-index:9999;

            }

            .loader{

                width:70px;
                height:70px;

                border:8px solid #ddd;
                border-top:8px solid #2563eb;

                border-radius:50%;

                animation:spin 1s linear infinite;

            }

            @keyframes spin{

                to{
                    transform:rotate(360deg);
                }

            }

            #loadingText{

                margin-top:25px;
                font-size:18px;
                font-weight:bold;

            }
        </style>
        <title>Notes</title>
    </head>
    <body class="bg-gradient-to-br from-slate-100 via-indigo-50 to-purple-100 min-h-screen">

        <div class="min-h-screen flex items-center justify-center px-6">

            <div class="max-w-md w-full">

                <!-- Badge -->
                <div class="flex justify-center mb-5">

                    <span class="bg-yellow-400 text-yellow-900 font-bold px-4 py-2 rounded-full text-sm shadow">
                        ⭐ MOST POPULAR
                    </span>

                </div>

                <div class="bg-white rounded-3xl shadow-2xl overflow-hidden">

                    <!-- Header -->

                    <div class="bg-gradient-to-r from-indigo-600 via-violet-600 to-purple-600 text-white p-8">

                        <div class="flex justify-center mb-5">

                            <div class="w-20 h-20 rounded-full bg-white/20 flex items-center justify-center">

                                <i class="fa-solid fa-crown text-yellow-300 text-4xl"></i>

                            </div>

                        </div>

                        <h1 class="text-3xl font-extrabold text-center">
                            Premium Lifetime
                        </h1>

                        <p class="text-center text-indigo-100 mt-2">
                            Unlock every feature forever.
                        </p>

                    </div>

                    <!-- Price -->

                    <div class="py-8 text-center">

                        <div class="text-6xl font-black text-indigo-600">
                            RM${amount}
                        </div>

                        <p class="text-green-600 font-semibold">
                            One-time payment
                        </p>

                    </div>

                    <!-- Features -->

                    <div class="px-8 space-y-4">
                        <c:if test="${role eq 'lecturer'}">
                            <div class="flex items-center gap-4">
                                <i class="fa-solid fa-circle-check text-green-500 text-xl"></i>
                                Unlimited Assignment Uploads
                            </div>

                            <div class="flex items-center gap-4">
                                <i class="fa-solid fa-circle-check text-green-500 text-xl"></i>
                                Unlimited Notes Uploads
                            </div>
                        </c:if>

                        <div class="flex items-center gap-4">
                            <i class="fa-solid fa-circle-check text-green-500 text-xl"></i>
                            Unlimited Discussion Posts
                        </div>

                        <div class="flex items-center gap-4">
                            <i class="fa-solid fa-circle-check text-green-500 text-xl"></i>
                            Lifetime Access
                        </div>

                        <div class="flex items-center gap-4">
                            <i class="fa-solid fa-circle-check text-green-500 text-xl"></i>
                            Instant Activation
                        </div>

                    </div>

                    <!-- CTA -->

                    <div class="p-8">

                        <button
                            onclick="simulatePayment()"
                            class="w-full bg-gradient-to-r from-indigo-600 to-violet-600 hover:from-indigo-700 hover:to-violet-700 text-white py-4 rounded-2xl text-lg font-bold shadow-lg hover:scale-105 transition duration-300">

                            Upgrade to Premium

                        </button>

                        <div class="mt-6 flex justify-center gap-6 text-sm text-slate-500">

                            <div>
                                <i class="fa-solid fa-lock"></i>
                                Secure Payment
                            </div>

                            <div>
                                <i class="fa-solid fa-bolt"></i>
                                Instant Access
                            </div>

                        </div>

                    </div>

                </div>

            </div>

        </div>
        <div id="loadingOverlay"
            class="fixed inset-0 bg-white/95 backdrop-blur flex items-center justify-center hidden z-50">

            <div class="bg-white rounded-3xl shadow-2xl p-10 w-96 text-center">

                <div class="loader mx-auto"></div>

                <h2 class="text-2xl font-bold mt-6">
                    Processing Payment
                </h2>

                <p id="loadingText"
                   class="text-slate-500 mt-3">
                    Connecting to secure payment gateway...
                </p>

                <div class="w-full h-2 bg-slate-200 rounded-full mt-8 overflow-hidden">

                    <div class="h-full bg-indigo-600 animate-pulse w-3/4 rounded-full"></div>

                </div>

            </div>

        </div>
        
        <form id="paymentForm" action="subscribe?prevPage=${prevPage}" method="post">

            <input type="hidden" name="amount" value="${amount}">

        </form>
    </body>
    <script>
        

        function simulatePayment(){

            document.getElementById("loadingOverlay").style.display="flex";

            const text=document.getElementById("loadingText");

            setTimeout(()=>{
                text.innerHTML="Verifying payment...";
            },1500);

            setTimeout(()=>{
                text.innerHTML="Activating Premium Membership...";
            },3000);

            setTimeout(()=>{
                text.innerHTML="Payment Successful ✓";
            },4500);

            setTimeout(()=>{
                document.getElementById("paymentForm").submit();
            },5500);

        }
    </script>
</html>