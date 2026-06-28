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
public class PostDAO {
    // ---------------------------------------------------------------
    // View posts
    // ---------------------------------------------------------------

    public List<Post> getAllPostsByUser(int userId, String role) throws SQLException {
        List<Post> posts = new ArrayList<>();

        String sql;

        if ("student".equals(role)) {
            // Student sees posts from enrolled courses only
            sql = "SELECT p.id, p.title, p.content, p.course_id, p.user_id, " +
                  "p.created_at, p.updated_at, " +
                  "u.name AS author_name, " +
                  "c.title AS course_name, " +
                  "(SELECT COUNT(*) FROM comments cm WHERE cm.post_id = p.id) AS comment_count " +
                  "FROM posts p " +
                  "JOIN users u ON u.id = p.user_id " +
                  "JOIN courses c ON c.id = p.course_id " +
                  "JOIN enrollments e ON e.course_id = p.course_id " +
                  "WHERE e.student_id = ? " +
                  "ORDER BY p.created_at DESC";
        } else if ("lecturer".equals(role)) {
            // Lecturer sees posts from teaching courses only
            sql = "SELECT p.id, p.title, p.content, p.course_id, p.user_id, " +
                  "p.created_at, p.updated_at, " +
                  "u.name AS author_name, " +
                  "c.title AS course_name, " +
                  "(SELECT COUNT(*) FROM comments cm WHERE cm.post_id = p.id) AS comment_count " +
                  "FROM posts p " +
                  "JOIN users u ON u.id = p.user_id " +
                  "JOIN courses c ON c.id = p.course_id " +
                  "JOIN course_lecturer cl ON cl.course_id = p.course_id " +
                  "WHERE cl.lecturer_id = ? " +
                  "ORDER BY p.created_at DESC";
        } else {
            // Admin sees all posts
            sql = "SELECT p.id, p.title, p.content, p.course_id, p.user_id, " +
                  "p.created_at, p.updated_at, " +
                  "u.name AS author_name, " +
                  "c.title AS course_name, " +
                  "(SELECT COUNT(*) FROM comments cm WHERE cm.post_id = p.id) AS comment_count " +
                  "FROM posts p " +
                  "JOIN users u ON u.id = p.user_id " +
                  "JOIN courses c ON c.id = p.course_id " +
                  "ORDER BY p.created_at DESC";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (!"admin".equals(role)) {
                ps.setInt(1, userId);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Post post = new Post();
                    post.setId(rs.getInt("id"));
                    post.setTitle(rs.getString("title"));
                    post.setContent(rs.getString("content"));
                    post.setCourseId(rs.getInt("course_id"));
                    post.setUserId(rs.getInt("user_id"));
                    post.setCreatedAt(rs.getTimestamp("created_at"));
                    post.setUpdatedAt(rs.getTimestamp("updated_at"));
                    post.setAuthorName(rs.getString("author_name"));
                    post.setCourseName(rs.getString("course_name"));
                    post.setCommentCount(rs.getInt("comment_count"));
                    posts.add(post);
                }
            }
        }
        return posts;
    }

    /**
     * Returns a single post with all comments.
     */
    public Post getPostById(int postId) throws SQLException {
        String sql = "SELECT p.id, p.title, p.content, p.course_id, p.user_id, " +
                     "p.created_at, p.updated_at, " +
                     "u.name AS author_name, " +
                     "c.title AS course_name " +
                     "FROM posts p " +
                     "JOIN users u ON u.id = p.user_id " +
                     "JOIN courses c ON c.id = p.course_id " +
                     "WHERE p.id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, postId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Post post = new Post();
                    post.setId(rs.getInt("id"));
                    post.setTitle(rs.getString("title"));
                    post.setContent(rs.getString("content"));
                    post.setCourseId(rs.getInt("course_id"));
                    post.setUserId(rs.getInt("user_id"));
                    post.setCreatedAt(rs.getTimestamp("created_at"));
                    post.setUpdatedAt(rs.getTimestamp("updated_at"));
                    post.setAuthorName(rs.getString("author_name"));
                    post.setCourseName(rs.getString("course_name"));
                    // Load all comments for this post
                    post.setComments(getCommentsByPost(postId));
                    return post;
                }
            }
        }
        return null;
    }

    /**
     * Returns all comments for a post.
     */
    public List<Comment> getCommentsByPost(int postId) throws SQLException {
        List<Comment> comments = new ArrayList<>();

        String sql = "SELECT cm.id, cm.post_id, cm.user_id, cm.content, " +
                     "cm.created_at, cm.updated_at, " +
                     "u.name AS author_name " +
                     "FROM comments cm " +
                     "JOIN users u ON u.id = cm.user_id " +
                     "WHERE cm.post_id = ? " +
                     "ORDER BY cm.created_at ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, postId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Comment comment = new Comment();
                    comment.setId(rs.getInt("id"));
                    comment.setPostId(rs.getInt("post_id"));
                    comment.setUserId(rs.getInt("user_id"));
                    comment.setContent(rs.getString("content"));
                    comment.setCreatedAt(rs.getTimestamp("created_at"));
                    comment.setUpdatedAt(rs.getTimestamp("updated_at"));
                    comment.setAuthorName(rs.getString("author_name"));
                    comments.add(comment);
                }
            }
        }
        return comments;
    }

    /**
     * Creates a new discussion post.
     */
    public boolean createPost(int userId, int courseId, String title, String content) throws SQLException {

        String sql = "INSERT INTO posts (user_id, course_id, title, content) " +
                     "VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, courseId);
            ps.setString(3, title);
            ps.setString(4, content);
            return ps.executeUpdate() == 1;
        }
    }

    // ---------------------------------------------------------------
    // UC013 - Edit post
    // ---------------------------------------------------------------

    /**
     * Updates post content.
     */
    public boolean updatePost(int postId, int userId,  String title, String content) throws SQLException {

        String sql = "UPDATE posts SET title = ?, content = ?, updated_at = NOW() " +
                     "WHERE id = ? AND user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, title);
            ps.setString(2, content);
            ps.setInt(3, postId);
            ps.setInt(4, userId);
            // Returns 0 if ownership check fails → "Access denied"
            return ps.executeUpdate() == 1;
        }
    }

    /**
     * Deletes a post owned by this user.
     */
    public boolean deletePost(int postId, int userId) throws SQLException {
        String sql = "DELETE FROM posts WHERE id = ? AND user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, postId);
            ps.setInt(2, userId);
            return ps.executeUpdate() == 1;
        }
    }

    /**
     * Admin deletes any post (no ownership check).
     */
    public boolean deletePostAdmin(int postId) throws SQLException {
        String sql = "DELETE FROM posts WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, postId);
            return ps.executeUpdate() == 1;
        }
    }

    // ---------------------------------------------------------------
    // Comments
    // ---------------------------------------------------------------

    /**
     * Adds a comment to a post.
     */
    public boolean addComment(int postId, int userId, String content) throws SQLException {
        String sql = "INSERT INTO comments (post_id, user_id, content) VALUES (?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, postId);
            ps.setInt(2, userId);
            ps.setString(3, content);
            return ps.executeUpdate() == 1;
        }
    }

    /**
     * Deletes a comment owned by this user.
     */
    public boolean deleteComment(int commentId, int userId) throws SQLException {
        String sql = "DELETE FROM comments WHERE id = ? AND user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, commentId);
            ps.setInt(2, userId);
            return ps.executeUpdate() == 1;
        }
    }
}
