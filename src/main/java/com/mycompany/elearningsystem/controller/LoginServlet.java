/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.elearningsystem.controller;

import com.mycompany.elearningsystem.model.User;
import com.mycompany.elearningsystem.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

/**
 * UC002 - Login
 * Normal flow: GET shows form, POST validates and creates session.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    //Render page login
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    //Handle form login
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        // E1: empty email or password
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Please enter your email and password");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        try {
            User user = userDAO.findByEmail(email);

            // E2: no account with that email
            if (user == null) {
                req.setAttribute("error", "No account found with that email");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
                return;
            }

            // E3: incorrect password
            if (!userDAO.checkPassword(password, user.getPassword(), user.getRole())) {
                req.setAttribute("error", "Incorrect password. Please try again");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
                return;
            }

            // Inactive account check (admin can deactivate per UC020)
            if ("inactive".equals(user.getStatus())) {
                req.setAttribute("error", "This account has been deactivated. Contact admin.");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
                return;
            }

            // Success: create session, store id + role
            //Request = Short, Load page/ Submit form
            //Session = Long, Active until expire, dekat mana2 attribute userId akan sama
            HttpSession session = req.getSession(); //return current session / create new session
            session.setAttribute("userId", user.getId());
            session.setAttribute("userName", user.getName());
            session.setAttribute("role", user.getRole());

            // Post condition: redirect to dashboard based on role
            resp.sendRedirect(req.getContextPath() + "/dashboard");

        } catch (SQLException e) {
            throw new ServletException("Database error during login", e);
        }
    }
}

