/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.elearningsystem.dao;

import com.mycompany.elearningsystem.model.courses;
import com.mycompany.elearningsystem.model.coursesLect;
import com.mycompany.elearningsystem.util.DBConnection;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Haziq
 */
public class coursesLectDAO {
    
    public Boolean getCoursesById(int lecturer_id, int course_id){
        try{
            
            Connection con = DBConnection.getConnection();
            
            Statement stmt = con.createStatement();
                    
            String sql = "SELECT id FROM course_lecturer WHERE lecturer_id = ? AND course_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            
            ps.setInt(1, lecturer_id);
            ps.setInt(2, course_id);
            
            int rs = ps.executeUpdate();
            
            
            
            
            //insert data
//            stmt.executeUpdate("INSERT INTO `staff` (`staff_id`, `first_name`, `hire_date`, `salary`) VALUES ('', '', NULL, '')");
            stmt.close();
            con.close();
            return rs > 0;
            
            
//            response.getWriter().print("Connection to DB success");
        }catch(SQLException ex){
            Logger.getLogger(coursesLectDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return false;
    }
    public List<coursesLect> getCourses(int lecture_id){
        List<coursesLect> courselist = new ArrayList<>();
        
        
        
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
                coursesLect cl = new coursesLect();
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
            
            
            
            //insert data
//            stmt.executeUpdate("INSERT INTO `staff` (`staff_id`, `first_name`, `hire_date`, `salary`) VALUES ('', '', NULL, '')");
            stmt.close();
            con.close();
            return courselist;
            
//            response.getWriter().print("Connection to DB success");
        }catch(SQLException ex){
            Logger.getLogger(coursesLectDAO.class.getName()).log(Level.SEVERE, null, ex);
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
            
            
            
            
            //insert data
//            stmt.executeUpdate("INSERT INTO `staff` (`staff_id`, `first_name`, `hire_date`, `salary`) VALUES ('', '', NULL, '')");
            stmt.close();
            con.close();
            return rs > 0;
            
            
//            response.getWriter().print("Connection to DB success");
        }catch(SQLException ex){
            Logger.getLogger(coursesLectDAO.class.getName()).log(Level.SEVERE, null, ex);
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
            
            
            
            
            //insert data
//            stmt.executeUpdate("INSERT INTO `staff` (`staff_id`, `first_name`, `hire_date`, `salary`) VALUES ('', '', NULL, '')");
            stmt.close();
            con.close();
            return rs > 0;
            
            
//            response.getWriter().print("Connection to DB success");
        }catch(SQLException ex){
            Logger.getLogger(coursesLectDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return false;
    }
    
    
        
}
