/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.elearningsystem.model;

import com.mycompany.elearningsystem.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author amri1
 */

public class AssignmentDAO {
    // ---------------------------------------------------------------
    // STUDENT - UC006 View assignment
    // ---------------------------------------------------------------

    /**
     * UC006 Step 1 - Returns all assignments across the student's enrolled courses.
     */
    public List<Assignment> getAssignmentsByStudent(int studentId) throws SQLException {
        List<Assignment> assignments = new ArrayList<>();

        String sql = "SELECT a.id, a.title, a.description, a.due_date, a.max_marks, " +
                     "a.course_id, a.lecturer_id, a.created_at, " +
                     "c.title AS course_name, " +
                     "u.name AS lecturer_name, " +
                     "asub.id AS submission_id " +
                     "FROM assignments a " +
                     "JOIN courses c ON c.id = a.course_id " +
                     "JOIN users u ON u.id = a.lecturer_id " +
                     "JOIN enrollments e ON e.course_id = a.course_id " +
                     "LEFT JOIN assignment_submissions asub " +
                     "   ON asub.assignment_id = a.id AND asub.student_id = ? " +
                     "WHERE e.student_id = ? " +
                     "ORDER BY a.due_date ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ps.setInt(2, studentId);

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
                    a.setLecturerName(rs.getString("lecturer_name"));
                    // UC007 Post condition: track submission status
                    a.setSubmitted(rs.getInt("submission_id") != 0);
                    assignments.add(a);
                }
            }
        }
        return assignments;
    }

    /**
     * UC006 Step 2 - Returns a single assignment by ID for the detail panel.
     */
    public Assignment getAssignmentById(int assignmentId) throws SQLException {
        String sql = "SELECT a.id, a.title, a.description, a.due_date, a.max_marks, " +
                     "a.course_id, a.lecturer_id, a.created_at, " +
                     "c.title AS course_name, " +
                     "u.name AS lecturer_name " +
                     "FROM assignments a " +
                     "JOIN courses c ON c.id = a.course_id " +
                     "JOIN users u ON u.id = a.lecturer_id " +
                     "WHERE a.id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, assignmentId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
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
                    a.setLecturerName(rs.getString("lecturer_name"));
                    return a;
                }
            }
        }
        return null;
    }

    // ---------------------------------------------------------------
    // STUDENT - UC007 Submit assignment
    // ---------------------------------------------------------------

    /**
     * UC007 Step 3 - Saves the student's submission.
     */
    public boolean submitAssignment(int assignmentId, int studentId,
                                    String fileUrl, String answerText) throws SQLException {

        String sql = "INSERT INTO assignment_submissions " +
                     "(assignment_id, student_id, file_url, answer_text) " +
                     "VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, assignmentId);
            ps.setInt(2, studentId);
            ps.setString(3, fileUrl);
            ps.setString(4, answerText);
            return ps.executeUpdate() == 1;
        }
    }

    /**
     * Checks if a student has already submitted a specific assignment.
     */
    public boolean hasSubmitted(int assignmentId, int studentId) throws SQLException {
        String sql = "SELECT id FROM assignment_submissions " +
                     "WHERE assignment_id = ? AND student_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, assignmentId);
            ps.setInt(2, studentId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /**
     * Gets a student's existing submission for an assignment.
     */
    public AssignmentSubmission getSubmission(int assignmentId, int studentId) throws SQLException {
        String sql = "SELECT id, assignment_id, student_id, file_url, answer_text, " +
                     "submitted_at, mark, lecturer_comment " +
                     "FROM assignment_submissions " +
                     "WHERE assignment_id = ? AND student_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, assignmentId);
            ps.setInt(2, studentId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    AssignmentSubmission sub = new AssignmentSubmission();
                    sub.setId(rs.getInt("id"));
                    sub.setAssignmentId(rs.getInt("assignment_id"));
                    sub.setStudentId(rs.getInt("student_id"));
                    sub.setFileUrl(rs.getString("file_url"));
                    sub.setAnswerText(rs.getString("answer_text"));
                    sub.setSubmittedAt(rs.getTimestamp("submitted_at"));
                    // getMark() returns null if not yet marked
                    int mark = rs.getInt("mark");
                    sub.setMark(rs.wasNull() ? null : mark);
                    sub.setLecturerComment(rs.getString("lecturer_comment"));
                    return sub;
                }
            }
        }
        return null;
    }

    // ---------------------------------------------------------------
    // LECTURER - UC016 Manage assignment
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
