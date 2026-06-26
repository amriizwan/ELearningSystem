/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.elearningsystem.controller;

import com.mycompany.elearningsystem.model.Course;
import com.mycompany.elearningsystem.model.CourseDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 *
 * @author amri1
 */

@WebServlet("/course")
public class CourseServlet extends HttpServlet {
    private final CourseDAO courseDAO = new CourseDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        String role = (String) session.getAttribute("role");
        int userId = (int) session.getAttribute("userId");

        try {
            switch (role) {

                case "student":
                    List<Course> allCourses = courseDAO.getAllCourses();
                    List<Course> enrolledCourses = courseDAO.getEnrolledCourses(userId);
                    if (allCourses.isEmpty()) {
                        req.setAttribute("error", "No course available");
                    }
                    req.setAttribute("allCourses", allCourses);
                    req.setAttribute("enrolledCourses", enrolledCourses);
                    req.getRequestDispatcher("/WEB-INF/views/student/course.jsp").forward(req, resp);
                    break;

                case "lecturer":
                    List<Course> allForLecturer = courseDAO.getAllCourses();
                    List<Course> myCourses = courseDAO.getCoursesByLecturer(userId);
                    if (allForLecturer.isEmpty()) {
                        req.setAttribute("error", "No course available");
                    }
                    req.setAttribute("allCourses", allForLecturer);
                    req.setAttribute("myCourses", myCourses);
                    req.getRequestDispatcher("/WEB-INF/views/lecturer/course.jsp").forward(req, resp);
                    break;

                case "admin":
                    List<Course> adminCourses = courseDAO.getAllCoursesWithCount();
                    req.setAttribute("courses", adminCourses);
                    req.getRequestDispatcher("/WEB-INF/views/admin/course.jsp").forward(req, resp);
                    break;

                default:
                    resp.sendRedirect(req.getContextPath() + "/login");
            }
        } catch (SQLException e) {
            throw new ServletException("Database error loading courses", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        int userId = (int) session.getAttribute("userId");
        String action = req.getParameter("action");
        int courseId = Integer.parseInt(req.getParameter("courseId"));

        try {
            switch (action) {

                case "enrol":
                    if (!courseDAO.isEnrolled(userId, courseId)) {
                        courseDAO.enrollStudent(userId, courseId);
                        session.setAttribute("success", "You have successfully enrolled in this course");
                    }
                    break;

                case "unenroll":
                    courseDAO.unenrollStudent(userId, courseId);
                    session.setAttribute("success", "You have unenrolled from this course");
                    break;

                case "teach":
                    if (!courseDAO.isTeaching(userId, courseId)) {
                        courseDAO.assignLecturer(userId, courseId);
                        session.setAttribute("success", "You are now teaching this course");
                    }
                    break;

                case "stopteach":
                    courseDAO.removeLecturer(userId, courseId);
                    session.setAttribute("success", "You have stopped teaching this course");
                    break;

                case "create":
                    String newTitle = req.getParameter("title");
                    String newDesc = req.getParameter("description");
                    if (newTitle == null || newTitle.trim().isEmpty()) {
                        session.setAttribute("error", "Course title cannot be empty");
                    } else {
                        courseDAO.createCourse(newTitle.trim(), newDesc);
                        session.setAttribute("success", "Course created successfully");
                    }
                    break;

                case "update":
                    courseDAO.updateCourse(courseId, req.getParameter("title"), req.getParameter("description"));
                    session.setAttribute("success", "Course updated successfully");
                    break;

                case "delete":
                    courseDAO.deleteCourse(courseId);
                    session.setAttribute("success", "Course deleted successfully");
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error processing course action", e);
        }

        resp.sendRedirect(req.getContextPath() + "/course");
    }
}
