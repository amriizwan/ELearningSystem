/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.elearningsystem.controller;

import com.mycompany.elearningsystem.dao.DashboardDAO;
import com.mycompany.elearningsystem.model.ForumPost;
import com.mycompany.elearningsystem.model.QuizAttemptResult;
import com.mycompany.elearningsystem.model.Submission;
import com.mycompany.project.model.Course;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;

/**
 *
 * @author Haziq
 */

@WebServlet("/dashboard")
public class dashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── 1. Session check ─────────────────────────────────────────────────
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            // Not logged in — redirect to login page
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (!"lecturer".equals(role)) {
            // Wrong role — redirect to login
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        //HttpSession session = request.getSession(); //return current session / create new session
//            session.setAttribute("userId", 6);
//            session.setAttribute("userName", "Ziq");
//            session.setAttribute("role", "lecturer");

        // ── 2. Get session values ────────────────────────────────────────────
        int    lecturerId   = (Integer) session.getAttribute("userId");
        String lecturerName = (String)  session.getAttribute("name");
        String firstName    = dashboardController.getFirstName(lecturerName);

        // ── 3. Call DAO methods ──────────────────────────────────────────────
        DashboardDAO dao = new DashboardDAO();

        int course_count  = dao.getCourseCount(lecturerId);
        int student_count = dao.getStudentCount(lecturerId);
        int pending_mark  = dao.getPendingMarkCount(lecturerId);
        int notes_count   = dao.getNotesCount(lecturerId);
        int quiz_count    = dao.getQuizCount(lecturerId);

        ArrayList<Course>     courses             = dao.getCourses(lecturerId);
        ArrayList<Submission> pending_submissions  = dao.getPendingSubmissions(lecturerId);
        ArrayList<QuizAttemptResult> recent_attempts     = dao.getRecentAttempts(lecturerId);
        ArrayList<ForumPost>  recent_posts         = dao.getRecentPosts(lecturerId);

        // ── 4. Greeting & date ───────────────────────────────────────────────
        String greeting   = dashboardController.getGreeting();
        String today      = dashboardController.getTodayFormatted();

        // ── 5. Pass data to JSP via request attributes ───────────────────────
        request.setAttribute("firstName",           firstName);
        request.setAttribute("greeting",            greeting);
        request.setAttribute("today",               today);

        request.setAttribute("course_count",        course_count);
        request.setAttribute("student_count",       student_count);
        request.setAttribute("pending_mark",        pending_mark);
        request.setAttribute("notes_count",         notes_count);
        request.setAttribute("quiz_count",          quiz_count);

        request.setAttribute("courses",             courses);
        request.setAttribute("pending_submissions", pending_submissions);
        request.setAttribute("recent_attempts",     recent_attempts);
        request.setAttribute("recent_posts",        recent_posts);

        // ── 6. Forward to JSP ────────────────────────────────────────────────
        request.getRequestDispatcher("/WEB-INF/view/lecture/dashboard.jsp").forward(request, response);
    }
    
    public static String getGreeting() {
        int hour = LocalDateTime.now().getHour();
        if (hour < 12) {
            return "Good morning";
        } else if (hour < 17) {
            return "Good afternoon";
        } else {
            return "Good evening";
        }
    }
    
    public static String getTodayFormatted() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEEE, dd MMMM yyyy");
        return LocalDate.now().format(formatter);
    }
    
    public static String getFirstName(String fullName) {
        if (fullName == null || fullName.isEmpty()) {
            return "";
        }
        return fullName.split(" ")[0];
    }
}
