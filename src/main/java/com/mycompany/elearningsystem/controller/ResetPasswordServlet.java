/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.elearningsystem.controller;

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
 * UC001 - Register
 * Normal flow: GET shows form, POST creates account.
 **/
@WebServlet("/resetPassword")
public class ResetPasswordServlet extends HttpServlet {


    private final UserDAO userDAO = new UserDAO();
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/forgotPassword.jsp").forward(request, response);

    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email =
            request.getParameter("email");

        String name =
            request.getParameter("name");

        String password =
            request.getParameter("password");


        // Check account first
        boolean valid = userDAO.isValidUserForReset(email, name);


        if(!valid) {

            request.setAttribute(
                "error",
                "Invalid email/name or admin account cannot be reset"
            );
            request.getRequestDispatcher(
                "/forgotPassword.jsp"
            ).forward(request,response);

            return;
        }


        // Update password
        boolean updated =
            userDAO.resetPassword(email, name, password);

        if(updated) {
            response.sendRedirect("login");
        }
        else {

            request.setAttribute(
                "error",
                "Password update failed"
            );


            request.getRequestDispatcher(
                "/forgotPassword.jsp"
            ).forward(request,response);
        }

    }

}