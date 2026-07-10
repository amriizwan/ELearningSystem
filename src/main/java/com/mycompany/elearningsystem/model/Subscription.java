/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.elearningsystem.model;

import java.sql.Timestamp;

/**
 *
 * @author User
 */
public class Subscription {
    private int id;
    private int userId;
    private double amount;
    private String status;
    private Timestamp paymentAt;
    
    public Subscription() {}
    
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public Timestamp getPaymentAt() { return paymentAt; }
    public void setPaymentAt(Timestamp paymentAt) { this.paymentAt = paymentAt; }
}
