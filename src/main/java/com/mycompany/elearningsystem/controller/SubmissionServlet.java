package com.mycompany.elearningsystem.controller;

import com.mycompany.elearningsystem.model.Submission;
import com.mycompany.elearningsystem.dao.SubmissionDAO;
import com.mycompany.elearningsystem.model.AssignmentSubmission;
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
import java.util.UUID;

/**
 *
 * @author amri1
 */
@WebServlet("/submission")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1 MB
    maxFileSize = 20 * 1024 * 1024,       // 20 MB
    maxRequestSize = 25 * 1024 * 1024     // 25 MB
)
public class SubmissionServlet extends HttpServlet {

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException{
        
    }
    
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        
        HttpSession session = request.getSession(false);
        int assignmentId = Integer.parseInt(request.getParameter("assignment_id"));
        String answerText = request.getParameter("answer_text");
        int userId = (int) session.getAttribute("userId");
        
        SubmissionDAO submissionDAO = new SubmissionDAO();

        // Duplicate checking
        if (submissionDAO.hasSubmitted(assignmentId, userId)) {
            response.sendRedirect("assignment");
            return;
        }

        Part part = request.getPart("submission_file");
        
        boolean hasFile = part != null && part.getSize() > 0;

        if ((answerText == null || answerText.isBlank()) && !hasFile) {

            session.setAttribute("error",
                    "Please upload a file or enter an answer.");

            response.sendRedirect(request.getContextPath()
                    + "/assignment?id=" + assignmentId);
            return;
        }
        
        String contentType = part.getContentType();
//        if (part == null || part.getSize() == 0) {
//            session.setAttribute("error", "Please select a file to upload");
//            response.sendRedirect(request.getContextPath() +
//                        "/assignment?id=" + assignmentId);
//            return;
//        }
        
        String fileUrl = null;
        if (hasFile){
            
            if (!(contentType.equals("application/pdf"))) {
                session.setAttribute("error",
                        "Only PDF files are allowed.");

                response.sendRedirect(request.getContextPath() +
                            "/assignment?id=" + assignmentId);
                return;
            }

//            String uploadPath = "C:\\Users\\User\\OneDrive\\Documents\\NetBeansProjects\\ELearningSystem\\src\\main\\webapp\\uploads\\assignments";

            String uploadPath =
                       getServletContext().getRealPath("/uploads/assignments");
            
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

            fileUrl = "uploads/assignments/" + fileName2;
        }

//        // Validation
//        if ((answerText == null || answerText.isBlank()) && fileUrl == null) {
//            if (response != null) { // Fix 4: Guard check
//                session.setAttribute("error", "Please upload a file or enter an answer.");
//                response.sendRedirect("assignment");
//            }
//            return;
//        }
        
        

        AssignmentSubmission submission = new AssignmentSubmission();
        submission.setAssignmentId(assignmentId);
        submission.setStudentId(userId);
        submission.setAnswerText(answerText);
        submission.setFileUrl(fileUrl);

        // Insert to DB
        submissionDAO.insertSubmission(submission);
        session.setAttribute("success", "Assignment submitted successfully");
        response.sendRedirect(request.getContextPath() + "/assignment");
    }
    
}
