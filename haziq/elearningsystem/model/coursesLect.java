/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.elearningsystem.model;

/**
 *
 * @author Haziq
 */
public class coursesLect {
    private String id;
    private String title;
    private String description;
    private String course_id;
    private String lecture_id;
    private int student_count;
    private int note_count;
    private int asgn_count;
    private int quiz_count;
    private int lecturer_count;
    private int is_mine;
    

     public coursesLect() {
    }

    public coursesLect(String id, String course_id, String lecture_id, int student_count, int note_count, int asgn_count, int quiz_count, int lecturer_count, int is_mine) {
        this.id = id;
        this.course_id = course_id;
        this.lecture_id = lecture_id;
        this.student_count = student_count;
        this.note_count = note_count;
        this.asgn_count = asgn_count;
        this.quiz_count = quiz_count;
        this.lecturer_count = lecturer_count;
        this.is_mine = is_mine;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getCourse_id() {
        return course_id;
    }

    public void setCourse_id(String course_id) {
        this.course_id = course_id;
    }

    public String getLecture_id() {
        return lecture_id;
    }

    public void setLecture_id(String lecture_id) {
        this.lecture_id = lecture_id;
    }

    public int getStudent_count() {
        return student_count;
    }

    public void setStudent_count(int student_count) {
        this.student_count = student_count;
    }

    public int getNote_count() {
        return note_count;
    }

    public void setNote_count(int note_count) {
        this.note_count = note_count;
    }

    public int getAsgn_count() {
        return asgn_count;
    }

    public void setAsgn_count(int asgn_count) {
        this.asgn_count = asgn_count;
    }

    public int getQuiz_count() {
        return quiz_count;
    }

    public void setQuiz_count(int quiz_count) {
        this.quiz_count = quiz_count;
    }

    public int getLecturer_count() {
        return lecturer_count;
    }

    public void setLecturer_count(int lecturer_count) {
        this.lecturer_count = lecturer_count;
    }

    public int getIs_mine() {
        return is_mine;
    }

    public void setIs_mine(int is_mine) {
        this.is_mine = is_mine;
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
    
    

}
