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
public class CourseDAO {
    // --- STUDENT UC004 ---
    public List<Course> getAllCourses() throws SQLException {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT id, title, description, created_at FROM courses ORDER BY title ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Course course = new Course();
                course.setId(rs.getInt("id"));
                course.setTitle(rs.getString("title"));
                course.setDescription(rs.getString("description"));
                course.setCreatedAt(rs.getTimestamp("created_at"));
                courses.add(course);
            }
        }
        return courses;
    }

    public List<Course> getEnrolledCourses(int studentId) throws SQLException {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT c.id, c.title, c.description, c.created_at " +
                     "FROM courses c JOIN enrollments e ON e.course_id = c.id " +
                     "WHERE e.student_id = ? ORDER BY c.title ASC";
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

    public boolean isEnrolled(int studentId, int courseId) throws SQLException {
        String sql = "SELECT id FROM enrollments WHERE student_id = ? AND course_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean enrollStudent(int studentId, int courseId) throws SQLException {
        String sql = "INSERT INTO enrollments (student_id, course_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean unenrollStudent(int studentId, int courseId) throws SQLException {
        String sql = "DELETE FROM enrollments WHERE student_id = ? AND course_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            return ps.executeUpdate() == 1;
        }
    }

    public Course getCourseById(int courseId) throws SQLException {
        String sql = "SELECT id, title, description, created_at FROM courses WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Course course = new Course();
                    course.setId(rs.getInt("id"));
                    course.setTitle(rs.getString("title"));
                    course.setDescription(rs.getString("description"));
                    course.setCreatedAt(rs.getTimestamp("created_at"));
                    return course;
                }
            }
        }
        return null;
    }

    // --- LECTURER UC014 ---

    public List<Course> getCoursesByLecturer(int lecturerId) throws SQLException {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT c.id, c.title, c.description, c.created_at " +
                     "FROM courses c JOIN course_lecturer cl ON cl.course_id = c.id " +
                     "WHERE cl.lecturer_id = ? ORDER BY c.title ASC";
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

    public boolean isTeaching(int lecturerId, int courseId) throws SQLException {
        String sql = "SELECT id FROM course_lecturer WHERE lecturer_id = ? AND course_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, lecturerId);
            ps.setInt(2, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean assignLecturer(int lecturerId, int courseId) throws SQLException {
        String sql = "INSERT INTO course_lecturer (course_id, lecturer_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ps.setInt(2, lecturerId);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean removeLecturer(int lecturerId, int courseId) throws SQLException {
        String sql = "DELETE FROM course_lecturer WHERE lecturer_id = ? AND course_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, lecturerId);
            ps.setInt(2, courseId);
            return ps.executeUpdate() == 1;
        }
    }

    // --- ADMIN  ---

    public boolean createCourse(String title, String description) throws SQLException {
        String sql = "INSERT INTO courses (title, description) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, description);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean updateCourse(int courseId, String title, String description) throws SQLException {
        String sql = "UPDATE courses SET title = ?, description = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setInt(3, courseId);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean deleteCourse(int courseId) throws SQLException {
        String sql = "DELETE FROM courses WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            return ps.executeUpdate() == 1;
        }
    }

    public List<Course> getAllCoursesWithCount() throws SQLException {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT c.id, c.title, c.description, c.created_at, " +
                     "COUNT(e.id) AS enrollment_count " +
                     "FROM courses c LEFT JOIN enrollments e ON e.course_id = c.id " +
                     "GROUP BY c.id, c.title, c.description, c.created_at " +
                     "ORDER BY c.title ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Course course = new Course();
                course.setId(rs.getInt("id"));
                course.setTitle(rs.getString("title"));
                course.setDescription(rs.getString("description"));
                course.setCreatedAt(rs.getTimestamp("created_at"));
                course.setEnrollmentCount(rs.getInt("enrollment_count"));
                courses.add(course);
            }
        }
        return courses;
    }
}
