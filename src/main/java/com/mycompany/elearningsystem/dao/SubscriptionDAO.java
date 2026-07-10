/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.elearningsystem.dao;

import com.mycompany.elearningsystem.model.Subscription;
import com.mycompany.elearningsystem.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author User
 */
public class SubscriptionDAO {
    
    public boolean addSubscription(Subscription s) {

        boolean success = false;
      
        try {
            Connection conn = DBConnection.getConnection();
            
            String sql = "INSERT INTO subscription(user_id, amount, status) VALUES(?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, s.getId());
            ps.setDouble(2, s.getAmount());
            ps.setString(3, s.getStatus());

            success = ps.executeUpdate() > 0;
        } catch(SQLException ex) {
            ex.printStackTrace();
        }

        return success;
    }
    
    public boolean isSubscribe(int user_id) {
        try{
            String sql = 
                "SELECT 1\n" +
                "FROM subscription\n" +
                "WHERE user_id = ?\n" +
                "AND status = 'SUCCESS'\n" +
                "LIMIT 1";
            
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, user_id);
            ResultSet rs = ps.executeQuery();
            
            return rs.next(); 
            
        }catch(SQLException ex){
            Logger.getLogger(SubscriptionDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
    
    public double getTotalRevenue() {
        double revenue = 0;

        String sql = 
                "SELECT SUM(amount)\n" +
                "FROM subscription \n" +
                "WHERE status = 'Success'";

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                revenue = rs.getDouble(1);
            }
        }catch(SQLException e) {
            e.printStackTrace();
            System.out.println("SQL ERROR: " + e.getMessage());
        }

        return revenue;
    }
    
    public boolean isAssignmentsLimit(int user_id) {
        try{
            String sql = "SELECT limitation_name, num_limit FROM subscription_plan WHERE limitation_name = 'assignment_limit'";
            
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            int limit = 0;
            if (rs.next()) {
                limit = rs.getInt("num_limit");
            }

            int count = getTotalAssignments(user_id);

            return count >= limit;
            
        }catch(SQLException ex){
            Logger.getLogger(SubscriptionDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
    
    public boolean isNotesLimit(int user_id) {
        try{
            String sql = "SELECT limitation_name, num_limit FROM `subscription_plan` WHERE limitation_name = 'note_limit'";
            
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            int limit = 0;
            if (rs.next()) {
                limit = rs.getInt("num_limit");
            }


            int count = getTotalNotes(user_id);

            return count >= limit;
            
        }catch(SQLException ex){
            Logger.getLogger(AssignmentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
    
    public boolean isPostsLimit(int user_id) {
        try{
            String sql = 
                "SELECT limitation_name, num_limit FROM `subscription_plan` WHERE limitation_name = 'post_limit'";
            
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            int limit = 0;
            if (rs.next()) {
                limit = rs.getInt("num_limit");
            }

            int count = getTotalPosts(user_id);

            return count >= limit;
            
        }catch(SQLException ex){
            Logger.getLogger(SubscriptionDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
    
    public int getTotalNotes(int userId) {

        String sql = 
            "SELECT COUNT(*) FROM notes WHERE lecturer_id = ?";

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, userId);

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
    
    public int getTotalAssignments(int userId) {

        String sql = 
            "SELECT COUNT(*) FROM assignments WHERE lecturer_id = ?";

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, userId);

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
    
    public int getTotalPosts(int userId) {

        String sql = 
            "SELECT COUNT(*) AS post_count\n" +
            "FROM posts\n" +
            "WHERE user_id = ?;";

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, userId);

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
    
}
