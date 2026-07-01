/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.elearningsystem.dao;

import com.mycompany.elearningsystem.model.Submission;
import com.mycompany.elearningsystem.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author amri1
 */
public class SubmissionDAO {
    public boolean insertSubmission(Submission submission){

        boolean success = false;

        try{
            Connection conn = DBConnection.getConnection();

            String sql = 
                    "INSERT INTO assignment_submissions " +
                    "(assignment_id, student_id, file_url, answer_text) " +
                    "VALUES(?, ?, ?, ?)";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, submission.getAssignmentId());
            ps.setInt(2, submission.getStudentId());
            ps.setString(3, submission.getFilePath());
            ps.setString(4, submission.getAnswerText());

            success = ps.executeUpdate() > 0;

        }catch(SQLException e){
            e.printStackTrace();
        }

        return success;
    }
    
    public boolean hasSubmitted(int assignmentId, int studentId) {
        
        boolean exists = false;

        try {
            Connection conn = DBConnection.getConnection();

            String sql = 
                    "SELECT id " +
                    "FROM assignment_submissions " +
                    "WHERE assignment_id = ? " +
                    "AND student_id = ?";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, assignmentId);
            ps.setInt(2, studentId);

            ResultSet rs = ps.executeQuery();

            exists = rs.next();

            rs.close();
            ps.close();
            conn.close();

        } catch(SQLException e){
            e.printStackTrace();
        }

        return exists;
    }
    
}
