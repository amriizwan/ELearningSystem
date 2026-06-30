package com.mycompany.elearningsystem.model;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */


import java.util.Date;

/**
 *
 * @author User
 */
public class Assignment {
    private int assignmentId;
    private int courseId;
    private int lecturer_id;
    private String title;
    private String description;
    private Date dueDate;
    private int maxMark;
    private Date created_date;
    private int assignment_count;
    private int ungraded_count;
    private int enroll_count;

    public Assignment() {
    }

    public Assignment(int assignmentId, int courseId, int lecturer_id, String title, String description, Date dueDate, int maxMark, Date created_date, int assignment_count, int ungraded_count, int enroll_count) {
        this.assignmentId = assignmentId;
        this.courseId = courseId;
        this.lecturer_id = lecturer_id;
        this.title = title;
        this.description = description;
        this.dueDate = dueDate;
        this.maxMark = maxMark;
        this.created_date = created_date;
        this.assignment_count = assignment_count;
        this.ungraded_count = ungraded_count;
        this.enroll_count = enroll_count;
    }

    public int getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(int assignmentId) {
        this.assignmentId = assignmentId;
    }

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public int getLecturer_id() {
        return lecturer_id;
    }

    public void setLecturer_id(int lecturer_id) {
        this.lecturer_id = lecturer_id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getDueDate() {
        return dueDate;
    }

    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }

    public int getMaxMark() {
        return maxMark;
    }

    public void setMaxMark(int maxMark) {
        this.maxMark = maxMark;
    }

    public Date getCreated_date() {
        return created_date;
    }

    public void setCreated_date(Date created_date) {
        this.created_date = created_date;
    }

    public int getAssignment_count() {
        return assignment_count;
    }

    public void setAssignment_count(int assignment_count) {
        this.assignment_count = assignment_count;
    }

    public int getUngraded_count() {
        return ungraded_count;
    }

    public void setUngraded_count(int ungraded_count) {
        this.ungraded_count = ungraded_count;
    }

    public int getEnroll_count() {
        return enroll_count;
    }

    public void setEnroll_count(int enroll_count) {
        this.enroll_count = enroll_count;
    }

    
    
}