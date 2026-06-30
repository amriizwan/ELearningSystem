/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.elearningsystem.controller;

import com.mycompany.elearningsystem.dao.fileUploadDAO;
import com.mycompany.elearningsystem.model.fileUpload;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashSet;

/**
 *
 * @author Haziq
 */
@MultipartConfig
@WebServlet("/testUpload")  
public class uploadNoteController extends HttpServlet {
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException{
        Part file = request.getPart("document");
        String file_name = file.getSubmittedFileName();
        String fileType =
                file.getContentType();

        InputStream inputStream =
                file.getInputStream();

        byte[] fileBytes =
                inputStream.readAllBytes();
        String course_idStr = request.getParameter("course_id");
        int course_id = Integer.parseInt(course_idStr);
        String lecturer_idStr = request.getParameter("lecturer_id");
        int lecturer_id = Integer.parseInt(lecturer_idStr);
        String  title = request.getParameter("title");
        
        fileUpload fileUpload = new fileUpload();
        
        fileUpload.setCourse_id(course_id);
        fileUpload.setLecturer_id(lecturer_id);
        fileUpload.setFile_name(file_name);
        fileUpload.setFile_data(fileBytes);
        fileUpload.setTitle(title);
        
        fileUploadDAO dao = new fileUploadDAO();
        
        boolean success = dao.UploadFile(fileUpload);
        
         response.getWriter().println(
                success
                ? "Upload Successful"
                : "Upload Failed");
        
        
        
    }
    
}
