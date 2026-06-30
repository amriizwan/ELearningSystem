// FILE 2: src/java/com/mycompany/elearningsystem/dao/DashboardDAO.java

package com.mycompany.elearningsystem.dao;

import com.mycompany.elearningsystem.model.ForumPost;
import com.mycompany.elearningsystem.model.QuizAttemptResult;
import com.mycompany.elearningsystem.model.Submission;
import com.mycompany.elearningsystem.util.DBConnection;
import com.mycompany.project.model.Course;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class DashboardDAO {

    // ── Database connection settings ──────────────────────────────────────────

   

    // ── Stat: courses teaching ────────────────────────────────────────────────

    public int getCourseCount(int lecturerId) {
        String sql = "SELECT COUNT(*) AS total FROM course_lecturer WHERE lecturer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, lecturerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ── Stat: total students across all courses ───────────────────────────────

    public int getStudentCount(int lecturerId) {
        String sql = "SELECT COUNT(DISTINCT e.student_id) AS total " +
                     "FROM enrollments e " +
                     "JOIN course_lecturer cl ON cl.course_id = e.course_id AND cl.lecturer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, lecturerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ── Stat: pending submissions to mark ────────────────────────────────────

    public int getPendingMarkCount(int lecturerId) {
        String sql = "SELECT COUNT(*) AS total " +
                     "FROM assignment_submissions s " +
                     "JOIN assignments a ON a.id = s.assignment_id AND a.lecturer_id = ? " +
                     "WHERE s.mark IS NULL";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, lecturerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ── Stat: total notes uploaded ────────────────────────────────────────────

    public int getNotesCount(int lecturerId) {
        String sql = "SELECT COUNT(*) AS total FROM notes WHERE lecturer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, lecturerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ── Stat: total quizzes created ───────────────────────────────────────────

    public int getQuizCount(int lecturerId) {
        String sql = "SELECT COUNT(*) AS total FROM quizzes WHERE lecturer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, lecturerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ── My courses with student count ─────────────────────────────────────────

    public ArrayList<Course> getCourses(int lecturerId) {
        ArrayList<Course> courses = new ArrayList<>();
        String sql = "SELECT c.id, c.title, " +
                     "       COUNT(DISTINCT e.student_id) AS student_count, " +
                     "       COUNT(DISTINCT n.id)         AS note_count, " +
                     "       COUNT(DISTINCT a.id)         AS asgn_count, " +
                     "       COUNT(DISTINCT q.id)         AS quiz_count " +
                     "FROM course_lecturer cl " +
                     "JOIN courses c     ON c.id = cl.course_id " +
                     "LEFT JOIN enrollments e ON e.course_id = c.id " +
                     "LEFT JOIN notes n       ON n.course_id = c.id AND n.lecturer_id = ? " +
                     "LEFT JOIN assignments a ON a.course_id = c.id AND a.lecturer_id = ? " +
                     "LEFT JOIN quizzes q     ON q.course_id = c.id AND q.lecturer_id = ? " +
                     "WHERE cl.lecturer_id = ? " +
                     "GROUP BY c.id " +
                     "ORDER BY c.title ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, lecturerId);
            ps.setInt(2, lecturerId);
            ps.setInt(3, lecturerId);
            ps.setInt(4, lecturerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Course course = new Course();
                course.setId(rs.getInt("id"));
                course.setTitle(rs.getString("title"));
                course.setStudentCount(rs.getInt("student_count"));
                course.setNoteCount(rs.getInt("note_count"));
                course.setAsgnCount(rs.getInt("asgn_count"));
                course.setQuizCount(rs.getInt("quiz_count"));
                courses.add(course);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return courses;
    }

    // ── Recent submissions to mark ────────────────────────────────────────────

    public ArrayList<Submission> getPendingSubmissions(int lecturerId) {
        ArrayList<Submission> submissions = new ArrayList<>();
        String sql = "SELECT s.id AS submission_id, s.submitted_at, " +
                     "       u.name  AS student_name, " +
                     "       a.title AS assignment_title, a.id AS assignment_id, a.max_marks, " +
                     "       c.title AS course_title " +
                     "FROM assignment_submissions s " +
                     "JOIN assignments a ON a.id = s.assignment_id AND a.lecturer_id = ? " +
                     "JOIN users u       ON u.id = s.student_id " +
                     "JOIN courses c     ON c.id = a.course_id " +
                     "WHERE s.mark IS NULL " +
                     "ORDER BY s.submitted_at DESC " +
                     "LIMIT 6";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, lecturerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Submission sub = new Submission();
                sub.setSubmissionId(rs.getInt("submission_id"));
                sub.setSubmittedAt(rs.getString("submitted_at"));
                sub.setStudentName(rs.getString("student_name"));
                sub.setAssignmentTitle(rs.getString("assignment_title"));
                sub.setAssignmentId(rs.getInt("assignment_id"));
                sub.setMaxMarks(rs.getInt("max_marks"));
                sub.setCourseTitle(rs.getString("course_title"));
                submissions.add(sub);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return submissions;
    }

    // ── Recent quiz attempts ──────────────────────────────────────────────────

    public ArrayList<QuizAttemptResult> getRecentAttempts(int lecturerId) {
        ArrayList<QuizAttemptResult> attempts = new ArrayList<>();
        String sql = "SELECT qa.score, qa.submitted_at, " +
                     "       u.name  AS student_name, " +
                     "       q.title AS quiz_title, " +
                     "       COUNT(qq.id) AS total_questions " +
                     "FROM quiz_attempts qa " +
                     "JOIN quizzes q        ON q.id  = qa.quiz_id AND q.lecturer_id = ? " +
                     "JOIN users u          ON u.id  = qa.student_id " +
                     "LEFT JOIN quiz_questions qq ON qq.quiz_id = q.id " +
                     "WHERE qa.submitted_at IS NOT NULL " +
                     "GROUP BY qa.id " +
                     "ORDER BY qa.submitted_at DESC " +
                     "LIMIT 5";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, lecturerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                QuizAttemptResult attempt = new QuizAttemptResult();
                attempt.setScore(rs.getInt("score"));
                attempt.setSubmittedAt(rs.getTimestamp("submitted_at").toLocalDateTime());
                attempt.setStudentName(rs.getString("student_name"));
                attempt.setQuizTitle(rs.getString("quiz_title"));
                attempt.setTotalQuestions(rs.getInt("total_questions"));
                attempts.add(attempt);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return attempts;
    }

    // ── Recent forum posts in my courses ─────────────────────────────────────

    public ArrayList<ForumPost> getRecentPosts(int lecturerId) {
        ArrayList<ForumPost> posts = new ArrayList<>();
        String sql = "SELECT p.id, p.title, p.created_at, " +
                     "       u.name AS author_name, u.role AS author_role, " +
                     "       c.title AS course_title, " +
                     "       COUNT(cm.id) AS comment_count " +
                     "FROM posts p " +
                     "JOIN courses c          ON c.id = p.course_id " +
                     "JOIN course_lecturer cl ON cl.course_id = c.id AND cl.lecturer_id = ? " +
                     "JOIN users u            ON u.id = p.user_id " +
                     "LEFT JOIN comments cm   ON cm.post_id = p.id " +
                     "GROUP BY p.id " +
                     "ORDER BY p.created_at DESC " +
                     "LIMIT 4";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, lecturerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ForumPost post = new ForumPost();
                post.setId(rs.getInt("id"));
                post.setTitle(rs.getString("title"));
                post.setCreatedAt(rs.getString("created_at"));
                post.setAuthorName(rs.getString("author_name"));
                post.setAuthorRole(rs.getString("author_role"));
                post.setCourseTitle(rs.getString("course_title"));
                post.setCommentCount(rs.getInt("comment_count"));
                posts.add(post);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return posts;
    }
    
}
