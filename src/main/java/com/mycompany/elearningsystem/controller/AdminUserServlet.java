/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.elearningsystem.controller;

import com.mycompany.elearningsystem.model.User;
import com.mycompany.elearningsystem.model.UserDAO;
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
@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    // ---------------------------------------------------------------
    // GET — Step 1: display user list
    // ---------------------------------------------------------------
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            List<User> users = userDAO.findAll();

            // No users in system — list is empty, JSP handles display
            req.setAttribute("users", users);

            // Pass filter param back to JSP for role tab state
            String filterRole = req.getParameter("role");
            req.setAttribute("filterRole", filterRole);

            req.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException("Database error loading users", e);
        }
    }

    // ---------------------------------------------------------------
    // POST — handle all user management actions
    // ---------------------------------------------------------------
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        String action = req.getParameter("action");

        try {
            switch (action) {

                // UC020 Add: create new user account with specified role
                case "add": {
                    String name     = req.getParameter("name");
                    String email    = req.getParameter("email");
                    String password = req.getParameter("password");
                    String role     = req.getParameter("role");

                    if (name == null || name.trim().isEmpty()) {
                        session.setAttribute("error", "Please enter the user's full name");
                        break;
                    }
                    if (email == null || email.trim().isEmpty()) {
                        session.setAttribute("error", "Please enter the user's email");
                        break;
                    }
                    if (password == null || password.length() < 8) {
                        session.setAttribute("error", "Password must be at least 8 characters");
                        break;
                    }
                    if (userDAO.emailExists(email.trim())) {
                        session.setAttribute("error", "An account with that email already exists");
                        break;
                    }

                    userDAO.createUser(name.trim(), email.trim(), password, role);
                    session.setAttribute("success", "User account created successfully");
                    break;
                }

                // UC020 Edit: update name, email, role
                case "edit": {
                    int userId   = Integer.parseInt(req.getParameter("userId"));
                    String name  = req.getParameter("name");
                    String email = req.getParameter("email");
                    String role  = req.getParameter("role");

                    if (name == null || name.trim().isEmpty()) {
                        session.setAttribute("error", "Name cannot be empty");
                        break;
                    }

                    userDAO.updateUser(userId, name.trim(), email.trim(), role);
                    session.setAttribute("success", "User updated successfully");
                    break;
                }

                // UC020 Delete: remove user account and all related records (CASCADE)
                case "delete": {
                    int userId = Integer.parseInt(req.getParameter("userId"));
                    userDAO.deleteUser(userId);
                    session.setAttribute("success", "User account deleted successfully");
                    break;
                }

                // UC020 Deactivate: set status = inactive, user cannot login
                case "deactivate": {
                    int userId = Integer.parseInt(req.getParameter("userId"));
                    userDAO.updateStatus(userId, "inactive");
                    session.setAttribute("success", "User account deactivated");
                    break;
                }

                // UC020 Activate: set status = active
                case "activate": {
                    int userId = Integer.parseInt(req.getParameter("userId"));
                    userDAO.updateStatus(userId, "active");
                    session.setAttribute("success", "User account activated");
                    break;
                }
            }

        } catch (SQLException e) {
            throw new ServletException("Database error processing user action", e);
        }

        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }

}
