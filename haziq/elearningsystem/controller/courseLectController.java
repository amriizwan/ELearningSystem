/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.elearningsystem.controller;
import com.mycompany.elearningsystem.dao.coursesLectDAO;
import com.mycompany.elearningsystem.model.courses;
import com.mycompany.elearningsystem.model.coursesLect;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
/**
 *
 * @author Haziq
 */
@WebServlet("/lectureCourses")
public class courseLectController extends HttpServlet{
    
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException{
        //stop session from create new session
        HttpSession session = request.getSession(false);
                if(session == null || session.getAttribute("userId") == null){
            response.sendRedirect("login.jsp");
            return;
        }


        coursesLectDAO cd = new coursesLectDAO();
        int id = (Integer) session.getAttribute("userId");;
        List<coursesLect> cl = cd.getCourses(id);
        //to show all or teaching
        String show = "all";
        if ("teaching".equals(request.getParameter("show"))) {
            show = "teaching";
        }
        
        //css for course icon
        List<String> palettes = Arrays.asList(
            "bg-emerald-50 text-emerald-600",
            "bg-violet-50 text-violet-600",
            "bg-amber-50 text-amber-600",
            "bg-blue-50 text-blue-600",
            "bg-rose-50 text-rose-600",
            "bg-teal-50 text-teal-600"
        );

        
        //send data
        session.getAttribute("userId");
        request.setAttribute("palettes", palettes);
        request.setAttribute("courses", cl);
        request.setAttribute("show", show);
//        request.setAttribute("message", message);
        request.getRequestDispatcher("/WEB-INF/view/lecture/course.jsp").forward(request, response);
        
        
       
        
    }
    
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException{
        
        HttpSession session = request.getSession(false);
                 if(session == null || session.getAttribute("userId") == null){
            response.sendRedirect("login.jsp");
            return;
        }

        coursesLectDAO cd = new coursesLectDAO();
        
        String submit = request.getParameter("submit");
        //assign/unassign course lecture
        if(submit.equals("buttonCourse")){
            String courses_idStr = request.getParameter("course_id");
            int courses_id =Integer.parseInt(courses_idStr);
            String action = request.getParameter("action");
            
            int lecturerId = (Integer) session.getAttribute("userId");
         
            if(action.equals("uassign")){
                Boolean courseUnassign = cd.CoursesUnassign(lecturerId , courses_id);
                session.setAttribute("success", "Course removed from your teaching list.");
            }else if(action.equals("assign")){
                 Boolean courseAssign = cd.CoursesAssign(lecturerId , courses_id);
                 session.setAttribute("success", "Course added to your teaching list!.");
            }
        }
        
         
        
       
        response.sendRedirect("lectureCourses");
    }
    
}
