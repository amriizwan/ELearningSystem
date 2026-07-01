/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.elearningsystem.model;

import java.sql.Timestamp;

/**
 *
 * @author amri1
 */
public class Course {
    private int id;
    private String title;
    private String description;
    private Timestamp createdAt;

    // Extra field — filled by JOIN query, not stored in courses table
    private int enrollmentCount;
    
    private int noteCount;
    private int assignmentCount;
    private int quizCount;
    
    private String lecturerNames;
    private boolean enrolled;

    
    public Course() {}

    public Course(int id, String title, String description) {
        this.id = id;
        this.title = title;
        this.description = description;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public int getEnrollmentCount() { return enrollmentCount; }
    public void setEnrollmentCount(int enrollmentCount) { this.enrollmentCount = enrollmentCount; }
    
    public int getNoteCount() {
        return noteCount;
    }

    public int getAssignmentCount() {
        return assignmentCount;
    }

    public int getQuizCount() {
        return quizCount;
    }
    
    public void setNoteCount(int noteCount) {
        this.noteCount = noteCount;
    }

    public void setAssignmentCount(int assignmentCount) {
        this.assignmentCount = assignmentCount;
    }

    public void setQuizCount(int quizCount) {
        this.quizCount = quizCount;
    }
    
    public String getLecturerNames() {
        return lecturerNames;
    }
    
    public void setLecturerNames(String lecturerNames) {
        this.lecturerNames = lecturerNames;
    }
    
    public boolean isEnrolled() {
        return enrolled;
    }
    
    public void setEnrolled(boolean enrolled) {
        this.enrolled = enrolled;
    }
}

