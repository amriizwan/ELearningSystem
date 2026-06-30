package com.mycompany.project.model;

import java.time.LocalDateTime;

/**
 * Model class representing a row in the `quizzes` table.
 */
public class Quiz {

    private int id;
    private int courseId;
    private int lecturerId;
    private String title;
    private String quizCode;
    private LocalDateTime createdAt;

    // ── Aggregated fields (populated by DAO query) ──
    private int questionCount;
    private int attemptCount;
    private double avgScore;

    // ── Constructors ──
    public Quiz() {}

    // ── Getters & Setters ──
    public int getId()                        { return id; }
    public void setId(int id)                 { this.id = id; }

    public int getCourseId()                  { return courseId; }
    public void setCourseId(int courseId)     { this.courseId = courseId; }

    public int getLecturerId()                { return lecturerId; }
    public void setLecturerId(int l)          { this.lecturerId = l; }

    public String getTitle()                  { return title; }
    public void setTitle(String title)        { this.title = title; }

    public String getQuizCode()               { return quizCode; }
    public void setQuizCode(String quizCode)  { this.quizCode = quizCode; }

    public LocalDateTime getCreatedAt()               { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public int getQuestionCount()                     { return questionCount; }
    public void setQuestionCount(int questionCount)   { this.questionCount = questionCount; }

    public int getAttemptCount()                      { return attemptCount; }
    public void setAttemptCount(int attemptCount)     { this.attemptCount = attemptCount; }

    public double getAvgScore()                       { return avgScore; }
    public void setAvgScore(double avgScore)          { this.avgScore = avgScore; }
}
