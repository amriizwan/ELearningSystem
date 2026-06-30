package com.mycompany.elearningsystem.controller;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */


import com.mycompany.elearningsystem.dao.AssignmentDAO;
import com.mycompany.elearningsystem.model.Assignment;
import com.mycompany.elearningsystem.model.Assignment_submit;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author User
 */
@WebServlet("/assignment")
public class AssignmentController extends HttpServlet{
    
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException{
         HttpSession session = request.getSession(false);
                if(session == null || session.getAttribute("userId") == null){
                    response.sendRedirect("login.jsp");
                    return;
                }
        
        int lecture_id = (Integer) session.getAttribute("userId");
        
        AssignmentDAO ad = new AssignmentDAO();
        List<Assignment> lectCourses = ad.getLecturerCourse(lecture_id);
        
        
        //getparameter
        String course_idStr = request.getParameter("course_id");
         
        //selectedCourse
        if(course_idStr != null){
           int course_id = Integer.parseInt(course_idStr);
             List<Assignment> listAssignment = ad.getAssignment(course_id, lecture_id);
             request.setAttribute("listAssignment", listAssignment);
        }
        
        String view = request.getParameter("view");
        String asgn_idStr = request.getParameter("asgn_id");
        if(view != null){
            if(view.equals("edit")){
                int asgn_id = Integer.parseInt(asgn_idStr);
                Assignment selectedAssign = ad.getSelectedAssignment(asgn_id, lecture_id);
                request.setAttribute("selectedAssign", selectedAssign);
            }
            else if(view.equals("submissions")){
                int asgn_id = Integer.parseInt(asgn_idStr);
                List<Assignment_submit> submission = ad.getSubmissionAssignment(asgn_id);
                Assignment selectedAssign = ad.getSelectedAssignment(asgn_id, lecture_id);
                request.setAttribute("selectedAssign", selectedAssign);
                request.setAttribute("submission", submission);
            }
            else if(view.equals("mark")){
                int asgn_id = Integer.parseInt(asgn_idStr);
                String submission_idStr = request.getParameter("submission_id");
                int submission_id = Integer.parseInt(submission_idStr);
                
                Assignment_submit forMark = ad.getForMarking(submission_id, lecture_id);
                request.setAttribute("forMark", forMark);
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
        request.setAttribute("course_id", course_idStr);
        request.setAttribute("currentDate", new java.util.Date());
        request.setAttribute("lectCourses", lectCourses);
        request.setAttribute("palettes", palettes);
        request.getRequestDispatcher("/WEB-INF/view/lecture/assignment.jsp").forward(request, response);
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
                if(session == null || session.getAttribute("userId") == null){
                    response.sendRedirect("login.jsp");
                    return;
                }
        
        int lecture_id = (Integer) session.getAttribute("userId");
         AssignmentDAO ad = new AssignmentDAO();
         
         //check
         Boolean is_true = false;
        
        //handle date type
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
       
        String course_idStr = request.getParameter("course_id");
        int course_id = 0;
            if(course_idStr != null){
                course_id = Integer.parseInt(course_idStr);
            }
        String action = request.getParameter("action");
        if(action.equals("create_assignment")){
            String selectedCourseIdStr = request.getParameter("selectedCourseId");
            int selectedCourseId = Integer.parseInt(selectedCourseIdStr);
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            
            String max_marksStr = request.getParameter("max_marks");
            int max_marks = Integer.parseInt(max_marksStr);
            
            

           String due_dateStr = request.getParameter("due_date");

            // Example: "2026-06-27T14:30"
            LocalDateTime localDateTime = LocalDateTime.parse(due_dateStr);

            Timestamp dueDate = Timestamp.valueOf(localDateTime);
            
            Boolean uploadAssignment = ad.uploadAssignmnet(course_id, lecture_id, title, description, dueDate, max_marks);
            session.setAttribute("success", "Assignment created!");
            response.sendRedirect("assignment");
            
            
        }else if(action.equals("edit_assignment")){
            String asgn_idStr = request.getParameter("asgn_id");
            int asgn_id = Integer.parseInt(asgn_idStr);
            
            String title = request.getParameter("title");
            
            String description = request.getParameter("description");
            
            String max_marksStr = request.getParameter("max_marks");
            int max_marks = Integer.parseInt(max_marksStr);
            
            String due_dateStr = request.getParameter("due_date");

            // Example: "2026-06-27T14:30"
            LocalDateTime localDateTime = LocalDateTime.parse(due_dateStr);

            Timestamp dueDate = Timestamp.valueOf(localDateTime);
            
            Boolean editAssignment = ad.editAssignment(asgn_id, title, description, dueDate, max_marks, lecture_id);
           session.setAttribute("success", "Assignment updated!");
           response.sendRedirect("assignment");
            
            
        }else if(action.equals("delete_assignment")){
            String asgn_idStr = request.getParameter("asgn_id");
            int asgn_id = Integer.parseInt(asgn_idStr);
            
            
            Boolean deleteAssignment = ad.deleteAssignment(asgn_id,lecture_id );
            session.setAttribute("success", "Assignment deleted!");
            response.sendRedirect("assignment");
            
            
        }else if(action.equals("mark_submission")){
            String submission_idStr = request.getParameter("submission_id");
            int submission_id = Integer.parseInt(submission_idStr);
            
            String lecturer_comment = request.getParameter("lecturer_comment");
            String markStr = request.getParameter("mark");
            int mark = Integer.parseInt(markStr);
            
            Boolean markAssign = ad.markAssigment(submission_id, mark, lecturer_comment, lecture_id);
            session.setAttribute("success", "Submission marked!!");
            response.sendRedirect("assignment");
            
        }    
    }
}