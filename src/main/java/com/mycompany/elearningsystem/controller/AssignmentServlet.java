    /*
     * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
     * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
     */
    package com.mycompany.elearningsystem.controller;

    import com.mycompany.elearningsystem.model.Assignment;
    import com.mycompany.elearningsystem.model.AssignmentDAO;
    import com.mycompany.elearningsystem.model.AssignmentSubmission;
    import com.mycompany.elearningsystem.model.Course;
    import com.mycompany.elearningsystem.model.CourseDAO;
    import jakarta.servlet.ServletException;
    import jakarta.servlet.annotation.MultipartConfig;
    import jakarta.servlet.annotation.WebServlet;
    import jakarta.servlet.http.HttpServlet;
    import jakarta.servlet.http.HttpServletRequest;
    import jakarta.servlet.http.HttpServletResponse;
    import jakarta.servlet.http.HttpSession;
    import jakarta.servlet.http.Part;
    import java.io.File;
    import java.io.IOException;
    import java.io.InputStream;
    import java.io.PrintWriter;
    import java.nio.file.Files;
    import java.nio.file.Paths;
    import java.nio.file.StandardCopyOption;
    import java.sql.SQLException;
    import java.util.List;
    import java.util.UUID;

    /**
     *
     * @author amri1
     */
    /**
     * UC006 - View assignment (Student)
     * UC007 - Submit assignment (Student)
     * UC016 - Manage assignment (Lecturer)
     *
     * GET  /assignment                         -> list assignments by role
     * GET  /assignment?id=X                   -> UC006 Step 2: show assignment detail panel
     * GET  /assignment?viewSubmissions=X      -> lecturer views submissions for assignment X
     * POST /assignment?action=submit          -> UC007: student submits
     * POST /assignment?action=create          -> UC016: lecturer creates
     * POST /assignment?action=update          -> UC016: lecturer edits
     * POST /assignment?action=delete          -> UC016: lecturer deletes
     * POST /assignment?action=mark            -> lecturer marks a submission
     */
    @WebServlet("/assignment")
    @MultipartConfig
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

                    // UC006 Step 1: list all assignments across enrolled courses
                    List<Assignment> assignments = assignmentDAO.getAssignmentsByStudent(userId);

                    if (assignments.isEmpty()) {
                        req.setAttribute("error", "No assignments available");
                    }

                    req.setAttribute("assignments", assignments);

                    // UC006 Step 2: if student clicked a specific assignment, load detail panel
                    String idParam = req.getParameter("id");
                    if (idParam != null) {
                        int assignmentId = Integer.parseInt(idParam);
                        Assignment selected = assignmentDAO.getAssignmentById(assignmentId);
                        AssignmentSubmission existingSubmission =
                                assignmentDAO.getSubmission(assignmentId, userId);

                        req.setAttribute("selected", selected);
                        req.setAttribute("existingSubmission", existingSubmission);
                    }

                    req.getRequestDispatcher("/WEB-INF/views/student/assignment.jsp")
                            .forward(req, resp);

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
                        Assignment selected = assignmentDAO.getAssignmentById(assignmentId);
                        req.setAttribute("submissions", submissions);
                        req.setAttribute("selected", selected);
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

                    // UC007: Student submits assignment
                    case "submit": {
                        int assignmentId = Integer.parseInt(req.getParameter("assignmentId"));
    //                    String fileUrl   = req.getParameter("fileUrl");
                        String answerText = req.getParameter("answerText");

                        // UC007 E2: neither file nor text provided
    //                    if ((fileUrl == null || fileUrl.trim().isEmpty()) &&
    //                        (answerText == null || answerText.trim().isEmpty())) {
    //                        session.setAttribute("error",
    //                                "Please upload a file or enter a text answer before submitting.");
    //                        resp.sendRedirect(req.getContextPath() +
    //                                "/assignment?id=" + assignmentId);
    //                        return;
    //                    }
    //
    //                    // UC007 E1: validate file format — only PDF allowed
    //                    if (fileUrl != null && !fileUrl.trim().isEmpty()) {
    //                        String lower = fileUrl.trim().toLowerCase();
    //                        if (!lower.endsWith(".pdf")) {
    //                            session.setAttribute("error", "Invalid file format");
    //                            resp.sendRedirect(req.getContextPath() +
    //                                    "/assignment?id=" + assignmentId);
    //                            return;
    //                        }
    //                    }

                        // Prevent duplicate submission
    //                    if (assignmentDAO.hasSubmitted(assignmentId, userId)) {
    //                        session.setAttribute("error",
    //                                "You have already submitted this assignment.");
    //                        resp.sendRedirect(req.getContextPath() +
    //                                "/assignment?id=" + assignmentId);
    //                        return;
    //                    }

                        Part part = req.getPart("file");
                        String contentType = part.getContentType();
                        if (part == null || part.getSize() == 0) {
                            session.setAttribute("error", "Please select a file to upload");
                            resp.sendRedirect(req.getContextPath() +
                                        "/assignment?id=" + assignmentId);
                            return;
                        }
                        if (!(contentType.equals("application/pdf"))) {
                            session.setAttribute("error",
                                    "Only PDF files are allowed.");

                            resp.sendRedirect(req.getContextPath() +
                                        "/assignment?id=" + assignmentId);
                            return;
                        }

                        String uploadPath = getServletContext().getRealPath("/uploads/assignments");
//
                        File dir = new File(uploadPath);
                       if (!dir.exists()) {
                            dir.mkdirs();
                        }

                        String fileName = Paths.get(part.getSubmittedFileName())
                                               .getFileName()
                                               .toString();
                        String extension = "";

                        int dot = fileName.lastIndexOf('.');

                        if (dot != -1) {
                            extension = fileName.substring(dot);
                        }

                        String fileName2 = UUID.randomUUID().toString().substring(0, 8) + "-" + assignmentId + extension;

                        String filePath = uploadPath + File.separator + fileName2;
                       
                        
                        
                        try (InputStream input = part.getInputStream()) {
                            Files.copy(input, Paths.get(filePath),
                                    StandardCopyOption.REPLACE_EXISTING);
                        }

                        String fileUrl = "uploads/assignments/" + fileName2;
                        // UC007 Step 3: store submission
                        assignmentDAO.submitAssignment(assignmentId, userId, fileUrl, answerText != null ? answerText.trim() : null);

                        // UC007 Post condition: confirmation message
                        session.setAttribute("success",
                                "Assignment submitted successfully");
                        resp.sendRedirect(req.getContextPath() + "/assignment");
                        return;
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
