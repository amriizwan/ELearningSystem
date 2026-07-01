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
public class Submission {
    private int submissionId;
    private int assignmentId;
    private int studentId;
    private String filePath;
    private String answerText;
    private Timestamp submitDate;
    private int mark;    
    private String lecturerComment;

    public Submission() {
    }

    public Submission(int submissionId, int assignmentId, int studentId, String filePath, String answerText, Timestamp submitDate, int mark, String lecturerComment) {
        this.submissionId = submissionId;
        this.assignmentId = assignmentId;
        this.studentId = studentId;
        this.filePath = filePath;
        this.answerText = answerText;
        this.submitDate = submitDate;
        this.mark = mark;
        this.lecturerComment = lecturerComment;
    }

    public int getSubmissionId() {
        return submissionId;
    }

    public int getAssignmentId() {
        return assignmentId;
    }

    public int getStudentId() {
        return studentId;
    }

    public String getFilePath() {
        return filePath;
    }

    public String getAnswerText() {
        return answerText;
    }

    public Timestamp getSubmitDate() {
        return submitDate;
    }

    public int getMark() {
        return mark;
    }

    public String getLecturerComment() {
        return lecturerComment;
    }

    public void setSubmissionId(int submissionId) {
        this.submissionId = submissionId;
    }

    public void setAssignmentId(int assignmentId) {
        this.assignmentId = assignmentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public void setAnswerText(String answerText) {
        this.answerText = answerText;
    }

    public void setSubmitDate(Timestamp submitDate) {
        this.submitDate = submitDate;
    }

    public void setMark(int mark) {
        this.mark = mark;
    }

    public void setLecturerComment(String lecturerComment) {
        this.lecturerComment = lecturerComment;
    }
}
