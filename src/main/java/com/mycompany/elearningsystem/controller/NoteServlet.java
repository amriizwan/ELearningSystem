package com.mycompany.elearningsystem.controller;

import com.mycompany.elearningsystem.model.Course;
import com.mycompany.elearningsystem.dao.CourseDAO;
import com.mycompany.elearningsystem.model.Note;
import com.mycompany.elearningsystem.dao.NoteDAO;
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
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@WebServlet("/note")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 20,     //20MB
    maxRequestSize = 1024 * 1024 * 50   //50MB
)
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

        if ("student".equals(role)) {
            
        } else if ("lecturer".equals(role)) {
            int lecture_id = (Integer) session.getAttribute("userId");
            List<Note> noteList = noteDAO.getAllNote(lecture_id);
            
            String courses_idStr = req.getParameter("course_id");
            if(courses_idStr != null){
                int courses_id = Integer.parseInt(courses_idStr);
                List<Note> listNote = noteDAO.getSelectedCourse(courses_id,lecture_id );
                req.setAttribute("listNote", listNote);
            }else {
                // No course_id was provided
                List<Note> listNote = new ArrayList();
                req.setAttribute("listNote", listNote); // or another default
            }
            
            String editFilter = req.getParameter("edit");
            if(editFilter != null){
                int edit = Integer.parseInt(editFilter);
                Note selectedNote = noteDAO.getSelectedNote(edit,lecture_id );
                req.setAttribute("selectedNote", selectedNote);
            }else {
                // No course_id was provided
                req.setAttribute("selectedNote", 0); // or another default
            }
            req.setAttribute("noteList", noteList);
            
            req.getRequestDispatcher("/WEB-INF/views/lecturer/note.jsp").forward(req, resp);
            
        } else {
            resp.sendRedirect(req.getContextPath() + "/login");
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
        int lecture_id = (Integer) session.getAttribute("userId");
        boolean is_true = false;
        String course_idStr = req.getParameter("course_id");
        
        switch (action) {
            
            // Upload new note
            case "upload_note":
                int courses_id = Integer.parseInt(course_idStr);
                String title = req.getParameter("title");
                String type = req.getParameter("type");
                //file
                Part filePart = req.getPart("note_file");
                
                if (filePart == null || filePart.getSize() == 0) {
                    session.setAttribute("error", "Please select a file to upload");
                    resp.sendRedirect(req.getContextPath() +
                            "/note?course_id=" + courses_id +"&new=1");
                    return;
                }
                
                String contentType = filePart.getContentType();
                
                String uploadPath = "C:\\Users\\amri1\\OneDrive\\Documents\\NetBeansProjects\\ELearningSystem\\src\\main\\webapp\\uploads\\notes";
                
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
                
                boolean uploadFile = noteDAO.uploadNote(courses_id, lecture_id, title, type, fileUrl);
                if(uploadFile == true){
                    is_true = true;
                }
                session.setAttribute("success", "Note uploaded successfully");
                break;
                
                // Edit note title
            case "edit_note":
                String note_idStr = req.getParameter("note_id");
                int note_id = Integer.parseInt(note_idStr);
                String newTitle = req.getParameter("title");
                Boolean updateNote = noteDAO.updateNote(note_id, newTitle, lecture_id);
                session.setAttribute("success", "Note edited successfully");
                break;
                //  Delete note
            case "delete_note":
                String note_del = req.getParameter("note_id");
                int note_idDel = Integer.parseInt(note_del);
                
                Boolean deleteNote = noteDAO.deleteNote(note_idDel);
                session.setAttribute("success", "Note deleted successfully");
                break;
        }

        resp.sendRedirect(req.getContextPath() + "/note");
    }
}
