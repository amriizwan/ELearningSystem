/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.elearningsystem.dao;

import com.mycompany.elearningsystem.model.Note;
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

/**
 *
 * @author amri1
 */
public class NoteDAO {
    // STUDENT
    public List<Note> getNotesByCL(int courseId, int lecturerId) {
        List<Note> notesList = new ArrayList<>();

        String sql =
            "SELECT id, title, type, file_url, created_at " +
            "FROM notes " +
            "WHERE course_id = ? AND lecturer_id = ? " +
            "ORDER BY created_at DESC";

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, courseId);
            ps.setInt(2, lecturerId);

            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Note note = new Note();

                note.setId(rs.getInt("id"));
                note.setTitle(rs.getString("title"));
                note.setType(rs.getString("type"));
                note.setFileUrl(rs.getString("file_url"));
                note.setCreatedAt(rs.getTimestamp("created_at"));

                notesList.add(note);
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return notesList;
    }
    
    // ---------------------------------------------------------------
    // LECTURER
    // ---------------------------------------------------------------

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
            Logger.getLogger(NoteDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
           return false;
    }
    
    public List<Note> getAllNote(int lecture_id){
        List<Note> notelist = new ArrayList();
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
                Note nt = new Note();
                nt.setId(rs.getInt("id"));
                nt.setTitle(rs.getString("title"));
                nt.setNoteCount(rs.getInt("note_count"));
                notelist.add(nt);
            }
            
            stmt.close();
            con.close();
            return notelist;
        }catch(SQLException ex){
            Logger.getLogger(NoteDAO.class.getName()).log(Level.SEVERE, null, ex);
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
        }catch(SQLException ex){
            Logger.getLogger(NoteDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
    
    public Note getSelectedNote(int id, int lecturer_id){
        Note notelist = new Note();
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
                notelist.setCourseId(rs.getInt("course_id"));
                notelist.setLecturerId(rs.getInt("lecturer_id"));
                notelist.setTitle(rs.getString("title"));
                notelist.setType(rs.getString("type"));
                notelist.setFileUrl(rs.getString("file_url"));
                notelist.setCreatedAt(rs.getTimestamp("created_at"));
            }

            stmt.close();
            con.close();
            return notelist;
        }catch(SQLException ex){
            Logger.getLogger(NoteDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return notelist;
    }
    
    public List<Note> getSelectedCourse(int courses_id, int lecturer_id){
        List<Note> notelist = new ArrayList();
        try{
            Connection con = DBConnection.getConnection();
            Statement stmt = con.createStatement();
            
            String sql ="SELECT * FROM notes n WHERE n.course_id = ? AND n.lecturer_id = ? ORDER BY created_at DESC";
            
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, courses_id);
            ps.setInt(2, lecturer_id);
           
            ResultSet rs = ps.executeQuery();
            
            while(rs.next()){
                Note nt = new Note();
                nt.setId(rs.getInt("id"));
                nt.setCourseId(rs.getInt("course_id"));
                nt.setLecturerId(rs.getInt("lecturer_id"));
                nt.setTitle(rs.getString("title"));
                nt.setType(rs.getString("type"));
                nt.setFileUrl(rs.getString("file_url"));
                nt.setCreatedAt(rs.getTimestamp("created_at"));
                notelist.add(nt);
            }
            
            stmt.close();
            con.close();
            return notelist;
        }catch(SQLException ex){
            Logger.getLogger(NoteDAO.class.getName()).log(Level.SEVERE, null, ex);
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
        }catch(SQLException ex){
            Logger.getLogger(NoteDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
    
    
    /**
     * Gets a single note by ID — used to verify ownership before edit/delete.
     */
    public Note getNoteById(int noteId) throws SQLException {
        String sql = "SELECT n.id, n.course_id, n.lecturer_id, n.title, n.type, n.file_url, n.created_at, " +
                     "c.title AS course_name " +
                     "FROM notes n JOIN courses c ON c.id = n.course_id " +
                     "WHERE n.id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, noteId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Note note = new Note();
                    note.setId(rs.getInt("id"));
                    note.setCourseId(rs.getInt("course_id"));
                    note.setLecturerId(rs.getInt("lecturer_id"));
                    note.setTitle(rs.getString("title"));
                    note.setType(rs.getString("type"));
                    note.setFileUrl(rs.getString("file_url"));
                    note.setCreatedAt(rs.getTimestamp("created_at"));
                    note.setCourseName(rs.getString("course_name"));
                    return note;
                }
            }
        }
        return null;
    }
}
