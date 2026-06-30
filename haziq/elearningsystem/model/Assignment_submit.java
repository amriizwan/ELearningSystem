/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.elearningsystem.model;

import java.sql.Date;

/**
 *
 * @author Haziq
 */
public class Assignment_submit {
    private int id;
    private String student_name;
    private int assignment_id;
    private int student_id;
    private String file_url;
    private String answer;
    private Date submitted_date;
    private int mark;
    private String lecturer_comment;
    private int maxMark;
    private String title;
    

    public Assignment_submit() {
    }

    public Assignment_submit(int id, String student_name, int assignment_id, int student_id, String file_url, String answer, Date submitted_date, int mark, String lecturer_comment) {
        this.id = id;
        this.student_name = student_name;
        this.assignment_id = assignment_id;
        this.student_id = student_id;
        this.file_url = file_url;
        this.answer = answer;
        this.submitted_date = submitted_date;
        this.mark = mark;
        this.lecturer_comment = lecturer_comment;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getStudent_name() {
        return student_name;
    }

    public void setStudent_name(String student_name) {
        this.student_name = student_name;
    }

    public int getAssignment_id() {
        return assignment_id;
    }

    public void setAssignment_id(int assignment_id) {
        this.assignment_id = assignment_id;
    }

    public int getStudent_id() {
        return student_id;
    }

    public void setStudent_id(int student_id) {
        this.student_id = student_id;
    }

    public String getFile_url() {
        return file_url;
    }

    public void setFile_url(String file_url) {
        this.file_url = file_url;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }

    public Date getSubmitted_date() {
        return submitted_date;
    }

    public void setSubmitted_date(Date submitted_date) {
        this.submitted_date = submitted_date;
    }

    public int getMark() {
        return mark;
    }

    public void setMark(int mark) {
        this.mark = mark;
    }

    public String getLecturer_comment() {
        return lecturer_comment;
    }

    public void setLecturer_comment(String lecturer_comment) {
        this.lecturer_comment = lecturer_comment;
    }

    public int getMaxMark() {
        return maxMark;
    }

    public void setMaxMark(int maxMark) {
        this.maxMark = maxMark;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    

    
}
