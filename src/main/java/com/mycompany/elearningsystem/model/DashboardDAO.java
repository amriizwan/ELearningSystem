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
 * @author amri1 kena tukar cara store dalam object model, kalau ada tambahan attribute letak dekat model
 */
public class DashboardDAO {
    
    // STUDENT dashboard
    //untuk display course enrol by student (arraylist) a1
    public List<Course> getStudentCourses(int studentId) throws SQLException {
        List<Course> courses = new ArrayList<>();

        String sql = "SELECT c.id, c.title, c.description, c.created_at " +
                     "FROM courses c " +
                     "JOIN enrollments e ON e.course_id = c.id " +
                     "WHERE e.student_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Course course = new Course();
                    course.setId(rs.getInt("id"));
                    course.setTitle(rs.getString("title"));
                    course.setDescription(rs.getString("description"));
                    course.setCreatedAt(rs.getTimestamp("created_at"));
                    courses.add(course);
                }
            }
        }
        return courses;
    }
    
    //
    public List<Assignment> getUpcomingAssignments(int studentId) throws SQLException {
        List<Assignment> assignments = new ArrayList<>();

        String sql = "SELECT a.id, a.title, a.description, a.due_date, a.max_marks, " +
                     "c.title AS course_title " +
                     "FROM assignments a " +
                     "JOIN courses c ON c.id = a.course_id " +
                     "JOIN enrollments e ON e.course_id = a.course_id " +
                     "WHERE e.student_id = ? " +
                     "AND a.due_date >= NOW() " +
                     "AND a.id NOT IN (" +
                     "    SELECT assignment_id FROM assignment_submissions WHERE student_id = ?" +
                     ") " +
                     "ORDER BY a.due_date ASC LIMIT 5";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ps.setInt(2, studentId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Assignment assignment = new Assignment();
                    assignment.setId(rs.getInt("id"));
                    assignment.setTitle(rs.getString("title"));
                    assignment.setDescription(rs.getString("description"));
                    assignment.setDueDate(rs.getTimestamp("due_date"));
                    assignment.setMaxMarks(rs.getInt("max_marks"));
                    assignment.setCourseName(rs.getString("course_title"));
                    assignments.add(assignment);
                }
            }
        }
        return assignments;
    }
    
    
    public List<QuizAttempt> getRecentQuizScores(int studentId) throws SQLException {
        List<QuizAttempt> attempts = new ArrayList<>();

        String sql = "SELECT qa.id, qa.score, qa.started_at, qa.submitted_at, " +
                     "q.title AS quiz_title " +
                     "FROM quiz_attempts qa " +
                     "JOIN quizzes q ON q.id = qa.quiz_id " +
                     "WHERE qa.student_id = ? " +
                     "AND qa.submitted_at IS NOT NULL " +
                     "ORDER BY qa.submitted_at DESC LIMIT 5";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    QuizAttempt attempt = new QuizAttempt();
                    attempt.setId(rs.getInt("id"));
                    attempt.setScore(rs.getInt("score"));
                    attempt.setStartedAt(rs.getTimestamp("started_at"));
                    attempt.setSubmittedAt(rs.getTimestamp("submitted_at"));
                    attempt.setQuizTitle(rs.getString("quiz_title"));
                    attempts.add(attempt);
                }
            }
        }
        return attempts;
    }
    
    
    // LECTURER dashboard
    public List<Course> getLecturerCourses(int lecturerId) throws SQLException {
        List<Course> courses = new ArrayList<>();

        String sql = "SELECT c.id, c.title, c.description, c.created_at " +
                     "FROM courses c " +
                     "JOIN course_lecturer cl ON cl.course_id = c.id " +
                     "WHERE cl.lecturer_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, lecturerId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Course course = new Course();
                    course.setId(rs.getInt("id"));
                    course.setTitle(rs.getString("title"));
                    course.setDescription(rs.getString("description"));
                    course.setCreatedAt(rs.getTimestamp("created_at"));
                    courses.add(course);
                }
            }
        }
        return courses;
    }
    
    public List<AssignmentSubmission> getPendingSubmissions(int lecturerId) throws SQLException {
        List<AssignmentSubmission> submissions = new ArrayList<>();

        String sql = "SELECT asub.id, asub.submitted_at, " +
                     "u.name AS student_name, " +
                     "a.title AS assignment_title, " +
                     "c.title AS course_title " +
                     "FROM assignment_submissions asub " +
                     "JOIN assignments a ON a.id = asub.assignment_id " +
                     "JOIN courses c ON c.id = a.course_id " +
                     "JOIN users u ON u.id = asub.student_id " +
                     "WHERE a.lecturer_id = ? " +
                     "AND asub.mark IS NULL " +
                     "ORDER BY asub.submitted_at ASC LIMIT 10";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, lecturerId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AssignmentSubmission sub = new AssignmentSubmission();
                    sub.setId(rs.getInt("id"));
                    sub.setSubmittedAt(rs.getTimestamp("submitted_at"));
                    sub.setStudentName(rs.getString("student_name"));
                    sub.setAssignmentTitle(rs.getString("assignment_title"));
                    sub.setCourseName(rs.getString("course_title"));
                    submissions.add(sub);
                }
            }
        }
        return submissions;
    }
    
    // ADMIN dashboard
    public AdminStats getAdminStats() throws SQLException {
        AdminStats stats = new AdminStats();

        String sql = "SELECT " +
                     "(SELECT COUNT(*) FROM users) AS total_users, " +
                     "(SELECT COUNT(*) FROM users WHERE role = 'student') AS total_students, " +
                     "(SELECT COUNT(*) FROM users WHERE role = 'lecturer') AS total_lecturers, " +
                     "(SELECT COUNT(*) FROM users WHERE status = 'inactive') AS inactive_users, " +
                     "(SELECT COUNT(*) FROM courses) AS total_courses, " +
                     "(SELECT COUNT(*) FROM notes) AS total_notes, " +
                     "(SELECT COUNT(*) FROM assignments) AS total_assignments, " +
                     "(SELECT COUNT(*) FROM quizzes) AS total_quizzes, " +
                     "(SELECT COUNT(*) FROM posts) AS total_posts";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                stats.setTotalUsers(rs.getInt("total_users"));
                stats.setTotalStudents(rs.getInt("total_students"));
                stats.setTotalLecturers(rs.getInt("total_lecturers"));
                stats.setInactiveUsers(rs.getInt("inactive_users"));
                stats.setTotalCourses(rs.getInt("total_courses"));
                stats.setTotalNotes(rs.getInt("total_notes"));
                stats.setTotalAssignments(rs.getInt("total_assignments"));
                stats.setTotalQuizzes(rs.getInt("total_quizzes"));
                stats.setTotalPosts(rs.getInt("total_posts"));
            }
        }
        return stats;
    }

    /**
    Returns top 5 courses by enrollment count.
     */
    public List<Course> getTopCourses() throws SQLException {
        List<Course> courses = new ArrayList<>();

        String sql = "SELECT c.id, c.title, COUNT(e.id) AS enrollment_count " +
                     "FROM courses c " +
                     "LEFT JOIN enrollments e ON e.course_id = c.id " +
                     "GROUP BY c.id, c.title " +
                     "ORDER BY enrollment_count DESC LIMIT 5";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Course course = new Course();
                course.setId(rs.getInt("id"));
                course.setTitle(rs.getString("title"));
                course.setEnrollmentCount(rs.getInt("enrollment_count"));
                courses.add(course);
            }
        }
        return courses;
    }

    /**
    Returns 5 most recently registered users.
     */
    public List<User> getRecentUsers() throws SQLException {
        List<User> users = new ArrayList<>();

        String sql = "SELECT id, name, email, role, status, created_at " +
                     "FROM users ORDER BY created_at DESC LIMIT 5";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                user.setStatus(rs.getString("status"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                users.add(user);
            }
        }
        return users;
    }

    /**
    Returns 5 most recent forum posts.
     */
    public List<Post> getRecentPosts() throws SQLException {
        List<Post> posts = new ArrayList<>();

        String sql = "SELECT p.id, p.title, p.content, p.created_at, " +
                     "u.name AS author_name, " +
                     "c.title AS course_title " +
                     "FROM posts p " +
                     "JOIN users u ON u.id = p.user_id " +
                     "JOIN courses c ON c.id = p.course_id " +
                     "ORDER BY p.created_at DESC LIMIT 5";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Post post = new Post();
                post.setId(rs.getInt("id"));
                post.setTitle(rs.getString("title"));
                post.setContent(rs.getString("content"));
                post.setCreatedAt(rs.getTimestamp("created_at"));
                post.setAuthorName(rs.getString("author_name"));
                post.setCourseName(rs.getString("course_title"));
                posts.add(post);
            }
        }
        return posts;
    }
    
}
