package com.mycompany.elearningsystem.dao;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */



import com.mycompany.elearningsystem.model.Assignment;
import com.mycompany.elearningsystem.model.Assignment_submit;
import com.mycompany.elearningsystem.util.DBConnection;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author User
 */
public class AssignmentDAO {
    
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

                assignment.setAssignmentId(
                        rs.getInt("id"));
                assignment.setCourseId(
                        rs.getInt("course_id"));
                assignment.setLecturer_id(
                        rs.getInt("lecturer_id"));
                
                
                assignment.setTitle(
                        rs.getString("title"));
                assignment.setDescription(
                        rs.getString("description"));
                assignment.setDueDate(
                        rs.getDate("due_date"));
                assignment.setMaxMark(
                        rs.getInt("max_marks"));
                 assignment.setCreated_date(
                        rs.getDate("created_at"));
                
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

                assignment.setAssignmentId(
                        rs.getInt("id"));
                assignment.setCourseId(
                        rs.getInt("course_id"));
                assignment.setLecturer_id(
                        rs.getInt("lecturer_id"));
                
                
                assignment.setTitle(
                        rs.getString("title"));
                assignment.setDescription(
                        rs.getString("description"));
                assignment.setDueDate(
                        rs.getDate("due_date"));
                assignment.setMaxMark(
                        rs.getInt("max_marks"));
                 assignment.setCreated_date(
                        rs.getDate("due_date"));
                
            }

        } catch(SQLException e) {
            e.printStackTrace();
            System.out.println("SQL ERROR: " + e.getMessage());
        }

        return assignment;
    }
    
    // ── Fetch submissions for selected assignment ──
    public List<Assignment_submit> getSubmissionAssignment(int assignment_id){
        List<Assignment_submit> assignments = new ArrayList<>();

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
                Assignment_submit assignment =
                        new Assignment_submit();

                assignment.setId(
                        rs.getInt("id"));
                assignment.setAssignment_id(
                        rs.getInt("assignment_id"));
                assignment.setStudent_id(
                        rs.getInt("student_id"));
                
                
                assignment.setFile_url(
                        rs.getString("file_url"));
                assignment.setAnswer(
                        rs.getString("answer_text"));
                assignment.setLecturer_comment(
                        rs.getString("lecturer_comment"));
                assignment.setStudent_name(
                        rs.getString("student_name"));
                assignment.setSubmitted_date(
                        rs.getDate("submitted_at"));
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
    public Assignment_submit getForMarking(int assigmentSubmission_id, int lecturer_id){
        Assignment_submit assignment = new Assignment_submit();

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
                assignment.setAssignment_id(
                        rs.getInt("assignment_id"));
                assignment.setStudent_id(
                        rs.getInt("student_id"));
                
                
                assignment.setFile_url(
                        rs.getString("file_url"));
                assignment.setTitle(
                        rs.getString("asgn_title"));
                assignment.setAnswer(
                        rs.getString("answer_text"));
                assignment.setLecturer_comment(
                        rs.getString("lecturer_comment"));
                assignment.setStudent_name(
                        rs.getString("student_name"));
                assignment.setSubmitted_date(
                        rs.getDate("submitted_at"));
                assignment.setMark(
                        rs.getInt("mark"));
                assignment.setMaxMark(
                        rs.getInt("maxMarks"));
                
            }

        } catch(SQLException e) {
            e.printStackTrace();
            System.out.println("SQL ERROR: " + e.getMessage());
        }

        return assignment;
    }
    
     // CREATE ASSIGNMENT
    public Boolean uploadAssignmnet(int course_id, int lecturer_id, String title, String description, Timestamp  dueDate, int maxMarks ){
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
            
//            response.getWriter().print("Connection to DB success");
        }catch(SQLException ex){
            Logger.getLogger(noteDAO.class.getName()).log(Level.SEVERE, null, ex);
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
            
//            response.getWriter().print("Connection to DB success");
        }catch(SQLException ex){
            Logger.getLogger(noteDAO.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(noteDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
    
    public List<Assignment_submit> listSubmitted(int assignment_id){
        List<Assignment_submit> student_submitted = new ArrayList<>();

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
                Assignment_submit sb = new Assignment_submit();
                sb.setId(rs.getInt("id"));
                sb.setAssignment_id(rs.getInt("assignment_id"));
                sb.setStudent_id(rs.getInt("student_id"));
                sb.setFile_url(rs.getString("file_url"));
                sb.setAnswer(rs.getString("answer_text"));
                sb.setSubmitted_date(rs.getDate("submitted_date"));
                sb.setStudent_name(rs.getString("student_name"));
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
             
            
            
            
            
            
            
//            response.getWriter().print("Connection to DB success");
        }catch(SQLException ex){
            Logger.getLogger(noteDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
    
    
    
    
}