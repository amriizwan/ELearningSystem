/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.elearningsystem.controller;

import com.mycompany.elearningsystem.model.DashboardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

/**
 *
 * @author amri1
 */
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private final DashboardDAO dashboardDAO = new DashboardDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        String role = (String) session.getAttribute("role");
        int userId = (int) session.getAttribute("userId");

        try {
            switch (role) {

                case "student":
                    //a1 set attribute dekat page dashboard student, hantar object(arraylist) ke page
                    req.setAttribute("enrolledCourses", dashboardDAO.getStudentCourses(userId));
                    req.setAttribute("upcomingAssignments", dashboardDAO.getUpcomingAssignments(userId));
                    req.setAttribute("recentQuizScores", dashboardDAO.getRecentQuizScores(userId));
                    req.getRequestDispatcher("/WEB-INF/views/student/dashboard.jsp").forward(req, resp);
                    break;

                case "lecturer":
                    req.setAttribute("myCourses", dashboardDAO.getLecturerCourses(userId));
                    req.setAttribute("pendingSubmissions", dashboardDAO.getPendingSubmissions(userId));
                    req.getRequestDispatcher("/WEB-INF/views/lecturer/dashboard.jsp").forward(req, resp);
                    break;

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