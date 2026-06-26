/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.elearningsystem.controller;

import com.mycompany.elearningsystem.model.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;


/**
 * UC001 - Register
 * Normal flow: GET shows form, POST creates account.
 **/
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    //Render page register
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    //Handle form register
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String role = req.getParameter("role"); // "student" or "lecturer"
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        // E1: full name empty
        if (name == null || name.trim().isEmpty()) {
            req.setAttribute("error", "Please enter your full name");
            forwardBack(req, resp);
            return;
        }

        // E2: email empty
        if (email == null || email.trim().isEmpty()) {
            req.setAttribute("error", "Please enter your email addresses");
            forwardBack(req, resp);
            return;
        }

        // E3: password too short
        if (password == null || password.length() < 8) {
            req.setAttribute("error", "Password must at least 8 characters");
            forwardBack(req, resp);
            return;
        }

        // E4: passwords don't match
        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "Password do not match");
            forwardBack(req, resp);
            return;
        }

        try {
            // Precondition 1: email is not duplicate
            if (userDAO.emailExists(email)) {
                req.setAttribute("error", "An account with that email already exists");
                forwardBack(req, resp);
                return;
            }

            boolean created = userDAO.createUser(name, email, password, role);
            if (created) {
                // Post condition: account created -> show success, redirect to login
                req.setAttribute("success", "Account created! You can now log in");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
            } else {
                req.setAttribute("error", "Something went wrong. Please try again.");
                forwardBack(req, resp);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error during registration", e);
        }
    }

    private void forwardBack(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }
}

