package com.mycompany.elearningsystem.dao;

import com.mycompany.elearningsystem.model.Assignment;
import com.mycompany.elearningsystem.model.AssignmentSubmission;
import com.mycompany.elearningsystem.model.Submission;
import com.mycompany.elearningsystem.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

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

    /**
     * UC016 Step 1 - Returns all assignments created by this lecturer.
     */
    public List<Assignment> getAssignmentsByLecturer(int lecturerId) throws SQLException {
        List<Assignment> assignments = new ArrayList<>();

        String sql = "SELECT a.id, a.title, a.description, a.due_date, a.max_marks, " +
                     "a.course_id, a.lecturer_id, a.created_at, " +
                     "c.title AS course_name, " +
                     "(SELECT COUNT(*) FROM assignment_submissions asub " +
                     " WHERE asub.assignment_id = a.id) AS submission_count " +
                     "FROM assignments a " +
                     "JOIN courses c ON c.id = a.course_id " +
                     "WHERE a.lecturer_id = ? " +
                     "ORDER BY c.title ASC, a.due_date ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, lecturerId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Assignment a = new Assignment();
                    a.setId(rs.getInt("id"));
                    a.setTitle(rs.getString("title"));
                    a.setDescription(rs.getString("description"));
                    a.setDueDate(rs.getTimestamp("due_date"));
                    a.setMaxMarks(rs.getInt("max_marks"));
                    a.setCourseId(rs.getInt("course_id"));
                    a.setLecturerId(rs.getInt("lecturer_id"));
                    a.setCreatedAt(rs.getTimestamp("created_at"));
                    a.setCourseName(rs.getString("course_name"));
                    a.setSubmissionCount(rs.getInt("submission_count"));
                    assignments.add(a);
                }
            }
        }
        return assignments;
    }

    /**
     * UC016 Step 2 - Creates a new assignment.
     */
    public boolean createAssignment(int courseId, int lecturerId, String title,
                                    String description, String dueDate,
                                    int maxMarks) throws SQLException {

        String sql = "INSERT INTO assignments " +
                     "(course_id, lecturer_id, title, description, due_date, max_marks) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, courseId);
            ps.setInt(2, lecturerId);
            ps.setString(3, title);
            ps.setString(4, description);
            ps.setString(5, dueDate);
            ps.setInt(6, maxMarks);
            return ps.executeUpdate() == 1;
        }
    }

    /**
     * UC016 Step 3 - Updates title, description, due date, max marks.
     */
    public boolean updateAssignment(int assignmentId, int lecturerId, String title,
                                    String description, String dueDate,
                                    int maxMarks) throws SQLException {

        String sql = "UPDATE assignments SET title = ?, description = ?, " +
                     "due_date = ?, max_marks = ? " +
                     "WHERE id = ? AND lecturer_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, dueDate);
            ps.setInt(4, maxMarks);
            ps.setInt(5, assignmentId);
            ps.setInt(6, lecturerId);
            return ps.executeUpdate() == 1;
        }
    }

    /**
     * UC016 Step 4 - Deletes an assignment.
     */
    public boolean deleteAssignment(int assignmentId, int lecturerId) throws SQLException {
        String sql = "DELETE FROM assignments WHERE id = ? AND lecturer_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, assignmentId);
            ps.setInt(2, lecturerId);
            return ps.executeUpdate() == 1;
        }
    }

    /**
     * Returns all submissions for a specific assignment.
     */
    public List<AssignmentSubmission> getSubmissionsByAssignment(int assignmentId) throws SQLException {
        List<AssignmentSubmission> submissions = new ArrayList<>();

        String sql = "SELECT asub.id, asub.assignment_id, asub.student_id, " +
                     "asub.file_url, asub.answer_text, asub.submitted_at, " +
                     "asub.mark, asub.lecturer_comment, " +
                     "u.name AS student_name " +
                     "FROM assignment_submissions asub " +
                     "JOIN users u ON u.id = asub.student_id " +
                     "WHERE asub.assignment_id = ? " +
                     "ORDER BY asub.submitted_at ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, assignmentId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AssignmentSubmission sub = new AssignmentSubmission();
                    sub.setId(rs.getInt("id"));
                    sub.setAssignmentId(rs.getInt("assignment_id"));
                    sub.setStudentId(rs.getInt("student_id"));
                    sub.setFileUrl(rs.getString("file_url"));
                    sub.setAnswerText(rs.getString("answer_text"));
                    sub.setSubmittedAt(rs.getTimestamp("submitted_at"));
                    int mark = rs.getInt("mark");
                    sub.setMark(rs.wasNull() ? null : mark);
                    sub.setLecturerComment(rs.getString("lecturer_comment"));
                    sub.setStudentName(rs.getString("student_name"));
                    submissions.add(sub);
                }
            }
        }
        return submissions;
    }

    /**
     * Saves lecturer's mark and comment for a submission.
     */
    public boolean markSubmission(int submissionId, int mark,
                                  String comment) throws SQLException {

        String sql = "UPDATE assignment_submissions " +
                     "SET mark = ?, lecturer_comment = ? " +
                     "WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, mark);
            ps.setString(2, comment);
            ps.setInt(3, submissionId);
            return ps.executeUpdate() == 1;
        }
    }
}
