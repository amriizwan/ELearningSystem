package com.mycompany.elearningsystem.dao;

import com.mycompany.elearningsystem.model.AdminStats;
import com.mycompany.elearningsystem.model.Assignment;
import com.mycompany.elearningsystem.model.Course;
import com.mycompany.elearningsystem.model.Post;
import com.mycompany.elearningsystem.model.User;
import com.mycompany.elearningsystem.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DashboardDAO {
    
    // STUDENT dashboard
    public int getTotalEnrolledCourses(int studentId) {
        String sql = "SELECT COUNT(*) AS total FROM enrollments WHERE student_id = ?";

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }catch(SQLException e) {
                e.printStackTrace();
                System.out.println("SQL ERROR: " + e.getMessage());
        }
        return 0;
    }
    
    public int getTotalAssignments(int studentId) {
        String sql = 
                "SELECT COUNT(*) AS total " +
                "FROM assignments a " +
                "JOIN enrollments e ON e.course_id = a.course_id AND e.student_id = ? " +
                "LEFT JOIN assignment_submissions s ON s.assignment_id = a.id AND s.student_id = ? " +
                "WHERE s.id IS NULL AND a.due_date >= NOW()";

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, studentId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch(SQLException e) {
            e.printStackTrace();
            System.out.println("SQL ERROR: " + e.getMessage());
        }
        return 0;
    }
    
    public int getTotalOverdueAsgn(int studentId) {
        String sql = 
                "SELECT COUNT(*) AS total " +
                "FROM assignments a " +
                "JOIN enrollments e ON e.course_id = a.course_id AND e.student_id = ? " +
                "LEFT JOIN assignment_submissions s ON s.assignment_id = a.id AND s.student_id = ? " +
                "WHERE s.id IS NULL AND a.due_date < NOW()";

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch(SQLException e) {
            e.printStackTrace();
            System.out.println("SQL ERROR: " + e.getMessage());
        }
        return 0;
    }
    
    public int getTotalAvlQuiz(int studentId) {
        String sql = 
                "SELECT COUNT(*) AS total " +
                "FROM quizzes q " +
                "JOIN enrollments e ON e.course_id = q.course_id AND e.student_id = ? " +
                "LEFT JOIN quiz_attempts qa ON qa.quiz_id = q.id AND qa.student_id = ? " +
                "WHERE qa.id IS NULL";

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch(SQLException e) {
            e.printStackTrace();
            System.out.println("SQL ERROR: " + e.getMessage());
        }
        return 0;
    }
    
    public double getTotalAvgQuizScore(int studentId) {
        String sql = 
                "SELECT AVG(score) AS avg_score " +
                "FROM quiz_attempts " +
                "WHERE student_id = ? AND submitted_at IS NOT NULL";

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch(SQLException e) {
            e.printStackTrace();
            System.out.println("SQL ERROR: " + e.getMessage());
        }
        return 0;
    }
    
    public List<Assignment> getUpcomingTasks(int studentId) {
        List<Assignment> upTask = new ArrayList<>();

        String sql = 
                "SELECT a.id, a.title, a.due_date, c.title AS course_title, " +
                "u.name AS lecturer_name, " +
                "CASE WHEN a.due_date < NOW() THEN 'overdue' " +
                "WHEN a.due_date < DATE_ADD(NOW(), INTERVAL 3 DAY) THEN 'soon' " +
                "ELSE 'upcoming' END AS urgency " +
                "FROM assignments a " +
                "JOIN enrollments e ON e.course_id = a.course_id AND e.student_id = ? " +
                "JOIN courses c ON c.id = a.course_id " +
                "JOIN users u ON u.id = a.lecturer_id " +
                "LEFT JOIN assignment_submissions s ON s.assignment_id = a.id AND s.student_id = ? " +
                "WHERE s.id IS NULL " +
                "ORDER BY a.due_date ASC " +
                "LIMIT 5";

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
                assignment.setDueDate(rs.getTimestamp("due_date"));
                assignment.setCourseName(rs.getString("course_title"));
                assignment.setLecturerName(rs.getString("lecturer_name"));
                
                upTask.add(assignment);
            }
        } catch(SQLException e) {
            e.printStackTrace();
            System.out.println("SQL ERROR: " + e.getMessage());
        }
        return upTask;
    }
    
    
    //LECTURER dashboard
    
    
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
