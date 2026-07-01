package com.mycompany.elearningsystem.controller;

import com.mycompany.elearningsystem.dao.DashboardDAO;
import com.mycompany.elearningsystem.dao.EnrollmentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private final DashboardDAO dashboardDAO = new DashboardDAO();
    private final EnrollmentDAO enrollmentDAO = new EnrollmentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        String role = (String) session.getAttribute("role");
        int userId = (int) session.getAttribute("userId");

        try {
            switch (role) {

                case "student":
                    LocalTime now = LocalTime.now();
                    String greeting;

                    if (now.getHour() < 12) {
                        greeting = "Good morning";
                    } else if (now.getHour() < 17) {
                        greeting = "Good afternoon";
                    } else {
                        greeting = "Good evening";
                    }

                // for color palettes        
                    List<Map<String, String>> palettes = new ArrayList<>();

                    Map<String, String> p1 = new HashMap<>();
                    p1.put("badge", "bg-emerald-100 text-emerald-800");
                    p1.put("bar", "bg-emerald-500");
                    palettes.add(p1);

                    Map<String, String> p2 = new HashMap<>();
                    p2.put("badge", "bg-violet-100 text-violet-800");
                    p2.put("bar", "bg-violet-500");
                    palettes.add(p2);

                    Map<String, String> p3 = new HashMap<>();
                    p3.put("badge", "bg-amber-100 text-amber-800");
                    p3.put("bar", "bg-amber-500");
                    palettes.add(p3);

                    Map<String, String> p4 = new HashMap<>();
                    p4.put("badge", "bg-blue-100 text-blue-800");
                    p4.put("bar", "bg-blue-500");
                    palettes.add(p4);

                    String today = LocalDate.now()
                            .format(DateTimeFormatter.ofPattern("EEEE, dd MMMM yyyy"));

                    req.setAttribute("greeting", greeting);
                    req.setAttribute("palettes", palettes);
                    req.setAttribute("today", today);
                    req.setAttribute("enrolledCourses", enrollmentDAO.getEnrollmentsCourses(userId));
                    req.setAttribute("enrolCourseCount", dashboardDAO.getTotalEnrolledCourses(userId));
                    req.setAttribute("totalAsgnCount", dashboardDAO.getTotalAssignments(userId));
                    req.setAttribute("overDueCount", dashboardDAO.getTotalOverdueAsgn(userId));
                    req.setAttribute("avlQuizCount", dashboardDAO.getTotalAvlQuiz(userId));
                    req.setAttribute("avgCount", dashboardDAO.getTotalAvgQuizScore(userId));
                    req.setAttribute("tasks", dashboardDAO.getUpcomingTasks(userId));

                    req.getRequestDispatcher("/WEB-INF/views/student/dashboard.jsp").forward(req, resp);
                    break;
                    

                case "lecturer":
//                    req.setAttribute("myCourses", dashboardDAO.getLecturerCourses(userId));
//                    req.setAttribute("pendingSubmissions", dashboardDAO.getPendingSubmissions(userId));
//                    req.getRequestDispatcher("/WEB-INF/views/lecturer/dashboard.jsp").forward(req, resp);
//                    break;

                case "admin":
                    req.setAttribute("stats", dashboardDAO.getAdminStats());
                    req.setAttribute("topCourses", dashboardDAO.getTopCourses());
                    req.setAttribute("recentUsers", dashboardDAO.getRecentUsers());
                    req.setAttribute("recentPosts", dashboardDAO.getRecentPosts());
                    req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
                    break;

                default:
                    resp.sendRedirect(req.getContextPath() + "/login");
            }

        } catch (SQLException e) {
            throw new ServletException("Database error loading dashboard", e);
        }
    }
}