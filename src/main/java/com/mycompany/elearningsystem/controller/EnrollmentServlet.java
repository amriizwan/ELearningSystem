/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.elearningsystem.controller;

import com.mycompany.elearningsystem.dao.CourseDAO;
import com.mycompany.elearningsystem.model.Enrollment;
import com.mycompany.elearningsystem.dao.EnrollmentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
/**
 *
 * @author amri1
 */
@WebServlet("/enrollment")
public class EnrollmentServlet extends HttpServlet {
    
    private final EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
    private final CourseDAO courseDAO = new CourseDAO();
    
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException{
        
        HttpSession session = request.getSession(false);
        int userId = (int) session.getAttribute("userId");
        
        List<Map<String, String>> palettes = new ArrayList<>();

        // for color palettes
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

        request.setAttribute("palettes", palettes);
        request.setAttribute("courses", courseDAO.getAllCourses(userId));
        request.setAttribute("lectNames", courseDAO.getLecturerNames());

        request.getRequestDispatcher("/WEB-INF/views/student/enrollment.jsp").forward(request, response);
    }
    
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException{
        
        HttpSession session = request.getSession(false);
        int userId = (int) session.getAttribute("userId");
        
        
        String action = request.getParameter("action");
        Enrollment e = new Enrollment();
        e.setStudentId(userId);
        e.setCourseId(Integer.parseInt(request.getParameter("courseId")));
        
        switch(action){
            case "enroll":
                enrollmentDAO.insertEnrollment(e);
                session.setAttribute("success", "Successfully enrolled!");
                response.sendRedirect("enrollment");
                break;

            case "unenroll":
                enrollmentDAO.deleteEnrollment(e);
                session.setAttribute("info", "You have unenrolled from this course.");
                response.sendRedirect("enrollment");
                break;
        }
    }
}
