/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.elearningsystem.controller;

import com.mycompany.elearningsystem.model.CourseDAO;
import com.mycompany.elearningsystem.model.Post;
import com.mycompany.elearningsystem.model.PostDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 *
 * @author amri1
 */
/**
 * UC010 - View post in Discussion (Student, Lecturer)
 * UC011 - Delete post in Discussion (Student, Lecturer)
 * UC012 - Add post in Discussion (Student, Lecturer)
 * UC013 - Edit post in Discussion (Student, Lecturer)
 * UC019 - Delete post (Admin)
 *
 * GET  /discussion              -> UC010 Step 1: list all posts
 * GET  /discussion?id=X        -> UC010 Step 2: view post + comments
 * POST /discussion?action=post  -> UC012: create new post
 * POST /discussion?action=edit  -> UC013: edit own post
 * POST /discussion?action=delete     -> UC011: delete own post
 * POST /discussion?action=deleteAdmin -> UC019: admin deletes any post
 * POST /discussion?action=comment    -> add comment to post
 * POST /discussion?action=deleteComment -> delete own comment
 */
@WebServlet("/discussion")
public class DiscussionServlet extends HttpServlet {

    private final PostDAO postDAO = new PostDAO();
    private final CourseDAO courseDAO = new CourseDAO();

    // ---------------------------------------------------------------
    // GET
    // ---------------------------------------------------------------
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        String role  = (String) session.getAttribute("role");
        int userId   = (int) session.getAttribute("userId");

        try {
            // UC010 Step 2: view specific post with comments
            String idParam = req.getParameter("id");
            if (idParam != null) {
                Post post = postDAO.getPostById(Integer.parseInt(idParam));
                req.setAttribute("selectedPost", post);
            }

            // UC010 Step 1: list posts based on role
            List<Post> posts = postDAO.getAllPostsByUser(userId, role);

            // UC010 E1: no posts available
            if (posts.isEmpty()) {
                req.setAttribute("error", "No posts available");
            }

            req.setAttribute("posts", posts);

            // Pass courses for the create post form (UC012 data input: Select Course)
            if ("student".equals(role)) {
                req.setAttribute("courses", courseDAO.getEnrolledCourses(userId));
                req.getRequestDispatcher("/WEB-INF/views/student/discussion.jsp")
                        .forward(req, resp);
            } else if ("lecturer".equals(role)) {
                req.setAttribute("courses", courseDAO.getCoursesByLecturer(userId));
                req.getRequestDispatcher("/WEB-INF/views/lecturer/discussion.jsp")
                        .forward(req, resp);
            } else if ("admin".equals(role)) {
                req.getRequestDispatcher("/WEB-INF/views/admin/discussion.jsp")
                        .forward(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/login");
            }

        } catch (SQLException e) {
            throw new ServletException("Database error loading discussion", e);
        }
    }

    // ---------------------------------------------------------------
    // POST
    // ---------------------------------------------------------------
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        int userId   = (int) session.getAttribute("userId");
        String role  = (String) session.getAttribute("role");
        String action = req.getParameter("action");

        try {
            switch (action) {

                // UC012 Step 3: Create new post
                case "post": {
                    String title   = req.getParameter("title");
                    String content = req.getParameter("content");
                    int courseId   = Integer.parseInt(req.getParameter("courseId"));

                    // UC012 E1: content empty
                    if (content == null || content.trim().isEmpty()) {
                        session.setAttribute("error", "Post content cannot be empty");
                        resp.sendRedirect(req.getContextPath() + "/discussion");
                        return;
                    }

                    // Title defaults to "Untitled" if empty
                    if (title == null || title.trim().isEmpty()) {
                        title = "Untitled";
                    }

                    postDAO.createPost(userId, courseId, title.trim(), content.trim());
                    session.setAttribute("success", "Post published successfully");
                    break;
                }

                // UC013 Step 3: Edit own post
                case "edit": {
                    int postId     = Integer.parseInt(req.getParameter("postId"));
                    String title   = req.getParameter("title");
                    String content = req.getParameter("content");

                    // UC013 E1: ownership check — updatePost returns false if not owner
                    boolean updated = postDAO.updatePost(postId, userId,
                            title, content);

                    if (!updated) {
                        session.setAttribute("error", "Access denied");
                    } else {
                        session.setAttribute("success", "Post updated successfully");
                    }
                    resp.sendRedirect(req.getContextPath() + "/discussion?id=" + postId);
                    return;
                }

                // UC011 Step 3: Delete own post
                case "delete": {
                    int postId = Integer.parseInt(req.getParameter("postId"));
                    boolean deleted = postDAO.deletePost(postId, userId);

                    if (!deleted) {
                        // E1 from SDD: user cancels or doesn't own post → keep unchanged
                        session.setAttribute("error", "Access denied");
                    } else {
                        session.setAttribute("success", "Post deleted successfully");
                    }
                    break;
                }

                // UC019: Admin deletes any post (no ownership check)
                case "deleteAdmin": {
                    int postId = Integer.parseInt(req.getParameter("postId"));
                    postDAO.deletePostAdmin(postId);
                    session.setAttribute("success", "Post deleted successfully");
                    break;
                }

                // Add comment to a post
                case "comment": {
                    int postId     = Integer.parseInt(req.getParameter("postId"));
                    String content = req.getParameter("content");

                    if (content == null || content.trim().isEmpty()) {
                        session.setAttribute("error", "Comment cannot be empty");
                        resp.sendRedirect(req.getContextPath() + "/discussion?id=" + postId);
                        return;
                    }

                    postDAO.addComment(postId, userId, content.trim());
                    resp.sendRedirect(req.getContextPath() + "/discussion?id=" + postId);
                    return;
                }

                // Delete own comment
                case "deleteComment": {
                    int commentId = Integer.parseInt(req.getParameter("commentId"));
                    int postId    = Integer.parseInt(req.getParameter("postId"));
                    postDAO.deleteComment(commentId, userId);
                    resp.sendRedirect(req.getContextPath() + "/discussion?id=" + postId);
                    return;
                }
            }

        } catch (SQLException e) {
            throw new ServletException("Database error processing discussion action", e);
        }

        resp.sendRedirect(req.getContextPath() + "/discussion");
    }
}
