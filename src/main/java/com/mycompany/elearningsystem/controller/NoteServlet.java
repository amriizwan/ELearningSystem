/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.elearningsystem.controller;

import com.mycompany.elearningsystem.model.Course;
import com.mycompany.elearningsystem.model.CourseDAO;
import com.mycompany.elearningsystem.model.Note;
import com.mycompany.elearningsystem.model.NoteDAO;
import com.mycompany.elearningsystem.model.User;
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
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

/**
 *
 * @author amri1
 */
@WebServlet("/note")
@MultipartConfig
public class NoteServlet extends HttpServlet {
    private final NoteDAO noteDAO = new NoteDAO();
    private final CourseDAO courseDAO = new CourseDAO();

    // ---------------------------------------------------------------
    // GET — display notes page
    // ---------------------------------------------------------------
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        String role = (String) session.getAttribute("role");
        int userId = (int) session.getAttribute("userId");

        try {
            if ("student".equals(role)) {

                // UC005 Step 1: get all notes from enrolled courses
                List<Note> notes = noteDAO.getNotesByStudentEnrollment(userId);

                // UC005 Step 3: if student selected a course + lecturer, filter
                String courseIdParam = req.getParameter("courseId");
                String lecturerIdParam = req.getParameter("lecturerId");
               
                if (courseIdParam != null && !courseIdParam.isBlank() && lecturerIdParam != null && !lecturerIdParam.isBlank()) {

                    int courseId = Integer.parseInt(courseIdParam);
                    int lecturerId = Integer.parseInt(lecturerIdParam);

                    notes = noteDAO.getNotesByCourseAndLecturer(courseId, lecturerId);
                }

                // UC005 E1: no notes available
                if (notes.isEmpty()) {
                    req.setAttribute("error", "No notes available");
                }

                // Pass enrolled courses for the course selector dropdown
                List<User> getLecturer = noteDAO.getLecturer();
                List<Course> enrolledCourses = courseDAO.getEnrolledCourses(userId);
                req.setAttribute("lecturers", getLecturer);
                req.setAttribute("enrolledCourses", enrolledCourses);
                req.setAttribute("notes", notes);
                req.getRequestDispatcher("/WEB-INF/views/student/note.jsp").forward(req, resp);

            } else if ("lecturer".equals(role)) {

                // UC015 Step 1: get all notes by this lecturer
                List<Note> notes = noteDAO.getNotesByLecturer(userId);
                List<Course> myCourses = courseDAO.getCoursesByLecturer(userId);

                // UC015 E1: lecturer has no courses
                if (myCourses.isEmpty()) {
                    req.setAttribute("error", "No courses available.");
                }

                req.setAttribute("notes", notes);
                req.setAttribute("myCourses", myCourses);
                req.getRequestDispatcher("/WEB-INF/views/lecturer/note.jsp").forward(req, resp);

            } else {
                resp.sendRedirect(req.getContextPath() + "/login");
            }

        } catch (SQLException e) {
            throw new ServletException("Database error loading notes", e);
        }
    }

    // ---------------------------------------------------------------
    // POST — handle upload, edit, delete
    // ---------------------------------------------------------------
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        int userId = (int) session.getAttribute("userId");
        String action = req.getParameter("action");
        
        try {
            switch (action) {

                // UC015 Step 2: Upload new note
                case "upload":
                    int courseId   = Integer.parseInt(req.getParameter("courseId"));
                    String title   = req.getParameter("title");
                    String type    = req.getParameter("type");    // "pdf" or "video"
//                    String fileUrl = req.getParameter("fileUrl");

                    if (title == null || title.trim().isEmpty()) {
                        session.setAttribute("error", "Note title cannot be empty");
                        resp.sendRedirect(req.getContextPath() + "/note");
                        return;
                    }
                    
                    Part part = req.getPart("file");
                    if (part == null || part.getSize() == 0) {
                        session.setAttribute("error", "Please select a file to upload");
                        resp.sendRedirect(req.getContextPath() + "/note");
                        return;
                    }
                    String contentType = part.getContentType();

                    if (!(contentType.equals("application/pdf")
                            || contentType.startsWith("video/"))) {

                        session.setAttribute("error",
                                "Only PDF and Video files are allowed.");

                        resp.sendRedirect(req.getContextPath() + "/note");
                        return;
                    }
                    
                    // Validate file type based on selected type
                    if ("pdf".equals(type)) {
                        if (contentType.startsWith("video/")) {
                            session.setAttribute("error",
                                    "Please upload a PDF file.");
                            resp.sendRedirect(req.getContextPath() + "/note");
                            return;
                        }
                    } else if ("video".equals(type)) {
                        if (contentType.equals("application/pdf")) {
                            session.setAttribute("error",
                                    "Please upload a video.");
                            resp.sendRedirect(req.getContextPath() + "/note");
                            return;
                        }
                    }
                    
                    String uploadPath = getServletContext().getRealPath("/uploads/notes");

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

                    String fileName2 = UUID.randomUUID().toString().substring(0, 8) + "-" + title.trim() + extension;

                    String filePath = uploadPath + File.separator + fileName2;
                    

                    try (InputStream input = part.getInputStream()) {
                        Files.copy(input, Paths.get(filePath),
                                StandardCopyOption.REPLACE_EXISTING);
                    }
                   
                    String fileUrl = "uploads/notes/" + fileName2;
                    
                    noteDAO.uploadNote(courseId, userId, title.trim(), type, fileUrl);
                    session.setAttribute("success",
                            "Note uploaded successfully");
                    
                    break;

                // UC015 Step 3: Edit note title
                case "edit":
                    int editNoteId   = Integer.parseInt(req.getParameter("noteId"));
                    String newTitle  = req.getParameter("title");

                    if (newTitle == null || newTitle.trim().isEmpty()) {
                        session.setAttribute("error", "Note title cannot be empty");
                    } else {
                        noteDAO.updateNoteTitle(editNoteId, userId, newTitle.trim());
                        session.setAttribute("success", "Note updated successfully");
                    }
                    break;

                // UC015 Step 4: Delete note
                case "delete":
                    int deleteNoteId = Integer.parseInt(req.getParameter("noteId"));
                    noteDAO.deleteNote(deleteNoteId, userId);
                    session.setAttribute("success", "Note deleted successfully");
                    break;
            }

        } catch (SQLException e) {
            throw new ServletException("Database error processing note action", e);
        }

        resp.sendRedirect(req.getContextPath() + "/note");
    }
}
