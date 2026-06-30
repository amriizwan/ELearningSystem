/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.elearningsystem.dao;

import com.mycompany.elearningsystem.model.courses;
import com.mycompany.elearningsystem.model.coursesLect;
import com.mycompany.elearningsystem.model.note;
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
public class noteDAO {
    public Boolean uploadNote(int course_id, int lecture_id, String title, String type, String fileurl){
        
        try{
           Connection con = DBConnection.getConnection();
            
            Statement stmt = con.createStatement();
                    
            String sql = "INSERT INTO notes (course_id, lecturer_id, title, type, file_url) VALUES (?, ?, ?, ?, ?)";
            
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1,course_id);
            ps.setInt(2,lecture_id);
            ps.setString(3, title);
            ps.setString(4, type);
            ps.setString(5, fileurl);
            
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
    
    public List<note> getAllNote(int lecture_id){
        List<note> notelist = new ArrayList();
        
        try{
            
             Connection con = DBConnection.getConnection();
            
            Statement stmt = con.createStatement();
            
            String sql ="SELECT c.id, c.title, COUNT(n.id) AS note_count" +
                        "    FROM course_lecturer cl" +
                        "    JOIN courses c ON c.id = cl.course_id" +
                        "    LEFT JOIN notes n ON n.course_id = c.id AND n.lecturer_id = ?" +
                        "    WHERE cl.lecturer_id = ?" +
                        "    GROUP BY c.id ORDER BY c.title ASC";
            
           PreparedStatement ps = con.prepareStatement(sql);
           ps.setInt(1, lecture_id);
           ps.setInt(2, lecture_id);
           
          
                    
            ResultSet rs = ps.executeQuery();
            
            while(rs.next()){
                note nt = new note();
                nt.setId(rs.getInt("id"));
                nt.setTitle(rs.getString("title"));
                nt.setNote_count(rs.getInt("note_count"));
                notelist.add(nt);
            }
            
            
            
            
            
            //insert data
//            stmt.executeUpdate("INSERT INTO `staff` (`staff_id`, `first_name`, `hire_date`, `salary`) VALUES ('', '', NULL, '')");
            stmt.close();
            con.close();
            return notelist;
            
//            response.getWriter().print("Connection to DB success");
        }catch(SQLException ex){
            Logger.getLogger(coursesLectDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return notelist;
        
    }
    
    public Boolean deleteNote(int id){
        
        try{
            
             Connection con = DBConnection.getConnection();
            
            Statement stmt = con.createStatement();
                    
            String sql = "DELETE FROM notes WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1,id);
            
            
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
    
    public note getSelectedNote(int id, int lecturer_id){
        note notelist = new note();
        try{
            
            Connection con = DBConnection.getConnection();
            
            Statement stmt = con.createStatement();
            
            String sql ="SELECT * FROM notes WHERE id = ? AND lecturer_id = ?";
            
           PreparedStatement ps = con.prepareStatement(sql);
           ps.setInt(1, id);
           ps.setInt(2, lecturer_id);
           
          
                    
            ResultSet rs = ps.executeQuery();
            
           while(rs.next()){
            notelist.setId(rs.getInt("id"));
            notelist.setCourse_id(rs.getInt("course_id"));
            notelist.setLecture_id(rs.getInt("lecturer_id"));
            notelist.setTitle(rs.getString("title"));
            notelist.setType(rs.getString("type"));
            notelist.setUrl(rs.getString("file_url"));
            notelist.setCreated_at(rs.getDate("created_at"));
           }
                
            
            
            stmt.close();
            con.close();
            return notelist;
            
//            response.getWriter().print("Connection to DB success");
        }catch(SQLException ex){
            Logger.getLogger(coursesLectDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return notelist;
        
    }
    
    public List<note> getSelectedCourse(int courses_id, int lecturer_id){
        List<note> notelist = new ArrayList();
        try{
            
             Connection con = DBConnection.getConnection();
            
            Statement stmt = con.createStatement();
            
            String sql ="SELECT * FROM notes n WHERE n.course_id = ? AND n.lecturer_id = ? ORDER BY created_at DESC";
            
           PreparedStatement ps = con.prepareStatement(sql);
           ps.setInt(1, courses_id);
           ps.setInt(2, lecturer_id);
           
          
                    
            ResultSet rs = ps.executeQuery();
            
            while(rs.next()){
                note nt = new note();
                nt.setId(rs.getInt("id"));
                nt.setCourse_id(rs.getInt("course_id"));
                nt.setLecture_id(rs.getInt("lecturer_id"));
                nt.setTitle(rs.getString("title"));
                nt.setType(rs.getString("type"));
                nt.setUrl(rs.getString("file_url"));
                nt.setCreated_at(rs.getDate("created_at"));
                notelist.add(nt);
            }
            
            
            
            
            
            //insert data
//            stmt.executeUpdate("INSERT INTO `staff` (`staff_id`, `first_name`, `hire_date`, `salary`) VALUES ('', '', NULL, '')");
            stmt.close();
            con.close();
            return notelist;
            
//            response.getWriter().print("Connection to DB success");
        }catch(SQLException ex){
            Logger.getLogger(coursesLectDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return notelist;
        
    }
    
    public Boolean updateNote(int id, String title , int lecturer_id){
        try{
            Connection con = DBConnection.getConnection();
            
            Statement stmt = con.createStatement();
                    
            String sql = "UPDATE `notes` SET `title` = ? WHERE `id` =  ? AND lecturer_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, title);
            ps.setInt(2, id);
            ps.setInt(3, lecturer_id);
            
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
}
