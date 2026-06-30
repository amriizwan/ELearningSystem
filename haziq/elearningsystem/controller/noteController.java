/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.elearningsystem.controller;

import com.mycompany.elearningsystem.dao.coursesLectDAO;
import com.mycompany.elearningsystem.dao.noteDAO;
import com.mycompany.elearningsystem.model.coursesLect;
import com.mycompany.elearningsystem.model.note;
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
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import org.checkerframework.checker.units.qual.s;

/**
 *
 * @author Haziq
 */
@WebServlet("/note")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 20,     //20MB
    maxRequestSize = 1024 * 1024 * 50   //50MB
)
public class noteController extends HttpServlet  {
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException{
       HttpSession session = request.getSession(false);
                if(session == null || session.getAttribute("userId") == null){
            response.sendRedirect("login.jsp");
            return;
        }
        
        //fetch list of note
        int lecture_id = (Integer) session.getAttribute("userId");
        noteDAO nd = new noteDAO();
        List<note> noteList = nd.getAllNote(lecture_id);
        
        String courses_idStr = request.getParameter("course_id");
        if(courses_idStr != null){
            int courses_id = Integer.parseInt(courses_idStr);
            List<note> listNote = nd.getSelectedCourse(courses_id,lecture_id );
            request.setAttribute("listNote", listNote);
        }else {
            // No course_id was provided
            List<note> listNote = new ArrayList();
            request.setAttribute("listNote", listNote); // or another default
        }
        
        String editFilter = request.getParameter("edit");
        if(editFilter != null){
            int edit = Integer.parseInt(editFilter);
            note selectedNote = nd.getSelectedNote(edit,lecture_id );
            request.setAttribute("selectedNote", selectedNote);
        }else {
            // No course_id was provided
            request.setAttribute("selectedNote", 0); // or another default
        }
        
        request.setAttribute("noteList", noteList);
        request.getRequestDispatcher("/WEB-INF/view/lecture/notes.jsp").forward(request, response);
    }
    @SuppressWarnings("empty-statement")
     public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException{
         HttpSession session = request.getSession(false);
                if(session == null || session.getAttribute("userId") == null){
            response.sendRedirect("login.jsp");
            return;
        }
        
        int lecture_id = (Integer) session.getAttribute("userId");
        noteDAO nd = new noteDAO();
        boolean is_true = false;
         
         
        String action = request.getParameter("action");
        String course_idStr = request.getParameter("course_id");
        
      
        if(action.equals("edit_note")){
            String note_idStr = request.getParameter("note_id");
            int note_id = Integer.parseInt(note_idStr);
            
            
            String title = request.getParameter("title");
            
            Boolean updateNote = nd.updateNote(note_id, title, lecture_id );
            
             session.setAttribute("success", "Note edited successfully");
            response.sendRedirect(request.getContextPath() + "/note");
            return;
        }else if(action.equals("delete_note")){
            String note_idStr = request.getParameter("note_id");
            int note_id = Integer.parseInt(note_idStr);
            
            Boolean deleteNote = nd.deleteNote(note_id );
            session.setAttribute("success", "Note deleted successfully");
            response.sendRedirect(request.getContextPath() + "/note");
            return;
        }else if(action.equals("upload_note")){
            int courses_id = Integer.parseInt(course_idStr);
            String title = request.getParameter("title");
            String type = request.getParameter("type");
//            String file_url = request.getParameter("file_url");
            
            //file
            Part filePart = request.getPart("note_file");
           
            if (filePart == null || filePart.getSize() == 0) {
                session.setAttribute("error", "Please select a file to upload");
                response.sendRedirect(request.getContextPath() +
                            "/note?course_id=" + courses_id +"&new=1");
                return;
            }
            
             String contentType = filePart.getContentType();
            
            String uploadPath = getServletContext().getRealPath("/uploads/notes");
            
            
            
            File dir = new File(uploadPath);
                       if (!dir.exists()) {
                            dir.mkdirs();
                        }
            String fileName = Paths.get(filePart.getSubmittedFileName())
                                               .getFileName()
                                               .toString();
            String extension = "";
            
            int dot = fileName.lastIndexOf('.');
            
            if (dot != -1) {
                            extension = fileName.substring(dot);
                        }
            String fileName2 = UUID.randomUUID().toString().substring(0, 8) + "-" + courses_id + extension;
            
            String filePath = uploadPath + File.separator + fileName2;
            
            try (InputStream input = filePart.getInputStream()) {
                            Files.copy(input, Paths.get(filePath),
                                    StandardCopyOption.REPLACE_EXISTING);
                        }
            String fileUrl = "uploads/notes/" + fileName2;
            
            boolean uploadFile = nd.uploadNote(courses_id, lecture_id, title, type, fileUrl);
            if(uploadFile == true){
                is_true = true;
            }
            
            session.setAttribute("success", "Note uploaded successfully");
            response.sendRedirect(request.getContextPath() + "/note");
            return;
        }
         
        

     }
    
}
