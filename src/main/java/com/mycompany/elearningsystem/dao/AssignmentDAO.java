package com.mycompany.elearningsystem.dao;

import com.mycompany.elearningsystem.model.Assignment;
import com.mycompany.elearningsystem.model.AssignmentSubmission;
import com.mycompany.elearningsystem.model.Submission;
import com.mycompany.elearningsystem.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AssignmentDAO {
    // ---------------------------------------------------------------
    // STUDENT - 
    // ---------------------------------------------------------------

    public List<Assignment> getAssignmentsByCL(int courseId, int lecturerId, int studentId) {
        List<Assignment> assignments = new ArrayList<>();

        String sql = 
                "SELECT a.id, a.title, a.description, a.due_date, a.max_marks, " +
                "s.id AS submission_id, " +
                "s.submitted_at, " +
                "s.mark, " +
                "CASE " +
                "WHEN s.id IS NOT NULL AND s.mark IS NOT NULL THEN 'marked' " +
                "WHEN s.id IS NOT NULL THEN 'submitted' " +
                "WHEN a.due_date < NOW() THEN 'overdue' " +
                "WHEN a.due_date < DATE_ADD(NOW(), INTERVAL 3 DAY) THEN 'due_soon' " +
                "ELSE 'upcoming' " +
                "END AS status " +
                "FROM assignments a " +
                "LEFT JOIN assignment_submissions s ON s.assignment_id = a.id AND s.student_id = ? " +
                "WHERE a.course_id = ? AND a.lecturer_id = ? " +
                "ORDER BY a.due_date ASC";

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            ps.setInt(3, lecturerId);

            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Assignment assignment = new Assignment();

                assignment.setId(rs.getInt("id"));
                assignment.setTitle(rs.getString("title"));
                assignment.setDescription(rs.getString("description"));
                assignment.setDueDate(rs.getTimestamp("due_date"));
                assignment.setMaxMarks(rs.getInt("max_marks"));
                assignment.setSubmissionId(rs.getInt("submission_id"));
                assignment.setSubmittedAt(rs.getTimestamp("submitted_at"));
                assignment.setStatus(rs.getString("status"));


                assignments.add(assignment);
            }

        } catch(SQLException e) {
            e.printStackTrace();
            System.out.println("SQL ERROR: " + e.getMessage());
        }

        return assignments;
    }
    
    public List<Assignment> getAssignmentsByEnrCourse(int studentId){
        
        List<Assignment> assignments = new ArrayList<>();

        String sql = 
                "SELECT " +
                "a.id, a.title, a.description, a.due_date, a.max_marks, " +
                "c.title  AS course_title, " +
                "u.name   AS lecturer_name, " +
                "s.id     AS submission_id, " +
                "s.file_url, " +
                "s.answer_text, " +
                "s.submitted_at, " +
                "s.mark, " +
                "s.lecturer_comment, " +
                "CASE " +
                "WHEN s.id IS NOT NULL AND s.mark IS NOT NULL THEN 'marked' " +
                "WHEN s.id IS NOT NULL                        THEN 'submitted' " +
                "WHEN a.due_date < NOW()                      THEN 'overdue' " +
                "WHEN a.due_date < DATE_ADD(NOW(), INTERVAL 3 DAY) THEN 'due_soon' " +
                "ELSE 'upcoming' " +
                "END AS status " +
                "FROM assignments a " +
                "JOIN enrollments e  ON e.course_id    = a.course_id AND e.student_id = ? " +
                "JOIN courses c      ON c.id           = a.course_id " +
                "JOIN users u        ON u.id           = a.lecturer_id " +
                "LEFT JOIN assignment_submissions s ON s.assignment_id = a.id AND s.student_id = ? " +
                "ORDER BY " +
                "FIELD( " +
                "CASE " +
                "WHEN s.id IS NOT NULL AND s.mark IS NOT NULL THEN 'marked' " +
                "WHEN s.id IS NOT NULL THEN 'submitted' " +
                "WHEN a.due_date < NOW() THEN 'overdue' " +
                "WHEN a.due_date < DATE_ADD(NOW(), INTERVAL 3 DAY) THEN 'due_soon' " +
                "ELSE 'upcoming' " +
                "END, " +
                "'overdue','due_soon','upcoming','submitted','marked' " +
                "), " +
                "a.due_date ASC";

        try {
            Connection conn = DBConnection.getConnection();

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, studentId);
            ps.setInt(2, studentId);

            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Assignment assignment = new Assignment();

                assignment.setId(rs.getInt("id"));
                assignment.setTitle(rs.getString("title"));
                assignment.setDescription(rs.getString("description"));
                assignment.setDueDate(rs.getTimestamp("due_date"));
                assignment.setMaxMarks(rs.getInt("max_marks"));
                assignment.setStatus(rs.getString("status"));
                assignment.setLecturerName(rs.getString("lecturer_name"));
                assignment.setCourseName(rs.getString("course_title"));

                Submission s = new Submission();
                s.setSubmissionId(rs.getInt("submission_id"));
                s.setSubmitDate(rs.getTimestamp("submitted_at"));
                s.setMark(rs.getInt("mark"));
                s.setAnswerText(rs.getString("answer_text"));
                s.setFilePath(rs.getString("file_url"));
                s.setLecturerComment(rs.getString("lecturer_comment"));

                assignment.setSubmission(s);
                assignments.add(assignment);
            }

        } catch(SQLException e) {
            e.printStackTrace();
            System.out.println("SQL ERROR: " + e.getMessage());
        }
        
        return assignments;
    }
    

    // ---------------------------------------------------------------
    // LECTURER - Manage assignment
    // ---------------------------------------------------------------

    // ── Fetch lecturer's courses ──
    public List<Assignment> getLecturerCourse(int lecturer_id) {

        List<Assignment> courses = new ArrayList<>();

        String sql =
            "SELECT c.id, c.title, COUNT(a.id) AS asgn_count" +
            "    FROM course_lecturer cl" +
            "    JOIN courses c ON c.id = cl.course_id" +
            "    LEFT JOIN assignments a ON a.course_id = c.id AND a.lecturer_id = ?" +
            "    WHERE cl.lecturer_id = ?" +
            "    GROUP BY c.id ORDER BY c.title ASC";

            
            try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)){

                    ps.setInt(2, lecturer_id);
                    ps.setInt(1, lecturer_id);

                    ResultSet rs = ps.executeQuery();
                        while(rs.next()) {
                            Assignment assignment =
                                    new Assignment();

                            assignment.setCourseId(
                                    rs.getInt("id"));

                            assignment.setTitle(
                                    rs.getString("title"));

                            assignment.setAssignment_count(
                                    rs.getInt("asgn_count"));

                            courses.add(assignment);
                        }
            }catch(SQLException e) {
            e.printStackTrace();
            System.out.println("SQL ERROR: " + e.getMessage());
        }
        return courses;
    }
    
    // ── Fetch assignments for selected course ──
    public List<Assignment> getAssignment(int course_id, int lecturer_id){
        List<Assignment> assignments = new ArrayList<>();

        String sql =
            "SELECT a.*," +
            "               COUNT(DISTINCT s.id)                                           AS submission_count," +
            "               COUNT(DISTINCT CASE WHEN s.mark IS NULL THEN s.id END)        AS ungraded_count," +
            "               COUNT(DISTINCT e.student_id)                                   AS enrolled_count" +
            "        FROM assignments a" +
            "        LEFT JOIN assignment_submissions s ON s.assignment_id = a.id" +
            "        LEFT JOIN enrollments e            ON e.course_id = a.course_id" +
            "        WHERE a.course_id = ? AND a.lecturer_id = ?" +
            "        GROUP BY a.id" +
            "        ORDER BY a.due_date DESC";

        try {
            
            Connection conn  = DBConnection.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql);

            ps.setInt(1, course_id);
            ps.setInt(2, lecturer_id);

            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Assignment assignment =
                        new Assignment();

                assignment.setId(
                        rs.getInt("id"));
                assignment.setCourseId(
                        rs.getInt("course_id"));
                assignment.setLecturerId(
                        rs.getInt("lecturer_id"));
                
                
                assignment.setTitle(
                        rs.getString("title"));
                assignment.setDescription(
                        rs.getString("description"));
                assignment.setDueDate(
                        rs.getTimestamp("due_date"));
                assignment.setMaxMarks(
                        rs.getInt("max_marks"));
                 assignment.setCreatedAt(
                        rs.getTimestamp("created_at"));
                
                assignment.setAssignment_count(
                        rs.getInt("submission_count"));
                assignment.setUngraded_count(
                        rs.getInt("ungraded_count"));
                assignment.setEnroll_count(
                        rs.getInt("enrolled_count"));

                assignments.add(assignment);
            }

        } catch(SQLException e) {
            e.printStackTrace();
            System.out.println("SQL ERROR: " + e.getMessage());
        }

        return assignments;
    }
    
    // ── Fetch selected assignment ──
    public Assignment getSelectedAssignment(int assigment_id, int lecturer_id){
        Assignment assignment = new Assignment();

        String sql =
            "SELECT * FROM assignments WHERE id = ? AND lecturer_id = ?";

        try {
            
            Connection conn = DBConnection.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql);

            ps.setInt(1, assigment_id);
            ps.setInt(2, lecturer_id);

            ResultSet rs = ps.executeQuery();
            while(rs.next()) {

                assignment.setId(
                        rs.getInt("id"));
                assignment.setCourseId(
                        rs.getInt("course_id"));
                assignment.setLecturerId(
                        rs.getInt("lecturer_id"));
                
                
                assignment.setTitle(
                        rs.getString("title"));
                assignment.setDescription(
                        rs.getString("description"));
                assignment.setDueDate(
                        rs.getTimestamp("due_date"));
                assignment.setMaxMarks(
                        rs.getInt("max_marks"));
                 assignment.setCreatedAt(
                        rs.getTimestamp("due_date"));
                
            }

        } catch(SQLException e) {
            e.printStackTrace();
            System.out.println("SQL ERROR: " + e.getMessage());
        }

        return assignment;
    }
    
    // ── Fetch submissions for selected assignment ──
    public List<AssignmentSubmission> getSubmissionAssignment(int assignment_id){
        List<AssignmentSubmission> assignments = new ArrayList<>();

        String sql =
            "SELECT s.*, u.name AS student_name" +
            "        FROM assignment_submissions s" +
            "        JOIN users u ON u.id = s.student_id" +
            "        WHERE s.assignment_id = ?" +
            "        ORDER BY s.submitted_at DESC";

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps =
                    conn.prepareStatement(sql);

            ps.setInt(1, assignment_id);

            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                AssignmentSubmission assignment =
                        new AssignmentSubmission();

                assignment.setId(
                        rs.getInt("id"));
                assignment.setAssignmentId(
                        rs.getInt("assignment_id"));
                assignment.setStudentId(
                        rs.getInt("student_id"));
                
                
                assignment.setFileUrl(
                        rs.getString("file_url"));
                assignment.setAnswerText(
                        rs.getString("answer_text"));
                assignment.setLecturerComment(
                        rs.getString("lecturer_comment"));
                assignment.setStudentName(
                        rs.getString("student_name"));
                assignment.setSubmittedAt(
                        rs.getTimestamp("submitted_at"));
                assignment.setMark(
                        rs.getInt("mark"));
                
                assignments.add(assignment);
            }

        } catch(SQLException e) {
            e.printStackTrace();
            System.out.println("SQL ERROR: " + e.getMessage());
        }

        return assignments;
    }
    
    // ── Fetch single submission for marking ──
    public AssignmentSubmission getForMarking(int assigmentSubmission_id, int lecturer_id){
        AssignmentSubmission assignment = new AssignmentSubmission();

        String sql =
            " SELECT s.*, u.name AS student_name, a.title AS asgn_title, a.max_marks AS maxMarks " +
            "        FROM assignment_submissions s" +
            "        JOIN users u        ON u.id = s.student_id" +
            "        JOIN assignments a  ON a.id = s.assignment_id AND a.lecturer_id = ?" +
            "        WHERE s.id = ?";

        try {
           Connection conn = DBConnection.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql);

            ps.setInt(1, lecturer_id);
            ps.setInt(2, assigmentSubmission_id);

            ResultSet rs = ps.executeQuery();
            while(rs.next()) {

                assignment.setId(
                        rs.getInt("id"));
                assignment.setAssignmentId(
                        rs.getInt("assignment_id"));
                assignment.setStudentId(
                        rs.getInt("student_id"));
                
                
                assignment.setFileUrl(
                        rs.getString("file_url"));
                assignment.setTitle(
                        rs.getString("asgn_title"));
                assignment.setAnswerText(
                        rs.getString("answer_text"));
                assignment.setLecturerComment(
                        rs.getString("lecturer_comment"));
                assignment.setStudentName(
                        rs.getString("student_name"));
                assignment.setSubmittedAt(
                        rs.getTimestamp("submitted_at"));
                assignment.setMark(
                        rs.getInt("mark"));
                assignment.setMaxMarks(
                        rs.getInt("maxMarks"));
                
            }

        } catch(SQLException e) {
            e.printStackTrace();
            System.out.println("SQL ERROR: " + e.getMessage());
        }

        return assignment;
    }
    
     // CREATE ASSIGNMENT
    public Boolean uploadAssignmnet(int course_id, int lecturer_id, String title, String description, Timestamp dueDate, int maxMarks ){
        try{
            
            Connection conn = DBConnection.getConnection();
            Statement stmt = conn.createStatement();
                    
            String sql = "INSERT INTO `assignments` (`course_id`, `lecturer_id`, `title`, `description`, `due_date`, `max_marks`) VALUES (?,?,?,?,?,?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1,course_id );
            ps.setInt(2,lecturer_id );
            ps.setString(3, title);
            ps.setString(4, description);
            ps.setTimestamp(5, dueDate);
            ps.setInt(6, maxMarks);
             
            
            int rowsAffected = ps.executeUpdate();
         
            stmt.close();
            conn.close();
            return rowsAffected > 0;
            
        }catch(SQLException ex){
            Logger.getLogger(AssignmentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
    
     // DELETE ASSIGNMENT
    public Boolean deleteAssignment(int id, int lecturer_id){
        try{
            
            Connection con = DBConnection.getConnection();
            Statement stmt = con.createStatement();
                    
            String sql = "DELETE FROM assignments WHERE id = ? AND lecturer_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1,id);
            ps.setInt(2,lecturer_id);
            int rowsAffected = ps.executeUpdate();
           
            stmt.close();
            con.close();
            return rowsAffected > 0;
            
        }catch(SQLException ex){
            Logger.getLogger(AssignmentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
    
    // EDIT ASSIGNMENT
    public Boolean editAssignment(int id, String title, String description, Timestamp dueDate, int maxMarks, int lecturer_id){
        try{
            
            Connection con = DBConnection.getConnection();
            Statement stmt = con.createStatement();
                    
            String sql = "UPDATE assignments SET title=?, description=?, due_date=?, max_marks=? WHERE id=? AND lecturer_id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setTimestamp(3, dueDate);
            ps.setInt(4, maxMarks);
            ps.setInt(5, id);
            ps.setInt(6, lecturer_id);
             
            
            int rowsAffected = ps.executeUpdate();
            
            stmt.close();
            con.close();
            return rowsAffected > 0;
            
//            response.getWriter().print("Connection to DB success");
        }catch(SQLException ex){
            Logger.getLogger(AssignmentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
    
    public List<AssignmentSubmission> listSubmitted(int assignment_id){
        List<AssignmentSubmission> student_submitted = new ArrayList<>();

        String sql =
            "SELECT s.*, u.name AS student_name" +
            "        FROM assignment_submissions s" +
            "        JOIN users u ON u.id = s.student_id" +
            "        WHERE s.assignment_id = ?" +
            "        ORDER BY s.submitted_at DESC";

        try {
            Connection conn = DBConnection.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql);
            ps.setInt(1, assignment_id);
            

            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                AssignmentSubmission sb = new AssignmentSubmission();
                sb.setId(rs.getInt("id"));
                sb.setAssignmentId(rs.getInt("assignment_id"));
                sb.setStudentId(rs.getInt("student_id"));
                sb.setFileUrl(rs.getString("file_url"));
                sb.setAnswerText(rs.getString("answer_text"));
                sb.setSubmittedAt(rs.getTimestamp("submitted_date"));
                sb.setStudentName(rs.getString("student_name"));
                student_submitted.add(sb);
            }

        } catch(SQLException e) {
            e.printStackTrace();
            System.out.println("SQL ERROR: " + e.getMessage());
        }

        return student_submitted;
    }
    
     // MARK SUBMISSION
    public Boolean markAssigment(int submittion_id, int mark, String lecturer_comment, int lecturer_id){
        
        try{
            
            Connection con = DBConnection.getConnection();
            Statement stmt = con.createStatement();
            
            String query = "SELECT s.id FROM assignment_submissions s JOIN assignments a ON a.id = s.assignment_id WHERE s.id = ? AND a.lecturer_id = ?";
            PreparedStatement check = con.prepareStatement(query);
            check.setInt(1, submittion_id);
            check.setInt(2, lecturer_id);
            ResultSet checkId = check.executeQuery();
            
            if(checkId.next()){
                String sql = "UPDATE assignment_submissions SET mark=?, lecturer_comment=? WHERE id=?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, mark);
                ps.setString(2,lecturer_comment);
                ps.setInt(3, submittion_id);
                int rowsAffected = ps.executeUpdate();
                
                stmt.close();
                con.close();
                return rowsAffected > 0;
            }else {
                checkId.close();
                stmt.close();
                con.close();
                
                return false;
            }
             
        }catch(SQLException ex){
            Logger.getLogger(AssignmentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
}
