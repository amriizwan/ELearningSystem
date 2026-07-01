package com.mycompany.elearningsystem.controller;

import com.mycompany.elearningsystem.model.Assignment;
import com.mycompany.elearningsystem.dao.AssignmentDAO;
import com.mycompany.elearningsystem.model.Course;
import com.mycompany.elearningsystem.dao.CourseDAO;
import com.mycompany.elearningsystem.model.Enrollment;
import com.mycompany.elearningsystem.dao.EnrollmentDAO;
import com.mycompany.elearningsystem.model.Note;
import com.mycompany.elearningsystem.dao.NoteDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
                    EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
                    List<Course> enrolledCourses = enrollmentDAO.getEnrollmentsCourses(userId);
                    req.setAttribute("enrolledCourses", enrolledCourses);

                    String courseIdParam = req.getParameter("id");
                    String lectIdParam = req.getParameter("lecturerId");
                    

                    if (courseIdParam != null) {
                        int courseId = Integer.parseInt(courseIdParam);

                        List<Enrollment> lectCourse = enrollmentDAO.getLectforCourse(courseId);
                        req.setAttribute("lectCourse", lectCourse);
                        req.setAttribute("selected_courseId", courseId);

                        if (lectIdParam != null) {
                            int lecturerId = Integer.parseInt(lectIdParam);

                            NoteDAO noteDAO = new NoteDAO();

                            List<Note> notes = noteDAO.getNotesByCL(courseId, lecturerId);
                            req.setAttribute("notes", notes);
                            req.setAttribute("selected_lecturerId", lecturerId);

                            AssignmentDAO assignmentDAO = new AssignmentDAO();

                            List<Assignment> assignments = assignmentDAO.getAssignmentsByCL(courseId, lecturerId, userId);
                            req.setAttribute("assignments", assignments);
                        }
                    }
                    
                    List<Map<String, String>> palettes = new ArrayList<>();
                    Map<String, String> p1 = new HashMap<>();
                    p1.put("badge", "bg-emerald-100 text-emerald-800");
                    p1.put("bar", "bg-emerald-500");
                    p1.put("icon", "bg-emerald-50 text-emerald-600");
                    palettes.add(p1);

                    Map<String, String> p2 = new HashMap<>();
                    p2.put("badge", "bg-violet-100 text-violet-800");
                    p2.put("bar", "bg-violet-500");
                    p2.put("icon", "bg-violet-50 text-violet-600");
                    palettes.add(p2);

                    Map<String, String> p3 = new HashMap<>();
                    p3.put("badge", "bg-amber-100 text-amber-800");
                    p3.put("bar", "bg-amber-500");
                    p3.put("icon", "bg-amber-50 text-amber-600");
                    palettes.add(p3);

                    Map<String, String> p4 = new HashMap<>();
                    p4.put("badge", "bg-blue-100 text-blue-800");
                    p4.put("bar", "bg-blue-500");
                    p4.put("icon", "bg-blue-50 text-blue-600");
                    palettes.add(p4);

                    Map<String, String> p5 = new HashMap<>();
                    p5.put("badge", "bg-rose-100 text-rose-800");
                    p5.put("bar", "bg-rose-500");
                    p5.put("icon", "bg-rose-50 text-rose-600");
                    palettes.add(p5);

                    Map<String, String> p6 = new HashMap<>();
                    p6.put("badge", "bg-teal-100 text-teal-800");
                    p6.put("bar", "bg-teal-500");
                    p6.put("icon", "bg-teal-50 text-teal-600");
                    palettes.add(p6);

                    req.setAttribute("palettes", palettes);

                    req.getRequestDispatcher("/WEB-INF/views/student/course.jsp")
                           .forward(req, resp);
                    break;
                    

                case "lecturer":
//                    List<Course> allForLecturer = courseDAO.getAllCourses();
//                    List<Course> myCourses = courseDAO.getCoursesByLecturer(userId);
//                    if (allForLecturer.isEmpty()) {
//                        req.setAttribute("error", "No course available");
//                    }
//                    req.setAttribute("allCourses", allForLecturer);
//                    req.setAttribute("myCourses", myCourses);
//                    req.getRequestDispatcher("/WEB-INF/views/lecturer/course.jsp").forward(req, resp);
//                    break;

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
