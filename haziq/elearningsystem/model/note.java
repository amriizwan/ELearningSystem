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
public class note {
    private int id;
    private int course_id;
    private int lecture_id;
    private String title;
    private String type;
    private String url;
    private Date created_at;
    private int note_count;

    public note() {
    }

    public note(int id, int course_id, int lecture_id, String title, String type, String url, Date created_at) {
        this.id = id;
        this.course_id = course_id;
        this.lecture_id = lecture_id;
        this.title = title;
        this.type = type;
        this.url = url;
        this.created_at = created_at;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCourse_id() {
        return course_id;
    }

    public void setCourse_id(int course_id) {
        this.course_id = course_id;
    }

    public int getLecture_id() {
        return lecture_id;
    }

    public void setLecture_id(int lecture_id) {
        this.lecture_id = lecture_id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public Date getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Date created_at) {
        this.created_at = created_at;
    }

    public int getNote_count() {
        return note_count;
    }

    public void setNote_count(int note_count) {
        this.note_count = note_count;
    }
    
    
    
    
}
