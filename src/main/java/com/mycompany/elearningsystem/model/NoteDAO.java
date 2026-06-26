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
public class NoteDAO {
    // STUDENT - UC005
    public List<User> getLecturer() throws SQLException{
        List<User> lect = new ArrayList<>();
        
        String sql = "SELECT id, name " + 
                     "FROM users " +
                     "WHERE role = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "lecturer");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setName(rs.getString("name"));
                    lect.add(user);
                }
            }
        }
        
        return lect;
    }
    
    
    /**
     * UC005 Step 1 - Returns all notes for courses the student is enrolled in.
     */
    public List<Note> getNotesByStudentEnrollment(int studentId) throws SQLException {
        List<Note> notes = new ArrayList<>();

        String sql = "SELECT n.id, n.course_id, n.lecturer_id, n.title, n.type, n.file_url, n.created_at, " +
                     "c.title AS course_name, " +
                     "u.name AS lecturer_name " +
                     "FROM notes n " +
                     "JOIN courses c ON c.id = n.course_id " +
                     "JOIN users u ON u.id = n.lecturer_id " +
                     "JOIN enrollments e ON e.course_id = n.course_id " +
                     "WHERE e.student_id = ? " +
                     "ORDER BY c.title ASC, u.name ASC, n.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Note note = new Note();
                    note.setId(rs.getInt("id"));
                    note.setCourseId(rs.getInt("course_id"));
                    note.setLecturerId(rs.getInt("lecturer_id"));
                    note.setTitle(rs.getString("title"));
                    note.setType(rs.getString("type"));
                    note.setFileUrl(rs.getString("file_url"));
                    note.setCreatedAt(rs.getTimestamp("created_at"));
                    note.setCourseName(rs.getString("course_name"));
                    note.setLecturerName(rs.getString("lecturer_name"));
                    notes.add(note);
                }
            }
        }
        return notes;
    }

    /**
     * UC005 Step 3 - Returns notes for a specific course and lecturer.
     * Called when student selects a course then chooses a lecturer.
     */
    public List<Note> getNotesByCourseAndLecturer(int courseId, int lecturerId) throws SQLException {
        List<Note> notes = new ArrayList<>();

        String sql = "SELECT n.id, n.course_id, n.lecturer_id, n.title, n.type, n.file_url, n.created_at, " +
                     "c.title AS course_name, " +
                     "u.name AS lecturer_name " +
                     "FROM notes n " +
                     "JOIN courses c ON c.id = n.course_id " +
                     "JOIN users u ON u.id = n.lecturer_id " +
                     "WHERE n.course_id = ? AND n.lecturer_id = ? " +
                     "ORDER BY n.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, courseId);
            ps.setInt(2, lecturerId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Note note = new Note();
                    note.setId(rs.getInt("id"));
                    note.setCourseId(rs.getInt("course_id"));
                    note.setLecturerId(rs.getInt("lecturer_id"));
                    note.setTitle(rs.getString("title"));
                    note.setType(rs.getString("type"));
                    note.setFileUrl(rs.getString("file_url"));
                    note.setCreatedAt(rs.getTimestamp("created_at"));
                    note.setCourseName(rs.getString("course_name"));
                    note.setLecturerName(rs.getString("lecturer_name"));
                    notes.add(note);
                }
            }
        }
        return notes;
    }

    // ---------------------------------------------------------------
    // LECTURER - UC015
    // ---------------------------------------------------------------

    /**
     * UC015 Step 1 - Returns all notes uploaded by this lecturer.
     */
    public List<Note> getNotesByLecturer(int lecturerId) throws SQLException {
        List<Note> notes = new ArrayList<>();

        String sql = "SELECT n.id, n.course_id, n.lecturer_id, n.title, n.type, n.file_url, n.created_at, " +
                     "c.title AS course_name " +
                     "FROM notes n " +
                     "JOIN courses c ON c.id = n.course_id " +
                     "WHERE n.lecturer_id = ? " +
                     "ORDER BY c.title ASC, n.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, lecturerId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Note note = new Note();
                    note.setId(rs.getInt("id"));
                    note.setCourseId(rs.getInt("course_id"));
                    note.setLecturerId(rs.getInt("lecturer_id"));
                    note.setTitle(rs.getString("title"));
                    note.setType(rs.getString("type"));
                    note.setFileUrl(rs.getString("file_url"));
                    note.setCreatedAt(rs.getTimestamp("created_at"));
                    note.setCourseName(rs.getString("course_name"));
                    notes.add(note);
                }
            }
        }
        return notes;
    }

    /**
     * UC015 Step 2 - Uploads a new note.
     */
    public boolean uploadNote(int courseId, int lecturerId, String title,
                              String type, String fileUrl) throws SQLException {

        String sql = "INSERT INTO notes (course_id, lecturer_id, title, type, file_url) " +
                     "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, courseId);
            ps.setInt(2, lecturerId);
            ps.setString(3, title);
            ps.setString(4, type);
            ps.setString(5, fileUrl);
            return ps.executeUpdate() == 1;
        }
    }

    /**
     * UC015 Step 3 - Edits note title only.
     */
    public boolean updateNoteTitle(int noteId, int lecturerId, String newTitle) throws SQLException {
        String sql = "UPDATE notes SET title = ? WHERE id = ? AND lecturer_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newTitle);
            ps.setInt(2, noteId);
            ps.setInt(3, lecturerId);
            return ps.executeUpdate() == 1;
        }
    }

    /**
     * UC015 Step 4 - Deletes a note.
     */
    public boolean deleteNote(int noteId, int lecturerId) throws SQLException {
        String sql = "DELETE FROM notes WHERE id = ? AND lecturer_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, noteId);
            ps.setInt(2, lecturerId);
            return ps.executeUpdate() == 1;
        }
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
