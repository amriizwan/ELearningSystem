package com.mycompany.elearningsystem.model;

import java.sql.Timestamp;

public class Enrollment {
    private int id;
    private int studentId;
    private int courseId;
    private Timestamp enrolledAt;
    
    private int noteCount;
    private int assignmentCount;
    private int lectId;
    private String lectName;

    
    public Enrollment(){}
    
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }
    
    public int getCourseId() { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }
    
    public Timestamp getEnrolledAt() { return enrolledAt; }
    public void setEnrolledAt(Timestamp enrolledAt) { this.enrolledAt = enrolledAt; }
    
    public int getNoteCount() {
        return noteCount;
    }

    public int getAssignmentCount() {
        return assignmentCount;
    }
    
    public int getLectId() {
        return lectId;
    }

    public String getLectName() {
        return lectName;
    }
    
    public void setNoteCount(int noteCount) {
        this.noteCount = noteCount;
    }

    public void setAssignmentCount(int assignmentCount) {
        this.assignmentCount = assignmentCount;
    }
    
    public void setLectId(int lectId) {
        this.lectId = lectId;
    }

    public void setLectName(String lectName) {
        this.lectName = lectName;
    }
    
}
