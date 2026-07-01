/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.elearningsystem.dao;

import com.mycompany.elearningsystem.model.Course;
import com.mycompany.elearningsystem.model.Enrollment;
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
public class EnrollmentDAO {
    public boolean insertEnrollment(Enrollment e) {

        boolean success = false;
      
        try {
            Connection conn = DBConnection.getConnection();
            
            String sql = "INSERT INTO enrollments(student_id, course_id) VALUES(?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, e.getStudentId());
            ps.setInt(2, e.getCourseId());

            success = ps.executeUpdate() > 0;
        } catch(SQLException ex) {
            ex.printStackTrace();
        }

        return success;
    }
    
    public boolean deleteEnrollment(Enrollment e) {

        boolean success = false;

        String sql =
                "DELETE FROM enrollments " +
                "WHERE student_id = ? AND course_id = ?";

        try {

            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, e.getStudentId());
            ps.setInt(2, e.getCourseId());

            success = ps.executeUpdate() > 0;
        } catch(SQLException ex) {
            ex.printStackTrace();
        }

        return success;
    }
    
    public List<Course> getEnrollmentsCourses(int studentId) {
        List<Course> enrollments = new ArrayList<>();

        String sql =
                "SELECT c.id, c.title, c.description, " +
                "COUNT(DISTINCT n.id) AS note_count, " +
                "COUNT(DISTINCT a.id) AS asgn_count, " +
                "COUNT(DISTINCT q.id) AS quiz_count " +
                "FROM enrollments e " +
                "JOIN courses c ON c.id = e.course_id " +
                "LEFT JOIN notes n       ON n.course_id = c.id " +
                "LEFT JOIN assignments a ON a.course_id = c.id " +
                "LEFT JOIN quizzes q     ON q.course_id = c.id " +
                "WHERE e.student_id = ? " +
                "GROUP BY c.id " +
                "ORDER BY c.title ASC";

        try {

            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();

            while(rs.next()) {

                Course c = new Course();
                c.setId(rs.getInt("id"));
                c.setTitle(rs.getString("title"));
                c.setDescription(rs.getString("description"));
                c.setNoteCount(rs.getInt("note_count"));
                c.setQuizCount(rs.getInt("quiz_count"));
                c.setAssignmentCount(rs.getInt("asgn_count"));

                enrollments.add(c);
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }

        return enrollments;
    }
    
    
    public List<Enrollment> getLectforCourse(int courseId) {
        List<Enrollment> lectCourse = new ArrayList<>();

        String sql =
                "SELECT u.id, u.name, " +
                "COUNT(DISTINCT n.id) AS note_count, " +
                "COUNT(DISTINCT a.id) AS asgn_count " +
                "FROM course_lecturer cl " +
                "JOIN users u ON u.id = cl.lecturer_id " +
                "LEFT JOIN notes n       ON n.course_id = ? AND n.lecturer_id = u.id " +
                "LEFT JOIN assignments a ON a.course_id = ? AND a.lecturer_id = u.id " +
                "WHERE cl.course_id = ? " +
                "GROUP BY u.id " +
                "ORDER BY u.name ASC";

        try {

            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, courseId);
            ps.setInt(2, courseId);
            ps.setInt(3, courseId);

            ResultSet rs = ps.executeQuery();
            while(rs.next()) {

                Enrollment e = new Enrollment();
                e.setLectId(rs.getInt("id"));
                e.setLectName(rs.getString("name"));
                e.setNoteCount(rs.getInt("note_count"));
                e.setAssignmentCount(rs.getInt("asgn_count"));

                lectCourse.add(e);
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }

        return lectCourse;
    }
    
    
}
