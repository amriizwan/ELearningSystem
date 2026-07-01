package com.mycompany.elearningsystem.dao;

import com.mycompany.elearningsystem.model.Course;
import com.mycompany.elearningsystem.model.CourseLecturer;
import com.mycompany.elearningsystem.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CourseDAO {
    // --- STUDENT ---
    public List<Course> getLecturerNames() {
        List<Course> lectNames = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            
            String sql =
                "SELECT cl.course_id, GROUP_CONCAT(u.name ORDER BY u.name SEPARATOR ', ') AS lecturers " +
                "FROM course_lecturer cl " +
                "JOIN users u ON u.id = cl.lecturer_id " +
                "GROUP BY cl.course_id";
            
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
                
            while(rs.next()) {
                Course ln = new Course();
                
                ln.setId(rs.getInt("course_id"));
                ln.setLecturerNames(rs.getString("lecturers"));
                    
                lectNames.add(ln);
            }
        } catch(SQLException e) {
        }
        return lectNames;
    }
    
    public List<Course> getAllCourses(int studentId) {
        List<Course> courses = new ArrayList<>();
    
        try {
            Connection conn = DBConnection.getConnection();
            
            String sql =
                "SELECT " +
                "c.id, " +
                "c.title, " +
                "c.description, " +
                "COUNT(DISTINCT n.id) AS note_count, " +
                "COUNT(DISTINCT a.id) AS asgn_count, " +
                "COUNT(DISTINCT q.id) AS quiz_count, " +
                "COUNT(DISTINCT e2.student_id) AS enrolled_students, " +
                "MAX(CASE WHEN e.student_id = ? THEN 1 ELSE 0 END) AS is_enrolled " +
                "FROM courses c " +
                "LEFT JOIN course_lecturer cl ON cl.course_id = c.id " +
                "LEFT JOIN notes n ON n.course_id = c.id " +
                "LEFT JOIN assignments a ON a.course_id = c.id " +
                "LEFT JOIN quizzes q ON q.course_id = c.id " +
                "LEFT JOIN enrollments e ON e.course_id = c.id AND e.student_id = ? " +
                "LEFT JOIN enrollments e2 ON e2.course_id = c.id " +
                "GROUP BY c.id " +
                "ORDER BY c.title ASC";
            
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, studentId);
            ps.setInt(2, studentId);
            ResultSet rs = ps.executeQuery();
                

            while(rs.next()) {
                    
                Course c = new Course();

                c.setId(rs.getInt("id"));
                c.setTitle(rs.getString("title"));
                c.setDescription(rs.getString("description"));
                c.setNoteCount(rs.getInt("note_count"));
                c.setQuizCount(rs.getInt("quiz_count"));
                c.setAssignmentCount(rs.getInt("asgn_count"));
                c.setEnrollmentCount(rs.getInt("enrolled_students"));
                c.setEnrolled(rs.getInt("is_enrolled") == 1);
                    
                courses.add(c);
            }

        } catch(SQLException e) {
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


    // --- LECTURER ---

    public Boolean getCoursesById(int lecturer_id, int course_id){
        try{          
            Connection con = DBConnection.getConnection();            
            Statement stmt = con.createStatement();
                    
            String sql = "SELECT id FROM course_lecturer WHERE lecturer_id = ? AND course_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            
            ps.setInt(1, lecturer_id);
            ps.setInt(2, course_id);
            
            int rs = ps.executeUpdate();
            stmt.close();
            con.close();
            return rs > 0;
        }catch(SQLException ex){
            Logger.getLogger(CourseDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return false;
    }
    public List<CourseLecturer> getCourses(int lecture_id){
        List<CourseLecturer> courselist = new ArrayList<>();
        try{
            Connection con = DBConnection.getConnection();
            Statement stmt = con.createStatement();
                    
            String sql = "SELECT c.id, c.title, c.description," +
                        "           COUNT(DISTINCT e.student_id)  AS student_count," +
                        "           COUNT(DISTINCT n.id)          AS note_count," +
                        "           COUNT(DISTINCT a.id)          AS asgn_count," +
                        "           COUNT(DISTINCT q.id)          AS quiz_count," +
                        "           COUNT(DISTINCT cl2.lecturer_id) AS lecturer_count," +
                        "           MAX(CASE WHEN cl.lecturer_id = ? THEN 1 ELSE 0 END) AS is_mine" +
                        "    FROM courses c" +
                        "    LEFT JOIN course_lecturer cl  ON cl.course_id  = c.id AND cl.lecturer_id = ?" +
                        "    LEFT JOIN course_lecturer cl2 ON cl2.course_id = c.id" +
                        "    LEFT JOIN enrollments e       ON e.course_id   = c.id" +
                        "    LEFT JOIN notes n             ON n.course_id   = c.id AND n.lecturer_id  = ?" +
                        "    LEFT JOIN assignments a       ON a.course_id   = c.id AND a.lecturer_id  = ?" +
                        "    LEFT JOIN quizzes q           ON q.course_id   = c.id AND q.lecturer_id  = ?" +
                        "    GROUP BY c.id" +
                        "    ORDER BY is_mine DESC, c.title ASC";
            
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1,lecture_id);
            ps.setInt(2,lecture_id);
            ps.setInt(3,lecture_id);
            ps.setInt(4,lecture_id);
            ps.setInt(5,lecture_id);
            
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                CourseLecturer cl = new CourseLecturer();
                cl.setId(rs.getString("id"));
                cl.setStudent_count(rs.getInt("student_count"));
                cl.setNote_count(rs.getInt("note_count"));
                cl.setAsgn_count(rs.getInt("asgn_count"));
                cl.setQuiz_count(rs.getInt("quiz_count"));
                cl.setLecturer_count(rs.getInt("lecturer_count"));
                cl.setIs_mine(rs.getInt("is_mine"));
                cl.setTitle(rs.getString("title"));
                cl.setDescription(rs.getString("description"));
                courselist.add(cl);
            }
            stmt.close();
            con.close();
            return courselist;
        }catch(SQLException ex){
            Logger.getLogger(CourseDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return courselist;
    }
    
    public Boolean CoursesUnassign(int lecturer_id, int course_id ){
        try{
            Connection con = DBConnection.getConnection();
            Statement stmt = con.createStatement();
                    
            String sql = "DELETE FROM course_lecturer WHERE lecturer_id = ? AND course_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            
            ps.setInt(1, lecturer_id);
            ps.setInt(2, course_id);
            
            int rs = ps.executeUpdate();
            stmt.close();
            con.close();
            return rs > 0;
            
        }catch(SQLException ex){
            Logger.getLogger(CourseDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return false;
    }
    
    public Boolean CoursesAssign(int lecturer_id, int course_id ){
        try{
            Connection con = DBConnection.getConnection();
            Statement stmt = con.createStatement();
                    
            String sql = "INSERT INTO course_lecturer (course_id, lecturer_id) VALUES (?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            
            ps.setInt(2, lecturer_id);
            ps.setInt(1, course_id);
            
            int rs = ps.executeUpdate();
            stmt.close();
            con.close();
            return rs > 0;
            
        }catch(SQLException ex){
            Logger.getLogger(CourseDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return false;
    }

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
