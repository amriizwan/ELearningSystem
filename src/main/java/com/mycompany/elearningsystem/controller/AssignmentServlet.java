package com.mycompany.elearningsystem.controller;

import com.mycompany.elearningsystem.model.Assignment;
import com.mycompany.elearningsystem.dao.AssignmentDAO;
import com.mycompany.elearningsystem.model.AssignmentSubmission;
import com.mycompany.elearningsystem.model.Course;
import com.mycompany.elearningsystem.dao.CourseDAO;
import com.mycompany.elearningsystem.dao.SubscriptionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@WebServlet("/assignment")
public class AssignmentServlet extends HttpServlet {

    private final AssignmentDAO assignmentDAO = new AssignmentDAO();
    private final CourseDAO courseDAO = new CourseDAO();
    private final SubscriptionDAO subsDAO = new SubscriptionDAO();

    // ---------------------------------------------------------------
    // GET — display assignment pages
    // ---------------------------------------------------------------
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        String role = (String) session.getAttribute("role");
        int userId = (int) session.getAttribute("userId");

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
            
            int lecture_id = (Integer) session.getAttribute("userId");
            List<Assignment> lectCourses = assignmentDAO.getLecturerCourse(lecture_id);
            
            
            //getparameter
            String course_idStr = req.getParameter("course_id");
            
            //selectedCourse
            if(course_idStr != null){
                int course_id = Integer.parseInt(course_idStr);
                List<Assignment> listAssignment = assignmentDAO.getAssignment(course_id, lecture_id);
                req.setAttribute("listAssignment", listAssignment);
            }
            
            //check if assignment upload has reached limit and a subscriber 
            boolean hasReachLimit = false;
            if (!subsDAO.isSubscribe(userId)) {
                hasReachLimit = subsDAO.isAssignmentsLimit(userId);
            }
            req.setAttribute("hasReachLimit", hasReachLimit);
            req.setAttribute("price", "14.99");
            
            String view = req.getParameter("view");
            String asgn_idStr = req.getParameter("asgn_id");
            if(view != null){
                if(view.equals("edit")){
                    int asgn_id = Integer.parseInt(asgn_idStr);
                    Assignment selectedAssign = assignmentDAO.getSelectedAssignment(asgn_id, lecture_id);
                    req.setAttribute("selectedAssign", selectedAssign);
                }
                else if(view.equals("submissions")){
                    int asgn_id = Integer.parseInt(asgn_idStr);
                    List<AssignmentSubmission> submission = assignmentDAO.getSubmissionAssignment(asgn_id);
                    Assignment selectedAssign = assignmentDAO.getSelectedAssignment(asgn_id, lecture_id);
                    req.setAttribute("selectedAssign", selectedAssign);
                    req.setAttribute("submission", submission);
                }
                else if(view.equals("mark")){
                    int asgn_id = Integer.parseInt(asgn_idStr);
                    String submission_idStr = req.getParameter("submission_id");
                    int submission_id = Integer.parseInt(submission_idStr);
                    
                    AssignmentSubmission forMark = assignmentDAO.getForMarking(submission_id, lecture_id);
                    req.setAttribute("forMark", forMark);
                }
            }
            //palete css
            List<String> palettes = Arrays.asList(
                    "bg-emerald-50 text-emerald-600",
                    "bg-violet-50 text-violet-600",
                    "bg-amber-50 text-amber-600",
                    "bg-blue-50 text-blue-600",
                    "bg-rose-50 text-rose-600",
                    "bg-teal-50 text-teal-600"
            );
            
            //send attribute
            req.setAttribute("course_id", course_idStr);
            req.setAttribute("currentDate", new java.util.Date());
            req.setAttribute("lectCourses", lectCourses);
            req.setAttribute("palettes", palettes);
            
            req.getRequestDispatcher("/WEB-INF/views/lecturer/assignment.jsp")
                    .forward(req, resp);
            
        } else {
            resp.sendRedirect(req.getContextPath() + "/login");
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
        int lecture_id = (Integer) session.getAttribute("userId");
        Boolean is_true = false;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
       
        String course_idStr = req.getParameter("course_id");
        int course_id = 0;
            if(course_idStr != null){
                course_id = Integer.parseInt(course_idStr);
            }

            switch (action) {
                //Student submits assignment
                case "submit": {
                    resp.sendRedirect(req.getContextPath() + "/submission");

                }
                // Lecturer creates assignment
                case "create_assignment": {
                    String selectedCourseIdStr = req.getParameter("selectedCourseId");
                    int selectedCourseId = Integer.parseInt(selectedCourseIdStr);
                    String title = req.getParameter("title");
                    String description = req.getParameter("description");

                    String max_marksStr = req.getParameter("max_marks");
                    int max_marks = Integer.parseInt(max_marksStr);
                    
                    
                    
                    String due_dateStr = req.getParameter("due_date");
                    
                    // Example: "2026-06-27T14:30"
                    LocalDateTime localDateTime = LocalDateTime.parse(due_dateStr);

                    Timestamp dueDate = Timestamp.valueOf(localDateTime);

                    Boolean uploadAssignment = assignmentDAO.uploadAssignmnet(selectedCourseId, lecture_id, title, description, dueDate, max_marks);
                    session.setAttribute("success", "Assignment created!");
                    break;
                }

                // Lecturer edits assignment
                case "edit_assignment": {
                    String asgn_idStr = req.getParameter("asgn_id");
                    int asgn_id = Integer.parseInt(asgn_idStr);

                    String title = req.getParameter("title");

                    String description = req.getParameter("description");

                    String max_marksStr = req.getParameter("max_marks");
                    int max_marks = Integer.parseInt(max_marksStr);

                    String due_dateStr = req.getParameter("due_date");

                    // Example: "2026-06-27T14:30"
                    LocalDateTime localDateTime = LocalDateTime.parse(due_dateStr);

                    Timestamp dueDate = Timestamp.valueOf(localDateTime);

                    Boolean editAssignment = assignmentDAO.editAssignment(asgn_id, title, description, dueDate, max_marks, lecture_id);
                    session.setAttribute("success", "Assignment updated!");
                    
                    break;
                }

                //Lecturer deletes assignment
                case "delete_assignment": {
                    String asgn_idStr = req.getParameter("asgn_id");
                    int asgn_id = Integer.parseInt(asgn_idStr);
                    
                    
                    Boolean deleteAssignment = assignmentDAO.deleteAssignment(asgn_id,lecture_id );
                    session.setAttribute("success", "Assignment deleted!");
                    break;
                }

                // Lecturer marks a student submission
                case "mark_submission": {
                    String submission_idStr = req.getParameter("submission_id");
                    int submission_id = Integer.parseInt(submission_idStr);

                    String lecturer_comment = req.getParameter("lecturer_comment");
                    String markStr = req.getParameter("mark");
                    int mark = Integer.parseInt(markStr);

                    Boolean markAssign = assignmentDAO.markAssigment(submission_id, mark, lecturer_comment, lecture_id);
                    session.setAttribute("success", "Submission marked!!");
                    break;
                }
            }

        resp.sendRedirect(req.getContextPath() + "/assignment");
    }

}
