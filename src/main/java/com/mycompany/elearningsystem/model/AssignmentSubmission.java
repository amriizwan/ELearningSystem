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
public class AssignmentSubmission {
    private int id;
    private int assignmentId;
    private int studentId;
    private String fileUrl;
    private String answerText;
    private Timestamp submittedAt;
    private Integer mark;           // nullable — null means not yet marked
    private String lecturerComment;
    private int maxMarks;

    public int getMaxMarks() {
        return maxMarks;
    }

    public void setMaxMarks(int maxMarks) {
        this.maxMarks = maxMarks;
    }


    // Extra fields for display
    private String studentName;
    private String assignmentTitle;
    private String courseName;
    
    private String initials;
    private String timeAgo;
    
    private String title;

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public AssignmentSubmission() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getAssignmentId() { return assignmentId; }
    public void setAssignmentId(int assignmentId) { this.assignmentId = assignmentId; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public String getFileUrl() { return fileUrl; }
    public void setFileUrl(String fileUrl) { this.fileUrl = fileUrl; }

    public String getAnswerText() { return answerText; }
    public void setAnswerText(String answerText) { this.answerText = answerText; }

    public Timestamp getSubmittedAt() { return submittedAt; }
    public void setSubmittedAt(Timestamp submittedAt) { this.submittedAt = submittedAt; }

    public Integer getMark() { return mark; }
    public void setMark(Integer mark) { this.mark = mark; }

    public String getLecturerComment() { return lecturerComment; }
    public void setLecturerComment(String lecturerComment) { this.lecturerComment = lecturerComment; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getAssignmentTitle() { return assignmentTitle; }
    public void setAssignmentTitle(String assignmentTitle) { this.assignmentTitle = assignmentTitle; }

    public String getCourseName() { return courseName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }

    // Helper — true if lecturer has already marked this submission
    public boolean isMarked() { return mark != null; }
    
    public String getInitials() {
    return initials;
}

    public void setInitials(String initials) {
        this.initials = initials;
    }

    public String getTimeAgo() {
        return timeAgo;
    }

    public void setTimeAgo(String timeAgo) {
        this.timeAgo = timeAgo;
    }
}
