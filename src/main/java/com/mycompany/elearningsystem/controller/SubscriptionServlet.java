/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.elearningsystem.controller;

import com.mycompany.elearningsystem.dao.SubscriptionDAO;
import com.mycompany.elearningsystem.model.Subscription;
import com.mycompany.elearningsystem.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 *
 * @author User
 */
@WebServlet("/subscribe")
public class SubscriptionServlet extends HttpServlet {
    
    private final SubscriptionDAO subsDAO = new SubscriptionDAO();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        String role = (String) session.getAttribute("role");
        double amount = Double.parseDouble(req.getParameter("amount"));
        String prevPage = req.getParameter("prevPage");
        
        req.setAttribute("prevPage", prevPage);
        req.setAttribute("role", role);
        req.setAttribute("amount", amount);
        
        req.getRequestDispatcher("/WEB-INF/views/lecturer/subscribe.jsp")
                    .forward(req, resp);
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        int userId = (int) session.getAttribute("userId");
        double amount = Double.parseDouble(req.getParameter("amount"));
        String status = "Success";
        
        Subscription s = new Subscription();
        s.setId(userId);
        s.setAmount(amount);
        s.setStatus(status);
        
        subsDAO.addSubscription(s);
        
        String prevPage = (String) req.getParameter("prevPage");
        session.setAttribute("success", "Plan Upgraded successfully, Enjoy !!");
        resp.sendRedirect(prevPage);
    }
}
