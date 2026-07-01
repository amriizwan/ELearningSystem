package com.mycompany.elearningsystem.controller;

import com.mycompany.elearningsystem.model.Assignment;
import com.mycompany.elearningsystem.dao.AssignmentDAO;
import com.mycompany.elearningsystem.model.AssignmentSubmission;
import com.mycompany.elearningsystem.model.Course;
import com.mycompany.elearningsystem.dao.CourseDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/assignment")
public class AssignmentServlet extends HttpServlet {

    private final AssignmentDAO assignmentDAO = new AssignmentDAO();
    private final CourseDAO courseDAO = new CourseDAO();

    // ---------------------------------------------------------------
    // GET — display assignment pages
    // ---------------------------------------------------------------
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        String role = (String) session.getAttribute("role");
        int userId = (int) session.getAttribute("userId");

        try {
            if ("student".equals(role)) {

                AssignmentDAO adao = new AssignmentDAO();
                List<Assignment> assignments = adao.getAssignmentsByEnrCourse(userId);
                List<Assignment> filteredAssignments = new ArrayList<>();

                int allCount = assignments.size();
                int pendingCount = 0;
                int submittedCount = 0;
                int markedCount = 0;

                String filter = req.getParameter("filter");
                if (filter == null || filter.isEmpty()) {
                    filter = "all";
                }

                for (Assignment a : assignments) {
                    String status = a.getStatus();

                    if (null != status) {
                        switch (status) {
                            case "overdue":
                            case "due_soon":
                            case "upcoming":
                                pendingCount++;
                                break;
                            case "submitted":
                                submittedCount++;
                                break;
                            case "marked":
                                markedCount++;
                                break;
                            default:
                                break;
                        }
                    }

                    if ("all".equals(filter)) {
                        filteredAssignments.add(a);
                    } else if ("pending".equals(filter)
                            && ("overdue".equals(status)
                            || "due_soon".equals(status)
                            || "upcoming".equals(status))) {
                        filteredAssignments.add(a);
                    } else if ("submitted".equals(filter)
                            && "submitted".equals(status)) {
                        filteredAssignments.add(a);
                    } else if ("marked".equals(filter)
                            && "marked".equals(status)) {
                        filteredAssignments.add(a);
                    }
                }

                String asgnId = req.getParameter("id");

                req.setAttribute("asgnId", asgnId);
                req.setAttribute("assignments", filteredAssignments);
                req.setAttribute("filter", filter);
                req.setAttribute("allCount", allCount);
                req.setAttribute("pendingCount", pendingCount);
                req.setAttribute("submittedCount", submittedCount);
                req.setAttribute("markedCount", markedCount);

                req.getRequestDispatcher("/WEB-INF/views/student/assignment.jsp").forward(req, resp);

            } else if ("lecturer".equals(role)) {

                // UC016 Step 1: list assignments + check if viewing submissions
                List<Assignment> assignments = assignmentDAO.getAssignmentsByLecturer(userId);
                List<Course> myCourses = courseDAO.getCoursesByLecturer(userId);

                if (myCourses.isEmpty()) {
                    req.setAttribute("error", "No courses available.");
                }

                req.setAttribute("assignments", assignments);
                req.setAttribute("myCourses", myCourses);

                // Lecturer clicking "View submissions" for a specific assignment
                String viewSubParam = req.getParameter("viewSubmissions");
                if (viewSubParam != null) {
                    int assignmentId = Integer.parseInt(viewSubParam);
                    List<AssignmentSubmission> submissions =
                            assignmentDAO.getSubmissionsByAssignment(assignmentId);
//                        Assignment selected = assignmentDAO.getAssignmentById(assignmentId);
                    req.setAttribute("submissions", submissions);
//                        req.setAttribute("selected", selected);
                }

                req.getRequestDispatcher("/WEB-INF/views/lecturer/assignment.jsp")
                        .forward(req, resp);

            } else {
                resp.sendRedirect(req.getContextPath() + "/login");
            }

        } catch (SQLException e) {
            throw new ServletException("Database error loading assignments", e);
        }
    }

    // ---------------------------------------------------------------
    // POST — handle all assignment actions
    // ---------------------------------------------------------------
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        int userId = (int) session.getAttribute("userId");
        String action = req.getParameter("action");

        try {
            switch (action) {

                //Student submits assignment
                case "submit": {
                    resp.sendRedirect(req.getContextPath() + "/submission");

                }

                // UC016 Step 2: Lecturer creates assignment
                case "create": {
                    int courseId     = Integer.parseInt(req.getParameter("courseId"));
                    String title     = req.getParameter("title");
                    String desc      = req.getParameter("description");
                    String dueDate   = req.getParameter("dueDate");
                    int maxMarks     = Integer.parseInt(req.getParameter("maxMarks"));

                    if (title == null || title.trim().isEmpty()) {
                        session.setAttribute("error", "Assignment title cannot be empty");
                    } else {
                        assignmentDAO.createAssignment(courseId, userId,
                                title.trim(), desc, dueDate, maxMarks);
                        session.setAttribute("success",
                                "Assignment created successfully");
                    }
                    break;
                }

                // UC016 Step 3: Lecturer edits assignment
                case "update": {
                    int assignmentId = Integer.parseInt(req.getParameter("assignmentId"));
                    String title     = req.getParameter("title");
                    String desc      = req.getParameter("description");
                    String dueDate   = req.getParameter("dueDate");
                    int maxMarks     = Integer.parseInt(req.getParameter("maxMarks"));

                    assignmentDAO.updateAssignment(assignmentId, userId,
                            title, desc, dueDate, maxMarks);
                    session.setAttribute("success",
                            "Assignment updated successfully");
                    break;
                }

                // UC016 Step 4: Lecturer deletes assignment
                case "delete": {
                    int assignmentId = Integer.parseInt(req.getParameter("assignmentId"));
                    assignmentDAO.deleteAssignment(assignmentId, userId);
                    session.setAttribute("success",
                            "Assignment deleted successfully");
                    break;
                }

                // Lecturer marks a student submission
                case "mark": {
                    int submissionId = Integer.parseInt(req.getParameter("submissionId"));
                    int mark         = Integer.parseInt(req.getParameter("mark"));
                    String comment   = req.getParameter("comment");
                    int assignmentId = Integer.parseInt(req.getParameter("assignmentId"));

                    assignmentDAO.markSubmission(submissionId, mark, comment);
                    session.setAttribute("success", "Submission marked successfully");
                    resp.sendRedirect(req.getContextPath() +
                            "/assignment?viewSubmissions=" + assignmentId);
                    return;
                }
            }

        } catch (SQLException e) {
            throw new ServletException("Database error processing assignment", e);
        }

        resp.sendRedirect(req.getContextPath() + "/assignment");
    }

}
